import 'package:serverpod/serverpod.dart';
import '../services/arena_battle_service.dart';

/// Arena PvP battle endpoint.
///
/// Handles matchmaking, battle actions, and history.
/// Battle logic runs server-side for anti-cheat.
class ArenaEndpoint extends Endpoint {
  /// Join the matchmaking queue to find an opponent.
  ///
  /// Returns a battle ID immediately if a match is found, otherwise null
  /// (client should poll [checkQueueStatus] until a match appears).
  Future<String?> joinQueue(
    Session session, {
    required int creatureId,
    required int combatPower,
    required int eloRating,
  }) async {
    final userId = _requireUserId(session);

    return ArenaBattleService.joinQueue(
      session,
      userId: userId,
      creatureId: creatureId,
      combatPower: combatPower,
      eloRating: eloRating,
    );
  }

  /// Check if a queued player has been matched.
  /// Returns a battle ID when a match is found, null otherwise.
  Future<String?> checkQueueStatus(Session session) async {
    final userId = _requireUserId(session);
    return ArenaBattleService.checkQueueStatus(userId);
  }

  /// Leave the matchmaking queue.
  Future<void> leaveQueue(Session session) async {
    final userId = _requireUserId(session);
    ArenaBattleService.leaveQueue(userId);
  }

  /// Get the current state of an active battle.
  Future<Map<String, dynamic>?> getBattleState(
    Session session, {
    required String battleId,
  }) async {
    final userId = _requireUserId(session);
    final snapshot = ArenaBattleService.getBattleState(battleId, userId);
    if (snapshot == null) return null;

    return {
      'battleId': snapshot.battleId,
      'round': snapshot.round,
      'maxRounds': snapshot.maxRounds,
      'myHp': snapshot.myHp,
      'myMaxHp': snapshot.myMaxHp,
      'opponentHp': snapshot.opponentHp,
      'opponentMaxHp': snapshot.opponentMaxHp,
      'isFinished': snapshot.isFinished,
      'winnerId': snapshot.winnerId,
      'mySpecialCooldown': snapshot.mySpecialCooldown,
    };
  }

  /// Submit a battle action for the current round.
  ///
  /// [action] must be one of: 'attack', 'special', 'defend', 'dodge'
  ///
  /// Returns the turn result as a map when both players have submitted,
  /// or null if still waiting for the opponent.
  Future<Map<String, dynamic>?> submitAction(
    Session session, {
    required String battleId,
    required String action,
  }) async {
    final userId = _requireUserId(session);

    if (!{'attack', 'special', 'defend', 'dodge'}.contains(action)) {
      throw ArgumentError('Invalid action: $action');
    }

    final result = ArenaBattleService.submitAction(
      session,
      battleId: battleId,
      userId: userId,
      action: action,
    );

    if (result == null) return null;

    return {
      'round': result.round,
      'hp1': result.hp1,
      'hp2': result.hp2,
      'maxHp1': result.maxHp1,
      'maxHp2': result.maxHp2,
      'isFinished': result.isFinished,
      'winnerId': result.winnerId,
      'logMessage': result.logMessage,
      'xpGained': result.xpGained,
      'satoshisGained': result.satoshisGained,
    };
  }

  /// Forfeit the current battle (immediate loss).
  Future<Map<String, dynamic>> forfeit(
    Session session, {
    required String battleId,
  }) async {
    final userId = _requireUserId(session);
    final result = ArenaBattleService.forfeit(
      session,
      battleId: battleId,
      userId: userId,
    );

    return {
      'round': result.round,
      'hp1': result.hp1,
      'hp2': result.hp2,
      'maxHp1': result.maxHp1,
      'maxHp2': result.maxHp2,
      'isFinished': result.isFinished,
      'winnerId': result.winnerId,
      'logMessage': result.logMessage,
      'xpGained': result.xpGained,
      'satoshisGained': result.satoshisGained,
    };
  }

  /// Get the current user's battle history (last [limit] entries).
  Future<List<Map<String, dynamic>>> getBattleHistory(
    Session session, {
    int limit = 20,
    int offset = 0,
  }) async {
    _requireUserId(session);
    // TODO: Fetch from database once DB is wired up.
    // Currently returns empty list – client maintains its own history.
    return [];
  }

  // ---- helpers ----

  int _requireUserId(Session session) {
    // TODO: Extract from JWT claims once auth is wired to session.
    // For development, use a placeholder.
    return session.sessionId?.hashCode ?? 1;
  }
}
