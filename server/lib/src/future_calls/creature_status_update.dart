import 'package:serverpod/serverpod.dart';
import 'package:tamagotchi_server_server/src/generated/protocol.dart';

import '../services/creature_status_service.dart';
import '../../server.dart' show FutureCallNames;

/// Future call that periodically updates all creature statuses.
///
/// Runs every 30 minutes via self-scheduling. Uses Greeting as the
/// carrier type because Serverpod requires a SerializableModel.
class CreatureStatusUpdateCall extends FutureCall<Greeting> {
  static const updateInterval = Duration(minutes: 30);

  @override
  Future<void> invoke(Session session, Greeting? object) async {
    session.log('Starting creature status update...', level: LogLevel.info);

    try {
      final result = await CreatureStatusService.processAllCreatures(session);

      if (result.success) {
        session.log(
          'Status update OK – processed: ${result.processed}, '
          'sick: ${result.becameSick}, deaths: ${result.deaths}',
          level: LogLevel.info,
        );
      } else {
        session.log(
          'Status update finished with ${result.errors} error(s)',
          level: LogLevel.warning,
        );
      }

      await _scheduleNextRun(session);
    } catch (e, st) {
      session.log('Status update failed: $e\n$st', level: LogLevel.error);
      await _scheduleNextRun(session);
    }
  }

  Future<void> _scheduleNextRun(Session session) async {
    await session.serverpod.futureCallWithDelay(
      FutureCallNames.creatureStatusUpdate.name,
      Greeting(
        message: 'status-tick',
        author: 'scheduler',
        timestamp: DateTime.now(),
      ),
      updateInterval,
    );
  }
}
