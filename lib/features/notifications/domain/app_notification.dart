import 'package:equatable/equatable.dart';

/// Type of in-app notification.
enum NotificationType {
  creatureHungry,
  creatureSick,
  creatureUnhappy,
  creatureLowEnergy,
  creatureCritical,
  battleInvitation,
  tournamentStarting,
  tournamentMatchReady,
  tournamentWon,
  rewardReceived,
  levelUp,
}

extension NotificationTypeExtension on NotificationType {
  String get icon {
    switch (this) {
      case NotificationType.creatureHungry:
        return '🍖';
      case NotificationType.creatureSick:
        return '🤒';
      case NotificationType.creatureUnhappy:
        return '😢';
      case NotificationType.creatureLowEnergy:
        return '😴';
      case NotificationType.creatureCritical:
        return '⚠️';
      case NotificationType.battleInvitation:
        return '⚔️';
      case NotificationType.tournamentStarting:
        return '🏆';
      case NotificationType.tournamentMatchReady:
        return '🥊';
      case NotificationType.tournamentWon:
        return '🥇';
      case NotificationType.rewardReceived:
        return '💰';
      case NotificationType.levelUp:
        return '⭐';
    }
  }
}

/// A single in-app notification.
class AppNotification extends Equatable {
  final String id;
  final NotificationType type;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool isRead;
  final Map<String, String>? data;

  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.createdAt,
    this.isRead = false,
    this.data,
  });

  AppNotification copyWith({bool? isRead}) {
    return AppNotification(
      id: id,
      type: type,
      title: title,
      body: body,
      createdAt: createdAt,
      isRead: isRead ?? this.isRead,
      data: data,
    );
  }

  @override
  List<Object?> get props => [id];
}
