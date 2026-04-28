import 'package:equatable/equatable.dart';

/// Experience points needed to reach each level.
class XpSystem {
  /// XP required to advance FROM this level (i.e., to reach level+1).
  static int xpForLevel(int level) {
    // Progressive curve: 100, 250, 450, 700, 1000, ...
    return (100 * level + 50 * (level - 1) * level ~/ 2).clamp(100, 999999);
  }

  /// Total XP accumulated to reach a given level.
  static int totalXpForLevel(int level) {
    int total = 0;
    for (int l = 1; l < level; l++) {
      total += xpForLevel(l);
    }
    return total;
  }

  /// Compute level from total accumulated XP.
  static int levelFromTotalXp(int totalXp) {
    int level = 1;
    while (totalXp >= totalXpForLevel(level + 1)) {
      level++;
      if (level >= 100) break;
    }
    return level;
  }

  /// Progress within current level (0.0 – 1.0).
  static double progressInLevel(int totalXp, int level) {
    final base = totalXpForLevel(level);
    final next = totalXpForLevel(level + 1);
    if (next <= base) return 1.0;
    return ((totalXp - base) / (next - base)).clamp(0.0, 1.0);
  }
}

/// A reward gained from a battle or activity.
class BattleReward extends Equatable {
  final int xp;
  final int satoshis;
  final int eloChange;
  final bool leveledUp;
  final int newLevel;

  const BattleReward({
    required this.xp,
    required this.satoshis,
    required this.eloChange,
    required this.leveledUp,
    required this.newLevel,
  });

  @override
  List<Object?> get props => [xp, satoshis, eloChange, newLevel];
}

/// User's accumulated reward stats.
class UserRewardStats extends Equatable {
  final int totalXp;
  final int level;
  final double levelProgress;
  final int xpToNextLevel;
  final int satoshiBalance;
  final int eloRating;
  final int totalBattles;
  final int battlesWon;

  const UserRewardStats({
    this.totalXp = 0,
    this.level = 1,
    this.levelProgress = 0.0,
    this.xpToNextLevel = 100,
    this.satoshiBalance = 0,
    this.eloRating = 1000,
    this.totalBattles = 0,
    this.battlesWon = 0,
  });

  double get winRate => totalBattles > 0 ? battlesWon / totalBattles : 0.0;

  UserRewardStats copyWith({
    int? totalXp,
    int? level,
    double? levelProgress,
    int? xpToNextLevel,
    int? satoshiBalance,
    int? eloRating,
    int? totalBattles,
    int? battlesWon,
  }) {
    return UserRewardStats(
      totalXp: totalXp ?? this.totalXp,
      level: level ?? this.level,
      levelProgress: levelProgress ?? this.levelProgress,
      xpToNextLevel: xpToNextLevel ?? this.xpToNextLevel,
      satoshiBalance: satoshiBalance ?? this.satoshiBalance,
      eloRating: eloRating ?? this.eloRating,
      totalBattles: totalBattles ?? this.totalBattles,
      battlesWon: battlesWon ?? this.battlesWon,
    );
  }

  @override
  List<Object?> get props => [totalXp, level, satoshiBalance, eloRating, totalBattles];
}
