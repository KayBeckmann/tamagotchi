import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../domain/models/creature.dart';
import '../domain/models/creature_type.dart';
import '../domain/models/action_cooldown.dart';
import '../domain/models/item.dart';

/// Repository for creature operations.
class CreatureRepository {
  // In-memory storage for development
  final List<Creature> _creatures = [];
  final _uuid = const Uuid();
  final ActionCooldownManager _cooldownManager = ActionCooldownManager();

  // User inventory (in-memory for development)
  final Map<String, List<InventoryItem>> _userInventory = {};

  /// Get all creatures for a user.
  Future<List<Creature>> getCreatures(String userId) async {
    // TODO: Replace with actual API call
    await Future.delayed(const Duration(milliseconds: 300));
    return _creatures.where((c) => c.userId == userId).toList();
  }

  /// Get a creature by ID.
  Future<Creature?> getCreature(String creatureId) async {
    // TODO: Replace with actual API call
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _creatures.firstWhere((c) => c.id == creatureId);
    } catch (_) {
      return null;
    }
  }

  /// Create a new creature.
  Future<Creature> createCreature({
    required String userId,
    required String creatureTypeId,
    required String name,
  }) async {
    // TODO: Replace with actual API call
    await Future.delayed(const Duration(milliseconds: 500));

    final type = CreatureCatalog.getById(creatureTypeId);
    if (type == null) {
      throw Exception('Unknown creature type: $creatureTypeId');
    }

    final now = DateTime.now();
    final creature = Creature(
      id: _uuid.v4(),
      userId: userId,
      type: type,
      name: name,
      isActive: _creatures.where((c) => c.userId == userId).isEmpty,
      stage: DevelopmentStage.egg,
      ageInDays: 0,
      birthDate: now,
      lastInteractionAt: now,
      lastStatusUpdateAt: now,
      createdAt: now,
    );

    _creatures.add(creature);

    // Give new users some starter items
    _initializeUserInventory(userId);

    return creature;
  }

  /// Initialize user inventory with starter items.
  void _initializeUserInventory(String userId) {
    if (_userInventory.containsKey(userId)) return;

    _userInventory[userId] = [
      InventoryItem(
        item: ItemCatalog.getById('food_normal')!,
        quantity: 5,
        acquiredAt: DateTime.now(),
      ),
      InventoryItem(
        item: ItemCatalog.getById('medicine_basic')!,
        quantity: 2,
        acquiredAt: DateTime.now(),
      ),
    ];
  }

  /// Set a creature as active.
  Future<void> setActiveCreature(String userId, String creatureId) async {
    // TODO: Replace with actual API call
    await Future.delayed(const Duration(milliseconds: 200));

    for (var i = 0; i < _creatures.length; i++) {
      if (_creatures[i].userId == userId) {
        _creatures[i] = _creatures[i].copyWith(
          isActive: _creatures[i].id == creatureId,
        );
      }
    }
  }

  /// Update creature stats after interaction.
  Future<Creature> updateCreature(Creature creature) async {
    // TODO: Replace with actual API call
    await Future.delayed(const Duration(milliseconds: 100));

    final index = _creatures.indexWhere((c) => c.id == creature.id);
    if (index >= 0) {
      _creatures[index] = creature;
    }
    return creature;
  }

  // ============================================================
  // Cooldown Management
  // ============================================================

  /// Check if an action is available for a creature.
  bool isActionAvailable(String creatureId, ActionType action) {
    return _cooldownManager.isActionAvailable(creatureId, action);
  }

  /// Get remaining cooldown for an action.
  Duration? getRemainingCooldown(String creatureId, ActionType action) {
    return _cooldownManager.getRemainingCooldown(creatureId, action);
  }

  /// Get all cooldowns for a creature.
  Map<ActionType, Duration?> getAllCooldowns(String creatureId) {
    return _cooldownManager.getAllCooldowns(creatureId);
  }

  // ============================================================
  // Creature Interactions
  // ============================================================

  /// Feed a creature.
  Future<Creature> feedCreature(String creatureId, int hungerGain, int weightGain) async {
    // Check cooldown
    if (!_cooldownManager.isActionAvailable(creatureId, ActionType.feed)) {
      final remaining = _cooldownManager.getRemainingCooldown(creatureId, ActionType.feed);
      throw CooldownException(ActionType.feed, remaining!);
    }

    final creature = await getCreature(creatureId);
    if (creature == null) throw Exception('Creature not found');

    final updated = creature.copyWith(
      hunger: (creature.hunger + hungerGain).clamp(0, 100),
      weight: creature.weight + (weightGain / 10),
      lastInteractionAt: DateTime.now(),
    );

    // Record cooldown
    _cooldownManager.recordAction(creatureId, ActionType.feed);

    return updateCreature(updated);
  }

  /// Play with a creature.
  Future<Creature> playWithCreature(String creatureId) async {
    // Check cooldown
    if (!_cooldownManager.isActionAvailable(creatureId, ActionType.play)) {
      final remaining = _cooldownManager.getRemainingCooldown(creatureId, ActionType.play);
      throw CooldownException(ActionType.play, remaining!);
    }

    final creature = await getCreature(creatureId);
    if (creature == null) throw Exception('Creature not found');

    final updated = creature.copyWith(
      happiness: (creature.happiness + 15).clamp(0, 100),
      energy: (creature.energy - 10).clamp(0, 100),
      lastInteractionAt: DateTime.now(),
    );

    // Record cooldown
    _cooldownManager.recordAction(creatureId, ActionType.play);

    return updateCreature(updated);
  }

  /// Clean a creature.
  Future<Creature> cleanCreature(String creatureId) async {
    // Check cooldown
    if (!_cooldownManager.isActionAvailable(creatureId, ActionType.clean)) {
      final remaining = _cooldownManager.getRemainingCooldown(creatureId, ActionType.clean);
      throw CooldownException(ActionType.clean, remaining!);
    }

    final creature = await getCreature(creatureId);
    if (creature == null) throw Exception('Creature not found');

    final updated = creature.copyWith(
      cleanliness: 100,
      lastInteractionAt: DateTime.now(),
    );

    // Record cooldown
    _cooldownManager.recordAction(creatureId, ActionType.clean);

    return updateCreature(updated);
  }

  /// Put creature to sleep.
  Future<Creature> sleepCreature(String creatureId) async {
    final creature = await getCreature(creatureId);
    if (creature == null) throw Exception('Creature not found');

    final updated = creature.copyWith(
      isSleeping: true,
      lastInteractionAt: DateTime.now(),
    );

    return updateCreature(updated);
  }

  /// Wake creature up.
  Future<Creature> wakeCreature(String creatureId) async {
    final creature = await getCreature(creatureId);
    if (creature == null) throw Exception('Creature not found');

    final updated = creature.copyWith(
      isSleeping: false,
      energy: (creature.energy + 30).clamp(0, 100),
      lastInteractionAt: DateTime.now(),
    );

    return updateCreature(updated);
  }

  /// Train a creature.
  Future<Creature> trainCreature(String creatureId, String statType) async {
    // Check cooldown
    if (!_cooldownManager.isActionAvailable(creatureId, ActionType.train)) {
      final remaining = _cooldownManager.getRemainingCooldown(creatureId, ActionType.train);
      throw CooldownException(ActionType.train, remaining!);
    }

    final creature = await getCreature(creatureId);
    if (creature == null) throw Exception('Creature not found');
    if (!creature.canTrain) throw Exception('Creature cannot train');

    Creature updated;
    switch (statType) {
      case 'attack':
        updated = creature.copyWith(
          trainedAttack: creature.trainedAttack + 1,
          energy: (creature.energy - 20).clamp(0, 100),
          lastInteractionAt: DateTime.now(),
        );
        break;
      case 'defense':
        updated = creature.copyWith(
          trainedDefense: creature.trainedDefense + 1,
          energy: (creature.energy - 20).clamp(0, 100),
          lastInteractionAt: DateTime.now(),
        );
        break;
      case 'speed':
        updated = creature.copyWith(
          trainedSpeed: creature.trainedSpeed + 1,
          energy: (creature.energy - 20).clamp(0, 100),
          lastInteractionAt: DateTime.now(),
        );
        break;
      default:
        throw Exception('Unknown stat type: $statType');
    }

    // Record cooldown
    _cooldownManager.recordAction(creatureId, ActionType.train);

    return updateCreature(updated);
  }

  /// Give medicine to a creature.
  Future<Creature> giveMedicine(String creatureId, String itemId) async {
    // Check cooldown
    if (!_cooldownManager.isActionAvailable(creatureId, ActionType.medicine)) {
      final remaining = _cooldownManager.getRemainingCooldown(creatureId, ActionType.medicine);
      throw CooldownException(ActionType.medicine, remaining!);
    }

    final creature = await getCreature(creatureId);
    if (creature == null) throw Exception('Creature not found');

    final item = ItemCatalog.getById(itemId);
    if (item == null) throw Exception('Item not found');
    if (item.category != ItemCategory.medicine) {
      throw Exception('Item is not medicine');
    }

    // Check inventory
    final inventory = _userInventory[creature.userId];
    if (inventory == null) throw Exception('No inventory found');

    final invIndex = inventory.indexWhere((inv) => inv.item.id == itemId);
    if (invIndex < 0 || inventory[invIndex].quantity <= 0) {
      throw Exception('No medicine in inventory');
    }

    // Use the medicine
    final updated = creature.copyWith(
      health: (creature.health + item.healthEffect).clamp(0, 100),
      happiness: (creature.happiness + item.happinessEffect).clamp(0, 100),
      energy: (creature.energy + item.energyEffect).clamp(0, 100),
      isSick: creature.health + item.healthEffect >= 50 ? false : creature.isSick,
      lastInteractionAt: DateTime.now(),
    );

    // Decrease inventory
    if (inventory[invIndex].quantity == 1) {
      inventory.removeAt(invIndex);
    } else {
      inventory[invIndex] = inventory[invIndex].copyWith(
        quantity: inventory[invIndex].quantity - 1,
      );
    }

    // Record cooldown
    _cooldownManager.recordAction(creatureId, ActionType.medicine);

    return updateCreature(updated);
  }

  // ============================================================
  // Inventory Management
  // ============================================================

  /// Get user's inventory.
  Future<List<InventoryItem>> getInventory(String userId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _userInventory[userId] ?? [];
  }

  /// Add item to inventory.
  Future<void> addToInventory(String userId, String itemId, int quantity) async {
    final item = ItemCatalog.getById(itemId);
    if (item == null) throw Exception('Item not found');

    _userInventory[userId] ??= [];
    final inventory = _userInventory[userId]!;

    final existingIndex = inventory.indexWhere((inv) => inv.item.id == itemId);
    if (existingIndex >= 0) {
      inventory[existingIndex] = inventory[existingIndex].copyWith(
        quantity: inventory[existingIndex].quantity + quantity,
      );
    } else {
      inventory.add(InventoryItem(
        item: item,
        quantity: quantity,
        acquiredAt: DateTime.now(),
      ));
    }
  }

  /// Get the count of creatures for a user.
  Future<int> getCreatureCount(String userId) async {
    return _creatures.where((c) => c.userId == userId && !c.isDead).length;
  }
}

/// Exception thrown when an action is on cooldown.
class CooldownException implements Exception {
  final ActionType action;
  final Duration remaining;

  CooldownException(this.action, this.remaining);

  @override
  String toString() {
    return '${action.displayName} ist noch im Cooldown. '
        'Verfügbar in ${ActionCooldownManager.formatCooldown(remaining)}.';
  }
}

/// Provider for CreatureRepository.
final creatureRepositoryProvider = Provider<CreatureRepository>((ref) {
  return CreatureRepository();
});
