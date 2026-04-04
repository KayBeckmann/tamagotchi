/// Action types that have cooldowns.
enum ActionType {
  feed,
  play,
  clean,
  train,
  medicine,
}

/// Extension for action type properties.
extension ActionTypeExtension on ActionType {
  /// Get the cooldown duration for this action.
  Duration get cooldownDuration {
    switch (this) {
      case ActionType.feed:
        return const Duration(minutes: 30);
      case ActionType.play:
        return const Duration(minutes: 15);
      case ActionType.clean:
        return const Duration(minutes: 60);
      case ActionType.train:
        return const Duration(minutes: 45);
      case ActionType.medicine:
        return const Duration(hours: 2);
    }
  }

  /// Get the display name for this action.
  String get displayName {
    switch (this) {
      case ActionType.feed:
        return 'Füttern';
      case ActionType.play:
        return 'Spielen';
      case ActionType.clean:
        return 'Waschen';
      case ActionType.train:
        return 'Trainieren';
      case ActionType.medicine:
        return 'Medizin';
    }
  }
}

/// Tracks cooldowns for creature actions.
class ActionCooldownManager {
  // Map: creatureId -> Map<ActionType, lastActionTime>
  final Map<String, Map<ActionType, DateTime>> _cooldowns = {};

  /// Check if an action is available for a creature.
  bool isActionAvailable(String creatureId, ActionType action) {
    final creatureCooldowns = _cooldowns[creatureId];
    if (creatureCooldowns == null) return true;

    final lastAction = creatureCooldowns[action];
    if (lastAction == null) return true;

    final cooldownEnd = lastAction.add(action.cooldownDuration);
    return DateTime.now().isAfter(cooldownEnd);
  }

  /// Get the remaining cooldown time for an action.
  Duration? getRemainingCooldown(String creatureId, ActionType action) {
    final creatureCooldowns = _cooldowns[creatureId];
    if (creatureCooldowns == null) return null;

    final lastAction = creatureCooldowns[action];
    if (lastAction == null) return null;

    final cooldownEnd = lastAction.add(action.cooldownDuration);
    final now = DateTime.now();

    if (now.isAfter(cooldownEnd)) return null;

    return cooldownEnd.difference(now);
  }

  /// Get when an action will be available again.
  DateTime? getNextAvailableTime(String creatureId, ActionType action) {
    final creatureCooldowns = _cooldowns[creatureId];
    if (creatureCooldowns == null) return null;

    final lastAction = creatureCooldowns[action];
    if (lastAction == null) return null;

    final cooldownEnd = lastAction.add(action.cooldownDuration);
    if (DateTime.now().isAfter(cooldownEnd)) return null;

    return cooldownEnd;
  }

  /// Record that an action was performed.
  void recordAction(String creatureId, ActionType action) {
    _cooldowns[creatureId] ??= {};
    _cooldowns[creatureId]![action] = DateTime.now();
  }

  /// Get all cooldowns for a creature.
  Map<ActionType, Duration?> getAllCooldowns(String creatureId) {
    return {
      for (final action in ActionType.values)
        action: getRemainingCooldown(creatureId, action),
    };
  }

  /// Clear all cooldowns for a creature (e.g., when creature dies).
  void clearCooldowns(String creatureId) {
    _cooldowns.remove(creatureId);
  }

  /// Format remaining cooldown as a readable string.
  static String formatCooldown(Duration? remaining) {
    if (remaining == null) return 'Verfügbar';

    if (remaining.inHours > 0) {
      return '${remaining.inHours}h ${remaining.inMinutes % 60}m';
    } else if (remaining.inMinutes > 0) {
      return '${remaining.inMinutes}m ${remaining.inSeconds % 60}s';
    } else {
      return '${remaining.inSeconds}s';
    }
  }
}
