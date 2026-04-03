import 'package:serverpod/serverpod.dart';

/// Realtime WebSocket endpoint for live updates.
///
/// Handles real-time communication for:
/// - Battle state updates (Arena & Tournament)
/// - Creature status changes
/// - Matchmaking notifications
/// - Friend activity
/// - Tournament bracket updates
///
/// ## WebSocket Channels
///
/// Users subscribe to channels based on their needs:
///
/// ### User Channel: `user:{userId}`
/// Personal notifications:
/// - Creature status alerts (hungry, sick, etc.)
/// - Friend requests
/// - Challenge invitations
/// - Tournament match ready
/// - Transaction confirmations
///
/// ### Battle Channel: `battle:{battleId}`
/// Real-time battle updates:
/// - Turn notifications
/// - Action results
/// - Battle end
///
/// ### Tournament Channel: `tournament:{tournamentId}`
/// Tournament updates:
/// - Bracket changes
/// - Match results
/// - Next round start
///
/// ### Matchmaking Channel: `matchmaking:{queueId}`
/// Queue updates:
/// - Match found
/// - Queue position
///
/// ## Message Types
///
/// All messages follow this structure:
/// ```json
/// {
///   "type": "message_type",
///   "channel": "channel_name",
///   "data": { ... },
///   "timestamp": "ISO8601"
/// }
/// ```
class RealtimeEndpoint extends Endpoint {
  /// Subscribe to a channel for real-time updates.
  ///
  /// Valid channel prefixes:
  /// - `user:` - Personal notifications (auto-subscribed on connect)
  /// - `battle:` - Battle updates (requires participation)
  /// - `tournament:` - Tournament updates (requires registration)
  Future<SubscriptionResult> subscribe(
    Session session, {
    required String channel,
  }) async {
    // TODO: Implement channel subscription
    // 1. Validate channel format
    // 2. Verify user authorization for channel
    // 3. Add user to channel subscribers
    throw UnimplementedError('Subscribe not yet implemented');
  }

  /// Unsubscribe from a channel.
  Future<void> unsubscribe(
    Session session, {
    required String channel,
  }) async {
    // TODO: Implement channel unsubscription
    throw UnimplementedError('Unsubscribe not yet implemented');
  }

  /// Get list of current subscriptions.
  Future<List<String>> getSubscriptions(Session session) async {
    // TODO: Implement subscription list
    throw UnimplementedError('Get subscriptions not yet implemented');
  }

  /// Send a ping to keep connection alive.
  Future<PongResponse> ping(Session session) async {
    return PongResponse(
      timestamp: DateTime.now(),
      serverTime: DateTime.now().toUtc(),
    );
  }
}

/// Result of channel subscription.
class SubscriptionResult {
  final bool success;
  final String channel;
  final String? error;

  SubscriptionResult({
    required this.success,
    required this.channel,
    this.error,
  });
}

/// Ping response.
class PongResponse {
  final DateTime timestamp;
  final DateTime serverTime;

  PongResponse({
    required this.timestamp,
    required this.serverTime,
  });
}

// ============================================================================
// WebSocket Message Types (for documentation/reference)
// ============================================================================

/// Base class for all WebSocket messages.
abstract class WebSocketMessage {
  String get type;
  String get channel;
  DateTime get timestamp;
  Map<String, dynamic> toJson();
}

/// Notification about creature status.
class CreatureStatusMessage {
  static const String type = 'creature_status';

  final int creatureId;
  final String creatureName;
  final String alertType; // 'hungry', 'sick', 'unhappy', 'tired', 'dirty', 'dying'
  final int currentValue;
  final String message;

  CreatureStatusMessage({
    required this.creatureId,
    required this.creatureName,
    required this.alertType,
    required this.currentValue,
    required this.message,
  });
}

/// Battle turn notification.
class BattleTurnMessage {
  static const String type = 'battle_turn';

  final int battleId;
  final int round;
  final bool isYourTurn;
  final int timeRemainingSeconds;
  final Map<String, dynamic> lastAction;

  BattleTurnMessage({
    required this.battleId,
    required this.round,
    required this.isYourTurn,
    required this.timeRemainingSeconds,
    required this.lastAction,
  });
}

/// Battle ended notification.
class BattleEndMessage {
  static const String type = 'battle_end';

  final int battleId;
  final int? winnerCreatureId;
  final int? winnerUserId;
  final bool isDraw;
  final int xpGained;
  final int satoshisGained;
  final int eloChange;

  BattleEndMessage({
    required this.battleId,
    this.winnerCreatureId,
    this.winnerUserId,
    required this.isDraw,
    required this.xpGained,
    required this.satoshisGained,
    required this.eloChange,
  });
}

/// Match found in queue.
class MatchFoundMessage {
  static const String type = 'match_found';

  final int battleId;
  final String opponentUsername;
  final String opponentCreatureName;
  final int opponentElo;

  MatchFoundMessage({
    required this.battleId,
    required this.opponentUsername,
    required this.opponentCreatureName,
    required this.opponentElo,
  });
}

/// Challenge received from friend.
class ChallengeReceivedMessage {
  static const String type = 'challenge_received';

  final int challengeId;
  final int challengerUserId;
  final String challengerUsername;
  final String challengerCreatureName;
  final DateTime expiresAt;

  ChallengeReceivedMessage({
    required this.challengeId,
    required this.challengerUserId,
    required this.challengerUsername,
    required this.challengerCreatureName,
    required this.expiresAt,
  });
}

/// Tournament match ready notification.
class TournamentMatchReadyMessage {
  static const String type = 'tournament_match_ready';

  final int tournamentId;
  final String tournamentName;
  final int matchId;
  final String roundName;
  final String opponentUsername;
  final DateTime deadlineAt;

  TournamentMatchReadyMessage({
    required this.tournamentId,
    required this.tournamentName,
    required this.matchId,
    required this.roundName,
    required this.opponentUsername,
    required this.deadlineAt,
  });
}

/// Tournament bracket update.
class TournamentBracketUpdateMessage {
  static const String type = 'tournament_bracket_update';

  final int tournamentId;
  final int currentRound;
  final List<Map<String, dynamic>> updatedMatches;

  TournamentBracketUpdateMessage({
    required this.tournamentId,
    required this.currentRound,
    required this.updatedMatches,
  });
}

/// Transaction confirmation.
class TransactionConfirmedMessage {
  static const String type = 'transaction_confirmed';

  final int transactionId;
  final String transactionType;
  final int amountSatoshis;
  final int newBalance;
  final String message;

  TransactionConfirmedMessage({
    required this.transactionId,
    required this.transactionType,
    required this.amountSatoshis,
    required this.newBalance,
    required this.message,
  });
}

/// Friend request received.
class FriendRequestMessage {
  static const String type = 'friend_request';

  final int requestId;
  final int fromUserId;
  final String fromUsername;
  final String? fromAvatarUrl;

  FriendRequestMessage({
    required this.requestId,
    required this.fromUserId,
    required this.fromUsername,
    this.fromAvatarUrl,
  });
}
