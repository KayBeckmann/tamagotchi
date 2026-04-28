import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/responsive_layout.dart';
import '../providers/reward_provider.dart';

/// Simulated leaderboard entry.
class LeaderboardEntry {
  final int rank;
  final String username;
  final int eloRating;
  final int wins;
  final int losses;
  final bool isCurrentUser;

  const LeaderboardEntry({
    required this.rank,
    required this.username,
    required this.eloRating,
    required this.wins,
    required this.losses,
    this.isCurrentUser = false,
  });

  double get winRate => (wins + losses) > 0 ? wins / (wins + losses) : 0;
}

final _leaderboardProvider = Provider<List<LeaderboardEntry>>((ref) {
  final rewardStats = ref.watch(rewardProvider);
  final rng = Random(42); // fixed seed for stable demo data

  final names = [
    'DragonMaster', 'ShadowWolf', 'LightningBolt', 'IceQueen',
    'FireKing', 'ThunderBird', 'MysticFox', 'NightHunter',
    'CryptoCat', 'StarFighter', 'Spieler${rewardStats.eloRating}',
  ];

  final entries = <LeaderboardEntry>[];

  // Generate 10 simulated opponents
  for (int i = 0; i < 10; i++) {
    final elo = 1500 - i * 60 + rng.nextInt(40);
    final wins = 20 + rng.nextInt(80);
    final losses = 5 + rng.nextInt(40);
    entries.add(LeaderboardEntry(
      rank: i + 1,
      username: names[i],
      eloRating: elo,
      wins: wins,
      losses: losses,
    ));
  }

  // Insert current player at correct rank
  final playerEntry = LeaderboardEntry(
    rank: 0, // will be overwritten
    username: 'Du',
    eloRating: rewardStats.eloRating,
    wins: rewardStats.battlesWon,
    losses: rewardStats.totalBattles - rewardStats.battlesWon,
    isCurrentUser: true,
  );

  entries.add(playerEntry);
  entries.sort((a, b) => b.eloRating.compareTo(a.eloRating));

  return List.generate(
    entries.length,
    (i) => LeaderboardEntry(
      rank: i + 1,
      username: entries[i].username,
      eloRating: entries[i].eloRating,
      wins: entries[i].wins,
      losses: entries[i].losses,
      isCurrentUser: entries[i].isCurrentUser,
    ),
  );
});

class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(_leaderboardProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Rangliste')),
      body: ResponsiveLayout(
        mobile: _buildList(context, theme, entries),
        tablet: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: _buildList(context, theme, entries),
          ),
        ),
        desktop: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: _buildList(context, theme, entries),
          ),
        ),
      ),
    );
  }

  Widget _buildList(
    BuildContext context,
    ThemeData theme,
    List<LeaderboardEntry> entries,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: entries.length,
      itemBuilder: (context, i) {
        final entry = entries[i];
        final isTop3 = entry.rank <= 3;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: entry.isCurrentUser
                ? theme.colorScheme.primaryContainer.withValues(alpha: 0.4)
                : null,
            borderRadius: BorderRadius.circular(12),
            border: entry.isCurrentUser
                ? Border.all(color: theme.colorScheme.primary, width: 2)
                : null,
          ),
          child: ListTile(
            leading: _RankBadge(rank: entry.rank),
            title: Row(
              children: [
                Text(
                  entry.username,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: entry.isCurrentUser
                        ? FontWeight.w900
                        : FontWeight.normal,
                  ),
                ),
                if (entry.isCurrentUser)
                  Container(
                    margin: const EdgeInsets.only(left: 6),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Du',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
              ],
            ),
            subtitle: Text(
              '${entry.wins}S / ${entry.losses}N · ${(entry.winRate * 100).toStringAsFixed(0)}% Siegrate',
              style: theme.textTheme.bodySmall,
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${entry.eloRating}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isTop3 ? Colors.amber.shade700 : null,
                  ),
                ),
                Text(
                  'ELO',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RankBadge extends StatelessWidget {
  final int rank;
  const _RankBadge({required this.rank});

  @override
  Widget build(BuildContext context) {
    if (rank == 1) return const Text('🥇', style: TextStyle(fontSize: 28));
    if (rank == 2) return const Text('🥈', style: TextStyle(fontSize: 28));
    if (rank == 3) return const Text('🥉', style: TextStyle(fontSize: 28));

    return CircleAvatar(
      radius: 18,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Text(
        '$rank',
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
