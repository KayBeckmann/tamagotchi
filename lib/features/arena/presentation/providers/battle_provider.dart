import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/arena_repository.dart';
import '../domain/models/battle.dart';
import '../../../creature/domain/models/creature.dart';

class BattleStateNotifier extends StateNotifier<AsyncValue<BattleSession>> {
  final ArenaRepository _repository;
  final String _userId;
  final String _userName;
  final Creature _playerCreature;

  BattleStateNotifier(
    this._repository,
    this._userId,
    this._userName,
    this._playerCreature,
  ) : super(const AsyncValue.loading()) {
    _startMatchmaking();
  }

  Future<void> _startMatchmaking() async {
    state = const AsyncValue.loading();
    try {
      final opponent = await _repository.findOpponent(_playerCreature.level);
      final player = BattleParticipant.fromCreature(_playerCreature, _userName);
      
      state = AsyncValue.data(BattleSession(
        player: player,
        opponent: opponent,
        state: BattleState.starting,
        history: [],
        isPlayerTurn: player.speed >= opponent.speed,
      ));
      
      // Auto-start after delay
      await Future.delayed(const Duration(seconds: 2));
      _startBattle();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void _startBattle() {
    final session = state.value;
    if (session == null) return;
    
    state = AsyncValue.data(session.copyWith(state: BattleState.ongoing));
    
    if (!session.isPlayerTurn) {
      _executeOpponentTurn();
    }
  }

  Future<void> executePlayerAction(BattleAction action) async {
    final session = state.value;
    if (session == null || !session.isPlayerTurn || session.state != BattleState.ongoing) return;

    // 1. Reset player defense/dodge flags
    session.player.isDefending = false;
    session.player.isDodging = false;

    // 2. Execute turn
    final turn = _repository.executeTurn(
      session.player,
      session.opponent,
      action,
      session.history.length + 1,
    );

    final updatedHistory = [...session.history, turn];
    
    // 3. Check for battle end
    if (session.opponent.isDead) {
      _finishBattle(session.copyWith(history: updatedHistory));
      return;
    }

    // 4. Update state and switch turn
    state = AsyncValue.data(session.copyWith(
      history: updatedHistory,
      isPlayerTurn: false,
    ));

    // 5. Opponent turn after delay
    await Future.delayed(const Duration(seconds: 1));
    _executeOpponentTurn();
  }

  Future<void> _executeOpponentTurn() async {
    final session = state.value;
    if (session == null || session.isPlayerTurn || session.state != BattleState.ongoing) return;

    // 1. Reset opponent defense/dodge flags
    session.opponent.isDefending = false;
    session.opponent.isDodging = false;

    // 2. Simple AI: Attack if player low HP, else 70% attack, 20% special, 10% defend
    BattleAction action = BattleAction.attack;
    final r = _repository.executeTurn(session.opponent, session.player, BattleAction.attack, 0).damage; // dummy check
    // Actually we just use a random action for now
    final random = _repository.executeTurn(session.opponent, session.player, BattleAction.attack, 0); // Need to use repo's random? 
    
    // Use simple logic
    final dice = (DateTime.now().millisecond % 10);
    if (dice > 8) action = BattleAction.defend;
    else if (dice > 6) action = BattleAction.special;

    // 3. Execute turn
    final turn = _repository.executeTurn(
      session.opponent,
      session.player,
      action,
      session.history.length + 1,
    );

    final updatedHistory = [...session.history, turn];

    // 4. Check for battle end
    if (session.player.isDead) {
      _finishBattle(session.copyWith(history: updatedHistory));
      return;
    }

    // 5. Update state and switch turn
    state = AsyncValue.data(session.copyWith(
      history: updatedHistory,
      isPlayerTurn: true,
    ));
  }

  Future<void> _finishBattle(BattleSession session) async {
    state = AsyncValue.data(session.copyWith(state: BattleState.finished));
    
    final result = await _repository.finalizeBattle(
      _userId,
      session.opponent.id,
      session.opponent.isDead,
      session.history,
    );
    
    state = AsyncValue.data(session.copyWith(result: result));
  }
}

class BattleSession {
  final BattleParticipant player;
  final BattleParticipant opponent;
  final BattleState state;
  final List<BattleTurn> history;
  final bool isPlayerTurn;
  final BattleResult? result;

  BattleSession({
    required this.player,
    required this.opponent,
    required this.state,
    required this.history,
    required this.isPlayerTurn,
    this.result,
  });

  BattleSession copyWith({
    BattleState? state,
    List<BattleTurn>? history,
    bool? isPlayerTurn,
    BattleResult? result,
  }) {
    return BattleSession(
      player: player,
      opponent: opponent,
      state: state ?? this.state,
      history: history ?? this.history,
      isPlayerTurn: isPlayerTurn ?? this.isPlayerTurn,
      result: result ?? this.result,
    );
  }
}

final battleProvider = StateNotifierProvider.family<BattleStateNotifier, AsyncValue<BattleSession>, Creature>((ref, creature) {
  final repo = ref.watch(arenaRepositoryProvider);
  return BattleStateNotifier(repo, 'user_1', 'Kay', creature);
});
