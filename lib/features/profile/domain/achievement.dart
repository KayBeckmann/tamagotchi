import 'package:equatable/equatable.dart';

/// Achievement reward type.
enum AchievementRewardType {
  satoshis,
  creatureSlot,
  creatureUnlock,
  cosmetic,
}

/// A single achievement definition.
class Achievement extends Equatable {
  final String code;
  final String name;
  final String description;
  final String icon;
  final AchievementRewardType rewardType;
  final int rewardValue;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final double progress; // 0.0 to 1.0
  final String progressLabel;

  const Achievement({
    required this.code,
    required this.name,
    required this.description,
    required this.icon,
    required this.rewardType,
    required this.rewardValue,
    this.isUnlocked = false,
    this.unlockedAt,
    this.progress = 0.0,
    this.progressLabel = '',
  });

  Achievement copyWith({
    bool? isUnlocked,
    DateTime? unlockedAt,
    double? progress,
    String? progressLabel,
  }) {
    return Achievement(
      code: code,
      name: name,
      description: description,
      icon: icon,
      rewardType: rewardType,
      rewardValue: rewardValue,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      progress: progress ?? this.progress,
      progressLabel: progressLabel ?? this.progressLabel,
    );
  }

  @override
  List<Object?> get props => [code];
}

/// Catalog of all achievements.
class AchievementCatalog {
  static const List<Achievement> all = [
    Achievement(
      code: 'first_creature',
      name: 'Erste Kreatur',
      description: 'Erstelle deine erste Kreatur.',
      icon: '🥚',
      rewardType: AchievementRewardType.satoshis,
      rewardValue: 1000,
    ),
    Achievement(
      code: 'first_win',
      name: 'Erster Sieg',
      description: 'Gewinne deinen ersten Arena-Kampf.',
      icon: '⚔️',
      rewardType: AchievementRewardType.satoshis,
      rewardValue: 2000,
    ),
    Achievement(
      code: 'ten_wins',
      name: 'Zehn Siege',
      description: 'Gewinne 10 Arena-Kämpfe.',
      icon: '🏆',
      rewardType: AchievementRewardType.satoshis,
      rewardValue: 5000,
    ),
    Achievement(
      code: 'first_tournament',
      name: 'Turniereinsteiger',
      description: 'Nimm an deinem ersten Turnier teil.',
      icon: '🎯',
      rewardType: AchievementRewardType.satoshis,
      rewardValue: 3000,
    ),
    Achievement(
      code: 'tournament_winner',
      name: 'Turniersieger',
      description: 'Gewinne ein Turnier.',
      icon: '🥇',
      rewardType: AchievementRewardType.creatureSlot,
      rewardValue: 1,
    ),
    Achievement(
      code: 'level_10',
      name: 'Erfahrener Spieler',
      description: 'Erreiche Level 10.',
      icon: '⭐',
      rewardType: AchievementRewardType.satoshis,
      rewardValue: 10000,
    ),
    Achievement(
      code: 'adult_creature',
      name: 'Erwachsene Kreatur',
      description: 'Ziehe eine Kreatur bis ins Erwachsenenalter auf (15+ Tage).',
      icon: '🌟',
      rewardType: AchievementRewardType.satoshis,
      rewardValue: 5000,
    ),
    Achievement(
      code: 'five_creatures',
      name: 'Sammlerwahn',
      description: 'Besitze gleichzeitig 5 Kreaturen.',
      icon: '🦁',
      rewardType: AchievementRewardType.creatureSlot,
      rewardValue: 5,
    ),
    Achievement(
      code: 'dragon_unlock',
      name: 'Drachenzähmer',
      description: 'Schalte den Drachen frei (10 Arena-Siege).',
      icon: '🐲',
      rewardType: AchievementRewardType.creatureUnlock,
      rewardValue: 0, // dragon unlocked
    ),
    Achievement(
      code: 'login_streak_7',
      name: 'Treuer Spieler',
      description: 'Logge dich 7 Tage in Folge ein.',
      icon: '📅',
      rewardType: AchievementRewardType.satoshis,
      rewardValue: 7000,
    ),
    Achievement(
      code: 'wealthy',
      name: 'Satoshi-Millionär',
      description: 'Sammle insgesamt 100.000 Satoshis.',
      icon: '💰',
      rewardType: AchievementRewardType.cosmetic,
      rewardValue: 0,
    ),
  ];

  static Achievement? getByCode(String code) {
    try {
      return all.firstWhere((a) => a.code == code);
    } catch (_) {
      return null;
    }
  }
}
