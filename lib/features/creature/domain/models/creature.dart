import 'package:equatable/equatable.dart';

import 'creature_type.dart';

/// Development stage of a creature.
enum DevelopmentStage {
  egg,    // Day 0 - Just hatching
  baby,   // Day 1-3 - Limited interactions
  child,  // Day 4-7 - All basic interactions
  teen,   // Day 8-14 - Training and Arena unlocked
  adult,  // Day 15+ - Tournament unlocked
}

/// A player's creature instance.
class Creature extends Equatable {
  final String id;
  final String userId;
  final CreatureType type;
  final String name;
  final bool isActive;

  // Development
  final DevelopmentStage stage;
  final int ageInDays;
  final DateTime birthDate;

  // Status values (0-100)
  final int hunger;
  final int happiness;
  final int energy;
  final int health;
  final int cleanliness;

  // Physical
  final double weight;

  // Battle stats (base + trained)
  final int trainedAttack;
  final int trainedDefense;
  final int trainedSpeed;
  final int maxBattleHp;
  final int currentBattleHp;

  // State
  final bool isSleeping;
  final bool isSick;
  final bool isStunned;
  final DateTime? stunnedUntil;

  // Death mechanics
  final int neglectDays;
  final bool isDead;
  final DateTime? deathDate;
  final String? deathCause;

  // Timestamps
  final DateTime lastInteractionAt;
  final DateTime lastStatusUpdateAt;
  final DateTime createdAt;

  const Creature({
    required this.id,
    required this.userId,
    required this.type,
    required this.name,
    this.isActive = false,
    required this.stage,
    required this.ageInDays,
    required this.birthDate,
    this.hunger = 100,
    this.happiness = 100,
    this.energy = 100,
    this.health = 100,
    this.cleanliness = 100,
    this.weight = 5.0,
    this.trainedAttack = 0,
    this.trainedDefense = 0,
    this.trainedSpeed = 0,
    this.maxBattleHp = 100,
    this.currentBattleHp = 100,
    this.isSleeping = false,
    this.isSick = false,
    this.isStunned = false,
    this.stunnedUntil,
    this.neglectDays = 0,
    this.isDead = false,
    this.deathDate,
    this.deathCause,
    required this.lastInteractionAt,
    required this.lastStatusUpdateAt,
    required this.createdAt,
  });

  // Computed battle stats
  int get totalAttack => type.baseAttack + trainedAttack;
  int get totalDefense => type.baseDefense + trainedDefense;
  int get totalSpeed => type.baseSpeed + trainedSpeed;

  // Stage multiplier for battle
  double get stageMultiplier {
    switch (stage) {
      case DevelopmentStage.egg:
        return 0.0;
      case DevelopmentStage.baby:
        return 0.5;
      case DevelopmentStage.child:
        return 0.75;
      case DevelopmentStage.teen:
        return 0.9;
      case DevelopmentStage.adult:
        return 1.0;
    }
  }

  // Combat power (for matchmaking)
  int get combatPower {
    final baseStats = totalAttack + totalDefense + totalSpeed;
    return (baseStats * stageMultiplier).round();
  }

  // Check if creature can battle (Arena)
  bool get canBattle {
    if (isDead || isStunned || isSleeping) return false;
    if (stage == DevelopmentStage.egg || stage == DevelopmentStage.baby) return false;
    if (stage == DevelopmentStage.child) return false;
    return true;
  }

  // Check if creature can enter tournaments
  bool get canEnterTournament {
    return canBattle && stage == DevelopmentStage.adult;
  }

  // Check if creature can train
  bool get canTrain {
    if (isDead || isStunned || isSleeping) return false;
    if (stage == DevelopmentStage.egg ||
        stage == DevelopmentStage.baby ||
        stage == DevelopmentStage.child) return false;
    return energy >= 20;
  }

  // Overall mood based on status values
  CreatureMood get mood {
    final average = (hunger + happiness + energy + health + cleanliness) / 5;
    if (average >= 80) return CreatureMood.happy;
    if (average >= 60) return CreatureMood.content;
    if (average >= 40) return CreatureMood.neutral;
    if (average >= 20) return CreatureMood.unhappy;
    return CreatureMood.miserable;
  }

