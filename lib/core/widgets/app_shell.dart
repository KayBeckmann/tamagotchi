import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/notifications/presentation/notification_provider.dart';

class AppShell extends ConsumerWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/arena')) return 1;
    if (location.startsWith('/tournament')) return 2;
    if (location.startsWith('/shop')) return 3;
    if (location.startsWith('/social')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWide = MediaQuery.sizeOf(context).width >= 900;
    final index = _currentIndex(context);
    final unreadCount = ref.watch(unreadNotificationCountProvider);

    final destinations = const [
      NavigationDestination(icon: Icon(Icons.pets), label: 'Kreatur'),
      NavigationDestination(icon: Icon(Icons.sports_mma), label: 'Arena'),
      NavigationDestination(icon: Icon(Icons.emoji_events), label: 'Turnier'),
      NavigationDestination(icon: Icon(Icons.store), label: 'Shop'),
      NavigationDestination(icon: Icon(Icons.people), label: 'Sozial'),
    ];

    final railDestinations = destinations
        .map((d) => NavigationRailDestination(
              icon: d.icon,
              label: Text(d.label),
            ))
        .toList();

    Widget notificationButton() => Badge(
          isLabelVisible: unreadCount > 0,
          label: Text('$unreadCount'),
          child: IconButton(
            icon: const Icon(Icons.notifications_outlined),
            tooltip: 'Benachrichtigungen',
            onPressed: () => context.push('/notifications'),
          ),
        );

    if (isWide) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: index,
              onDestinationSelected: (i) => _onTap(context, i),
              labelType: NavigationRailLabelType.all,
              leading: Column(
                children: [
                  const SizedBox(height: 8),
                  notificationButton(),
                  IconButton(
                    icon: const Icon(Icons.account_balance_wallet),
                    tooltip: 'Wallet',
                    onPressed: () => context.go('/wallet'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.inventory_2),
                    tooltip: 'Inventar',
                    onPressed: () => context.go('/inventory'),
                  ),
                ],
              ),
              trailing: Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.person),
                      tooltip: 'Profil',
                      onPressed: () => context.go('/profile'),
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings),
                      tooltip: 'Einstellungen',
                      onPressed: () => context.go('/settings'),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              destinations: railDestinations,
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(child: child),
          ],
        ),
      );
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => _onTap(context, i),
        destinations: destinations,
      ),
      floatingActionButton: unreadCount > 0
          ? FloatingActionButton.small(
              onPressed: () => context.push('/notifications'),
              child: Badge(
                label: Text('$unreadCount'),
                child: const Icon(Icons.notifications),
              ),
            )
          : null,
    );
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
      case 1:
        context.go('/arena');
      case 2:
        context.go('/tournament');
      case 3:
        context.go('/shop');
      case 4:
        context.go('/social');
    }
  }
}
