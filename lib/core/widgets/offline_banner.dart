import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/connectivity_provider.dart';

/// A banner that appears when the device is offline.
class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityStatus = ref.watch(connectivityProvider);
    final theme = Theme.of(context);

    if (connectivityStatus == ConnectivityStatus.online) {
      return const SizedBox.shrink();
    }

    return Material(
      color: connectivityStatus == ConnectivityStatus.checking
          ? theme.colorScheme.primaryContainer
          : theme.colorScheme.errorContainer,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Icon(
                connectivityStatus == ConnectivityStatus.checking
                    ? Icons.sync
                    : Icons.wifi_off,
                size: 20,
                color: connectivityStatus == ConnectivityStatus.checking
                    ? theme.colorScheme.onPrimaryContainer
                    : theme.colorScheme.onErrorContainer,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  connectivityStatus == ConnectivityStatus.checking
                      ? 'Verbindung wird geprüft...'
                      : 'Keine Internetverbindung',
                  style: TextStyle(
                    color: connectivityStatus == ConnectivityStatus.checking
                        ? theme.colorScheme.onPrimaryContainer
                        : theme.colorScheme.onErrorContainer,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (connectivityStatus == ConnectivityStatus.offline)
                TextButton(
                  onPressed: () => ref.read(connectivityProvider.notifier).checkNow(),
                  style: TextButton.styleFrom(
                    foregroundColor: theme.colorScheme.onErrorContainer,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  child: const Text('Erneut versuchen'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A wrapper widget that shows the offline banner above its child.
class OfflineAwareScaffold extends ConsumerWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;

  const OfflineAwareScaffold({
    super.key,
    required this.child,
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      body: Column(
        children: [
          const OfflineBanner(),
          Expanded(child: child),
        ],
      ),
    );
  }
}
