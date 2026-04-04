import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../domain/models/creature.dart';
import '../domain/models/creature_type.dart';

/// Repository for creature operations.
class CreatureRepository {
  // In-memory storage for development
  final List<Creature> _creatures = [];
  final _uuid = const Uuid();

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
    return creature;
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

  /// Feed a creature.
  Future<Creature> feedCreature(String creatureId, int hungerGain, int weightGain) async {
    final creature = await getCreature(creatureId);
    if (creature == null) throw Exception('Creature not found');

    final updated = creature.copyWith(
      hunger: (creature.hunger + hungerGain).clamp(0, 100),
      weight: creature.weight + (weightGain / 10),
      lastInteractionAt: DateTime.now(),
    );

    return updateCreature(updated);
  }

  /// Play with a creature.
  Future<Creature> playWithCreature(String creatureId) async {
    final creature = await getCreature(creatureId);
    if (creature == null) throw Exception('Creature not found');

    final updated = creature.copyWith(
      happiness: (creature.happiness + 15).clamp(0, 100),
      energy: (creature.energy - 10).clamp(0, 100),
      lastInteractionAt: DateTime.now(),
    );

    return updateCreature(updated);
  }

  /// Clean a creature.
  Future<Creature> cleanCreature(String creatureId) async {
    final creature = await getCreature(creatureId);
    if (creature == null) throw Exception('Creature not found');

    final updated = creature.copyWith(
      cleanliness: 100,
      lastInteractionAt: DateTime.now(),
    );

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

    return updateCreature(updated);
  }

  /// Get the count of creatures for a user.
  Future<int> getCreatureCount(String userId) async {
    return _creatures.where((c) => c.userId == userId && !c.isDead).length;
  }
}

/// Provider for CreatureRepository.
final creatureRepositoryProvider = Provider<CreatureRepository>((ref) {
  return CreatureRepository();
});
