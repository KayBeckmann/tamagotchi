import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../domain/models/tournament.dart';
import '../../creature/domain/models/creature_type.dart';

/// Tournament repository with in-memory demo data.
class TournamentRepository {
  final _uuid = const Uuid();
  final _rng = Random();

  late final List<Tournament> _tournaments;

  TournamentRepository() {
    _tournaments = _generateDemoTournaments();
  }

  /// Get all tournaments.
  Future<List<Tournament>> getTournaments() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_tournaments);
  }

  /// Get a tournament by ID.
  Future<Tournament?> getTournament(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _tournaments.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Register a creature for a tournament.
  Future<Tournament> register({
    required String tournamentId,
    required String userId,
    required String username,
    required String creatureId,
    required String creatureName,
    required String creatureTypeId,
    required int eloRating,
    required int currentSatoshis,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final idx = _tournaments.indexWhere((t) => t.id == tournamentId);
    if (idx < 0) throw Exception('Turnier nicht gefunden');

    final tournament = _tournaments[idx];
    if (tournament.status != TournamentStatus.registration) {
      throw Exception('Anmeldung ist nicht mehr möglich');
    }
    if (tournament.isFull) {
      throw Exception('Turnier ist bereits voll');
    }
    if (currentSatoshis < tournament.entryFeeSatoshis) {
      throw Exception('Nicht genügend Satoshis (${tournament.entryFeeSatoshis} benötigt)');
    }
    if (tournament.isCurrentUserParticipating) {
      throw Exception('Du bist bereits angemeldet');
    }

    final newParticipant = TournamentParticipant(
      userId: userId,
      username: username,
      creatureId: creatureId,
      creatureName: creatureName,
      creatureTypeId: creatureTypeId,
      eloRating: eloRating,
      seed: tournament.currentParticipants + 1,
      isCurrentUser: true,
    );

    final newParticipants = [...tournament.participants, newParticipant];
    final newPot = tournament.prizePotSatoshis + tournament.entryFeeSatoshis;

    final updated = Tournament(
      id: tournament.id,
      name: tournament.name,
      description: tournament.description,
      format: tournament.format,
      status: tournament.status,
      maxParticipants: tournament.maxParticipants,
      entryFeeSatoshis: tournament.entryFeeSatoshis,
      prizePotSatoshis: newPot,
      participants: newParticipants,
      registrationEndsAt: tournament.registrationEndsAt,
      bracket: tournament.bracket,
    );

    _tournaments[idx] = updated;
    return updated;
  }

  /// Cancel registration.
  Future<Tournament> cancelRegistration(String tournamentId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final idx = _tournaments.indexWhere((t) => t.id == tournamentId);
    if (idx < 0) throw Exception('Turnier nicht gefunden');

    final tournament = _tournaments[idx];
    final newParticipants =
        tournament.participants.where((p) => !p.isCurrentUser).toList();
    final refund = tournament.entryFeeSatoshis;

    final updated = Tournament(
      id: tournament.id,
      name: tournament.name,
      description: tournament.description,
      format: tournament.format,
      status: tournament.status,
      maxParticipants: tournament.maxParticipants,
      entryFeeSatoshis: tournament.entryFeeSatoshis,
      prizePotSatoshis: max(0, tournament.prizePotSatoshis - refund),
      participants: newParticipants,
      registrationEndsAt: tournament.registrationEndsAt,
    );
    _tournaments[idx] = updated;
    return updated;
  }

  // ---- Demo data generation ----

  List<Tournament> _generateDemoTournaments() {
    return [
      _generateTournament(
        name: 'Frühlingsmeisterschaft 2026',
        description: 'Das große Saisonturnier für alle Kreaturen!',
        format: TournamentFormat.singleElimination,
        status: TournamentStatus.registration,
        maxParticipants: 8,
        entryFeeSatoshis: 5000,
        participantCount: 5,
        registrationEndsIn: const Duration(hours: 6),
      ),
      _generateTournament(
        name: 'Anfänger-Cup',
        description: 'Kostenloses Turnier für neue Spieler.',
        format: TournamentFormat.roundRobin,
        status: TournamentStatus.registration,
        maxParticipants: 8,
        entryFeeSatoshis: 0,
        participantCount: 3,
        registrationEndsIn: const Duration(days: 1),
      ),
      _generateTournament(
        name: 'Winterkrieger 2026',
        description: 'Doppel-Ausscheidung – nur die Stärksten überleben!',
        format: TournamentFormat.doubleElimination,
        status: TournamentStatus.active,
        maxParticipants: 8,
        entryFeeSatoshis: 10000,
        participantCount: 8,
        registrationEndsIn: Duration.zero,
      ),
      _generateTournament(
        name: 'Herbst-Clash 2025',
        description: 'Das vergangene Herbstturnier.',
        format: TournamentFormat.singleElimination,
        status: TournamentStatus.completed,
        maxParticipants: 8,
        entryFeeSatoshis: 2000,
        participantCount: 8,
        registrationEndsIn: Duration.zero,
      ),
    ];
  }

  Tournament _generateTournament({
    required String name,
    required String description,
    required TournamentFormat format,
    required TournamentStatus status,
    required int maxParticipants,
    required int entryFeeSatoshis,
    required int participantCount,
    required Duration registrationEndsIn,
  }) {
    final id = _uuid.v4();
    final participants = _generateParticipants(participantCount, maxParticipants);
    final pot = entryFeeSatoshis * participantCount;

    TournamentBracket? bracket;
    TournamentParticipant? champion;

    if (status == TournamentStatus.active || status == TournamentStatus.completed) {
      bracket = _generateBracket(participants, maxParticipants, status);
    }
    if (status == TournamentStatus.completed && participants.isNotEmpty) {
      champion = participants.first;
    }

    return Tournament(
      id: id,
      name: name,
      description: description,
      format: format,
      status: status,
      maxParticipants: maxParticipants,
      entryFeeSatoshis: entryFeeSatoshis,
      prizePotSatoshis: pot,
      participants: participants,
      registrationEndsAt: DateTime.now().add(registrationEndsIn),
      bracket: bracket,
      startedAt: status != TournamentStatus.registration
          ? DateTime.now().subtract(const Duration(hours: 2))
          : null,
      completedAt: status == TournamentStatus.completed
          ? DateTime.now().subtract(const Duration(hours: 1))
          : null,
      champion: champion,
    );
  }

  List<TournamentParticipant> _generateParticipants(int count, int max) {
    const names = [
      'DragonMaster', 'ShadowWolf', 'LightningBolt', 'IceQueen',
      'FireKing', 'ThunderBird', 'MysticFox', 'NightHunter',
    ];
    final allTypes = CreatureCatalog.all;

    final participants = <TournamentParticipant>[];
    for (int i = 0; i < count && i < max; i++) {
      final type = allTypes[_rng.nextInt(allTypes.length)];
      participants.add(TournamentParticipant(
        userId: 'user_$i',
        username: names[i % names.length],
        creatureId: _uuid.v4(),
        creatureName: '${type.name}_$i',
        creatureTypeId: type.id,
        eloRating: 900 + _rng.nextInt(600),
        seed: i + 1,
      ));
    }
    return participants;
  }

  TournamentBracket _generateBracket(
    List<TournamentParticipant> participants,
    int maxParticipants,
    TournamentStatus status,
  ) {
    final totalRounds = (log(maxParticipants) / log(2)).ceil();
    final matches = <TournamentMatch>[];
    int matchIdx = 0;

    // Round 1: pair participants by seed
    final round1Matches = maxParticipants ~/ 2;
    for (int pos = 1; pos <= round1Matches; pos++) {
      final p1Idx = (pos - 1) * 2;
      final p2Idx = p1Idx + 1;
      final p1 = p1Idx < participants.length ? participants[p1Idx] : null;
      final p2 = p2Idx < participants.length ? participants[p2Idx] : null;

      TournamentParticipant? winner;
      bool completed = false;

      if (status == TournamentStatus.active ||
          status == TournamentStatus.completed) {
        if (p1 != null && p2 != null) {
          winner = _rng.nextBool() ? p1 : p2;
          completed = true;
        } else if (p1 != null) {
          winner = p1; // bye
          completed = true;
        }
      }

      matches.add(TournamentMatch(
        matchId: 'match_${matchIdx++}',
        round: 1,
        position: pos,
        participant1: p1,
        participant2: p2,
        winner: winner,
        isCompleted: completed,
        scheduledAt: DateTime.now().subtract(const Duration(hours: 1)),
      ));
    }

    // Later rounds (simplified – winners advance)
    for (int round = 2; round <= totalRounds; round++) {
      final prevRoundMatches =
          matches.where((m) => m.round == round - 1).toList();
      final numMatches = prevRoundMatches.length ~/ 2;

      for (int pos = 1; pos <= numMatches; pos++) {
        final m1 = pos <= prevRoundMatches.length
            ? prevRoundMatches[(pos - 1) * 2]
            : null;
        final m2 = (pos - 1) * 2 + 1 < prevRoundMatches.length
            ? prevRoundMatches[(pos - 1) * 2 + 1]
            : null;

        final p1 = m1?.winner;
        final p2 = m2?.winner;
        final isFinalRound = round == totalRounds;

        TournamentParticipant? winner;
        bool completed = status == TournamentStatus.completed ||
            (status == TournamentStatus.active && !isFinalRound);

        if (completed && p1 != null && p2 != null) {
          winner = _rng.nextBool() ? p1 : p2;
        }

        matches.add(TournamentMatch(
          matchId: 'match_${matchIdx++}',
          round: round,
          position: pos,
          participant1: p1,
          participant2: p2,
          winner: winner,
          isCompleted: completed,
          scheduledAt: DateTime.now(),
        ));
      }
    }

    return TournamentBracket(totalRounds: totalRounds, matches: matches);
  }
}

final tournamentRepositoryProvider = Provider<TournamentRepository>((ref) {
  return TournamentRepository();
});
