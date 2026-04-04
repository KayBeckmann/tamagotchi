import 'package:serverpod/serverpod.dart';

import '../services/creature_status_service.dart';

/// Future call that periodically updates all creature statuses.
///
/// This runs every 30 minutes (configurable) and:
/// - Decreases hunger, happiness, energy, cleanliness over time
/// - Checks for sickness conditions
/// - Handles death from neglect (7 days with health = 0)
/// - Updates development stages based on age
/// - Recovers creatures from tournament stun
class CreatureStatusUpdateCall extends FutureCall<void> {
  /// Interval between status updates.
  static const updateInterval = Duration(minutes: 30);

  @override
  Future<void> invoke(Session session, void object) async {
    session.log('Starting creature status update...', level: LogLevel.info);

    try {
      // Process all creatures
      final result = await CreatureStatusService.processAllCreatures(session);

      if (result.success) {
        session.log(
          'Creature status update completed successfully. '
          'Processed: ${result.processed}, '
          'Became sick: ${result.becameSick}, '
          'Deaths: ${result.deaths}, '
          'Stage changes: ${result.stageChanges}',
          level: LogLevel.info,
        );
      } else {
        session.log(
          'Creature status update completed with errors: ${result.errors}',
          level: LogLevel.warning,
        );
      }

      // Schedule next run
      await _scheduleNextRun(session);
    } catch (e, stackTrace) {
      session.log(
        'Creature status update failed: $e\n$stackTrace',
        level: LogLevel.error,
      );

      // Still schedule next run even on failure
      await _scheduleNextRun(session);
    }
  }

  /// Schedule the next status update run.
  Future<void> _scheduleNextRun(Session session) async {
    await session.serverpod.futureCallWithDelay(
      FutureCallNames.creatureStatusUpdate.name,
      null,
      updateInterval,
    );

    session.log(
      'Next creature status update scheduled in ${updateInterval.inMinutes} minutes',
      level: LogLevel.debug,
    );
  }
}

/// Names of all future calls in the server.
enum FutureCallNames {
  creatureStatusUpdate,
}
