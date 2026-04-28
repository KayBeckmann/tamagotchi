import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/reward.dart';
import '../../domain/models/battle_state.dart';

/// Global reward state notifier – tracks XP, level, satoshis, ELO.
class RewardNotifier extends StateNotifier<UserRewardStats> {
  RewardNotifier()
      : super(const UserRewardStats(
          totalXp: 350,        // Start with some XP (level 5)
          level: 5,
          satoshiBalance: 12500,
          eloRating: 1000,
          totalBattles: 17,
          battlesWon: 12,
        )) {
    _recalcLevel();
  }

  /// Apply rewards from a finished battle.
  BattleReward applyBattleResult(BattleState battle) {
    if (!battle.isFinished || battle.result == null) {
      return const BattleReward(
        xp: 0, satoshis: 0, eloChange: 0, leveledUp: false, newLevel: 1,
      );
    }

    final oldLevel = state.level;
    final isWin = battle.result == BattleResult.playerWon;

    final newTotalXp = state.totalXp + battle.xpGained;
    final newLevel = XpSystem.levelFromTotalXp(newTotalXp);
    final newProgress = XpSystem.progressInLevel(newTotalXp, newLevel);
    final newXpToNext = XpSystem.xpForLevel(newLevel) -
        (newTotalXp - XpSystem.totalXpForLevel(newLevel));

    final newSatoshis = state.satoshiBalance + battle.satoshisGained;
    final newElo = state.eloRating + battle.playerEloChange;
    final newBattles = state.totalBattles + 1;
    final newWins = state.battlesWon + (isWin ? 1 : 0);

    state = state.copyWith(
      totalXp: newTotalXp,
      level: newLevel,
      levelProgress: newProgress,
      xpToNextLevel: newXpToNext.clamp(0, 999999),
      satoshiBalance: newSatoshis,
      eloRating: newElo.clamp(100, 9999),
      totalBattles: newBattles,
      battlesWon: newWins,
    );

    return BattleReward(
      xp: battle.xpGained,
      satoshis: battle.satoshisGained,
      eloChange: battle.playerEloChange,
      leveledUp: newLevel > oldLevel,
      newLevel: newLevel,
    );
  }

  void _recalcLevel() {
    final level = XpSystem.levelFromTotalXp(state.totalXp);
    final progress = XpSystem.progressInLevel(state.totalXp, level);
    final toNext = XpSystem.xpForLevel(level) -
        (state.totalXp - XpSystem.totalXpForLevel(level));
    state = state.copyWith(
      level: level,
      levelProgress: progress,
      xpToNextLevel: toNext.clamp(0, 999999),
    );
  }
}

final rewardProvider =
    StateNotifierProvider<RewardNotifier, UserRewardStats>((ref) {
  return RewardNotifier();
});
