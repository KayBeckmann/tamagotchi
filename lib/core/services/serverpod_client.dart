import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tamagotchi_server_client/tamagotchi_server_client.dart';

import '../constants/app_constants.dart';

/// Serverpod client singleton provider.
final clientProvider = Provider<Client>((ref) {
  return Client(AppConstants.apiBaseUrl);
});
