import 'package:equatable/equatable.dart';

/// Category of creature (Animal or Monster).
enum CreatureCategory {
  animal,
  monster,
}

/// A creature type definition from the catalog.
class CreatureType extends Equatable {
  final String id;
  final String name;
  final String description;
  final CreatureCategory category;

  // Base stats for battle
  final int baseAttack;
  final int baseDefense;
  final int baseSpeed;
  final int baseHealth;

  // Special ability
  final String specialAbilityName;
  final String specialAbilityDescription;
  final int specialAbilityCooldown;

  // Visual assets
  final String spriteSheetPath;
  final String thumbnailPath;
  final String eggSpritePath;

  // Availability
  final bool isUnlockable;
  final String? unlockRequirement;

  const CreatureType({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.baseAttack,
    required this.baseDefense,
    required this.baseSpeed,
    required this.baseHealth,
    required this.specialAbilityName,
    required this.specialAbilityDescription,
    required this.specialAbilityCooldown,
    required this.spriteSheetPath,
    required this.thumbnailPath,
    required this.eggSpritePath,
    this.isUnlockable = false,
    this.unlockRequirement,
  });

  /// Total base stat points.
  int get totalBaseStats => baseAttack + baseDefense + baseSpeed + baseHealth;

  @override
  List<Object?> get props => [id];
}

/// Catalog of all available creature types.
class CreatureCatalog {
  static const List<CreatureType> animals = [
    // Cat
    CreatureType(
      id: 'cat',
      name: 'Katze',
      description: 'Eine verspielte und unabhängige Kreatur mit schnellen Reflexen.',
      category: CreatureCategory.animal,
      baseAttack: 12,
      baseDefense: 8,
      baseSpeed: 15,
      baseHealth: 10,
      specialAbilityName: 'Krallenhieb',
      specialAbilityDescription: 'Ein schneller Angriff, der Verteidigung ignoriert.',
      specialAbilityCooldown: 3,
      spriteSheetPath: 'assets/creatures/cat/sprite.png',
      thumbnailPath: 'assets/creatures/cat/thumbnail.png',
      eggSpritePath: 'assets/creatures/cat/egg.png',
    ),
    // Dog
    CreatureType(
      id: 'dog',
      name: 'Hund',
      description: 'Ein treuer Begleiter mit hoher Ausdauer und starker Verteidigung.',
      category: CreatureCategory.animal,
      baseAttack: 10,
      baseDefense: 14,
      baseSpeed: 10,
      baseHealth: 13,
      specialAbilityName: 'Treuer Schutz',
      specialAbilityDescription: 'Erhöht Verteidigung für 2 Runden.',
      specialAbilityCooldown: 4,
      spriteSheetPath: 'assets/creatures/dog/sprite.png',
      thumbnailPath: 'assets/creatures/dog/thumbnail.png',
      eggSpritePath: 'assets/creatures/dog/egg.png',
    ),
    // Dragon
    CreatureType(
      id: 'dragon',
      name: 'Drache',
      description: 'Eine majestätische Kreatur mit verheerender Feuerkraft.',
      category: CreatureCategory.animal,
      baseAttack: 16,
      baseDefense: 10,
      baseSpeed: 8,
      baseHealth: 12,
      specialAbilityName: 'Feueratem',
      specialAbilityDescription: 'Verursacht Flächenschaden über 2 Runden.',
      specialAbilityCooldown: 5,
      spriteSheetPath: 'assets/creatures/dragon/sprite.png',
      thumbnailPath: 'assets/creatures/dragon/thumbnail.png',
      eggSpritePath: 'assets/creatures/dragon/egg.png',
      isUnlockable: true,
      unlockRequirement: 'Gewinne 10 Arena-Kämpfe',
    ),
    // Rabbit
    CreatureType(
      id: 'rabbit',
      name: 'Hase',
      description: 'Ein flinker Sprinter, der Angriffen geschickt ausweicht.',
      category: CreatureCategory.animal,
      baseAttack: 8,
      baseDefense: 6,
      baseSpeed: 18,
      baseHealth: 8,
      specialAbilityName: 'Blitzhüpfer',
      specialAbilityDescription: 'Weicht dem nächsten Angriff garantiert aus.',
      specialAbilityCooldown: 2,
      spriteSheetPath: 'assets/creatures/rabbit/sprite.png',
      thumbnailPath: 'assets/creatures/rabbit/thumbnail.png',
      eggSpritePath: 'assets/creatures/rabbit/egg.png',
    ),
    // Fox
    CreatureType(
      id: 'fox',
      name: 'Fuchs',
      description: 'Ein schlauer Jäger mit ausgewogenen Fähigkeiten.',
      category: CreatureCategory.animal,
      baseAttack: 11,
      baseDefense: 9,
      baseSpeed: 14,
      baseHealth: 11,
      specialAbilityName: 'List',
      specialAbilityDescription: 'Der nächste Angriff trifft kritisch.',
      specialAbilityCooldown: 3,
      spriteSheetPath: 'assets/creatures/fox/sprite.png',
      thumbnailPath: 'assets/creatures/fox/thumbnail.png',
      eggSpritePath: 'assets/creatures/fox/egg.png',
    ),
    // Bird
    CreatureType(
      id: 'bird',
      name: 'Vogel',
      description: 'Ein wendiger Flieger mit Überraschungsangriffen.',
      category: CreatureCategory.animal,
      baseAttack: 10,
      baseDefense: 5,
      baseSpeed: 17,
      baseHealth: 9,
      specialAbilityName: 'Sturzflug',
      specialAbilityDescription: 'Mächtiger Angriff aus der Luft.',
      specialAbilityCooldown: 4,
      spriteSheetPath: 'assets/creatures/bird/sprite.png',
      thumbnailPath: 'assets/creatures/bird/thumbnail.png',
      eggSpritePath: 'assets/creatures/bird/egg.png',
    ),
  ];

