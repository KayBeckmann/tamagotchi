import 'package:serverpod/serverpod.dart';

import 'package:tamagotchi_server_server/src/birthday_reminder.dart';
import 'package:tamagotchi_server_server/src/web/routes/root.dart';
import 'package:tamagotchi_server_server/src/future_calls/creature_status_update.dart';

import 'src/generated/protocol.dart';
import 'src/generated/endpoints.dart';

void run(List<String> args) async {
  final pod = Serverpod(args, Protocol(), Endpoints());

  pod.webServer.addRoute(RouteRoot(), '/');
  pod.webServer.addRoute(RouteRoot(), '/index.html');
  pod.webServer.addRoute(
    RouteStaticDirectory(serverDirectory: 'static', basePath: '/'),
    '/*',
  );

  await pod.start();

  // Register all future calls
  pod.registerFutureCall(
    BirthdayReminder(),
    FutureCallNames.birthdayReminder.name,
  );
  pod.registerFutureCall(
    CreatureStatusUpdateCall(),
    FutureCallNames.creatureStatusUpdate.name,
  );

  // Schedule demo greeting (existing)
  await pod.futureCallWithDelay(
    FutureCallNames.birthdayReminder.name,
    Greeting(
      message: 'Hello!',
      author: 'Serverpod Server',
      timestamp: DateTime.now(),
    ),
    const Duration(seconds: 5),
  );

  // Schedule first creature status update after 30 seconds on startup,
  // then it reschedules itself every 30 minutes.
  await pod.futureCallWithDelay(
    FutureCallNames.creatureStatusUpdate.name,
    Greeting(
      message: 'initial-tick',
      author: 'startup',
      timestamp: DateTime.now(),
    ),
    const Duration(seconds: 30),
  );
}

/// Names of all future calls in the server.
enum FutureCallNames {
  birthdayReminder,
  creatureStatusUpdate,
}
