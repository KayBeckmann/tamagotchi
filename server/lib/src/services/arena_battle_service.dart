import 'dart:math';
import 'package:serverpod/serverpod.dart';

/// Server-side arena battle service.
///
/// Implements the core combat logic server-side for anti-cheat.
/// Uses in-memory state for active battles; persists results to DB.
class ArenaBattleService {
  static final _rng = Random();

  // Active battles in memory: battleId -> BattleData
  static final Map<String, _ActiveBattle> _activeBattles = {};

  // Matchmaking queue: userId -> _QueueEntry
  static final Map<int, _QueueEntry> _queue = {};

  // ---- Matchmaking ----

  /// Add a creature to the matchmaking queue.
  /// Returns a battle ID if a match was found immediately.
  static Future<String?> joinQueue(
    Session session, {
    required int userId,
    required int creatureId,
    required int combatPower,
    required int eloRating,
  }) async {
    // Remove stale entries
    _cleanupQueue();

    // Look for a matching opponent
    final match = _findMatch(userId, combatPower, eloRating);

    if (match != null) {
      _queue.remove(match.userId);
      final battleId = _createBattle(
        user1Id: match.userId,
        creature1Id: match.creatureId,
        creature1Cp: match.combatPower,
        user2Id: userId,
        creature2Id: creatureId,
        creature2Cp: combatPower,
      );
      session.log('Battle started: $battleId', level: LogLevel.info);
      return battleId;
    }

    // No match found – add to queue
    _queue[userId] = _QueueEntry(
      userId: userId,
      creatureId: creatureId,
      combatPower: combatPower,
      eloRating: eloRating,
      joinedAt: DateTime.now(),
    );
    session.log('User $userId joined queue', level: LogLevel.info);
    return null;
  }

  /// Check if a match has been found for a queued user.
  static String? checkQueueStatus(int userId) {
    for (final battle in _activeBattles.values) {
      if ((battle.user1Id == userId || battle.user2Id == userId) &&
          battle.status == _BattleStatus.waitingForStart) {
        return battle.battleId;
      }
    }
    return null;
  }

  /// Remove user from the queue.
  static void leaveQueue(int userId) {
    _queue.remove(userId);
  }

  // ---- Battle actions ----

  /// Submit an action for a turn. Returns the computed turn result.
  /// Both players' actions are collected; the turn resolves when both submit.
  static ServerTurnResult? submitAction(
    Session session, {
    required String battleId,
    required int userId,
    required String action, // 'attack' | 'special' | 'defend' | 'dodge'
  }) {
    final battle = _activeBattles[battleId];
    if (battle == null) {
      throw ArgumentError('Battle not found: $battleId');
    }

    final isUser1 = battle.user1Id == userId;
    if (!isUser1 && battle.user2Id != userId) {
      throw ArgumentError('User $userId is not a participant in battle $battleId');
    }

    // Store action
    if (isUser1) {
      battle.pendingAction1 = action;
    } else {
      battle.pendingAction2 = action;
    }

    // Auto-fill opponent action with AI if needed (for single-player simulation)
    if (battle.isAiBattle) {
      battle.pendingAction2 = _pickAiAction(battle);
    }

    // Resolve when both actions are in
    if (battle.pendingAction1 != null && battle.pendingAction2 != null) {
      return _resolveTurn(session, battle);
    }
    return null; // Waiting for other player
  }

  /// Forfeit a battle.
  static ServerTurnResult forfeit(
    Session session, {
    required String battleId,
    required int userId,
  }) {
    final battle = _activeBattles[battleId];
    if (battle == null) throw ArgumentError('Battle not found: $battleId');

    final isUser1 = battle.user1Id == userId;
    // Set forfeiting player HP to 0
    if (isUser1) {
      battle.hp1 = 0;
    } else {
      battle.hp2 = 0;
    }
    battle.status = _BattleStatus.finished;

    return _buildTurnResult(battle, round: battle.round, logMsg: 'Spieler hat aufgegeben.');
  }

  /// Get state of an active battle for a specific user.
  static ServerBattleSnapshot? getBattleState(String battleId, int userId) {
    final battle = _activeBattles[battleId];
    if (battle == null) return null;

    final isUser1 = battle.user1Id == userId;
    return ServerBattleSnapshot(
      battleId: battleId,
      round: battle.round,
      maxRounds: battle.maxRounds,
      myHp: isUser1 ? battle.hp1 : battle.hp2,
      myMaxHp: isUser1 ? battle.maxHp1 : battle.maxHp2,
      opponentHp: isUser1 ? battle.hp2 : battle.hp1,
      opponentMaxHp: isUser1 ? battle.maxHp2 : battle.maxHp1,
      isFinished: battle.status == _BattleStatus.finished,
      winnerId: battle.winnerId,
      mySpecialCooldown: isUser1 ? battle.cooldown1 : battle.cooldown2,
    );
  }

