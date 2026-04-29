import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/daily_reward.dart';
import '../providers/daily_reward_provider.dart';

/// Show the daily reward dialog if a reward is claimable.
void showDailyRewardDialogIfNeeded(BuildContext context, WidgetRef ref) {
  final state = ref.read(dailyRewardProvider);
  if (!state.canClaim) return;

  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!context.mounted) return;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const _DailyRewardDialog(),
    );
  });
}

class _DailyRewardDialog extends ConsumerWidget {
  const _DailyRewardDialog();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dailyRewardProvider);
    final theme = Theme.of(context);
    final numberFormat = NumberFormat('#,###', 'de_DE');

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Text(
              'Tägliche Belohnung',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Tag ${state.streakDay} in Folge!',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 20),

            // 7-day streak calendar
            _StreakCalendar(currentDay: state.streakDay),
            const SizedBox(height: 24),

            // Today's reward highlight
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    'Heutige Belohnung',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.currency_bitcoin, color: Colors.amber, size: 32),
                      const SizedBox(width: 8),
                      Text(
                        '${numberFormat.format(state.todaysReward.satoshis)} Sats',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                  if (state.todaysReward.bonusItemName != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          state.todaysReward.bonusItemIcon ?? '🎁',
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '+ ${state.todaysReward.bonusItemName}',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Claim button
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: state.canClaim
                    ? () {
                        ref.read(dailyRewardProvider.notifier).claim();
                        Navigator.of(context).pop();
                      }
                    : null,
                icon: const Icon(Icons.redeem),
                label: const Text('Belohnung abholen'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StreakCalendar extends StatelessWidget {
  final int currentDay;

  const _StreakCalendar({required this.currentDay});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final numberFormat = NumberFormat('#,###', 'de_DE');

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: DailyRewardCalendar.rewards.map((reward) {
        final isDone = reward.day < currentDay;
        final isToday = reward.day == currentDay;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isDone
                        ? theme.colorScheme.primary
                        : isToday
                            ? theme.colorScheme.primaryContainer
                            : theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                    border: isToday
                        ? Border.all(
                            color: theme.colorScheme.primary,
                            width: 2,
                          )
                        : null,
                  ),
                  child: Center(
                    child: isDone
                        ? Icon(Icons.check,
                            size: 18,
                            color: theme.colorScheme.onPrimary)
                        : reward.bonusItemIcon != null
                            ? Text(reward.bonusItemIcon!,
                                style: const TextStyle(fontSize: 16))
                            : const Icon(Icons.currency_bitcoin,
                                size: 16, color: Colors.amber),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'T${reward.day}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight:
                        isToday ? FontWeight.bold : FontWeight.normal,
                    color: isToday
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  numberFormat.format(reward.satoshis),
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontSize: 9,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
