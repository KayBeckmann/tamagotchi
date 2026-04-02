import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 900;
    final index = _currentIndex(context);

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

    if (isWide) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: index,
              onDestinationSelected: (i) => _onTap(context, i),
              labelType: NavigationRailLabelType.all,
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: const Icon(Icons.account_balance_wallet),
                  tooltip: 'Wallet',
                  onPressed: () => context.go('/wallet'),
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