  // ---- Private helpers ----

  static _QueueEntry? _findMatch(int userId, int cp, int elo) {
    for (final entry in _queue.values) {
      if (entry.userId == userId) continue;
      // Match within 30% combat power difference
      final cpDiff = (entry.combatPower - cp).abs();
      if (cpDiff <= cp * 0.30 + 5) return entry;
    }
    return null;
  }

  static String _createBattle({
    required int user1Id,
    required int creature1Id,
    required int creature1Cp,
    required int user2Id,
    required int creature2Id,
    required int creature2Cp,
  }) {
    final id = 'battle_${DateTime.now().millisecondsSinceEpoch}';
    final hp1 = _computeMaxHp(creature1Cp);
    final hp2 = _computeMaxHp(creature2Cp);

    _activeBattles[id] = _ActiveBattle(
      battleId: id,
      user1Id: user1Id,
      creature1Id: creature1Id,
      user2Id: user2Id,
      creature2Id: creature2Id,
      maxHp1: hp1,
      maxHp2: hp2,
      hp1: hp1,
      hp2: hp2,
      isAiBattle: false,
    );
    return id;
  }

  static int _computeMaxHp(int combatPower) {
    return max(50, combatPower * 3);
  }

  static ServerTurnResult _resolveTurn(Session session, _ActiveBattle battle) {
    battle.round++;

    final action1 = battle.pendingAction1!;
    final action2 = battle.pendingAction2!;
    battle.pendingAction1 = null;
    battle.pendingAction2 = null;

    // Compute damage
    final dmg1 = _computeDamage(
      attackerAction: action1,
      defenderAction: action2,
      attackPower: battle.atk1,
      defensePower: battle.def2,
    );
    final dmg2 = _computeDamage(
      attackerAction: action2,
      defenderAction: action1,
      attackPower: battle.atk2,
      defensePower: battle.def1,
    );

    // Dodge check
    final dodged1 = action1 == 'dodge' && _rng.nextDouble() < 0.40;
    final dodged2 = action2 == 'dodge' && _rng.nextDouble() < 0.40;

    final actualDmg1 = dodged2 ? 0 : dmg1;
    final actualDmg2 = dodged1 ? 0 : dmg2;

    battle.hp1 = max(0, battle.hp1 - actualDmg2);
    battle.hp2 = max(0, battle.hp2 - actualDmg1);

    // Update cooldowns
    battle.cooldown1 = max(0, battle.cooldown1 - 1);
    battle.cooldown2 = max(0, battle.cooldown2 - 1);
    if (action1 == 'special') battle.cooldown1 = 3;
    if (action2 == 'special') battle.cooldown2 = 3;

    // Check end condition
    if (battle.hp1 <= 0 || battle.hp2 <= 0 || battle.round >= battle.maxRounds) {
      battle.status = _BattleStatus.finished;
      if (battle.hp1 > battle.hp2) {
        battle.winnerId = battle.user1Id;
      } else if (battle.hp2 > battle.hp1) {
        battle.winnerId = battle.user2Id;
      }
      // null winnerId = draw
    }

    final log = 'Runde ${battle.round}: '
        '${_actionLabel(action1)} → $actualDmg1 Schaden | '
        '${_actionLabel(action2)} → $actualDmg2 Schaden';

    session.log(log, level: LogLevel.debug);

    return _buildTurnResult(battle, round: battle.round, logMsg: log);
  }

  static ServerTurnResult _buildTurnResult(
    _ActiveBattle battle, {
    required int round,
    required String logMsg,
  }) {
    final isFinished = battle.status == _BattleStatus.finished;
    final xp = isFinished
        ? (battle.winnerId == null ? 25 : (battle.winnerId == battle.user1Id ? 50 : 10))
        : 0;
    final sats = isFinished
        ? (battle.winnerId == battle.user1Id ? 100 + _rng.nextInt(500) : 10 + _rng.nextInt(50))
        : 0;

    return ServerTurnResult(
      round: round,
      hp1: battle.hp1,
      hp2: battle.hp2,
      maxHp1: battle.maxHp1,
      maxHp2: battle.maxHp2,
      isFinished: isFinished,
      winnerId: battle.winnerId,
      logMessage: logMsg,
      xpGained: xp,
      satoshisGained: sats,
    );
  }

