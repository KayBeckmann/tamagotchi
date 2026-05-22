import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/social_repository.dart';
import '../domain/models/social.dart';

class SocialScreen extends StatelessWidget {
  const SocialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Soziales'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.people), text: 'Freunde'),
              Tab(icon: Icon(Icons.leaderboard), text: 'Rangliste'),
              Tab(icon: Icon(Icons.swap_horiz), text: 'Handel'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _FriendsTab(),
            _RankingTab(),
            _TradeTab(),
          ],
        ),
      ),
    );
  }
}

// --- Friends Tab ---

class _FriendsTab extends ConsumerWidget {
  const _FriendsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final friendsState = ref.watch(friendsProvider('user_1'));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Freund suchen...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              isDense: true,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _showAddFriendDialog(context, ref),
              icon: const Icon(Icons.person_add),
              label: const Text('Freund hinzufügen'),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: friendsState.when(
            data: (friends) => ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: friends.length,
              itemBuilder: (context, index) {
                final friend = friends[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: Stack(
                      children: [
                        CircleAvatar(
                          backgroundColor: theme.colorScheme.primaryContainer,
                          child: Text(
                            friend.username[0].toUpperCase(),
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: friend.isOnline ? Colors.green : Colors.grey,
                              shape: BoxShape.circle,
                              border: Border.all(color: theme.colorScheme.surface, width: 2),
                            ),
                          ),
                        ),
                      ],
                    ),
                    title: Text(friend.username, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${friend.creatureName} · Level ${friend.creatureLevel}'),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                );
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Fehler: $err')),
          ),
        ),
      ],
    );
  }

  void _showAddFriendDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Freund hinzufügen'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Benutzername'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Abbrechen')),
          FilledButton(
            onPressed: () async {
              await ref.read(socialRepositoryProvider).addFriend('user_1', controller.text);
              ref.invalidate(friendsProvider('user_1'));
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Hinzufügen'),
          ),
        ],
      ),
    );
  }
}

// --- Ranking Tab ---

class _RankingTab extends ConsumerWidget {
  const _RankingTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final rankingsState = ref.watch(rankingsProvider);
    final playerRankState = ref.watch(playerRankProvider('user_1'));

    return Column(
      children: [
        playerRankState.when(
          data: (entry) => Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [theme.colorScheme.primaryContainer, theme.colorScheme.tertiaryContainer],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Text(
                  '#${entry.rank}',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Dein Rang', style: theme.textTheme.labelMedium),
                      Text('${entry.points} Punkte', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const Icon(Icons.trending_up, color: Colors.green),
              ],
            ),
          ),
          loading: () => const LinearProgressIndicator(),
          error: (_, __) => const SizedBox.shrink(),
        ),
        Expanded(
          child: rankingsState.when(
            data: (rankings) => ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: rankings.length,
              itemBuilder: (context, index) {
                final entry = rankings[index];
                final isMe = entry.name == 'Kay';
                return Card(
                  margin: const EdgeInsets.only(bottom: 4),
                  color: isMe ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3) : null,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: entry.rank <= 3
                          ? [Colors.amber, Colors.grey.shade400, Colors.brown.shade300][entry.rank - 1]
                          : theme.colorScheme.surfaceContainerHighest,
                      child: Text(
                        '${entry.rank}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: entry.rank <= 3 ? Colors.white : theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    title: Text(entry.name, style: TextStyle(fontWeight: isMe ? FontWeight.bold : FontWeight.normal)),
                    subtitle: Text('Level ${entry.level}'),
                    trailing: Text('${entry.points} Pkt.', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
                  ),
                );
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Fehler: $err')),
          ),
        ),
      ],
    );
  }
}

// --- Trade Tab ---

class _TradeTab extends ConsumerWidget {
  const _TradeTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final tradeOffersState = ref.watch(tradeOffersProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {
                // TODO: Neues Handelsangebot erstellen
              },
              icon: const Icon(Icons.add),
              label: const Text('Neues Handelsangebot'),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('Aktive Handelsangebote', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: tradeOffersState.when(
            data: (offers) => ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: offers.length,
              itemBuilder: (context, index) {
                final offer = offers[index];
                if (offer.status != TradeStatus.open) return const SizedBox.shrink();

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Von ${offer.fromUsername}', style: theme.textTheme.labelMedium),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _TradeItemDisplay(
                                label: 'Bietet',
                                itemName: '${offer.offeredItemName} x${offer.offeredQuantity}',
                                icon: Icons.inventory_2,
                                color: Colors.blue,
                              ),
                            ),
                            const Icon(Icons.swap_horiz, color: Colors.grey),
                            Expanded(
                              child: _TradeItemDisplay(
                                label: 'Sucht',
                                itemName: '${offer.wantedItemName} x${offer.wantedQuantity}',
                                icon: Icons.shopping_basket,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () async {
                              await ref.read(socialRepositoryProvider).acceptTrade('user_1', offer.id);
                              ref.invalidate(tradeOffersProvider);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Handel abgeschlossen!')),
                                );
                              }
                            },
                            child: const Text('Handel annehmen'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Fehler: $err')),
          ),
        ),
      ],
    );
  }
}

class _TradeItemDisplay extends StatelessWidget {
  final String label;
  final String itemName;
  final IconData icon;
  final Color color;

  const _TradeItemDisplay({
    required this.label,
    required this.itemName,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(label, style: theme.textTheme.labelSmall),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 4),
        Text(itemName, style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
      ],
    );
  }
}
