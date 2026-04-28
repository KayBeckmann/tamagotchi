import 'package:equatable/equatable.dart';

/// Tournament format.
enum TournamentFormat {
  singleElimination,
  doubleElimination,
  roundRobin,
}

extension TournamentFormatExtension on TournamentFormat {
  String get displayName {
    switch (this) {
      case TournamentFormat.singleElimination:
        return 'Einzelausscheidung';
      case TournamentFormat.doubleElimination:
        return 'Doppel-Ausscheidung';
      case TournamentFormat.roundRobin:
        return 'Rundenturnier';
    }
  }
}

/// Tournament lifecycle phase.
enum TournamentStatus {
  registration,
  active,
  completed,
  cancelled,
}

extension TournamentStatusExtension on TournamentStatus {
  String get displayName {
    switch (this) {
      case TournamentStatus.registration:
        return 'Anmeldung';
      case TournamentStatus.active:
        return 'Laufend';
      case TournamentStatus.completed:
        return 'Abgeschlossen';
      case TournamentStatus.cancelled:
        return 'Abgesagt';
    }
  }
}

/// A tournament participant.
class TournamentParticipant extends Equatable {
  final String userId;
  final String username;
  final String creatureId;
  final String creatureName;
  final String creatureTypeId;
  final int eloRating;
  final int seed;            // Seeding position (1 = highest ELO)
  final bool isEliminated;
  final bool isCurrentUser;

  const TournamentParticipant({
    required this.userId,
    required this.username,
    required this.creatureId,
    required this.creatureName,
    required this.creatureTypeId,
    required this.eloRating,
    required this.seed,
    this.isEliminated = false,
    this.isCurrentUser = false,
  });

  @override
  List<Object?> get props => [userId, creatureId];
}

/// A single match in a tournament bracket.
class TournamentMatch extends Equatable {
  final String matchId;
  final int round;          // 1 = first round, 2 = quarterfinals, etc.
  final int position;       // Position in that round (1-indexed)
  final TournamentParticipant? participant1;
  final TournamentParticipant? participant2;
  final TournamentParticipant? winner;
  final bool isCompleted;
  final DateTime? scheduledAt;

  const TournamentMatch({
    required this.matchId,
    required this.round,
    required this.position,
    this.participant1,
    this.participant2,
    this.winner,
    this.isCompleted = false,
    this.scheduledAt,
  });

  bool get hasParticipants =>
      participant1 != null && participant2 != null;

  bool get isBye =>
      (participant1 != null && participant2 == null) ||
      (participant1 == null && participant2 != null);

  @override
  List<Object?> get props => [matchId];
}

/// Complete tournament bracket.
class TournamentBracket extends Equatable {
  final int totalRounds;
  final List<TournamentMatch> matches;

  const TournamentBracket({
    required this.totalRounds,
    required this.matches,
  });

  List<TournamentMatch> matchesForRound(int round) =>
      matches.where((m) => m.round == round).toList()
        ..sort((a, b) => a.position.compareTo(b.position));

  @override
  List<Object?> get props => [totalRounds, matches.length];
}

/// Full tournament information.
class Tournament extends Equatable {
  final String id;
  final String name;
  final String description;
  final TournamentFormat format;
  final TournamentStatus status;

  final int maxParticipants;    // 8, 16, or 32
  final int entryFeeSatoshis;   // 0 = free tournament
  final int prizePotSatoshis;   // Accumulated pot

  final List<TournamentParticipant> participants;
  final TournamentBracket? bracket;

  final DateTime registrationEndsAt;
  final DateTime? startedAt;
  final DateTime? completedAt;

  final TournamentParticipant? champion;

  const Tournament({
    required this.id,
    required this.name,
    required this.description,
    required this.format,
    required this.status,
    required this.maxParticipants,
    required this.entryFeeSatoshis,
    required this.prizePotSatoshis,
    required this.participants,
    required this.registrationEndsAt,
    this.bracket,
    this.startedAt,
    this.completedAt,
    this.champion,
  });

  int get currentParticipants => participants.length;
  bool get isFull => currentParticipants >= maxParticipants;
  bool get isFree => entryFeeSatoshis == 0;

  bool get isCurrentUserParticipating =>
      participants.any((p) => p.isCurrentUser);

  @override
  List<Object?> get props => [id];
}
