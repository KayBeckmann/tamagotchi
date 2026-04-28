import 'package:equatable/equatable.dart';

/// Type of action a creature can take in battle.
enum BattleActionType {
  normalAttack,
  specialAttack,
  defend,
  dodge,
}

extension BattleActionTypeExtension on BattleActionType {
  String get displayName {
    switch (this) {
      case BattleActionType.normalAttack:
        return 'Angriff';
      case BattleActionType.specialAttack:
        return 'Spezial';
      case BattleActionType.defend:
        return 'Verteidigen';
      case BattleActionType.dodge:
        return 'Ausweichen';
    }
  }

  String get icon {
    switch (this) {
      case BattleActionType.normalAttack:
        return '⚔️';
      case BattleActionType.specialAttack:
        return '✨';
      case BattleActionType.defend:
        return '🛡️';
      case BattleActionType.dodge:
        return '💨';
    }
  }

  String get description {
    switch (this) {
      case BattleActionType.normalAttack:
        return 'Standard-Angriff';
      case BattleActionType.specialAttack:
        return 'Kreaturspezifischer Angriff (Cooldown)';
      case BattleActionType.defend:
        return 'Reduziert nächsten Schaden um 50%';
      case BattleActionType.dodge:
        return '40% Chance, Angriff komplett zu vermeiden';
    }
  }
}

/// A single action submitted by a player in a turn.
class BattleAction extends Equatable {
  final String creatureId;
  final BattleActionType type;
  final DateTime submittedAt;

  const BattleAction({
    required this.creatureId,
    required this.type,
    required this.submittedAt,
  });

  @override
  List<Object?> get props => [creatureId, type, submittedAt];
}
