import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/responsive_layout.dart';
import '../../../creature/presentation/providers/creature_provider.dart';
import '../../../creature/domain/models/creature.dart';
import '../providers/arena_provider.dart';
import '../../data/arena_repository.dart';

class ArenaScreen extends ConsumerWidget {
  const ArenaScreen({super.key});

  static const _userId = 'user_1';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final creatureState = ref.watch(creatureListProvider(_userId));
    final historyAsync = ref.watch(battleHistoryProvider(_userId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Arena')),
      body: ResponsiveLayout(
        mobile: _buildBody(
          context, theme, ref, creatureState, historyAsync,
          maxWidth: double.infinity,
        ),
        tablet: Center(
          child: _buildBody(
            context, theme, ref, creatureState, historyAsync,
            maxWidth: 600,
          ),
        ),
        desktop: Center(
          child: _buildBody(
            context, theme, ref, creatureState, historyAsync,
            maxWidth: 700,
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    ThemeData theme,
    WidgetRef ref,
    CreatureListState creatureState,
    AsyncValue<List<BattleHistoryEntry>> historyAsync, {
    required double maxWidth,
  }) {
    final creature = creatureState is CreatureListLoaded
        ? creatureState.activeCreature
        : null;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero card
            _ArenaHeroCard(theme: theme),
            const SizedBox(height: 20),

            // Stats row
            _StatsRow(historyAsync: historyAsync),
            const SizedBox(height: 20),

            // Active creature info
            if (creature != null) ...[
              _ActiveCreatureCard(creature: creature, theme: theme),
              const SizedBox(height: 20),
            ],

            // Action buttons
            _ActionButtons(
              creature: creature,
              onFight: () => _startMatchmaking(context, ref, creature),
            ),
            const SizedBox(height: 24),

            // Battle history
            Text(
              'Letzte Kämpfe',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _BattleHistory(historyAsync: historyAsync),
          ],
        ),
      ),
    );
  }

  void _startMatchmaking(
    BuildContext context,
    WidgetRef ref,
    Creature? creature,
  ) {
    if (creature == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Keine aktive Kreatur ausgewählt.')),
      );
      return;
    }
    if (!creature.canBattle) {
      String reason = '';
      if (creature.isDead) reason = 'Deine Kreatur ist tot.';
      else if (creature.isStunned) reason = 'Deine Kreatur ist betäubt.';
      else if (creature.isSleeping) reason = 'Deine Kreatur schläft.';
      else reason = 'Deine Kreatur muss mindestens Jugendlich sein (8+ Tage).';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(reason)),
      );
      return;
    }
    context.push('/arena/matchmaking', extra: creature);
  }
}

class _ArenaHeroCard extends StatelessWidget {
  final ThemeData theme;
  const _ArenaHeroCard({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primaryContainer,
              theme.colorScheme.tertiaryContainer,
            ],
          ),
        ),
        child: Column(
          children: [
            Icon(Icons.shield, size: 64, color: theme.colorScheme.primary),
            const SizedBox(height: 12),
            Text(
              'Arena-Kämpfe',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Kämpfe gegen andere Spieler und steige in der Rangliste auf!',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsRow extends ConsumerWidget {
  final AsyncValue<List<BattleHistoryEntry>> historyAsync;
  const _StatsRow({required this.historyAsync});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = historyAsync.valueOrNull ?? [];
    final wins = entries.where((e) => e.playerWon).length;
    final losses = entries.where((e) => !e.playerWon).length;

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Siege',
            value: '$wins',
            icon: Icons.emoji_events,
            color: Colors.amber,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            label: 'Niederlagen',
            value: '$losses',
            icon: Icons.close,
            color: Colors.red,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            label: 'Kämpfe',
            value: '${entries.length}',
            icon: Icons.sports_kabaddi,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActiveCreatureCard extends StatelessWidget {
  final Creature creature;
  final ThemeData theme;

  const _ActiveCreatureCard({required this.creature, required this.theme});

  @override
  Widget build(BuildContext context) {
    const emojis = {
      'cat': '🐱', 'dog': '🐶', 'dragon': '🐲', 'rabbit': '🐰',
      'fox': '🦊', 'bird': '🐦', 'slime': '🟢', 'goblin': '👺',
      'ghost': '👻', 'elemental': '⚡', 'golem': '🪨', 'shadow_cat': '🐈‍⬛',
    };
    final emoji = emojis[creature.type.id] ?? '🐾';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Text(emoji, style: const TextStyle(fontSize: 28)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    creature.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${creature.type.name} · ${creature.stage.displayName}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _StatChip(
                        label: 'ATK',
                        value: creature.totalAttack,
                        color: Colors.red,
                      ),
                      const SizedBox(width: 6),
                      _StatChip(
                        label: 'DEF',
                        value: creature.totalDefense,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 6),
                      _StatChip(
                        label: 'SPD',
                        value: creature.totalSpeed,
                        color: Colors.green,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (!creature.canBattle)
              Icon(Icons.lock, color: theme.colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _StatChip({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '$label $value',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final Creature? creature;
  final VoidCallback onFight;

  const _ActionButtons({required this.creature, required this.onFight});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: onFight,
            icon: const Icon(Icons.search),
            label: const Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: Text('Kampf suchen', style: TextStyle(fontSize: 16)),
            ),
          ),
        ),
      ],
    );
  }
}

class _BattleHistory extends StatelessWidget {
  final AsyncValue<List<BattleHistoryEntry>> historyAsync;

  const _BattleHistory({required this.historyAsync});

  @override
  Widget build(BuildContext context) {
    return historyAsync.when(
      data: (entries) {
        if (entries.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Text('Noch keine Kämpfe bestritten.'),
            ),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: entries.length.clamp(0, 10),
          itemBuilder: (context, i) {
            final entry = entries[i];
            return ListTile(
              dense: true,
              leading: CircleAvatar(
                backgroundColor: entry.playerWon
                    ? Colors.green.withValues(alpha: 0.15)
                    : Colors.red.withValues(alpha: 0.15),
                child: Icon(
                  entry.playerWon ? Icons.check : Icons.close,
                  color: entry.playerWon ? Colors.green : Colors.red,
                  size: 18,
                ),
              ),
              title: Text('vs. ${entry.opponentName} (${entry.opponentCreatureName})'),
              subtitle: Text(
                '${entry.totalRounds} Runden · +${entry.xpGained} XP · +${entry.satoshisGained} Sats',
              ),
              trailing: Text(
                entry.playerWon ? 'Sieg' : 'Niederlage',
                style: TextStyle(
                  color: entry.playerWon ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Text('Fehler: $e'),
    );
  }
}
