import 'package:flutter/material.dart';

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

class _FriendsTab extends StatelessWidget {
  const _FriendsTab();

  static const _friends = [
    _Friend(
      name: 'Spieler_42',
      creatureName: 'Flamara',
      level: 12,
      isOnline: true,
    ),
    _Friend(
      name: 'DragonMaster',
      creatureName: 'Voltix',
      level: 23,
      isOnline: true,
    ),
    _Friend(
      name: 'Pixel_Queen',
      creatureName: 'Aquari',
      level: 8,
      isOnline: false,
    ),
    _Friend(
      name: 'CryptoKnight',
      creatureName: 'Schatti',
      level: 15,
      isOnline: false,
    ),
    _Friend(
      name: 'NaturFreund',
      creatureName: 'Blattling',
      level: 6,
      isOnline: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
              onPressed: () {
                // TODO: Freund hinzufuegen
              },
              icon: const Icon(Icons.person_add),
              label: const Text('Freund hinzufuegen'),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _friends.length,
            itemBuilder: (context, index) {
              final friend = _friends[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Stack(
                    children: [
                      CircleAvatar(
                        backgroundColor:
                            theme.colorScheme.primaryContainer,
                        child: Text(
                          friend.name[0].toUpperCase(),
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
                            color: friend.isOnline
                                ? Colors.green
                                : Colors.grey,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: theme.colorScheme.surface,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  title: Text(
                    friend.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${friend.creatureName} · Level ${friend.level}',
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      // TODO: Aktion ausfuehren
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'battle',
                        child: ListTile(
                          leading: Icon(Icons.shield),
                          title: Text('Herausfordern'),
                          dense: true,
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'trade',
                        child: ListTile(
                          leading: Icon(Icons.swap_horiz),
                          title: Text('Handeln'),
                          dense: true,
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'remove',
                        child: ListTile(
                          leading: Icon(Icons.person_remove),
                          title: Text('Entfernen'),
                          dense: true,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _Friend {
  final String name;
  final String creatureName;
  final int level;
  final bool isOnline;

  const _Friend({
    required this.name,
    required this.creatureName,
    required this.level,
    required this.isOnline,
  });
}

// --- Ranking Tab ---

class _RankingTab extends StatelessWidget {
  const _RankingTab();

  static const _rankings = [
    _RankEntry(rank: 1, name: 'ProGamer99', level: 45, points: 98500),
    _RankEntry(rank: 2, name: 'DragonMaster', level: 23, points: 72300),
    _RankEntry(rank: 3, name: 'MegaFighter', level: 38, points: 65100),
    _RankEntry(rank: 4, name: 'StarPlayer', level: 30, points: 54200),
    _RankEntry(rank: 5, name: 'Spieler_42', level: 12, points: 43800),
    _RankEntry(rank: 6, name: 'CryptoKnight', level: 15, points: 38900),
    _RankEntry(rank: 7, name: 'Pixel_Queen', level: 8, points: 31200),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Player's own rank
        Container(
          width: double.infinity,
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primaryContainer,
                theme.colorScheme.tertiaryContainer,
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Text(
                '#42',
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
                    Text(
                      'Dein Rang',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      '15.200 Punkte',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.trending_up, color: Colors.green),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _rankings.length,
            itemBuilder: (context, index) {
              final entry = _rankings[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: entry.rank <= 3
                        ? [
                            Colors.amber,
                            Colors.grey.shade400,
                            Colors.brown.shade300,
                          ][entry.rank - 1]
                        : theme.colorScheme.surfaceContainerHighest,
                    child: Text(
                      '${entry.rank}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: entry.rank <= 3
                            ? Colors.white
                            : theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  title: Text(
                    entry.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Level ${entry.level}'),
                  trailing: Text(
                    '${entry.points} Pkt.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _RankEntry {
  final int rank;
  final String name;
  final int level;
  final int points;

  const _RankEntry({
    required this.rank,
    required this.name,
    required this.level,
    required this.points,
  });
}

// --- Trade Tab ---

class _TradeTab extends StatelessWidget {
  const _TradeTab();

  static const _tradeOffers = [
    _TradeOffer(
      fromPlayer: 'Spieler_42',
      offeredItem: 'Goldener Apfel',
      offeredIcon: Icons.apple,
      offeredColor: Colors.amber,
      wantedItem: 'Zauberstab',
      wantedIcon: Icons.auto_fix_high,
      wantedColor: Colors.deepPurple,
    ),
    _TradeOffer(
      fromPlayer: 'DragonMaster',
      offeredItem: 'Wundertrank',
      offeredIcon: Icons.auto_awesome,
      offeredColor: Colors.purple,
      wantedItem: 'Steak x5',
      wantedIcon: Icons.lunch_dining,
      wantedColor: Colors.brown,
    ),
    _TradeOffer(
      fromPlayer: 'Pixel_Queen',
      offeredItem: 'Teddybaer',
      offeredIcon: Icons.smart_toy,
      offeredColor: Colors.brown,
      wantedItem: 'Heiltrank x3',
      wantedIcon: Icons.science,
      wantedColor: Colors.green,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
            child: Text(
              'Aktive Handelsangebote',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _tradeOffers.length,
            itemBuilder: (context, index) {
              final offer = _tradeOffers[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        offer.fromPlayer,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _TradeItemDisplay(
                              label: 'Bietet',
                              itemName: offer.offeredItem,
                              icon: offer.offeredIcon,
                              color: offer.offeredColor,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8),
                            child: Icon(
                              Icons.swap_horiz,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          Expanded(
                            child: _TradeItemDisplay(
                              label: 'Sucht',
                              itemName: offer.wantedItem,
                              icon: offer.wantedIcon,
                              color: offer.wantedColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Handelsanfrage an ${offer.fromPlayer} gesendet!',
                                ),
                              ),
                            );
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
        ),
      ],
    );
  }
}

class _TradeOffer {
  final String fromPlayer;
  final String offeredItem;
  final IconData offeredIcon;
  final Color offeredColor;
  final String wantedItem;
  final IconData wantedIcon;
  final Color wantedColor;

  const _TradeOffer({
    required this.fromPlayer,
    required this.offeredItem,
    required this.offeredIcon,
    required this.offeredColor,
    required this.wantedItem,
    required this.wantedIcon,
    required this.wantedColor,
  });
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
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 4),
        Text(
          itemName,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
