import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// App settings.
class AppSettings {
  final ThemeMode themeMode;
  final String language;
  final bool notificationsEnabled;
  final bool criticalStatusNotifications;
  final bool battleNotifications;
  final bool tournamentNotifications;
  final bool soundEnabled;
  final bool vibrationEnabled;

  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.language = 'de',
    this.notificationsEnabled = true,
    this.criticalStatusNotifications = true,
    this.battleNotifications = true,
    this.tournamentNotifications = true,
    this.soundEnabled = true,
    this.vibrationEnabled = true,
  });

  AppSettings copyWith({
    ThemeMode? themeMode,
    String? language,
    bool? notificationsEnabled,
    bool? criticalStatusNotifications,
    bool? battleNotifications,
    bool? tournamentNotifications,
    bool? soundEnabled,
    bool? vibrationEnabled,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      criticalStatusNotifications: criticalStatusNotifications ?? this.criticalStatusNotifications,
      battleNotifications: battleNotifications ?? this.battleNotifications,
      tournamentNotifications: tournamentNotifications ?? this.tournamentNotifications,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
    );
  }
}

/// Notifier for app settings.
class SettingsNotifier extends StateNotifier<AppSettings> {
  SharedPreferences? _prefs;

  SettingsNotifier() : super(const AppSettings()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _prefs = await SharedPreferences.getInstance();

    final themeModeIndex = _prefs?.getInt('themeMode') ?? 0;
    final language = _prefs?.getString('language') ?? 'de';
    final notificationsEnabled = _prefs?.getBool('notificationsEnabled') ?? true;
    final criticalStatusNotifications = _prefs?.getBool('criticalStatusNotifications') ?? true;
    final battleNotifications = _prefs?.getBool('battleNotifications') ?? true;
    final tournamentNotifications = _prefs?.getBool('tournamentNotifications') ?? true;
    final soundEnabled = _prefs?.getBool('soundEnabled') ?? true;
    final vibrationEnabled = _prefs?.getBool('vibrationEnabled') ?? true;

    state = AppSettings(
      themeMode: ThemeMode.values[themeModeIndex.clamp(0, ThemeMode.values.length - 1)],
      language: language,
      notificationsEnabled: notificationsEnabled,
      criticalStatusNotifications: criticalStatusNotifications,
      battleNotifications: battleNotifications,
      tournamentNotifications: tournamentNotifications,
      soundEnabled: soundEnabled,
      vibrationEnabled: vibrationEnabled,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await _prefs?.setInt('themeMode', mode.index);
  }

  Future<void> setLanguage(String language) async {
    state = state.copyWith(language: language);
    await _prefs?.setString('language', language);
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    state = state.copyWith(notificationsEnabled: enabled);
    await _prefs?.setBool('notificationsEnabled', enabled);
  }

  Future<void> setCriticalStatusNotifications(bool enabled) async {
    state = state.copyWith(criticalStatusNotifications: enabled);
    await _prefs?.setBool('criticalStatusNotifications', enabled);
  }

  Future<void> setBattleNotifications(bool enabled) async {
    state = state.copyWith(battleNotifications: enabled);
    await _prefs?.setBool('battleNotifications', enabled);
  }

  Future<void> setTournamentNotifications(bool enabled) async {
    state = state.copyWith(tournamentNotifications: enabled);
    await _prefs?.setBool('tournamentNotifications', enabled);
  }

  Future<void> setSoundEnabled(bool enabled) async {
    state = state.copyWith(soundEnabled: enabled);
    await _prefs?.setBool('soundEnabled', enabled);
  }

  Future<void> setVibrationEnabled(bool enabled) async {
    state = state.copyWith(vibrationEnabled: enabled);
    await _prefs?.setBool('vibrationEnabled', enabled);
  }

  Future<void> resetToDefaults() async {
    state = const AppSettings();
    await _prefs?.clear();
    await _loadSettings();
  }
}

/// Provider for app settings.
final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>(
  (ref) => SettingsNotifier(),
);

/// Provider for theme mode.
final themeModeProvider = Provider<ThemeMode>((ref) {
  return ref.watch(settingsProvider).themeMode;
});
