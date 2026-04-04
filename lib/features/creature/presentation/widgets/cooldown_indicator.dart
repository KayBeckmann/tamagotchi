import 'dart:async';

import 'package:flutter/material.dart';

import '../../domain/models/action_cooldown.dart';

/// Widget that displays a countdown timer for an action cooldown.
class CooldownIndicator extends StatefulWidget {
  final Duration? remainingTime;
  final ActionType action;
  final Widget child;
  final VoidCallback? onCooldownComplete;

  const CooldownIndicator({
    super.key,
    required this.remainingTime,
    required this.action,
    required this.child,
    this.onCooldownComplete,
  });

  @override
  State<CooldownIndicator> createState() => _CooldownIndicatorState();
}

class _CooldownIndicatorState extends State<CooldownIndicator> {
  Timer? _timer;
  Duration? _remaining;

  @override
  void initState() {
    super.initState();
    _remaining = widget.remainingTime;
    _startTimer();
  }

  @override
  void didUpdateWidget(CooldownIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.remainingTime != oldWidget.remainingTime) {
      _remaining = widget.remainingTime;
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    if (_remaining != null && _remaining!.inSeconds > 0) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _remaining = _remaining! - const Duration(seconds: 1);
          if (_remaining!.inSeconds <= 0) {
            _remaining = null;
            timer.cancel();
            widget.onCooldownComplete?.call();
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_remaining == null || _remaining!.inSeconds <= 0) {
      return widget.child;
    }

    final theme = Theme.of(context);

    return Stack(
      alignment: Alignment.center,
      children: [
        // Dimmed child
        Opacity(
          opacity: 0.5,
          child: widget.child,
        ),
        // Cooldown overlay
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            ActionCooldownManager.formatCooldown(_remaining),
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}

/// A row showing all action cooldowns.
class CooldownStatusRow extends StatelessWidget {
  final Map<ActionType, Duration?> cooldowns;

  const CooldownStatusRow({
    super.key,
    required this.cooldowns,
  });

  @override
  Widget build(BuildContext context) {
    final activeCooldowns = cooldowns.entries
        .where((e) => e.value != null && e.value!.inSeconds > 0)
        .toList();

    if (activeCooldowns.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.timer, size: 16),
                const SizedBox(width: 8),
                Text(
                  'Cooldowns',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: activeCooldowns.map((entry) {
                return Chip(
                  avatar: Icon(_getActionIcon(entry.key), size: 16),
                  label: Text(
                    '${entry.key.displayName}: ${ActionCooldownManager.formatCooldown(entry.value)}',
                  ),
                  visualDensity: VisualDensity.compact,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getActionIcon(ActionType action) {
    switch (action) {
      case ActionType.feed:
        return Icons.restaurant;
      case ActionType.play:
        return Icons.sports_esports;
      case ActionType.clean:
        return Icons.shower;
      case ActionType.train:
        return Icons.fitness_center;
      case ActionType.medicine:
        return Icons.medical_services;
    }
  }
}
