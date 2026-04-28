import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/tournament_repository.dart';
import '../../domain/models/tournament.dart';

/// All tournaments list.
final tournamentsProvider = FutureProvider<List<Tournament>>((ref) async {
  final repo = ref.watch(tournamentRepositoryProvider);
  return repo.getTournaments();
});

/// Single tournament by ID.
final tournamentDetailProvider =
    FutureProvider.family<Tournament?, String>((ref, id) async {
  final repo = ref.watch(tournamentRepositoryProvider);
  return repo.getTournament(id);
});

/// State for tournament registration.
sealed class TournamentRegistrationState {}

class TournamentRegistrationIdle extends TournamentRegistrationState {}

class TournamentRegistrationLoading extends TournamentRegistrationState {}

class TournamentRegistrationSuccess extends TournamentRegistrationState {
  final Tournament tournament;
  final bool cancelled;
  TournamentRegistrationSuccess(this.tournament, {this.cancelled = false});
}

class TournamentRegistrationError extends TournamentRegistrationState {
  final String message;
  TournamentRegistrationError(this.message);
}

/// Notifier for tournament registration actions.
class TournamentRegistrationNotifier
    extends StateNotifier<TournamentRegistrationState> {
  final TournamentRepository _repo;

  TournamentRegistrationNotifier(this._repo)
      : super(TournamentRegistrationIdle());

  Future<void> register({
    required String tournamentId,
    required String userId,
    required String username,
    required String creatureId,
    required String creatureName,
    required String creatureTypeId,
    required int eloRating,
    required int currentSatoshis,
  }) async {
    state = TournamentRegistrationLoading();
    try {
      final tournament = await _repo.register(
        tournamentId: tournamentId,
        userId: userId,
        username: username,
        creatureId: creatureId,
        creatureName: creatureName,
        creatureTypeId: creatureTypeId,
        eloRating: eloRating,
        currentSatoshis: currentSatoshis,
      );
      state = TournamentRegistrationSuccess(tournament);
    } catch (e) {
      state = TournamentRegistrationError(e.toString());
    }
  }

  Future<void> cancelRegistration(String tournamentId) async {
    state = TournamentRegistrationLoading();
    try {
      final tournament = await _repo.cancelRegistration(tournamentId);
      state = TournamentRegistrationSuccess(tournament, cancelled: true);
    } catch (e) {
      state = TournamentRegistrationError(e.toString());
    }
  }

  void reset() => state = TournamentRegistrationIdle();
}

final tournamentRegistrationProvider = StateNotifierProvider<
    TournamentRegistrationNotifier, TournamentRegistrationState>((ref) {
  return TournamentRegistrationNotifier(ref.watch(tournamentRepositoryProvider));
});
