import 'dart:async';

import 'package:serverpod/serverpod.dart';

/// Service for managing creature status updates.
///
/// This service runs periodically to:
/// - Decrease creature status values over time
/// - Check for sickness conditions
/// - Handle death mechanics from neglect
/// - Update development stages based on age
/// - Handle stun recovery from tournament losses
class CreatureStatusService {
  /// Interval between status updates.
  static const updateInterval = Duration(minutes: 30);

  /// Status decay rates per update interval.
  static const hungerDecay = 5;
  static const happinessDecay = 3;
  static const energyDecayAwake = 4;
  static const energyRecoverySleep = 10;
  static const cleanlinessDecay = 2;

  /// Thresholds for sickness.
  static const sicknessThreshold = 20;

  /// Days of neglect before death.
  static const neglectDaysUntilDeath = 7;

  /// Process status updates for all creatures.
  ///
  /// This should be called periodically (e.g., via a Serverpod Future Call
  /// or external cron job).
  static Future<StatusUpdateResult> processAllCreatures(Session session) async {
    final result = StatusUpdateResult();

    try {
      // Get all living creatures
      // TODO: Replace with actual database query
      // final creatures = await Creature.db.find(
      //   session,
      //   where: (c) => c.isDead.equals(false),
      // );

      session.log('Processing creature status updates...', level: LogLevel.info);

      // For each creature, process status decay
      // for (final creature in creatures) {
      //   try {
      //     await _processCreature(session, creature);
      //     result.processed++;
      //   } catch (e) {
      //     result.errors++;
      //     session.log(
      //       'Error processing creature ${creature.id}: $e',
      //       level: LogLevel.error,
      //     );
      //   }
      // }

      result.success = true;
      session.log(
        'Status update complete. Processed: ${result.processed}, '
        'Sick: ${result.becameSick}, Deaths: ${result.deaths}',
        level: LogLevel.info,
      );
    } catch (e) {
      result.success = false;
      session.log('Status update failed: $e', level: LogLevel.error);
    }

    return result;
  }

  /// Process status decay for a single creature.
  // static Future<void> _processCreature(Session session, Creature creature) async {
  //   final now = DateTime.now();
  //   var updated = creature;
  //
  //   // Calculate time since last update
  //   final timeSinceUpdate = now.difference(creature.lastStatusUpdateAt);
  //   final updateCycles = timeSinceUpdate.inMinutes ~/ updateInterval.inMinutes;
  //
  //   if (updateCycles <= 0) return;
  //
  //   // Apply status decay for each cycle
  //   for (var i = 0; i < updateCycles; i++) {
  //     updated = _applyStatusDecay(updated);
  //   }
  //
  //   // Check for sickness
  //   if (_shouldBecomeSick(updated) && !updated.isSick) {
  //     updated = updated.copyWith(isSick: true);
  //   }
  //
  //   // Check for neglect death
  //   if (updated.health <= 0) {
  //     final newNeglectDays = updated.neglectDays + 1;
  //     if (newNeglectDays >= neglectDaysUntilDeath) {
  //       // Creature dies from neglect
  //       updated = updated.copyWith(
  //         isDead: true,
  //         deathDate: now,
  //         deathCause: 'neglect',
  //       );
  //     } else {
  //       updated = updated.copyWith(neglectDays: newNeglectDays);
  //     }
  //   } else {
  //     // Reset neglect days if health is above 0
  //     updated = updated.copyWith(neglectDays: 0);
  //   }
  //
  //   // Check for stun recovery
  //   if (updated.isStunned && updated.stunnedUntil != null) {
  //     if (now.isAfter(updated.stunnedUntil!)) {
  //       updated = updated.copyWith(
  //         isStunned: false,
  //         stunnedUntil: null,
  //       );
  //     }
  //   }
  //
  //   // Update development stage based on age
  //   final ageInDays = now.difference(updated.birthDate).inDays;
  //   final newStage = _getStageForAge(ageInDays);
  //   if (newStage != updated.stage) {
  //     updated = updated.copyWith(
  //       stage: newStage,
  //       ageInDays: ageInDays,
  //     );
  //   }
  //
  //   // Update timestamp
  //   updated = updated.copyWith(lastStatusUpdateAt: now);
  //
  //   // Save to database
  //   await Creature.db.updateRow(session, updated);
  // }

  /// Apply status decay based on creature state.
  // static Creature _applyStatusDecay(Creature creature) {
  //   return creature.copyWith(
  //     hunger: (creature.hunger - hungerDecay).clamp(0, 100),
  //     happiness: (creature.happiness - happinessDecay).clamp(0, 100),
  //     energy: creature.isSleeping
  //         ? (creature.energy + energyRecoverySleep).clamp(0, 100)
  //         : (creature.energy - energyDecayAwake).clamp(0, 100),
  //     cleanliness: (creature.cleanliness - cleanlinessDecay).clamp(0, 100),
  //     health: _calculateHealthChange(creature),
  //   );
  // }

  /// Calculate health change based on other stats.
  static int _calculateHealthChange(int currentHealth, int hunger, int happiness, int cleanliness, bool isSick) {
    var healthChange = 0;

    // Low hunger damages health
    if (hunger < 20) {
      healthChange -= 5;
    }

    // Very low happiness damages health
    if (happiness < 10) {
      healthChange -= 2;
    }

    // Low cleanliness can cause sickness
    if (cleanliness < 15) {
      healthChange -= 3;
    }

    // Sickness drains health
    if (isSick) {
      healthChange -= 5;
    }

    // Natural recovery if all stats are good
    if (hunger > 50 && happiness > 50 && cleanliness > 50 && !isSick) {
      healthChange += 2;
    }

    return (currentHealth + healthChange).clamp(0, 100);
  }

  /// Check if creature should become sick.
  static bool shouldBecomeSick(int health, int cleanliness, int hunger) {
    // Sickness chance increases with low stats
    if (health < sicknessThreshold) return true;
    if (cleanliness < 10 && hunger < 30) return true;
    return false;
  }

  /// Get development stage for age.
  static String getStageForAge(int ageInDays) {
    if (ageInDays < 1) return 'egg';
    if (ageInDays <= 3) return 'baby';
    if (ageInDays <= 7) return 'child';
    if (ageInDays <= 14) return 'teen';
    return 'adult';
  }
}

/// Result of a status update run.
class StatusUpdateResult {
  bool success = false;
  int processed = 0;
  int becameSick = 0;
  int deaths = 0;
  int stageChanges = 0;
  int stunRecoveries = 0;
  int errors = 0;
}

/// Configuration for status decay rates.
class StatusDecayConfig {
  final int hungerDecayRate;
  final int happinessDecayRate;
  final int energyDecayRate;
  final int cleanlinessDecayRate;
  final int energyRecoveryRate;
  final Duration updateInterval;

  const StatusDecayConfig({
    this.hungerDecayRate = 5,
    this.happinessDecayRate = 3,
    this.energyDecayRate = 4,
    this.cleanlinessDecayRate = 2,
    this.energyRecoveryRate = 10,
    this.updateInterval = const Duration(minutes: 30),
  });

  /// Default configuration.
  static const defaultConfig = StatusDecayConfig();

  /// Aggressive decay for testing.
  static const testConfig = StatusDecayConfig(
    hungerDecayRate: 10,
    happinessDecayRate: 8,
    energyDecayRate: 6,
    cleanlinessDecayRate: 5,
    updateInterval: Duration(minutes: 5),
  );
}
