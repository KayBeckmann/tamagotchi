abstract class AppConstants {
  static const String appName = 'Tamagotchi';
  static const String appVersion = '0.1.0';

  // API
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080',
  );

  // Creature Stats
  static const int maxStatValue = 100;
  static const int minStatValue = 0;
  static const int maxCreatureSlots = 5;
  static const int maxCreatureSlotsExpanded = 10;

  // Timing (in minutes)
  static const int statDecayIntervalMinutes = 30;
  static const int feedCooldownMinutes = 30;
  static const int tournamentStunRecoveryMinutes = 360; // 6 hours

  // Arena
  static const int maxBattleRounds = 20;
  static const int victoryXp = 50;
  static const int defeatXp = 10;

  // Tournament
  static const double tournamentFeePercent = 0.05; // 5%

  // Creature Evolution (days)
  static const int eggDuration = 0;
  static const int babyDuration = 3;
  static const int childDuration = 7;
  static const int teenDuration = 14;
}
