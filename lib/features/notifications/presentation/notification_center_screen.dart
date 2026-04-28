import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/responsive_layout.dart';
import 'notification_provider.dart';
import '../domain/app_notification.dart';

class NotificationCenterScreen extends ConsumerWidget {
  const NotificationCenterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Benachrichtigungen'),
        actions: [
          if (notifications.isNotEmpty)
            TextButton(
              onPressed: () {
                ref.read(notificationProvider.notifier).markAllRead();
              },
              child: const Text('Alle lesen'),
            ),
          if (notifications.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              tooltip: 'Alle löschen',
              onPressed: () =>
                  ref.read(notificationProvider.notifier).clearAll(),
            ),
        ],
      ),
      body: ResponsiveLayout(
        mobile: _buildList(context, theme, ref, notifications),
        tablet: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: _buildList(context, theme, ref, notifications),
          ),
        ),
        desktop: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: _buildList(context, theme, ref, notifications),
          ),
        ),
      ),
    );
  }

  Widget _buildList(
    BuildContext context,
    ThemeData theme,
    WidgetRef ref,
    List<AppNotification> notifications,
  ) {
    if (notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 80,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'Keine Benachrichtigungen',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: notifications.length,
      separatorBuilder: (_, __) => const Divider(height: 1, indent: 72),
      itemBuilder: (context, i) {
        final n = notifications[i];
        return _NotificationTile(
          notification: n,
          onTap: () => ref.read(notificationProvider.notifier).markRead(n.id),
          onDismiss: () =>
              ref.read(notificationProvider.notifier).dismiss(n.id),
        );
      },
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const _NotificationTile({
    required this.notification,
    required this.onTap,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeFormat = DateFormat('HH:mm · dd.MM.');
    final isUnread = !notification.isRead;

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        color: theme.colorScheme.errorContainer,
        child: Icon(
          Icons.delete,
          color: theme.colorScheme.onErrorContainer,
        ),
      ),
      onDismissed: (_) => onDismiss(),
      child: ListTile(
        onTap: onTap,
        tileColor: isUnread
            ? theme.colorScheme.primaryContainer.withValues(alpha: 0.2)
            : null,
        leading: CircleAvatar(
          backgroundColor: isUnread
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.surfaceContainerHighest,
          child: Text(
            notification.type.icon,
            style: const TextStyle(fontSize: 20),
          ),
        ),
        title: Text(
          notification.title,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight:
                isUnread ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification.body, style: theme.textTheme.bodySmall),
            Text(
              timeFormat.format(notification.createdAt),
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        trailing: isUnread
            ? Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.primary,
                ),
              )
            : null,
        isThreeLine: true,
      ),
    );
  }
}
