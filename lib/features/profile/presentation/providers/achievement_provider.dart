import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/achievement.dart';
import '../../../arena/presentation/providers/reward_provider.dart';

/// Manages achievement state and evaluation.
class AchievementNotifier extends StateNotifier<List<Achievement>> {
  AchievementNotifier() : super(_initAchievements());

  static List<Achievement> _initAchievements() {
    // Simulate some already-unlocked achievements
    return AchievementCatalog.all.map((a) {
      if (a.code == 'first_creature') {
        return a.copyWith(
          isUnlocked: true,
          unlockedAt: DateTime.now().subtract(const Duration(days: 30)),
          progress: 1.0,
          progressLabel: 'Abgeschlossen',
        );
      }
      return a;
    }).toList();
  }

  /// Evaluate all achievements against current stats.
  void evaluate(UserRewardStats stats, int creatureCount, int adultCreatureCount) {
    state = state.map((a) {
      if (a.isUnlocked) return a;
      return _evaluate(a, stats, creatureCount, adultCreatureCount);
    }).toList();
  }

  Achievement _evaluate(
    Achievement a,
    UserRewardStats stats,
    int creatureCount,
    int adultCreatureCount,
  ) {
    switch (a.code) {
      case 'first_creature':
        if (creatureCount >= 1) {
          return a.copyWith(
            isUnlocked: true,
            unlockedAt: DateTime.now(),
            progress: 1.0,
            progressLabel: 'Abgeschlossen',
          );
        }
        return a.copyWith(
          progress: creatureCount / 1,
          progressLabel: '$creatureCount / 1',
        );

      case 'first_win':
        if (stats.battlesWon >= 1) {
          return a.copyWith(
            isUnlocked: true,
            unlockedAt: DateTime.now(),
            progress: 1.0,
            progressLabel: 'Abgeschlossen',
          );
        }
        return a.copyWith(
          progress: stats.battlesWon / 1,
          progressLabel: '${stats.battlesWon} / 1',
        );

      case 'ten_wins':
        if (stats.battlesWon >= 10) {
          return a.copyWith(
            isUnlocked: true,
            unlockedAt: DateTime.now(),
            progress: 1.0,
            progressLabel: 'Abgeschlossen',
          );
        }
        return a.copyWith(
          progress: (stats.battlesWon / 10).clamp(0.0, 1.0),
          progressLabel: '${stats.battlesWon} / 10',
        );

      case 'dragon_unlock':
        if (stats.battlesWon >= 10) {
          return a.copyWith(
            isUnlocked: true,
            unlockedAt: DateTime.now(),
            progress: 1.0,
            progressLabel: 'Abgeschlossen',
          );
        }
        return a.copyWith(
          progress: (stats.battlesWon / 10).clamp(0.0, 1.0),
          progressLabel: '${stats.battlesWon} / 10 Siege',
        );

      case 'level_10':
        if (stats.level >= 10) {
          return a.copyWith(
            isUnlocked: true,
            unlockedAt: DateTime.now(),
            progress: 1.0,
            progressLabel: 'Abgeschlossen',
          );
        }
        return a.copyWith(
          progress: (stats.level / 10).clamp(0.0, 1.0),
          progressLabel: 'Level ${stats.level} / 10',
        );

      case 'adult_creature':
        if (adultCreatureCount >= 1) {
          return a.copyWith(
            isUnlocked: true,
            unlockedAt: DateTime.now(),
            progress: 1.0,
            progressLabel: 'Abgeschlossen',
          );
        }
        return a.copyWith(
          progress: 0.0,
          progressLabel: 'Noch keine erwachsene Kreatur',
        );

      case 'five_creatures':
        return a.copyWith(
          progress: (creatureCount / 5).clamp(0.0, 1.0),
          progressLabel: '$creatureCount / 5',
        );

      case 'wealthy':
        if (stats.satoshiBalance >= 100000) {
          return a.copyWith(
            isUnlocked: true,
            unlockedAt: DateTime.now(),
            progress: 1.0,
            progressLabel: 'Abgeschlossen',
          );
        }
        return a.copyWith(
          progress: (stats.satoshiBalance / 100000).clamp(0.0, 1.0),
          progressLabel: '${stats.satoshiBalance} / 100.000 Sats',
        );

      default:
        return a;
    }
  }
}

final achievementProvider =
    StateNotifierProvider<AchievementNotifier, List<Achievement>>((ref) {
  return AchievementNotifier();
});
