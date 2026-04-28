import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/responsive_layout.dart';
import '../providers/arena_provider.dart';
import '../../domain/models/battle_action.dart';
import '../../domain/models/battle_state.dart';
import 'battle_result_screen.dart';

class BattleScreen extends ConsumerWidget {
  const BattleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final battle = ref.watch(battleProvider);

    if (battle == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Kein aktiver Kampf.'),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => context.go('/arena'),
                child: const Text('Zur Arena'),
              ),
            ],
          ),
        ),
      );
    }

    if (battle.isFinished) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.pushReplacement('/arena/result');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Runde ${battle.currentRound + 1} / ${battle.maxRounds}'),
        actions: [
          TextButton(
            onPressed: () => _confirmForfeit(context, ref),
            child: Text(
              'Aufgeben',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
      body: ResponsiveLayout(
        mobile: _BattleLayout(battle: battle),
        tablet: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: _BattleLayout(battle: battle),
          ),
        ),
        desktop: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: _BattleLayout(battle: battle),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmForfeit(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Kampf aufgeben?'),
        content: const Text('Du verlierst den Kampf und erhältst weniger XP.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Weiterkämpfen'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Aufgeben'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      ref.read(battleProvider.notifier).clearBattle();
      if (context.mounted) context.go('/arena');
    }
  }
}

class _BattleLayout extends ConsumerWidget {
  final BattleState battle;

  const _BattleLayout({required this.battle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isResolving = battle.status == BattleStatus.resolving;

    return Column(
      children: [
        // ---- Opponent ----
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: _CreatureCard(
            name: '${battle.opponentName} – ${battle.opponentCreature.name}',
            typeId: battle.opponentCreature.type.id,
            currentHp: battle.opponentCurrentHp,
            maxHp: battle.opponentCreature.maxBattleHp,
            hpPercent: battle.opponentHpPercent,
            isOpponent: true,
          ),
        ),

        // ---- VS divider ----
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              const Expanded(child: Divider()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'VS',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const Expanded(child: Divider()),
            ],
          ),
        ),

        // ---- Player ----
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: _CreatureCard(
            name: battle.playerCreature.name,
            typeId: battle.playerCreature.type.id,
            currentHp: battle.playerCurrentHp,
            maxHp: battle.playerCreature.maxBattleHp,
            hpPercent: battle.playerHpPercent,
            isOpponent: false,
            specialCooldown: battle.playerSpecialCooldown,
          ),
        ),

        const SizedBox(height: 12),

        // ---- Battle log ----
        if (battle.turns.isNotEmpty)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _BattleLog(turns: battle.turns),
            ),
          )
        else
          const Expanded(child: SizedBox()),

        // ---- Action buttons ----
        Padding(
          padding: const EdgeInsets.all(16),
          child: _ActionButtons(
            isResolving: isResolving,
            specialAvailable: battle.isPlayerSpecialAvailable,
            specialCooldown: battle.playerSpecialCooldown,
            specialName: battle.playerCreature.type.specialAbilityName,
            onAction: isResolving
                ? null
                : (action) => ref.read(battleProvider.notifier).submitAction(action),
          ),
        ),
      ],
    );
  }
}

class _CreatureCard extends StatelessWidget {
  final String name;
  final String typeId;
  final int currentHp;
  final int maxHp;
  final double hpPercent;
  final bool isOpponent;
  final int specialCooldown;

