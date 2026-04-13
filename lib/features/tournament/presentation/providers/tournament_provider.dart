import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/tournament_repository.dart';
import '../domain/models/tournament.dart';
import '../../../wallet/presentation/providers/wallet_provider.dart';

final tournamentListProvider = FutureProvider<List<Tournament>>((ref) async {
  final repo = ref.watch(tournamentRepositoryProvider);
  return repo.getTournaments();
});

final tournamentDetailProvider = FutureProvider.family<Tournament?, String>((ref, id) async {
  final repo = ref.watch(tournamentRepositoryProvider);
  return repo.getTournament(id);
});

class TournamentActionNotifier extends StateNotifier<AsyncValue<void>> {
  final TournamentRepository _repository;
  final Ref _ref;

  TournamentActionNotifier(this._repository, this._ref) : super(const AsyncValue.data(null));

  Future<void> join(String userId, String tournamentId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.joinTournament(userId, tournamentId);
      _ref.invalidate(tournamentListProvider);
      _ref.invalidate(tournamentDetailProvider(tournamentId));
      _ref.invalidate(balanceProvider(userId));
      _ref.invalidate(transactionsProvider(userId));
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final tournamentActionProvider = StateNotifierProvider<TournamentActionNotifier, AsyncValue<void>>((ref) {
  final repo = ref.watch(tournamentRepositoryProvider);
  return TournamentActionNotifier(repo, ref);
});
