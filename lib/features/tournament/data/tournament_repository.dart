import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/tournament.dart';
import '../../../wallet/data/wallet_repository.dart';

class TournamentRepository {
  final WalletRepository _walletRepository;

  // In-memory storage for development
  final List<Tournament> _tournaments = [];

  TournamentRepository(this._walletRepository) {
    _initializeMockTournaments();
  }

  void _initializeMockTournaments() {
    _tournaments.addAll([
      Tournament(
        id: 'tour_1',
        title: 'Wochenend-Duell',
        description: 'Ein schnelles Turnier für alle Kreaturen ab Stufe Kind.',
        format: TournamentFormat.singleElimination,
        status: TournamentStatus.registration,
        entryFeeSats: 500,
        prizePoolSats: 5000,
        maxParticipants: 8,
        participantIds: ['user_2', 'user_3', 'user_4'],
        startTime: DateTime.now().add(const Duration(hours: 4)),
        brackets: [],
      ),
      Tournament(
        id: 'tour_2',
        title: 'Meisterschaft der Elemente',
        description: 'Beweise deine Stärke im großen Elementar-Turnier.',
        format: TournamentFormat.singleElimination,
        status: TournamentStatus.ongoing,
        entryFeeSats: 1000,
        prizePoolSats: 25000,
        maxParticipants: 16,
        participantIds: List.generate(12, (i) => 'user_${i + 5}'),
        startTime: DateTime.now().subtract(const Duration(hours: 1)),
        brackets: [
          TournamentBracket(
            round: 1,
            matches: List.generate(8, (i) => TournamentMatch(
              id: 'match_$i',
              player1Id: 'user_${i * 2 + 5}',
              player2Id: 'user_${i * 2 + 6}',
              scheduledTime: DateTime.now(),
            )),
          ),
        ],
      ),
      Tournament(
        id: 'tour_3',
        title: 'Mitternachts-Arena',
        description: 'Kämpfe unter dem Sternenhimmel.',
        format: TournamentFormat.singleElimination,
        status: TournamentStatus.finished,
        entryFeeSats: 100,
        prizePoolSats: 1500,
        maxParticipants: 4,
        participantIds: ['user_1', 'user_5', 'user_9', 'user_12'],
        startTime: DateTime.now().subtract(const Duration(days: 1)),
        endTime: DateTime.now().subtract(const Duration(hours: 20)),
        winnerId: 'user_1',
        brackets: [],
      ),
    ]);
  }

  Future<List<Tournament>> getTournaments() async {
    // TODO: Replace with actual API call
    await Future.delayed(const Duration(milliseconds: 300));
    return _tournaments;
  }

  Future<Tournament?> getTournament(String tournamentId) async {
    // TODO: Replace with actual API call
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _tournaments.firstWhere((t) => t.id == tournamentId);
    } catch (_) {
      return null;
    }
  }

  Future<void> joinTournament(String userId, String tournamentId) async {
    final index = _tournaments.indexWhere((t) => t.id == tournamentId);
    if (index < 0) throw Exception('Turnier nicht gefunden');
    
    final tournament = _tournaments[index];
    if (tournament.status != TournamentStatus.registration) {
      throw Exception('Anmeldung bereits geschlossen');
    }
    if (tournament.isFull) {
      throw Exception('Turnier ist bereits voll');
    }
    if (tournament.participantIds.contains(userId)) {
      throw Exception('Bereits angemeldet');
    }

    // 1. Deduct fee
    await _walletRepository.removeSatoshi(
      userId, 
      tournament.entryFeeSats, 
      'Turnier-Eintritt: ${tournament.title}'
    );

    // 2. Add to participants
    _tournaments[index] = Tournament(
      id: tournament.id,
      title: tournament.title,
      description: tournament.description,
      format: tournament.format,
      status: tournament.status,
      entryFeeSats: tournament.entryFeeSats,
      prizePoolSats: tournament.prizePoolSats,
      maxParticipants: tournament.maxParticipants,
      participantIds: [...tournament.participantIds, userId],
      startTime: tournament.startTime,
      brackets: tournament.brackets,
    );
  }
}

final tournamentRepositoryProvider = Provider<TournamentRepository>((ref) {
  final walletRepo = ref.watch(walletRepositoryProvider);
  return TournamentRepository(walletRepo);
});
