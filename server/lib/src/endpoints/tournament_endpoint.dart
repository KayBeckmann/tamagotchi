import 'package:serverpod/serverpod.dart';

/// Tournament management endpoint.
///
/// Handles:
/// - Tournament listing and details
/// - Registration and payment
/// - Bracket viewing
/// - Match scheduling
class TournamentEndpoint extends Endpoint {
  /// Get list of tournaments with filtering.
  Future<List<TournamentInfo>> getTournaments(
    Session session, {
    String? status, // 'registration', 'active', 'completed'
    int limit = 20,
    int offset = 0,
  }) async {
    // TODO: Implement tournament listing
    throw UnimplementedError('Get tournaments not yet implemented');
  }

  /// Get detailed tournament information.
  Future<TournamentDetail> getTournament(
    Session session, {
    required int tournamentId,
  }) async {
    // TODO: Implement tournament detail retrieval
    throw UnimplementedError('Get tournament not yet implemented');
  }

  /// Get tournament bracket/matches.
  Future<TournamentBracket> getBracket(
    Session session, {
    required int tournamentId,
  }) async {
    // TODO: Implement bracket retrieval
    throw UnimplementedError('Get bracket not yet implemented');
  }

  /// Register for a tournament (initiates payment).
  Future<TournamentRegistration> register(
    Session session, {
    required int tournamentId,
    required int creatureId,
  }) async {
    // TODO: Implement tournament registration
    // 1. Verify registration is open
    // 2. Verify creature eligibility (adult stage)
    // 3. Verify user has sufficient balance
    // 4. Create pending registration
    // 5. Deduct entry fee
    // 6. Return registration status
    throw UnimplementedError('Register not yet implemented');
  }

  /// Cancel tournament registration (if still in registration phase).
  Future<void> cancelRegistration(
    Session session, {
    required int tournamentId,
  }) async {
    // TODO: Implement registration cancellation
    // 1. Verify tournament still in registration phase
    // 2. Refund entry fee
    // 3. Remove from participants
    throw UnimplementedError('Cancel registration not yet implemented');
  }

  /// Get user's tournament history.
  Future<List<TournamentHistoryEntry>> getMyTournamentHistory(
    Session session, {
    int limit = 20,
    int offset = 0,
  }) async {
    // TODO: Implement tournament history
    throw UnimplementedError('Get tournament history not yet implemented');
  }

  /// Get upcoming matches for the user in active tournaments.
  Future<List<TournamentMatch>> getMyUpcomingMatches(Session session) async {
    // TODO: Implement upcoming matches retrieval
    throw UnimplementedError('Get upcoming matches not yet implemented');
  }

  /// Report ready for a tournament match.
  Future<void> reportReady(
    Session session, {
    required int matchId,
  }) async {
    // TODO: Implement ready report
    // When both players ready, start the match
    throw UnimplementedError('Report ready not yet implemented');
  }
}

/// Basic tournament information.
class TournamentInfo {
  final int id;
  final String name;
  final String format;
  final String status;
  final int maxParticipants;
  final int currentParticipants;
  final int entryFeeSatoshis;
  final int prizePoolSatoshis;
  final DateTime registrationEndAt;
  final DateTime tournamentStartAt;

  TournamentInfo({
    required this.id,
    required this.name,
    required this.format,
    required this.status,
    required this.maxParticipants,
    required this.currentParticipants,
    required this.entryFeeSatoshis,
    required this.prizePoolSatoshis,
    required this.registrationEndAt,
    required this.tournamentStartAt,
  });
}

/// Detailed tournament information.
class TournamentDetail {
  final int id;
  final String name;
  final String description;
  final String format;
  final String status;
  final int maxParticipants;
  final int currentParticipants;
  final int entryFeeSatoshis;
  final int prizePoolSatoshis;
  final int firstPlacePct;
  final int secondPlacePct;
  final int thirdPlacePct;
  final DateTime registrationStartAt;
  final DateTime registrationEndAt;
  final DateTime tournamentStartAt;
  final int roundDurationHours;
  final bool isRegistered;
  final int? myCreatureId;
  final int? winnerId;
  final String? winnerUsername;

  TournamentDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.format,
    required this.status,
    required this.maxParticipants,
    required this.currentParticipants,
    required this.entryFeeSatoshis,
    required this.prizePoolSatoshis,
    required this.firstPlacePct,
    required this.secondPlacePct,
    required this.thirdPlacePct,
    required this.registrationStartAt,
    required this.registrationEndAt,
    required this.tournamentStartAt,
    required this.roundDurationHours,
    required this.isRegistered,
    this.myCreatureId,
    this.winnerId,
    this.winnerUsername,
  });
}

/// Tournament bracket structure.
class TournamentBracket {
  final int tournamentId;
  final String format;
  final int totalRounds;
  final int currentRound;
  final List<BracketRound> rounds;

  TournamentBracket({
    required this.tournamentId,
    required this.format,
    required this.totalRounds,
    required this.currentRound,
    required this.rounds,
  });
}

/// Single round in bracket.
class BracketRound {
  final int roundNumber;
  final String name; // 'Round of 16', 'Quarter-Finals', etc.
  final List<BracketMatch> matches;

  BracketRound({
    required this.roundNumber,
    required this.name,
    required this.matches,
  });
}

/// Single match in bracket.
class BracketMatch {
  final int matchId;
  final int position;
  final BracketParticipant? participant1;
  final BracketParticipant? participant2;
  final int? winnerId;
  final String status; // 'pending', 'ready', 'active', 'completed'
  final DateTime? scheduledAt;
  final DateTime? completedAt;

  BracketMatch({
    required this.matchId,
    required this.position,
    this.participant1,
    this.participant2,
    this.winnerId,
    required this.status,
    this.scheduledAt,
    this.completedAt,
  });
}

/// Participant in bracket.
class BracketParticipant {
  final int participantId;
  final int userId;
  final String username;
  final int creatureId;
  final String creatureName;
  final int seedNumber;
  final bool isEliminated;

  BracketParticipant({
    required this.participantId,
    required this.userId,
    required this.username,
    required this.creatureId,
    required this.creatureName,
    required this.seedNumber,
    required this.isEliminated,
  });
}

/// Tournament registration result.
class TournamentRegistration {
  final bool success;
  final int? participantId;
  final int? seedNumber;
  final String message;

  TournamentRegistration({
    required this.success,
    this.participantId,
    this.seedNumber,
    required this.message,
  });
}

/// Tournament history entry.
class TournamentHistoryEntry {
  final int tournamentId;
  final String tournamentName;
  final String format;
  final int placement;
  final int prizeWonSatoshis;
  final String creatureName;
  final DateTime completedAt;

  TournamentHistoryEntry({
    required this.tournamentId,
    required this.tournamentName,
    required this.format,
    required this.placement,
    required this.prizeWonSatoshis,
    required this.creatureName,
    required this.completedAt,
  });
}

/// Upcoming tournament match.
class TournamentMatch {
  final int matchId;
  final int tournamentId;
  final String tournamentName;
  final String roundName;
  final String? opponentUsername;
  final String? opponentCreatureName;
  final DateTime? scheduledAt;
  final DateTime deadlineAt;
  final bool opponentReady;

  TournamentMatch({
    required this.matchId,
    required this.tournamentId,
    required this.tournamentName,
    required this.roundName,
    this.opponentUsername,
    this.opponentCreatureName,
    this.scheduledAt,
    required this.deadlineAt,
    required this.opponentReady,
  });
}
