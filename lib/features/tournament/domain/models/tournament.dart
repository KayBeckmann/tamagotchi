import 'package:flutter/material.dart';
import '../../arena/domain/models/battle.dart';

enum TournamentFormat {
  singleElimination,
  doubleElimination,
  roundRobin,
}

enum TournamentStatus {
  registration,
  ongoing,
  finished,
  cancelled,
}

class Tournament {
  final String id;
  final String title;
  final String description;
  final TournamentFormat format;
  final TournamentStatus status;
  final int entryFeeSats;
  final int prizePoolSats;
  final int maxParticipants;
  final List<String> participantIds;
  final DateTime startTime;
  final DateTime? endTime;
  final List<TournamentBracket> brackets;
  final String? winnerId;

  Tournament({
    required this.id,
    required this.title,
    required this.description,
    required this.format,
    required this.status,
    required this.entryFeeSats,
    required this.prizePoolSats,
    required this.maxParticipants,
    required this.participantIds,
    required this.startTime,
    this.endTime,
    required this.brackets,
    this.winnerId,
  });

  int get currentParticipants => participantIds.length;
  bool get isFull => currentParticipants >= maxParticipants;
}

class TournamentBracket {
  final int round;
  final List<TournamentMatch> matches;

  TournamentBracket({
    required this.round,
    required this.matches,
  });
}

class TournamentMatch {
  final String id;
  final String? player1Id;
  final String? player2Id;
  final String? winnerId;
  final BattleResult? result;
  final DateTime scheduledTime;
  final bool isFinished;

  TournamentMatch({
    required this.id,
    this.player1Id,
    this.player2Id,
    this.winnerId,
    this.result,
    required this.scheduledTime,
    this.isFinished = false,
  });
}
