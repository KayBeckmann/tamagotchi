import 'package:equatable/equatable.dart';

/// Definition of one daily reward in the streak calendar.
class DailyRewardDefinition extends Equatable {
  final int day;
  final int satoshis;
  final String? bonusItemName;
  final String? bonusItemIcon;

  const DailyRewardDefinition({
    required this.day,
    required this.satoshis,
    this.bonusItemName,
    this.bonusItemIcon,
  });

  @override
  List<Object?> get props => [day];
}

/// The 7-day reward schedule.
class DailyRewardCalendar {
  static const rewards = [
    DailyRewardDefinition(day: 1, satoshis: 500),
    DailyRewardDefinition(day: 2, satoshis: 1000),
    DailyRewardDefinition(day: 3, satoshis: 1500),
    DailyRewardDefinition(day: 4, satoshis: 2000),
    DailyRewardDefinition(day: 5, satoshis: 3000),
    DailyRewardDefinition(day: 6, satoshis: 4000),
    DailyRewardDefinition(
      day: 7,
      satoshis: 5000,
      bonusItemName: 'Wundertrank',
      bonusItemIcon: '✨',
    ),
  ];

  static DailyRewardDefinition forDay(int streakDay) {
    final index = ((streakDay - 1) % rewards.length).clamp(0, rewards.length - 1);
    return rewards[index];
  }
}

/// Runtime state of the daily reward system.
class DailyRewardState extends Equatable {
  final int streakDay;
  final bool canClaim;
  final bool justClaimed;
  final DateTime? lastClaimed;
  final int pendingSatoshis;

  const DailyRewardState({
    this.streakDay = 1,
    this.canClaim = false,
    this.justClaimed = false,
    this.lastClaimed,
    this.pendingSatoshis = 0,
  });

  DailyRewardDefinition get todaysReward => DailyRewardCalendar.forDay(streakDay);

  bool get streakBroken {
    if (lastClaimed == null) return false;
    final daysSinceClaim = DateTime.now().difference(lastClaimed!).inDays;
    return daysSinceClaim > 1;
  }

  DailyRewardState copyWith({
    int? streakDay,
    bool? canClaim,
    bool? justClaimed,
    DateTime? lastClaimed,
    int? pendingSatoshis,
  }) {
    return DailyRewardState(
      streakDay: streakDay ?? this.streakDay,
      canClaim: canClaim ?? this.canClaim,
      justClaimed: justClaimed ?? this.justClaimed,
      lastClaimed: lastClaimed ?? this.lastClaimed,
      pendingSatoshis: pendingSatoshis ?? this.pendingSatoshis,
    );
  }

  @override
  List<Object?> get props => [streakDay, canClaim, justClaimed, lastClaimed];
}