  const _CreatureCard({
    required this.name,
    required this.typeId,
    required this.currentHp,
    required this.maxHp,
    required this.hpPercent,
    required this.isOpponent,
    this.specialCooldown = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hpColor = hpPercent > 0.5
        ? Colors.green
        : hpPercent > 0.25
            ? Colors.orange
            : Colors.red;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          textDirection:
              isOpponent ? TextDirection.rtl : TextDirection.ltr,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: isOpponent
                  ? theme.colorScheme.errorContainer
                  : theme.colorScheme.primaryContainer,
              child: Text(
                _creatureEmoji(typeId),
                style: const TextStyle(fontSize: 28),
              ),
            ).animate(target: hpPercent < 0.25 ? 1 : 0).shake(
                  duration: 500.ms,
                  hz: 4,
                ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: isOpponent
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textDirection: isOpponent ? TextDirection.rtl : TextDirection.ltr,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    textDirection:
                        isOpponent ? TextDirection.rtl : TextDirection.ltr,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: hpPercent.clamp(0.0, 1.0),
                            backgroundColor:
                                theme.colorScheme.surfaceContainerHighest,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(hpColor),
                            minHeight: 10,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$currentHp / $maxHp',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: hpColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _creatureEmoji(String typeId) {
    const emojis = {
      'cat': '🐱',
      'dog': '🐶',
      'dragon': '🐲',
      'rabbit': '🐰',
      'fox': '🦊',
      'bird': '🐦',
      'slime': '🟢',
      'goblin': '👺',
      'ghost': '👻',
      'elemental': '⚡',
      'golem': '🪨',
      'shadow_cat': '🐈‍⬛',
    };
    return emojis[typeId] ?? '🐾';
  }
}

class _BattleLog extends StatefulWidget {
  final List turns;

  const _BattleLog({required this.turns});

  @override
  State<_BattleLog> createState() => _BattleLogState();
}

class _BattleLogState extends State<_BattleLog> {
  final _scroll = ScrollController();

  @override
  void didUpdateWidget(_BattleLog oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.turns.length != oldWidget.turns.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scroll.hasClients) {
          _scroll.animateTo(
            _scroll.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: Row(
              children: [
                const Icon(Icons.history, size: 16),
                const SizedBox(width: 6),
                Text(
                  'Kampflog',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.all(8),
              itemCount: widget.turns.length,
              itemBuilder: (context, i) {
                final turn = widget.turns[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    turn.logMessage,
                    style: theme.textTheme.bodySmall,
                  ).animate().fadeIn(duration: 300.ms),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final bool isResolving;
  final bool specialAvailable;
  final int specialCooldown;
  final String specialName;
  final void Function(BattleActionType)? onAction;

  const _ActionButtons({
    required this.isResolving,
    required this.specialAvailable,
    required this.specialCooldown,
    required this.specialName,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isResolving) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: CircularProgressIndicator(),
      );
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _ActionButton(
                action: BattleActionType.normalAttack,
                onTap: onAction,
                theme: theme,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _ActionButton(
                action: BattleActionType.specialAttack,
                onTap: specialAvailable ? onAction : null,
                theme: theme,
                badgeText: !specialAvailable ? '$specialCooldown' : null,
                subtitle: specialName,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _ActionButton(
                action: BattleActionType.defend,
                onTap: onAction,
                theme: theme,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _ActionButton(
                action: BattleActionType.dodge,
                onTap: onAction,
                theme: theme,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final BattleActionType action;
  final void Function(BattleActionType)? onTap;
  final ThemeData theme;
  final String? badgeText;
  final String? subtitle;

  const _ActionButton({
    required this.action,
    required this.onTap,
    required this.theme,
    this.badgeText,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    Widget button = Material(
      color: disabled
          ? theme.colorScheme.surfaceContainerHighest
          : theme.colorScheme.primaryContainer,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: disabled ? null : () => onTap!(action),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(action.icon, style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 4),
              Text(
                action.displayName,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: disabled
                      ? theme.colorScheme.onSurfaceVariant
                      : theme.colorScheme.onPrimaryContainer,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: disabled
                        ? theme.colorScheme.onSurfaceVariant
                        : theme.colorScheme.onPrimaryContainer,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ),
    );

    if (badgeText != null) {
      button = Badge(
        label: Text(badgeText!),
        child: button,
      );
    }

    return button;
  }
}
