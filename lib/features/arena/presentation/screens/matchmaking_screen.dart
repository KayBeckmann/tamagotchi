import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/responsive_layout.dart';
import '../../../creature/domain/models/creature.dart';
import '../providers/arena_provider.dart';
import '../../domain/models/matchmaking_info.dart';
import 'battle_screen.dart';

class MatchmakingScreen extends ConsumerStatefulWidget {
  final Creature playerCreature;
  final int playerElo;

  const MatchmakingScreen({
    super.key,
    required this.playerCreature,
    required this.playerElo,
  });

  @override
  ConsumerState<MatchmakingScreen> createState() => _MatchmakingScreenState();
}

class _MatchmakingScreenState extends ConsumerState<MatchmakingScreen>
    with SingleTickerProviderStateMixin {
  late final Timer _timer;
  Duration _elapsed = Duration.zero;
  bool _navigating = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _elapsed += const Duration(seconds: 1));
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(matchmakingProvider.notifier).startSearch(
            widget.playerCreature,
            widget.playerElo,
          );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mm = ref.watch(matchmakingProvider);

    // Navigate when opponent found
    if (mm.status == MatchmakingStatus.found &&
        mm.opponent != null &&
        !_navigating) {
      _navigating = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startBattle(mm.opponent!);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kampfsuche'),
        automaticallyImplyLeading: false,
      ),
      body: ResponsiveLayout(
        mobile: _buildBody(context, theme, mm, maxWidth: double.infinity),
        tablet: Center(child: _buildBody(context, theme, mm, maxWidth: 480)),
        desktop: Center(child: _buildBody(context, theme, mm, maxWidth: 480)),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    ThemeData theme,
    MatchmakingState mm, {
    required double maxWidth,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Creature card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: theme.colorScheme.primaryContainer,
                      child: Text(
                        _creatureEmoji(widget.playerCreature.type.id),
                        style: const TextStyle(fontSize: 32),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.playerCreature.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.playerCreature.type.name,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Kampfkraft: ${widget.playerCreature.combatPower}',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 48),

            // Searching animation
            if (mm.status == MatchmakingStatus.searching) ...[
              SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  strokeWidth: 6,
                  color: theme.colorScheme.primary,
                ).animate(onPlay: (c) => c.repeat()).rotate(
                      duration: const Duration(seconds: 2),
                    ),
              ),
              const SizedBox(height: 24),
              Text(
                'Suche nach Gegner...',
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                _formatDuration(_elapsed),
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],

            if (mm.status == MatchmakingStatus.found) ...[
              Icon(
                Icons.check_circle,
                size: 80,
                color: Colors.green,
              ).animate().scale(duration: 300.ms).then().shake(),
              const SizedBox(height: 16),
              Text(
                'Gegner gefunden!',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                mm.opponent?.username ?? '',
                style: theme.textTheme.bodyLarge,
              ),
            ],

            if (mm.errorMessage != null) ...[
              Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
              const SizedBox(height: 16),
              Text(mm.errorMessage!, style: theme.textTheme.bodyMedium),
            ],

            const SizedBox(height: 48),

            if (mm.status == MatchmakingStatus.searching)
              OutlinedButton.icon(
                onPressed: () {
                  ref.read(matchmakingProvider.notifier).cancel();
                  context.pop();
                },
                icon: const Icon(Icons.close),
                label: const Text('Abbrechen'),
              ),
          ],
        ),
      ),
    );
  }

  void _startBattle(OpponentInfo opponent) {
    final battle = ref.read(battleProvider.notifier);
    battle.startBattle(
      playerCreature: widget.playerCreature,
      opponentCreature: opponent.creature,
      opponentName: opponent.username,
    );
    ref.read(matchmakingProvider.notifier).reset();
    if (mounted) {
      context.pushReplacement('/arena/battle');
    }
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
