import 'package:serverpod/serverpod.dart';

/// Arena PvP battle endpoint.
///
/// Handles:
/// - Matchmaking queue
/// - Battle initiation and actions
/// - Battle history
/// - Friend challenges
class ArenaEndpoint extends Endpoint {
  /// Join the matchmaking queue to find an opponent.
  Future<MatchmakingStatus> joinQueue(
    Session session, {
    required int creatureId,
  }) async {
    // TODO: Implement matchmaking queue join
    // 1. Verify creature ownership and eligibility (teen or adult)
    // 2. Check creature is not stunned or in battle
    // 3. Add to matchmaking queue with ELO range
    throw UnimplementedError('Join queue not yet implemented');
  }

  /// Leave the matchmaking queue.
  Future<void> leaveQueue(Session session) async {
    // TODO: Implement queue leave
    throw UnimplementedError('Leave queue not yet implemented');
  }

  /// Get current matchmaking status.
  Future<MatchmakingStatus> getQueueStatus(Session session) async {
    // TODO: Implement queue status check
    throw UnimplementedError('Get queue status not yet implemented');
  }

  /// Challenge a friend to a battle.
  Future<BattleChallenge> challengeFriend(
    Session session, {
    required int friendUserId,
    required int creatureId,
  }) async {
    // TODO: Implement friend challenge
    // 1. Verify friendship exists
    // 2. Create pending challenge
    // 3. Notify friend via WebSocket
    throw UnimplementedError('Challenge friend not yet implemented');
  }

  /// Accept or decline a battle challenge.
  Future<BattleInfo?> respondToChallenge(
    Session session, {
    required int challengeId,
    required bool accept,
    int? creatureId, // Required if accepting
  }) async {
    // TODO: Implement challenge response
    // 1. Verify challenge exists and is pending
    // 2. If accepting, create battle and return info
    // 3. If declining, cancel challenge
    throw UnimplementedError('Respond to challenge not yet implemented');
  }

  /// Get pending challenges for the current user.
  Future<List<BattleChallenge>> getPendingChallenges(Session session) async {
    // TODO: Implement pending challenges retrieval
    throw UnimplementedError('Get pending challenges not yet implemented');
  }

  /// Get info about an active battle.
  Future<BattleState> getBattleState(
    Session session, {
    required int battleId,
  }) async {
    // TODO: Implement battle state retrieval
    throw UnimplementedError('Get battle state not yet implemented');
  }

  /// Submit an action for the current turn.
  Future<TurnResult> submitAction(
    Session session, {
    required int battleId,
    required String actionType, // 'attack', 'special', 'defend', 'dodge'
  }) async {
    // TODO: Implement action submission
    // 1. Verify user is participant in battle
    // 2. Verify it's user's turn (or simultaneous turns)
    // 3. Process action
    // 4. Calculate damage/effects
    // 5. Check for battle end
    // 6. Return turn result
    throw UnimplementedError('Submit action not yet implemented');
  }

  /// Forfeit the current battle.
  Future<BattleResult> forfeit(
    Session session, {
    required int battleId,
  }) async {
    // TODO: Implement forfeit
    // 1. End battle with opponent as winner
    // 2. Apply ELO changes
    // 3. Award XP
    throw UnimplementedError('Forfeit not yet implemented');
  }

  /// Get battle history for the current user.
  Future<List<BattleHistoryEntry>> getBattleHistory(
    Session session, {
    int limit = 20,
    int offset = 0,
  }) async {
    // TODO: Implement battle history retrieval
    throw UnimplementedError('Get battle history not yet implemented');
  }

  /// Get detailed battle record with full log.
  Future<BattleRecord> getBattleRecord(
    Session session, {
    required int battleId,
  }) async {
    // TODO: Implement battle record retrieval
    throw UnimplementedError('Get battle record not yet implemented');
  }
}

/// Matchmaking queue status.
class MatchmakingStatus {
  final bool inQueue;
  final int? queuePosition;
  final Duration? estimatedWait;
  final int? foundBattleId;

  MatchmakingStatus({
    required this.inQueue,
    this.queuePosition,
    this.estimatedWait,
    this.foundBattleId,
  });
}

/// Battle challenge request.
class BattleChallenge {
  final int id;
  final int challengerUserId;
  final String challengerUsername;
  final int challengerCreatureId;
  final String challengerCreatureName;
  final int targetUserId;
  final DateTime createdAt;
  final DateTime expiresAt;

