import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Connectivity state.
enum ConnectivityStatus {
  online,
  offline,
  checking,
}

/// Provider for monitoring network connectivity.
class ConnectivityNotifier extends StateNotifier<ConnectivityStatus> {
  Timer? _periodicCheck;

  ConnectivityNotifier() : super(ConnectivityStatus.checking) {
    _checkConnectivity();
    _startPeriodicCheck();
  }

  void _startPeriodicCheck() {
    _periodicCheck = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _checkConnectivity(),
    );
  }

  Future<void> _checkConnectivity() async {
    try {
      // Try to lookup a reliable DNS
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 5));

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        state = ConnectivityStatus.online;
      } else {
        state = ConnectivityStatus.offline;
      }
    } on SocketException catch (_) {
      state = ConnectivityStatus.offline;
    } on TimeoutException catch (_) {
      state = ConnectivityStatus.offline;
    } catch (_) {
      state = ConnectivityStatus.offline;
    }
  }

  /// Manually trigger a connectivity check.
  Future<void> checkNow() async {
    state = ConnectivityStatus.checking;
    await _checkConnectivity();
  }

  @override
  void dispose() {
    _periodicCheck?.cancel();
    super.dispose();
  }
}

/// Provider for connectivity status.
final connectivityProvider = StateNotifierProvider<ConnectivityNotifier, ConnectivityStatus>((ref) {
  return ConnectivityNotifier();
});

/// Whether the device is currently online.
final isOnlineProvider = Provider<bool>((ref) {
  final status = ref.watch(connectivityProvider);
  return status == ConnectivityStatus.online;
});
