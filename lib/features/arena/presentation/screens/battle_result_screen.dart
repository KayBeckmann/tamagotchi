import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/responsive_layout.dart';
import '../providers/arena_provider.dart';
import '../../domain/models/battle_state.dart';

class BattleResultScreen extends ConsumerWidget {
  const BattleResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final battle = ref.watch(battleProvider);

    if (battle == null || !battle.isFinished) {
      return Scaffold(
        body: Center(
          child: FilledButton(
            onPressed: () => context.go('/arena'),
            child: const Text('Zur Arena'),
          ),
        ),
      );
    }

    final theme = Theme.of(context);
    final result = battle.result!;
    final isWin = result == BattleResult.playerWon;
    final isDraw = result == BattleResult.draw;

    final resultColor = isWin
        ? Colors.green
        : isDraw
            ? Colors.orange
            : Colors.red;

    final resultText = isWin
        ? 'Sieg!'
        : isDraw
            ? 'Unentschieden'
            : 'Niederlage';

    final resultEmoji = isWin ? '🏆' : isDraw ? '🤝' : '💀';

    return Scaffold(
      body: ResponsiveLayout(
        mobile: _buildResult(context, theme, battle, resultText, resultEmoji,
            resultColor, isWin, ref),
        tablet: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: _buildResult(context, theme, battle, resultText, resultEmoji,
                resultColor, isWin, ref),
          ),
        ),
        desktop: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: _buildResult(context, theme, battle, resultText, resultEmoji,
                resultColor, isWin, ref),
          ),
        ),
      ),
    );
  }

  Widget _buildResult(
    BuildContext context,
    ThemeData theme,
    BattleState battle,
    String resultText,
    String resultEmoji,
    Color resultColor,
    bool isWin,
    WidgetRef ref,
  ) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Big result emoji
          Text(resultEmoji, style: const TextStyle(fontSize: 80))
              .animate()
              .scale(
                begin: const Offset(0, 0),
                duration: 600.ms,
                curve: Curves.elasticOut,
              ),
          const SizedBox(height: 16),
          Text(
            resultText,
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: resultColor,
            ),
          ).animate().fadeIn(delay: 300.ms),
          const SizedBox(height: 8),
          Text(
            '${battle.playerCreature.name} vs. ${battle.opponentCreature.name}',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ).animate().fadeIn(delay: 400.ms),
          const SizedBox(height: 32),

          // Stats card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _ResultRow(
                    icon: Icons.star,
                    label: 'Erfahrungspunkte',
                    value: '+${battle.xpGained} XP',
                    color: Colors.amber,
                  ),
                  const Divider(height: 20),
                  _ResultRow(
                    icon: Icons.currency_bitcoin,
                    label: 'Satoshis verdient',
                    value: '+${battle.satoshisGained} Sats',
                    color: Colors.orange,
                  ),
                  const Divider(height: 20),
                  _ResultRow(
                    icon: Icons.leaderboard,
                    label: 'ELO-Änderung',
                    value: battle.playerEloChange >= 0
                        ? '+${battle.playerEloChange}'
                        : '${battle.playerEloChange}',
                    color: battle.playerEloChange >= 0 ? Colors.green : Colors.red,
                  ),
                  const Divider(height: 20),
                  _ResultRow(
                    icon: Icons.timer,
                    label: 'Runden gespielt',
                    value: '${battle.currentRound}',
                    color: theme.colorScheme.primary,
                  ),
                ],
              ),
            ),
          ).animate().slideY(
                begin: 0.3,
                duration: 500.ms,
                delay: 500.ms,
                curve: Curves.easeOut,
              ),

          const SizedBox(height: 32),

          // Buttons
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {
                ref.read(battleProvider.notifier).clearBattle();
                context.go('/arena');
              },
              icon: const Icon(Icons.refresh),
              label: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text('Nochmal kämpfen', style: TextStyle(fontSize: 16)),
              ),
            ),
          ).animate().fadeIn(delay: 800.ms),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                ref.read(battleProvider.notifier).clearBattle();
                context.go('/');
              },
              icon: const Icon(Icons.home),
              label: const Text('Zur Kreatur'),
            ),
          ).animate().fadeIn(delay: 900.ms),
        ],
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _ResultRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(label, style: theme.textTheme.bodyMedium),
        ),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
