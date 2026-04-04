import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/creature_repository.dart';
import '../../domain/models/creature.dart';
import '../../domain/models/creature_type.dart';

/// State for the creature list.
sealed class CreatureListState {
  const CreatureListState();
}

class CreatureListLoading extends CreatureListState {
  const CreatureListLoading();
}

class CreatureListLoaded extends CreatureListState {
  final List<Creature> creatures;
  final Creature? activeCreature;

  const CreatureListLoaded({
    required this.creatures,
    this.activeCreature,
  });
}

class CreatureListError extends CreatureListState {
  final String message;
  const CreatureListError(this.message);
}

/// Notifier for creature list.
class CreatureListNotifier extends StateNotifier<CreatureListState> {
  final CreatureRepository _repository;
  final String _userId;

  CreatureListNotifier(this._repository, this._userId)
      : super(const CreatureListLoading()) {
    loadCreatures();
  }

  Future<void> loadCreatures() async {
    state = const CreatureListLoading();
    try {
      final creatures = await _repository.getCreatures(_userId);
      final active = creatures.where((c) => c.isActive).firstOrNull;
      state = CreatureListLoaded(creatures: creatures, activeCreature: active);
    } catch (e) {
      state = CreatureListError(e.toString());
    }
  }

  Future<void> createCreature({
    required String typeId,
    required String name,
  }) async {
    try {
      await _repository.createCreature(
        userId: _userId,
        creatureTypeId: typeId,
        name: name,
      );
      await loadCreatures();
    } catch (e) {
      state = CreatureListError(e.toString());
    }
  }

  Future<void> setActiveCreature(String creatureId) async {
    try {
      await _repository.setActiveCreature(_userId, creatureId);
      await loadCreatures();
    } catch (e) {
      state = CreatureListError(e.toString());
    }
  }
}

/// Provider for creature list.
final creatureListProvider = StateNotifierProvider.family<CreatureListNotifier, CreatureListState, String>(
  (ref, userId) {
    final repository = ref.watch(creatureRepositoryProvider);
    return CreatureListNotifier(repository, userId);
  },
);

/// Provider for the active creature.
final activeCreatureProvider = Provider.family<Creature?, String>((ref, userId) {
  final state = ref.watch(creatureListProvider(userId));
  if (state is CreatureListLoaded) {
    return state.activeCreature;
  }
  return null;
});

/// Provider for creature types catalog.
final creatureTypesProvider = Provider<List<CreatureType>>((ref) {
  return CreatureCatalog.all;
});

/// Provider for available (unlocked) creature types.
final availableCreatureTypesProvider = Provider<List<CreatureType>>((ref) {
  // TODO: Filter based on user's unlocks
  return CreatureCatalog.available;
});

/// State for creature creation.
class CreatureCreationState {
  final CreatureType? selectedType;
  final String name;
  final bool isCreating;
  final String? error;

  const CreatureCreationState({
    this.selectedType,
    this.name = '',
    this.isCreating = false,
    this.error,
  });

  CreatureCreationState copyWith({
    CreatureType? selectedType,
    String? name,
    bool? isCreating,
    String? error,
    bool clearError = false,
  }) {
    return CreatureCreationState(
      selectedType: selectedType ?? this.selectedType,
      name: name ?? this.name,
      isCreating: isCreating ?? this.isCreating,
      error: clearError ? null : (error ?? this.error),
    );
  }

  bool get isValid => selectedType != null && name.length >= 2;
}

/// Notifier for creature creation.
class CreatureCreationNotifier extends StateNotifier<CreatureCreationState> {
  CreatureCreationNotifier() : super(const CreatureCreationState());

  void selectType(CreatureType type) {
    state = state.copyWith(selectedType: type, clearError: true);
  }

  void setName(String name) {
    state = state.copyWith(name: name, clearError: true);
  }

  void setCreating(bool isCreating) {
    state = state.copyWith(isCreating: isCreating);
  }

  void setError(String error) {
    state = state.copyWith(error: error, isCreating: false);
  }

  void reset() {
    state = const CreatureCreationState();
  }
}

final creatureCreationProvider = StateNotifierProvider.autoDispose<CreatureCreationNotifier, CreatureCreationState>(
  (ref) => CreatureCreationNotifier(),
);
