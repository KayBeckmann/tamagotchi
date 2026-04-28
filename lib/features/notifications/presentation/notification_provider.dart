import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../domain/app_notification.dart';
import '../../creature/domain/models/creature.dart';

/// Manages in-app notifications.
class NotificationNotifier extends StateNotifier<List<AppNotification>> {
  final _uuid = const Uuid();
  Timer? _checkTimer;

  NotificationNotifier() : super([]) {
    // Start periodic check
    _checkTimer = Timer.periodic(
      const Duration(minutes: 5),
      (_) => _checkCreatureStatus(),
    );
  }

  @override
  void dispose() {
    _checkTimer?.cancel();
    super.dispose();
  }

  int get unreadCount => state.where((n) => !n.isRead).length;

  /// Check creature status and generate alerts.
  void checkCreature(Creature creature) {
    if (creature.isDead || creature.isSleeping) return;

    if (creature.hunger < 20) {
      _addNotification(
        type: NotificationType.creatureHungry,
        title: '${creature.name} hat Hunger!',
        body: 'Hunger ist bei ${creature.hunger}%. Füttere deine Kreatur!',
      );
    } else if (creature.health < 20) {
      _addNotification(
        type: NotificationType.creatureCritical,
        title: '${creature.name} braucht Hilfe!',
        body: 'Gesundheit ist kritisch (${creature.health}%). Gib Medizin!',
      );
    } else if (creature.happiness < 20) {
      _addNotification(
        type: NotificationType.creatureUnhappy,
        title: '${creature.name} ist traurig!',
        body: 'Glück bei ${creature.happiness}%. Spiele mit deiner Kreatur!',
      );
    } else if (creature.isSick) {
      _addNotification(
        type: NotificationType.creatureSick,
        title: '${creature.name} ist krank!',
        body: 'Deine Kreatur braucht Medizin.',
      );
    }
  }

  /// Add a battle invitation notification.
  void addBattleInvitation(String fromUsername) {
    _addNotification(
      type: NotificationType.battleInvitation,
      title: 'Kampfeinladung!',
      body: '$fromUsername fordert dich zum Kampf heraus.',
    );
  }

  /// Add a tournament notification.
  void addTournamentNotification({
    required String tournamentName,
    required NotificationType type,
  }) {
    final title = switch (type) {
      NotificationType.tournamentStarting => 'Turnier startet bald!',
      NotificationType.tournamentMatchReady => 'Dein Turnierkampf steht an!',
      NotificationType.tournamentWon => 'Turniersieg! 🏆',
      _ => 'Turnier-Update',
    };
    _addNotification(
      type: type,
      title: title,
      body: tournamentName,
    );
  }

  /// Add level-up notification.
  void addLevelUp(int newLevel) {
    _addNotification(
      type: NotificationType.levelUp,
      title: 'Level Up! Du bist Level $newLevel!',
      body: 'Glückwunsch! Neue Fähigkeiten und Inhalte werden freigeschaltet.',
    );
  }

  /// Add reward notification.
  void addRewardNotification(int satoshis) {
    _addNotification(
      type: NotificationType.rewardReceived,
      title: '+$satoshis Satoshis erhalten!',
      body: 'Belohnung für deinen Kampf.',
    );
  }

  /// Mark a notification as read.
  void markRead(String id) {
    state = [
      for (final n in state)
        if (n.id == id) n.copyWith(isRead: true) else n,
    ];
  }

  /// Mark all notifications as read.
  void markAllRead() {
    state = state.map((n) => n.copyWith(isRead: true)).toList();
  }

  /// Remove a notification.
  void dismiss(String id) {
    state = state.where((n) => n.id != id).toList();
  }

  /// Remove all notifications.
  void clearAll() {
    state = [];
  }

  void _addNotification({
    required NotificationType type,
    required String title,
    required String body,
  }) {
    // Avoid duplicate notifications of same type (within last 5 minutes)
    final recentDuplicate = state.any(
      (n) =>
          n.type == type &&
          DateTime.now().difference(n.createdAt).inMinutes < 5,
    );
    if (recentDuplicate) return;

    final notification = AppNotification(
      id: _uuid.v4(),
      type: type,
      title: title,
      body: body,
      createdAt: DateTime.now(),
    );

    // Keep max 50 notifications
    final updated = [notification, ...state];
    state = updated.take(50).toList();
  }

  void _checkCreatureStatus() {
    // This is called by the timer – actual creature checks are triggered
    // by the creature provider when it loads data.
  }
}

final notificationProvider =
    StateNotifierProvider<NotificationNotifier, List<AppNotification>>((ref) {
  return NotificationNotifier();
});

final unreadNotificationCountProvider = Provider<int>((ref) {
  return ref.watch(notificationProvider).where((n) => !n.isRead).length;
});