  // Check if any stat is critical
  bool get hasCriticalStat {
    return hunger < 20 || happiness < 20 || energy < 20 ||
           health < 20 || cleanliness < 20;
  }

  // Get the most critical stat
  String? get mostCriticalStat {
    if (health < 20) return 'health';
    if (hunger < 20) return 'hunger';
    if (happiness < 20) return 'happiness';
    if (energy < 20) return 'energy';
    if (cleanliness < 20) return 'cleanliness';
    return null;
  }

  Creature copyWith({
    String? id,
    String? userId,
    CreatureType? type,
    String? name,
    bool? isActive,
    DevelopmentStage? stage,
    int? ageInDays,
    DateTime? birthDate,
    int? hunger,
    int? happiness,
    int? energy,
    int? health,
    int? cleanliness,
    double? weight,
    int? trainedAttack,
    int? trainedDefense,
    int? trainedSpeed,
    int? maxBattleHp,
    int? currentBattleHp,
    bool? isSleeping,
    bool? isSick,
    bool? isStunned,
    DateTime? stunnedUntil,
    int? neglectDays,
    bool? isDead,
    DateTime? deathDate,
    String? deathCause,
    DateTime? lastInteractionAt,
    DateTime? lastStatusUpdateAt,
    DateTime? createdAt,
  }) {
    return Creature(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      name: name ?? this.name,
      isActive: isActive ?? this.isActive,
      stage: stage ?? this.stage,
      ageInDays: ageInDays ?? this.ageInDays,
      birthDate: birthDate ?? this.birthDate,
      hunger: hunger ?? this.hunger,
      happiness: happiness ?? this.happiness,
      energy: energy ?? this.energy,
      health: health ?? this.health,
      cleanliness: cleanliness ?? this.cleanliness,
      weight: weight ?? this.weight,
      trainedAttack: trainedAttack ?? this.trainedAttack,
      trainedDefense: trainedDefense ?? this.trainedDefense,
      trainedSpeed: trainedSpeed ?? this.trainedSpeed,
      maxBattleHp: maxBattleHp ?? this.maxBattleHp,
      currentBattleHp: currentBattleHp ?? this.currentBattleHp,
      isSleeping: isSleeping ?? this.isSleeping,
      isSick: isSick ?? this.isSick,
      isStunned: isStunned ?? this.isStunned,
      stunnedUntil: stunnedUntil ?? this.stunnedUntil,
      neglectDays: neglectDays ?? this.neglectDays,
      isDead: isDead ?? this.isDead,
      deathDate: deathDate ?? this.deathDate,
      deathCause: deathCause ?? this.deathCause,
      lastInteractionAt: lastInteractionAt ?? this.lastInteractionAt,
      lastStatusUpdateAt: lastStatusUpdateAt ?? this.lastStatusUpdateAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id];
}

/// Creature mood based on overall status.
enum CreatureMood {
  happy,
  content,
  neutral,
  unhappy,
  miserable,
}

/// Extension for stage-related helpers.
extension DevelopmentStageExtension on DevelopmentStage {
  String get displayName {
    switch (this) {
      case DevelopmentStage.egg:
        return 'Ei';
      case DevelopmentStage.baby:
        return 'Baby';
      case DevelopmentStage.child:
        return 'Kind';
      case DevelopmentStage.teen:
        return 'Jugendlich';
      case DevelopmentStage.adult:
        return 'Erwachsen';
    }
  }

  /// Get the stage based on age in days.
  static DevelopmentStage fromAge(int ageInDays) {
    if (ageInDays < 1) return DevelopmentStage.egg;
    if (ageInDays <= 3) return DevelopmentStage.baby;
    if (ageInDays <= 7) return DevelopmentStage.child;
    if (ageInDays <= 14) return DevelopmentStage.teen;
    return DevelopmentStage.adult;
  }
}
