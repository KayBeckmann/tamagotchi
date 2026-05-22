import 'package:flutter/material.dart';

enum AchievementCategory {
  care,
  battle,
  wallet,
  social,
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final AchievementCategory category;
  final int rewardSatoshis;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final double progress; // 0.0 to 1.0

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.category,
    required this.rewardSatoshis,
    this.isUnlocked = false,
    this.unlockedAt,
    this.progress = 0.0,
  });

  Achievement copyWith({
    bool? isUnlocked,
    DateTime? unlockedAt,
    double? progress,
  }) {
    return Achievement(
      id: id,
      title: title,
      description: description,
      icon: icon,
      category: category,
      rewardSatoshis: rewardSatoshis,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      progress: progress ?? this.progress,
    );
  }
}

class AchievementCatalog {
  static final List<Achievement> all = [
    // Care Achievements
    Achievement(
      id: 'care_first_meal',
      title: 'Erstes Mahl',
      description: 'Füttere deine Kreatur zum ersten Mal.',
      icon: Icons.restaurant,
      category: AchievementCategory.care,
      rewardSatoshis: 50,
    ),
    Achievement(
      id: 'care_clean_freak',
      title: 'Sauberkeitsfanatiker',
      description: 'Wasche deine Kreatur 10 Mal.',
      icon: Icons.shower,
      category: AchievementCategory.care,
      rewardSatoshis: 100,
    ),
    Achievement(
      id: 'care_pro_trainer',
      title: 'Profi-Trainer',
      description: 'Trainiere eine Kreatur 25 Mal.',
      icon: Icons.fitness_center,
      category: AchievementCategory.care,
      rewardSatoshis: 250,
    ),
    
    // Wallet Achievements
    Achievement(
      id: 'wallet_saver',
      title: 'Sparfuchs',
      description: 'Besitze mehr als 50.000 Satoshis.',
      icon: Icons.account_balance_wallet,
      category: AchievementCategory.wallet,
      rewardSatoshis: 500,
    ),
    Achievement(
      id: 'wallet_big_spender',
      title: 'Gönner',
      description: 'Gib mehr als 10.000 Satoshis im Shop aus.',
      icon: Icons.shopping_bag,
      category: AchievementCategory.wallet,
      rewardSatoshis: 200,
    ),
    
    // Battle Achievements (Planned)
    Achievement(
      id: 'battle_first_win',
      title: 'Erster Sieg',
      description: 'Gewinne deinen ersten Arena-Kampf.',
      icon: Icons.shield,
      category: AchievementCategory.battle,
      rewardSatoshis: 100,
    ),
  ];

  static Achievement? getById(String id) {
    try {
      return all.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }
}