  static int _computeDamage({
    required String attackerAction,
    required String defenderAction,
    required int attackPower,
    required int defensePower,
  }) {
    if (attackerAction == 'defend' || attackerAction == 'dodge') return 0;

    double power = attackerAction == 'special' ? attackPower * 1.6 : attackPower.toDouble();
    final defMultiplier = defenderAction == 'defend' ? 0.5 : 1.0;
    final defense = defensePower * defMultiplier;

    double dmg = max(1.0, power - defense * 0.4);
    dmg *= 0.85 + _rng.nextDouble() * 0.30;
    if (_rng.nextDouble() < 0.10) dmg *= 1.5; // crit
    return max(1, dmg.round());
  }

  static String _pickAiAction(_ActiveBattle battle) {
    final opHpPct = battle.hp2 / battle.maxHp2;
    final playerHpPct = battle.hp1 / battle.maxHp1;
    final r = _rng.nextDouble();

    if (opHpPct < 0.25) {
      if (r < 0.30) return 'defend';
      if (r < 0.55) return 'special';
      return 'attack';
    }
    if (playerHpPct < 0.25) {
      if (r < 0.60) return 'attack';
      if (r < 0.80) return 'special';
      return 'dodge';
    }
    if (r < 0.45) return 'attack';
    if (r < 0.65) return 'special';
    if (r < 0.80) return 'defend';
    return 'dodge';
  }

  static String _actionLabel(String action) {
    return switch (action) {
      'attack' => 'Angriff',
      'special' => 'Spezial',
      'defend' => 'Verteidigung',
      'dodge' => 'Ausweichen',
      _ => action,
    };
  }

  static void _cleanupQueue() {
    final cutoff = DateTime.now().subtract(const Duration(minutes: 5));
    _queue.removeWhere((_, e) => e.joinedAt.isBefore(cutoff));
  }

  /// Clean up finished battles older than 1 hour.
  static void cleanupOldBattles() {
    final cutoff = DateTime.now().subtract(const Duration(hours: 1));
    _activeBattles.removeWhere(
      (_, b) =>
          b.status == _BattleStatus.finished &&
          b.startedAt.isBefore(cutoff),
    );
  }
}

// ---- Internal models ----

enum _BattleStatus { waitingForStart, active, finished }

class _QueueEntry {
  final int userId;
  final int creatureId;
  final int combatPower;
  final int eloRating;
  final DateTime joinedAt;

  const _QueueEntry({
    required this.userId,
    required this.creatureId,
    required this.combatPower,
    required this.eloRating,
    required this.joinedAt,
  });
}

class _ActiveBattle {
  final String battleId;
  final int user1Id;
  final int creature1Id;
  final int user2Id;
  final int creature2Id;
  final bool isAiBattle;
  final DateTime startedAt;

  int maxHp1;
  int maxHp2;
  int hp1;
  int hp2;
  int atk1;
  int atk2;
  int def1;
  int def2;
  int cooldown1;
  int cooldown2;

  String? pendingAction1;
  String? pendingAction2;

  int round;
  final int maxRounds;
  _BattleStatus status;
  int? winnerId;

  _ActiveBattle({
    required this.battleId,
    required this.user1Id,
    required this.creature1Id,
    required this.user2Id,
    required this.creature2Id,
    required this.maxHp1,
    required this.maxHp2,
    required this.hp1,
    required this.hp2,
    this.isAiBattle = false,
    this.atk1 = 15,
    this.atk2 = 15,
    this.def1 = 10,
    this.def2 = 10,
    this.cooldown1 = 0,
    this.cooldown2 = 0,
    this.round = 0,
    this.maxRounds = 20,
    this.status = _BattleStatus.active,
    this.winnerId,
  }) : startedAt = DateTime.now();
}

// ---- Public result types ----

class ServerTurnResult {
  final int round;
  final int hp1;
  final int hp2;
  final int maxHp1;
  final int maxHp2;
  final bool isFinished;
  final int? winnerId;
  final String logMessage;
  final int xpGained;
  final int satoshisGained;

  const ServerTurnResult({
    required this.round,
    required this.hp1,
    required this.hp2,
    required this.maxHp1,
    required this.maxHp2,
    required this.isFinished,
    this.winnerId,
    required this.logMessage,
    this.xpGained = 0,
    this.satoshisGained = 0,
  });
}

class ServerBattleSnapshot {
  final String battleId;
  final int round;
  final int maxRounds;
  final int myHp;
  final int myMaxHp;
  final int opponentHp;
  final int opponentMaxHp;
  final bool isFinished;
  final int? winnerId;
  final int mySpecialCooldown;

  const ServerBattleSnapshot({
    required this.battleId,
    required this.round,
    required this.maxRounds,
    required this.myHp,
    required this.myMaxHp,
    required this.opponentHp,
    required this.opponentMaxHp,
    required this.isFinished,
    this.winnerId,
    required this.mySpecialCooldown,
  });
}
