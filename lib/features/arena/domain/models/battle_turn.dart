import 'package:equatable/equatable.dart';
import 'battle_action.dart';

/// Result of one battle turn (one action from each side).
class BattleTurn extends Equatable {
  final int roundNumber;
  final BattleActionType playerAction;
  final BattleActionType opponentAction;
  final int playerDamageDealt;
  final int opponentDamageDealt;
  final int playerHpAfter;
  final int opponentHpAfter;
  final bool playerDodged;
  final bool opponentDodged;
  final bool playerCrit;
  final bool opponentCrit;
  final String logMessage;
  final bool specialUsed; // whether player used special this round

  const BattleTurn({
    required this.roundNumber,
    required this.playerAction,
    required this.opponentAction,
    required this.playerDamageDealt,
    required this.opponentDamageDealt,
    required this.playerHpAfter,
    required this.opponentHpAfter,
    this.playerDodged = false,
    this.opponentDodged = false,
    this.playerCrit = false,
    this.opponentCrit = false,
    required this.logMessage,
    this.specialUsed = false,
  });

  @override
  List<Object?> get props => [roundNumber];
}
