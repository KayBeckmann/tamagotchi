import 'package:flutter/material.dart';
import '../../../creature/domain/models/creature.dart';

enum BattleAction {
  attack,
  special,
  defend,
  dodge,
}

enum BattleState {
  searching,
  starting,
  ongoing,
  finished,
}

class BattleParticipant {
  final String id;
  final String name;
  final String creatureId;
  final String creatureName;
  final String creatureTypeId;
  final int level;
  final int maxHp;
  int currentHp;
  final int attack;
  final int defense;
  final int speed;
  bool isDefending;
  bool isDodging;

  BattleParticipant({
    required this.id,
    required this.name,
    required this.creatureId,
    required this.creatureName,
    required this.creatureTypeId,
    required this.level,
    required this.maxHp,
    required this.currentHp,
    required this.attack,
    required this.defense,
    required this.speed,
    this.isDefending = false,
    this.isDodging = false,
  });

  factory BattleParticipant.fromCreature(Creature creature, String userName) {
    // Battle HP is 100 + (level * 10)
    final maxHp = 100 + (creature.level * 10);
    return BattleParticipant(
      id: creature.userId,
      name: userName,
      creatureId: creature.id,
      creatureName: creature.name,
      creatureTypeId: creature.type.id,
      level: creature.level,
      maxHp: maxHp,
      currentHp: maxHp,
      attack: creature.totalAttack,
      defense: creature.totalDefense,
      speed: creature.totalSpeed,
    );
  }

  double get hpPercentage => currentHp / maxHp;
  bool get isDead => currentHp <= 0;
}

class BattleTurn {
  final int turnNumber;
  final String attackerId;
  final String defenderId;
  final BattleAction action;
  final int damage;
  final String logMessage;
  final bool isCritical;
  final bool isMissed;

  BattleTurn({
    required this.turnNumber,
    required this.attackerId,
    required this.defenderId,
    required this.action,
    required this.damage,
    required this.logMessage,
    this.isCritical = false,
    this.isMissed = false,
  });
}

class BattleResult {
  final String winnerId;
  final String loserId;
  final int xpGained;
  final int satoshisGained;
  final List<BattleTurn> history;

  BattleResult({
    required this.winnerId,
    required this.loserId,
    required this.xpGained,
    required this.satoshisGained,
    required this.history,
  });
}