  static const List<CreatureType> monsters = [
    // Slime
    CreatureType(
      id: 'slime',
      name: 'Schleim',
      description: 'Eine glibberige Kreatur, die Schaden absorbiert.',
      category: CreatureCategory.monster,
      baseAttack: 6,
      baseDefense: 16,
      baseSpeed: 5,
      baseHealth: 15,
      specialAbilityName: 'Absorption',
      specialAbilityDescription: 'Heilt sich selbst basierend auf erlittenem Schaden.',
      specialAbilityCooldown: 4,
      spriteSheetPath: 'assets/creatures/slime/sprite.png',
      thumbnailPath: 'assets/creatures/slime/thumbnail.png',
      eggSpritePath: 'assets/creatures/slime/egg.png',
    ),
    // Goblin
    CreatureType(
      id: 'goblin',
      name: 'Goblin',
      description: 'Ein hinterhältiger Kämpfer mit schnellen Attacken.',
      category: CreatureCategory.monster,
      baseAttack: 14,
      baseDefense: 7,
      baseSpeed: 13,
      baseHealth: 10,
      specialAbilityName: 'Hinterhalt',
      specialAbilityDescription: 'Greift zweimal an, aber mit reduziertem Schaden.',
      specialAbilityCooldown: 3,
      spriteSheetPath: 'assets/creatures/goblin/sprite.png',
      thumbnailPath: 'assets/creatures/goblin/thumbnail.png',
      eggSpritePath: 'assets/creatures/goblin/egg.png',
    ),
    // Ghost
    CreatureType(
      id: 'ghost',
      name: 'Geist',
      description: 'Eine unheimliche Präsenz, die schwer zu treffen ist.',
      category: CreatureCategory.monster,
      baseAttack: 10,
      baseDefense: 4,
      baseSpeed: 16,
      baseHealth: 11,
      specialAbilityName: 'Phasenverschiebung',
      specialAbilityDescription: 'Wird für 1 Runde unverwundbar.',
      specialAbilityCooldown: 5,
      spriteSheetPath: 'assets/creatures/ghost/sprite.png',
      thumbnailPath: 'assets/creatures/ghost/thumbnail.png',
      eggSpritePath: 'assets/creatures/ghost/egg.png',
    ),
    // Elemental
    CreatureType(
      id: 'elemental',
      name: 'Elementar',
      description: 'Eine Verkörperung roher magischer Energie.',
      category: CreatureCategory.monster,
      baseAttack: 15,
      baseDefense: 8,
      baseSpeed: 10,
      baseHealth: 13,
      specialAbilityName: 'Elementarsturm',
      specialAbilityDescription: 'Verursacht zufälligen Elementarschaden.',
      specialAbilityCooldown: 4,
      spriteSheetPath: 'assets/creatures/elemental/sprite.png',
      thumbnailPath: 'assets/creatures/elemental/thumbnail.png',
      eggSpritePath: 'assets/creatures/elemental/egg.png',
      isUnlockable: true,
      unlockRequirement: 'Erreiche Level 10',
    ),
    // Stone Golem
    CreatureType(
      id: 'golem',
      name: 'Steingolem',
      description: 'Ein unaufhaltsamer Koloss aus lebendem Stein.',
      category: CreatureCategory.monster,
      baseAttack: 12,
      baseDefense: 18,
      baseSpeed: 3,
      baseHealth: 16,
      specialAbilityName: 'Erdbeben',
      specialAbilityDescription: 'Erschüttert den Gegner und senkt dessen Geschwindigkeit.',
      specialAbilityCooldown: 5,
      spriteSheetPath: 'assets/creatures/golem/sprite.png',
      thumbnailPath: 'assets/creatures/golem/thumbnail.png',
      eggSpritePath: 'assets/creatures/golem/egg.png',
      isUnlockable: true,
      unlockRequirement: 'Gewinne ein Turnier',
    ),
    // Shadow Cat
    CreatureType(
      id: 'shadow_cat',
      name: 'Schattenkatze',
      description: 'Eine mysteriöse Kreatur aus purem Schatten.',
      category: CreatureCategory.monster,
      baseAttack: 13,
      baseDefense: 6,
      baseSpeed: 16,
      baseHealth: 9,
      specialAbilityName: 'Schattensprung',
      specialAbilityDescription: 'Teleportiert hinter den Gegner für garantierten Treffer.',
      specialAbilityCooldown: 3,
      spriteSheetPath: 'assets/creatures/shadow_cat/sprite.png',
      thumbnailPath: 'assets/creatures/shadow_cat/thumbnail.png',
      eggSpritePath: 'assets/creatures/shadow_cat/egg.png',
    ),
  ];

  /// Get all creature types.
  static List<CreatureType> get all => [...animals, ...monsters];

  /// Get creature type by ID.
  static CreatureType? getById(String id) {
    try {
      return all.firstWhere((type) => type.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Get all available (non-unlockable) creature types.
  static List<CreatureType> get available =>
      all.where((type) => !type.isUnlockable).toList();

  /// Get all unlockable creature types.
  static List<CreatureType> get unlockable =>
      all.where((type) => type.isUnlockable).toList();
}
