import 'package:serverpod/serverpod.dart';

/// Creature management endpoint for Tamagotchi operations.
///
/// Handles:
/// - Creature creation and selection
/// - Status management and interactions
/// - Development stages
/// - Training
class CreatureEndpoint extends Endpoint {
  /// Get all creature types available in the game.
  Future<List<CreatureTypeInfo>> getCreatureTypes(Session session) async {
    // TODO: Implement creature type catalog retrieval
    throw UnimplementedError('Get creature types not yet implemented');
  }

  /// Get all creatures owned by the current user.
  Future<List<CreatureInfo>> getMyCreatures(Session session) async {
    // TODO: Implement creature list retrieval
    throw UnimplementedError('Get my creatures not yet implemented');
  }

  /// Get detailed info about a specific creature.
  Future<CreatureDetail> getCreature(
    Session session, {
    required int creatureId,
  }) async {
    // TODO: Implement single creature retrieval
    throw UnimplementedError('Get creature not yet implemented');
  }

  /// Create a new creature (hatch from egg).
  Future<CreatureInfo> createCreature(
    Session session, {
    required int creatureTypeId,
    required String name,
  }) async {
    // TODO: Implement creature creation
    // 1. Check user has available slots
    // 2. Check creature type is unlocked for user
    // 3. Create creature in egg state
    throw UnimplementedError('Create creature not yet implemented');
  }

  /// Set a creature as the active creature.
  Future<void> setActiveCreature(
    Session session, {
    required int creatureId,
  }) async {
    // TODO: Implement active creature selection
    throw UnimplementedError('Set active creature not yet implemented');
  }

  /// Feed a creature with an item from inventory.
  Future<InteractionResult> feed(
    Session session, {
    required int creatureId,
    required int itemId,
  }) async {
    // TODO: Implement feeding
    // 1. Verify ownership and item in inventory
    // 2. Check cooldown
    // 3. Apply item effects
    // 4. Update creature stats
    // 5. Set new cooldown
    throw UnimplementedError('Feed not yet implemented');
  }

  /// Play with a creature.
  Future<InteractionResult> play(
    Session session, {
    required int creatureId,
  }) async {
    // TODO: Implement playing
    // 1. Verify ownership
    // 2. Check cooldown and energy
    // 3. Increase happiness, decrease energy
    throw UnimplementedError('Play not yet implemented');
  }

  /// Put a creature to sleep.
  Future<InteractionResult> sleep(
    Session session, {
    required int creatureId,
  }) async {
    // TODO: Implement sleeping
    // 1. Verify ownership
    // 2. Set creature to sleeping state
    // 3. Energy regenerates over time
    throw UnimplementedError('Sleep not yet implemented');
  }

  /// Wake up a sleeping creature.
  Future<InteractionResult> wakeUp(
    Session session, {
    required int creatureId,
  }) async {
    // TODO: Implement waking up
    throw UnimplementedError('Wake up not yet implemented');
  }

  /// Clean/wash a creature.
  Future<InteractionResult> clean(
    Session session, {
    required int creatureId,
  }) async {
    // TODO: Implement cleaning
    // 1. Verify ownership
    // 2. Check cooldown
    // 3. Increase cleanliness
    throw UnimplementedError('Clean not yet implemented');
  }

  /// Give medicine to a sick creature.
  Future<InteractionResult> giveMedicine(
    Session session, {
    required int creatureId,
    required int medicineItemId,
  }) async {
    // TODO: Implement medicine
    // 1. Verify ownership and medicine in inventory
    // 2. Check creature is sick
    // 3. Apply healing effect
    throw UnimplementedError('Give medicine not yet implemented');
  }

  /// Train a creature to improve battle stats.
  Future<InteractionResult> train(
    Session session, {
    required int creatureId,
    required String statType, // 'attack', 'defense', 'speed'
  }) async {
    // TODO: Implement training
    // 1. Verify ownership
    // 2. Check development stage (teen or adult)
    // 3. Check energy and cooldown
    // 4. Increase specified stat
    // 5. Decrease energy significantly
    throw UnimplementedError('Train not yet implemented');
  }

  /// Get action cooldowns for a creature.
  Future<Map<String, DateTime>> getCooldowns(
    Session session, {
    required int creatureId,
  }) async {
    // TODO: Implement cooldown retrieval
    throw UnimplementedError('Get cooldowns not yet implemented');
  }
}

/// Basic creature type information.
class CreatureTypeInfo {
  final int id;
  final String name;
  final String description;
  final String category;
  final String thumbnailUrl;
  final bool isUnlocked;

  CreatureTypeInfo({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.thumbnailUrl,
    required this.isUnlocked,
  });
}

/// Basic creature information.
class CreatureInfo {
  final int id;
  final String name;
  final String typeName;
  final String developmentStage;
  final bool isActive;
  final bool isDead;
  final int hunger;
  final int happiness;
  final int energy;
  final int health;
  final int cleanliness;

  CreatureInfo({
    required this.id,
    required this.name,
    required this.typeName,
    required this.developmentStage,
    required this.isActive,
    required this.isDead,
    required this.hunger,
    required this.happiness,
    required this.energy,
    required this.health,
    required this.cleanliness,
  });
}

/// Detailed creature information.
class CreatureDetail {
  final int id;
  final String name;
  final CreatureTypeInfo type;
  final String developmentStage;
  final int ageInDays;
  final DateTime birthDate;
  final bool isActive;
  final bool isDead;
  // Status values
  final int hunger;
  final int happiness;
  final int energy;
  final int health;
  final int cleanliness;
  final double weight;
  // Battle stats
  final int attack;
  final int defense;
  final int speed;
  final int maxBattleHp;
  final int currentBattleHp;
  // State
  final bool isSleeping;
  final bool isSick;
  final bool isStunned;
  final DateTime? stunnedUntil;
  // Timestamps
  final DateTime lastInteractionAt;

  CreatureDetail({
    required this.id,
    required this.name,
    required this.type,
    required this.developmentStage,
    required this.ageInDays,
    required this.birthDate,
    required this.isActive,
    required this.isDead,
    required this.hunger,
    required this.happiness,
    required this.energy,
    required this.health,
    required this.cleanliness,
    required this.weight,
    required this.attack,
    required this.defense,
    required this.speed,
    required this.maxBattleHp,
    required this.currentBattleHp,
    required this.isSleeping,
    required this.isSick,
    required this.isStunned,
    this.stunnedUntil,
    required this.lastInteractionAt,
  });
}

/// Result of a creature interaction.
class InteractionResult {
  final bool success;
  final String message;
  final Map<String, int> statChanges;
  final DateTime? nextAvailableAt;

  InteractionResult({
    required this.success,
    required this.message,
    required this.statChanges,
    this.nextAvailableAt,
  });
}
