import 'package:equatable/equatable.dart';
import '../../../creature/domain/models/creature.dart';
import 'battle_turn.dart';

/// Overall status of a battle.
enum BattleStatus {
  searching,     // Looking for opponent
  starting,      // Battle is about to begin
  playerTurn,    // Waiting for player action
  resolving,     // Computing turn result
  finished,      // Battle is over
}

/// The result of a completed battle.
enum BattleResult {
  playerWon,
  playerLost,
  draw,
}

/// Immutable snapshot of the entire battle state.
class BattleState extends Equatable {
  final String battleId;
  final BattleStatus status;

  // Participants
  final Creature playerCreature;
  final Creature opponentCreature;
  final String opponentName;

  // Current HP (separate from creature.health status)
  final int playerCurrentHp;
  final int opponentCurrentHp;

  // Round tracking
  final int currentRound;
  final int maxRounds;

  // Cooldown: turns remaining before special can be used again
  final int playerSpecialCooldown;

  // Buffs active for next damage calculation
  final bool playerDefending;
  final bool opponentDefending;

  // Turn history
  final List<BattleTurn> turns;

  // Final result (null until finished)
  final BattleResult? result;
  final int xpGained;
  final int satoshisGained;

  // ELO change preview
  final int playerEloChange;

  const BattleState({
    required this.battleId,
    required this.status,
    required this.playerCreature,
    required this.opponentCreature,
    required this.opponentName,
    required this.playerCurrentHp,
    required this.opponentCurrentHp,
    this.currentRound = 0,
    this.maxRounds = 20,
    this.playerSpecialCooldown = 0,
    this.playerDefending = false,
    this.opponentDefending = false,
    this.turns = const [],
    this.result,
    this.xpGained = 0,
    this.satoshisGained = 0,
    this.playerEloChange = 0,
  });

  double get playerHpPercent =>
      playerCurrentHp / playerCreature.maxBattleHp;

  double get opponentHpPercent =>
      opponentCurrentHp / opponentCreature.maxBattleHp;

  bool get isPlayerSpecialAvailable => playerSpecialCooldown == 0;

  bool get isFinished => status == BattleStatus.finished;

  BattleState copyWith({
    String? battleId,
    BattleStatus? status,
    Creature? playerCreature,
    Creature? opponentCreature,
    String? opponentName,
    int? playerCurrentHp,
    int? opponentCurrentHp,
    int? currentRound,
    int? maxRounds,
    int? playerSpecialCooldown,
    bool? playerDefending,
    bool? opponentDefending,
    List<BattleTurn>? turns,
    BattleResult? result,
    int? xpGained,
    int? satoshisGained,
    int? playerEloChange,
  }) {
    return BattleState(
      battleId: battleId ?? this.battleId,
      status: status ?? this.status,
      playerCreature: playerCreature ?? this.playerCreature,
      opponentCreature: opponentCreature ?? this.opponentCreature,
      opponentName: opponentName ?? this.opponentName,
      playerCurrentHp: playerCurrentHp ?? this.playerCurrentHp,
      opponentCurrentHp: opponentCurrentHp ?? this.opponentCurrentHp,
      currentRound: currentRound ?? this.currentRound,
      maxRounds: maxRounds ?? this.maxRounds,
      playerSpecialCooldown:
          playerSpecialCooldown ?? this.playerSpecialCooldown,
      playerDefending: playerDefending ?? this.playerDefending,
      opponentDefending: opponentDefending ?? this.opponentDefending,
      turns: turns ?? this.turns,
      result: result ?? this.result,
      xpGained: xpGained ?? this.xpGained,
      satoshisGained: satoshisGained ?? this.satoshisGained,
      playerEloChange: playerEloChange ?? this.playerEloChange,
    );
  }

  @override
  List<Object?> get props => [battleId, status, playerCurrentHp, opponentCurrentHp, currentRound, result];
}