  BattleChallenge({
    required this.id,
    required this.challengerUserId,
    required this.challengerUsername,
    required this.challengerCreatureId,
    required this.challengerCreatureName,
    required this.targetUserId,
    required this.createdAt,
    required this.expiresAt,
  });
}

/// Basic battle information.
class BattleInfo {
  final int id;
  final String battleType;
  final int creature1Id;
  final int creature2Id;
  final DateTime startedAt;

  BattleInfo({
    required this.id,
    required this.battleType,
    required this.creature1Id,
    required this.creature2Id,
    required this.startedAt,
  });
}

/// Current state of a battle.
class BattleState {
  final int battleId;
  final int currentRound;
  final int maxRounds;
  // Player 1 (current user's opponent or self)
  final BattleCreatureState creature1;
  // Player 2
  final BattleCreatureState creature2;
  final bool isMyTurn;
  final bool isFinished;
  final int? winnerId;
  final List<BattleLogEntry> recentLog;

  BattleState({
    required this.battleId,
    required this.currentRound,
    required this.maxRounds,
    required this.creature1,
    required this.creature2,
    required this.isMyTurn,
    required this.isFinished,
    this.winnerId,
    required this.recentLog,
  });
}

/// Creature state during battle.
class BattleCreatureState {
  final int creatureId;
  final String name;
  final String typeName;
  final int currentHp;
  final int maxHp;
  final bool isDefending;
  final int specialCooldown;

  BattleCreatureState({
    required this.creatureId,
    required this.name,
    required this.typeName,
    required this.currentHp,
    required this.maxHp,
    required this.isDefending,
    required this.specialCooldown,
  });
}

/// Result of a single turn.
class TurnResult {
  final int round;
  final String myAction;
  final String opponentAction;
  final int damageDealt;
  final int damageTaken;
  final bool dodged;
  final bool opponentDodged;
  final bool battleEnded;
  final int? winnerId;
  final BattleCreatureState myCreature;
  final BattleCreatureState opponentCreature;

  TurnResult({
    required this.round,
    required this.myAction,
    required this.opponentAction,
    required this.damageDealt,
    required this.damageTaken,
    required this.dodged,
    required this.opponentDodged,
    required this.battleEnded,
    this.winnerId,
    required this.myCreature,
    required this.opponentCreature,
  });
}

/// Single entry in battle log.
class BattleLogEntry {
  final int round;
  final String action;
  final int actorCreatureId;
  final int? targetCreatureId;
  final int? damage;
  final String description;

  BattleLogEntry({
    required this.round,
    required this.action,
    required this.actorCreatureId,
    this.targetCreatureId,
    this.damage,
    required this.description,
  });
}

/// Final battle result.
class BattleResult {
  final int battleId;
  final int? winnerCreatureId;
  final int? winnerUserId;
  final bool isDraw;
  final int xpGained;
  final int satoshisGained;
  final int eloChange;
  final int totalRounds;

  BattleResult({
    required this.battleId,
    this.winnerCreatureId,
    this.winnerUserId,
    required this.isDraw,
    required this.xpGained,
    required this.satoshisGained,
    required this.eloChange,
    required this.totalRounds,
  });
}

/// Battle history entry.
class BattleHistoryEntry {
  final int battleId;
  final String battleType;
  final String opponentUsername;
  final String opponentCreatureName;
  final String myCreatureName;
  final bool won;
  final bool isDraw;
  final int xpGained;
  final int eloChange;
  final DateTime playedAt;

  BattleHistoryEntry({
    required this.battleId,
    required this.battleType,
    required this.opponentUsername,
    required this.opponentCreatureName,
    required this.myCreatureName,
    required this.won,
    required this.isDraw,
    required this.xpGained,
    required this.eloChange,
    required this.playedAt,
  });
}

/// Full battle record with log.
class BattleRecord {
  final int battleId;
  final String battleType;
  final DateTime startedAt;
  final DateTime endedAt;
  final int totalRounds;
  final int? winnerCreatureId;
  final BattleCreatureState finalCreature1State;
  final BattleCreatureState finalCreature2State;
  final List<BattleLogEntry> fullLog;

  BattleRecord({
    required this.battleId,
    required this.battleType,
    required this.startedAt,
    required this.endedAt,
    required this.totalRounds,
    this.winnerCreatureId,
    required this.finalCreature1State,
    required this.finalCreature2State,
    required this.fullLog,
  });
}
