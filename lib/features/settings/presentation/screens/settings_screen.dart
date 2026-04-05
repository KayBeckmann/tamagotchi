import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Einstellungen'),
      ),
      body: ListView(
        children: [
          // Appearance Section
          _buildSectionHeader(context, 'Erscheinungsbild'),
          _buildThemeSelector(context, ref, settings),
          const Divider(),

          // Notifications Section
          _buildSectionHeader(context, 'Benachrichtigungen'),
          SwitchListTile(
            title: const Text('Benachrichtigungen aktivieren'),
            subtitle: const Text('Alle Push-Benachrichtigungen'),
            value: settings.notificationsEnabled,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).setNotificationsEnabled(value);
            },
          ),
          if (settings.notificationsEnabled) ...[
            SwitchListTile(
              title: const Text('Kritische Statuswerte'),
              subtitle: const Text('Warnung bei Hunger, Krankheit etc.'),
              value: settings.criticalStatusNotifications,
              onChanged: (value) {
                ref.read(settingsProvider.notifier).setCriticalStatusNotifications(value);
              },
            ),
            SwitchListTile(
              title: const Text('Kampfeinladungen'),
              subtitle: const Text('Benachrichtigung bei Arena-Einladungen'),
              value: settings.battleNotifications,
              onChanged: (value) {
                ref.read(settingsProvider.notifier).setBattleNotifications(value);
              },
            ),
            SwitchListTile(
              title: const Text('Turniere'),
              subtitle: const Text('Turnier-Updates und Erinnerungen'),
              value: settings.tournamentNotifications,
              onChanged: (value) {
                ref.read(settingsProvider.notifier).setTournamentNotifications(value);
              },
            ),
          ],
          const Divider(),

          // Sound & Haptics Section
          _buildSectionHeader(context, 'Sound & Haptik'),
          SwitchListTile(
            title: const Text('Soundeffekte'),
            subtitle: const Text('In-App Soundeffekte'),
            value: settings.soundEnabled,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).setSoundEnabled(value);
            },
          ),
          SwitchListTile(
            title: const Text('Vibration'),
            subtitle: const Text('Haptisches Feedback'),
            value: settings.vibrationEnabled,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).setVibrationEnabled(value);
            },
          ),
          const Divider(),

          // Account Section
          _buildSectionHeader(context, 'Konto'),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profil bearbeiten'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Navigate to edit profile
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profil bearbeiten - Kommt bald!')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Passwort ändern'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Navigate to change password
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Passwort ändern - Kommt bald!')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('E-Mail ändern'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Navigate to change email
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('E-Mail ändern - Kommt bald!')),
              );
            },
          ),
          const Divider(),

          // Info Section
          _buildSectionHeader(context, 'Informationen'),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Über die App'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showAboutDialog(context),
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Datenschutzerklärung'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Show privacy policy
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Datenschutzerklärung - Kommt bald!')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.gavel),
            title: const Text('Nutzungsbedingungen'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Show terms of service
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Nutzungsbedingungen - Kommt bald!')),
              );
            },
          ),
          const Divider(),

          // Danger Zone
          _buildSectionHeader(context, 'Gefahrenzone', isDestructive: true),
          ListTile(
            leading: Icon(Icons.restore, color: theme.colorScheme.error),
            title: Text(
              'Einstellungen zurücksetzen',
              style: TextStyle(color: theme.colorScheme.error),
            ),
            onTap: () => _confirmResetSettings(context, ref),
          ),
          ListTile(
            leading: Icon(Icons.logout, color: theme.colorScheme.error),
            title: Text(
              'Abmelden',
              style: TextStyle(color: theme.colorScheme.error),
            ),
            onTap: () => _confirmLogout(context, ref),
          ),
          ListTile(
            leading: Icon(Icons.delete_forever, color: theme.colorScheme.error),
            title: Text(
              'Konto löschen',
              style: TextStyle(color: theme.colorScheme.error),
            ),
            subtitle: const Text('Unwiderruflich'),
            onTap: () => _confirmDeleteAccount(context, ref),
          ),
          const SizedBox(height: 32),

          // App Version
          Center(
            child: Text(
              'Version 1.0.0',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, {bool isDestructive = false}) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          color: isDestructive ? theme.colorScheme.error : theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildThemeSelector(BuildContext context, WidgetRef ref, AppSettings settings) {
    return ListTile(
      leading: Icon(_getThemeIcon(settings.themeMode)),
      title: const Text('Design'),
      subtitle: Text(_getThemeLabel(settings.themeMode)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showThemeDialog(context, ref, settings),
    );
  }

  IconData _getThemeIcon(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return Icons.brightness_auto;
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
    }
  }

  String _getThemeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'System';
      case ThemeMode.light:
        return 'Hell';
      case ThemeMode.dark:
        return 'Dunkel';
    }
  }

  void _showThemeDialog(BuildContext context, WidgetRef ref, AppSettings settings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Design auswählen'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ThemeMode.values.map((mode) {
            return RadioListTile<ThemeMode>(
              title: Text(_getThemeLabel(mode)),
              secondary: Icon(_getThemeIcon(mode)),
              value: mode,
              groupValue: settings.themeMode,
              onChanged: (value) {
                if (value != null) {
                  ref.read(settingsProvider.notifier).setThemeMode(value);
                  Navigator.of(context).pop();
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Tamagotchi',
      applicationVersion: '1.0.0',
      applicationIcon: const FlutterLogo(size: 64),
      applicationLegalese: '© 2026 Tamagotchi App',
      children: [
        const SizedBox(height: 16),
        const Text(
          'Eine moderne Tamagotchi-App mit Arena-Kämpfen, '
          'Turnieren und Bitcoin-Integration.',
        ),
      ],
    );
  }

  void _confirmResetSettings(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Einstellungen zurücksetzen?'),
        content: const Text(
          'Alle Einstellungen werden auf die Standardwerte zurückgesetzt.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () {
              ref.read(settingsProvider.notifier).resetToDefaults();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Einstellungen zurückgesetzt')),
              );
            },
            child: const Text('Zurücksetzen'),
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Abmelden?'),
        content: const Text('Möchtest du dich wirklich abmelden?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () {
              ref.read(authProvider.notifier).logout();
              Navigator.of(context).pop();
              context.go('/login');
            },
            child: const Text('Abmelden'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteAccount(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konto löschen?'),
        content: const Text(
          'Diese Aktion kann nicht rückgängig gemacht werden. '
          'Alle deine Daten, Kreaturen und Fortschritte werden '
          'unwiderruflich gelöscht.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () {
              // TODO: Implement account deletion
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Kontolöschung - Kommt bald!')),
              );
            },
            child: const Text('Konto löschen'),
          ),
        ],
      ),
    );
  }
}
