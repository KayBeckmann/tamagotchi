import 'package:flutter/material.dart';

/// Represents different periods of the day.
enum DayPeriod {
  dawn,    // 5:00 - 7:59
  morning, // 8:00 - 11:59
  noon,    // 12:00 - 13:59
  afternoon, // 14:00 - 17:59
  evening, // 18:00 - 20:59
  night,   // 21:00 - 4:59
}

/// Helper class for time-of-day related functionality.
class TimeOfDayHelper {
  /// Get the current day period based on the hour.
  static DayPeriod getCurrentPeriod() {
    final hour = DateTime.now().hour;
    return getPeriodForHour(hour);
  }

  /// Get the day period for a specific hour.
  static DayPeriod getPeriodForHour(int hour) {
    if (hour >= 5 && hour < 8) return DayPeriod.dawn;
    if (hour >= 8 && hour < 12) return DayPeriod.morning;
    if (hour >= 12 && hour < 14) return DayPeriod.noon;
    if (hour >= 14 && hour < 18) return DayPeriod.afternoon;
    if (hour >= 18 && hour < 21) return DayPeriod.evening;
    return DayPeriod.night;
  }

  /// Get gradient colors for the current time of day.
  static List<Color> getBackgroundGradient([DayPeriod? period]) {
    final currentPeriod = period ?? getCurrentPeriod();

    switch (currentPeriod) {
      case DayPeriod.dawn:
        return [
          const Color(0xFFFF9966), // Orange
          const Color(0xFFFF5E62), // Pink-red
          const Color(0xFF614385), // Purple
        ];
      case DayPeriod.morning:
        return [
          const Color(0xFF87CEEB), // Sky blue
          const Color(0xFF98D8C8), // Mint
          const Color(0xFFF7DC6F), // Soft yellow
        ];
      case DayPeriod.noon:
        return [
          const Color(0xFF56CCF2), // Light blue
          const Color(0xFF2F80ED), // Blue
          const Color(0xFF87CEEB), // Sky blue
        ];
      case DayPeriod.afternoon:
        return [
          const Color(0xFF89CFF0), // Baby blue
          const Color(0xFFB4E7CE), // Light green
          const Color(0xFFF5DEB3), // Wheat
        ];
      case DayPeriod.evening:
        return [
          const Color(0xFFFF7E5F), // Coral
          const Color(0xFFFF6B6B), // Light red
          const Color(0xFF4B134F), // Dark purple
        ];
      case DayPeriod.night:
        return [
          const Color(0xFF0F2027), // Dark blue-black
          const Color(0xFF203A43), // Dark teal
          const Color(0xFF2C5364), // Dark cyan
        ];
    }
  }

  /// Get an icon for the current time of day.
  static IconData getTimeIcon([DayPeriod? period]) {
    final currentPeriod = period ?? getCurrentPeriod();

    switch (currentPeriod) {
      case DayPeriod.dawn:
        return Icons.wb_twilight;
      case DayPeriod.morning:
        return Icons.wb_sunny;
      case DayPeriod.noon:
        return Icons.light_mode;
      case DayPeriod.afternoon:
        return Icons.wb_sunny_outlined;
      case DayPeriod.evening:
        return Icons.wb_twilight;
      case DayPeriod.night:
        return Icons.nightlight_round;
    }
  }

  /// Get a greeting message for the current time of day.
  static String getGreeting([DayPeriod? period]) {
    final currentPeriod = period ?? getCurrentPeriod();

    switch (currentPeriod) {
      case DayPeriod.dawn:
        return 'Guten Morgen';
      case DayPeriod.morning:
        return 'Guten Morgen';
      case DayPeriod.noon:
        return 'Guten Tag';
      case DayPeriod.afternoon:
        return 'Guten Tag';
      case DayPeriod.evening:
        return 'Guten Abend';
      case DayPeriod.night:
        return 'Gute Nacht';
    }
  }

  /// Check if it's currently dark (night or late evening).
  static bool isDark([DayPeriod? period]) {
    final currentPeriod = period ?? getCurrentPeriod();
    return currentPeriod == DayPeriod.night || currentPeriod == DayPeriod.evening;
  }

  /// Get text color suitable for the background.
  static Color getTextColor([DayPeriod? period]) {
    return isDark(period) ? Colors.white : Colors.black87;
  }
}
