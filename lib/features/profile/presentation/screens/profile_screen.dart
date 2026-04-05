import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../creature/presentation/providers/creature_provider.dart';
import '../../../creature/domain/models/creature.dart';
import '../providers/profile_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    if (authState is! AuthAuthenticated) {
      return const Center(child: CircularProgressIndicator());
    }

    final userId = authState.userId;
    final profileState = ref.watch(profileProvider(userId));
    final statistics = ref.watch(userStatisticsProvider(userId.toString()));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
            tooltip: 'Einstellungen',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(profileProvider(userId).notifier).refresh(),
        child: switch (profileState) {
          ProfileLoading() => const Center(child: CircularProgressIndicator()),
          ProfileError(:final message) => _buildError(context, message, ref, userId),
          ProfileLoaded(:final profile) => _buildProfile(context, ref, profile, statistics, userId.toString()),
        },
      ),
    );
  }

  Widget _buildError(BuildContext context, String message, WidgetRef ref, int userId) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(message, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => ref.read(profileProvider(userId).notifier).refresh(),
            icon: const Icon(Icons.refresh),
            label: const Text('Erneut versuchen'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfile(
    BuildContext context,
    WidgetRef ref,
    UserProfile profile,
    UserStatistics statistics,
    String userId,
  ) {
    final dateFormat = DateFormat('dd.MM.yyyy');

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Profile Header
        _buildProfileHeader(context, profile),
        const SizedBox(height: 24),

        // Level Progress
        _buildLevelCard(context, profile),
        const SizedBox(height: 16),

        // Battle Stats
        _buildStatsCard(
          context,
          'Kampfstatistik',
          Icons.sports_mma,
          [
            _StatRow('Kämpfe gesamt', profile.totalBattles.toString()),
            _StatRow('Siege', profile.battlesWon.toString()),
            _StatRow('Siegrate', '${(profile.winRate * 100).toStringAsFixed(1)}%'),
            _StatRow('Turniersiege', profile.tournamentsWon.toString()),
          ],
        ),
        const SizedBox(height: 16),

        // Creature Stats
        _buildStatsCard(
          context,
          'Kreaturen',
          Icons.pets,
          [
            _StatRow('Gesamt erstellt', statistics.totalCreatures.toString()),
            _StatRow('Am Leben', statistics.aliveCreatures.toString()),
            _StatRow('Verstorben', statistics.deadCreatures.toString()),
            _StatRow('Älteste Kreatur', '${statistics.longestCreatureAge} Tage'),
          ],
        ),
        const SizedBox(height: 16),

        // Wallet
        _buildWalletCard(context, profile),
        const SizedBox(height: 16),

        // Member Info
        _buildInfoCard(
          context,
          'Mitgliedschaft',
          Icons.person,
          [
            _StatRow('Mitglied seit', dateFormat.format(profile.memberSince)),
            _StatRow('Benutzer-ID', '#${profile.id}'),
          ],
        ),
        const SizedBox(height: 16),

        // Creatures Overview
        _buildCreaturesSection(context, ref, userId),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildProfileHeader(BuildContext context, UserProfile profile) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Text(
                profile.username.substring(0, 1).toUpperCase(),
                style: theme.textTheme.headlineLarge?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.username,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    profile.email,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Level ${profile.level}',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelCard(BuildContext context, UserProfile profile) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Erfahrung',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${profile.experiencePoints} / ${profile.experienceToNextLevel} XP',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: profile.levelProgress.clamp(0.0, 1.0),
                minHeight: 12,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Noch ${profile.experienceToNextLevel - profile.experiencePoints} XP bis Level ${profile.level + 1}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard(
    BuildContext context,
    String title,
    IconData icon,
    List<_StatRow> stats,
  ) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...stats.map((stat) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(stat.label, style: theme.textTheme.bodyMedium),
                  Text(
                    stat.value,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    String title,
    IconData icon,
    List<_StatRow> info,
  ) {
    return _buildStatsCard(context, title, icon, info);
  }

  Widget _buildWalletCard(BuildContext context, UserProfile profile) {
    final theme = Theme.of(context);
    final numberFormat = NumberFormat('#,###', 'de_DE');

    return Card(
      color: theme.colorScheme.primaryContainer,
      child: InkWell(
        onTap: () => context.push('/wallet'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.currency_bitcoin,
                  color: theme.colorScheme.onPrimary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Wallet-Guthaben',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    Text(
                      '${numberFormat.format(profile.satoshiBalance)} Sats',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCreaturesSection(BuildContext context, WidgetRef ref, String userId) {
    final theme = Theme.of(context);
    final creatureState = ref.watch(creatureListProvider(userId));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.pets, color: theme.colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      'Meine Kreaturen',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () => context.push('/creature-selection'),
                  child: const Text('Alle anzeigen'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (creatureState is CreatureListLoaded)
              _buildCreatureList(context, creatureState.creatures)
            else if (creatureState is CreatureListLoading)
              const Center(child: CircularProgressIndicator())
            else
              const Text('Keine Kreaturen vorhanden'),
          ],
        ),
      ),
    );
  }

  Widget _buildCreatureList(BuildContext context, List<Creature> creatures) {
    if (creatures.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Text('Noch keine Kreaturen erstellt'),
        ),
      );
    }

    final theme = Theme.of(context);
    final alive = creatures.where((c) => !c.isDead).take(3).toList();

    return Column(
      children: alive.map((creature) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: creature.isActive
                ? theme.colorScheme.primaryContainer
                : theme.colorScheme.surfaceContainerHighest,
            child: Icon(
              Icons.pets,
              color: creature.isActive
                  ? theme.colorScheme.onPrimaryContainer
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ),
          title: Text(
            creature.name,
            style: TextStyle(
              fontWeight: creature.isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          subtitle: Text(
            '${creature.type.name} • ${creature.stage.displayName}',
          ),
          trailing: creature.isActive
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Aktiv',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                )
              : null,
        ),
      )).toList(),
    );
  }
}

class _StatRow {
  final String label;
  final String value;
  const _StatRow(this.label, this.value);
}
