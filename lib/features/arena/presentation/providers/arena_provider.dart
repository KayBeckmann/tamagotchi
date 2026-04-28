import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/arena_repository.dart';
import '../../domain/models/battle_action.dart';
import '../../domain/models/battle_state.dart';
import '../../domain/models/matchmaking_info.dart';
import '../../domain/services/battle_calculator.dart';
import '../../../creature/domain/models/creature.dart';

// ---- Matchmaking ----

class MatchmakingNotifier extends StateNotifier<MatchmakingState> {
  final ArenaRepository _repo;

  MatchmakingNotifier(this._repo) : super(const MatchmakingState());

  Future<void> startSearch(Creature playerCreature, int playerElo) async {
    state = const MatchmakingState(status: MatchmakingStatus.searching);

    try {
      final opponentCreature = await _repo.findOpponent(
        playerCreature: playerCreature,
        playerElo: playerElo,
      );

      if (state.status != MatchmakingStatus.searching) return; // cancelled

      final opponent = OpponentInfo(
        userId: opponentCreature.userId,
        username: _repo.randomOpponentName(),
        eloRating: playerElo + (50 - (100 * (0.5 - 0.5)).round()),
        creature: opponentCreature,
      );

      state = MatchmakingState(
        status: MatchmakingStatus.found,
        opponent: opponent,
      );
    } catch (e) {
      state = MatchmakingState(
        status: MatchmakingStatus.idle,
        errorMessage: 'Fehler bei der Suche: $e',
      );
    }
  }

  void cancel() {
    state = const MatchmakingState(status: MatchmakingStatus.cancelled);
  }

  void reset() {
    state = const MatchmakingState();
  }
}

final matchmakingProvider =
    StateNotifierProvider<MatchmakingNotifier, MatchmakingState>((ref) {
  return MatchmakingNotifier(ref.watch(arenaRepositoryProvider));
});

// ---- Active Battle ----

class BattleNotifier extends StateNotifier<BattleState?> {
  final ArenaRepository _repo;

  BattleNotifier(this._repo) : super(null);

  void startBattle({
    required Creature playerCreature,
    required Creature opponentCreature,
    required String opponentName,
  }) {
    final playerHp = BattleCalculator.computeMaxBattleHp(playerCreature);
    final opponentHp = BattleCalculator.computeMaxBattleHp(opponentCreature);

    state = BattleState(
      battleId: _repo.generateBattleId(),
      status: BattleStatus.playerTurn,
      playerCreature: playerCreature,
      opponentCreature: opponentCreature,
      opponentName: opponentName,
      playerCurrentHp: playerHp,
      opponentCurrentHp: opponentHp,
    );
  }

  Future<void> submitAction(BattleActionType action) async {
    final current = state;
    if (current == null) return;
    if (current.status != BattleStatus.playerTurn) return;

    // Check special cooldown
    if (action == BattleActionType.specialAttack &&
        !current.isPlayerSpecialAvailable) return;

    // Set resolving state
    state = current.copyWith(status: BattleStatus.resolving);

    // Small delay for animation
    await Future.delayed(const Duration(milliseconds: 400));

    // Pick opponent action
    final opponentAction = BattleCalculator.pickOpponentAction(current);

    // Resolve the turn
    final newState = BattleCalculator.resolveTurn(current, action, opponentAction);

    state = newState;

    // If battle finished, save to history
    if (newState.isFinished && newState.result != null) {
      await _repo.saveBattleResult(BattleHistoryEntry(
        battleId: newState.battleId,
        opponentName: newState.opponentName,
        opponentCreatureName: newState.opponentCreature.name,
        playerWon: newState.result == BattleResult.playerWon,
        xpGained: newState.xpGained,
        satoshisGained: newState.satoshisGained,
        eloChange: newState.playerEloChange,
        battleDate: DateTime.now(),
        totalRounds: newState.currentRound,
      ));
    }
  }

  void clearBattle() {
    state = null;
  }
}

final battleProvider =
    StateNotifierProvider<BattleNotifier, BattleState?>((ref) {
  return BattleNotifier(ref.watch(arenaRepositoryProvider));
});

// ---- Battle History ----

final battleHistoryProvider = FutureProvider.family<List<BattleHistoryEntry>, String>(
  (ref, userId) async {
    final repo = ref.watch(arenaRepositoryProvider);
    return repo.getBattleHistory(userId);
  },
);
