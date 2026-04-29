import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/daily_reward.dart';
import '../../../../features/arena/presentation/providers/reward_provider.dart';

class DailyRewardNotifier extends StateNotifier<DailyRewardState> {
  final Ref _ref;

  DailyRewardNotifier(this._ref) : super(const DailyRewardState()) {
    _checkAvailability();
  }

  void _checkAvailability() {
    final last = state.lastClaimed;
    if (last == null) {
      // First ever login
      state = state.copyWith(canClaim: true);
      return;
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastDay = DateTime(last.year, last.month, last.day);
    final daysDiff = today.difference(lastDay).inDays;

    if (daysDiff == 0) {
      // Already claimed today
      state = state.copyWith(canClaim: false);
    } else if (daysDiff == 1) {
      // Consecutive day
      state = state.copyWith(canClaim: true);
    } else {
      // Streak broken — reset
      state = state.copyWith(canClaim: true, streakDay: 1);
    }
  }

  /// Claim today's reward. Returns the satoshis awarded.
  int claim() {
    if (!state.canClaim) return 0;

    final reward = state.todaysReward;
    final nextStreak = (state.streakDay % DailyRewardCalendar.rewards.length) + 1;

    // Apply satoshis to the global reward state
    _ref.read(rewardProvider.notifier).addSatoshis(reward.satoshis);

    state = state.copyWith(
      canClaim: false,
      justClaimed: true,
      lastClaimed: DateTime.now(),
      streakDay: nextStreak,
      pendingSatoshis: reward.satoshis,
    );

    return reward.satoshis;
  }

  void acknowledgeReward() {
    state = state.copyWith(justClaimed: false, pendingSatoshis: 0);
  }
}

final dailyRewardProvider =
    StateNotifierProvider<DailyRewardNotifier, DailyRewardState>((ref) {
  return DailyRewardNotifier(ref);
});
