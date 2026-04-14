import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../creature/presentation/providers/creature_provider.dart';
import '../../../creature/presentation/widgets/creature_sprite.dart';
import '../providers/battle_provider.dart';
import '../domain/models/battle.dart';

class ArenaScreen extends ConsumerWidget {
  const ArenaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Get active creature
    final creatureState = ref.watch(creatureListProvider('user_1'));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Arena'),
      ),
      body: switch (creatureState) {
        CreatureListLoading() => const Center(child: CircularProgressIndicator()),
        CreatureListError(message: final msg) => Center(child: Text('Fehler: $msg')),
        CreatureListLoaded(activeCreature: final creature) => creature != null
            ? _BattleView(creature: creature)
            : const Center(child: Text('Wähle zuerst eine Kreatur aus!')),
      },
    );
  }
}

class _BattleView extends ConsumerWidget {
  final dynamic creature; 

  const _BattleView({required this.creature});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final battleState = ref.watch(battleProvider(creature));

    return battleState.when(
      loading: () => const _MatchmakingView(),
      error: (err, _) => Center(child: Text('Fehler: $err')),
      data: (session) => switch (session.state) {
        BattleState.searching => const _MatchmakingView(),
        BattleState.starting => _BattleStartingView(session: session),
        BattleState.ongoing => _BattleArenaView(session: session),
        BattleState.finished => _BattleResultView(session: session),
      },
    );
  }
}

class _MatchmakingView extends StatelessWidget {
  const _MatchmakingView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          Text(
            'Suche Gegner...',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          const Text('Bereite dich auf den Kampf vor!'),
        ],
      ),
    );
  }
}

class _BattleStartingView extends StatelessWidget {
  final BattleSession session;

  const _BattleStartingView({required this.session});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'KAMPF BEGINNT!',
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 48),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ParticipantIntro(
                name: session.player.name,
                creatureName: session.player.creatureName,
                level: session.player.level,
              ),
              const Text('VS', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              _ParticipantIntro(
                name: session.opponent.name,
                creatureName: session.opponent.creatureName,
                level: session.opponent.level,
                isOpponent: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ParticipantIntro extends StatelessWidget {
  final String name;
  final String creatureName;
  final int level;
  final bool isOpponent;

  const _ParticipantIntro({
    required this.name,
    required this.creatureName,
    required this.level,
    this.isOpponent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: isOpponent ? Colors.red.withValues(alpha: 0.1) : Colors.blue.withValues(alpha: 0.1),
          child: Icon(Icons.pets, size: 40, color: isOpponent ? Colors.red : Colors.blue),
        ),
        const SizedBox(height: 12),
        Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(creatureName),
        Text('Level $level', style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _BattleArenaView extends ConsumerWidget {
  final BattleSession session;

  const _BattleArenaView({required this.session});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final activeCreature = ref.read(creatureListProvider('user_1')) as CreatureListLoaded;

    return Column(
      children: [
        // Top area: Opponent
        Expanded(
          flex: 4,
          child: Container(
            color: Colors.red.withValues(alpha: 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _BattleParticipantCard(participant: session.opponent, isOpponent: true),
                const SizedBox(height: 16),
                const Icon(Icons.pets, size: 80, color: Colors.red),
              ],
            ),
          ),
        ),

        // Middle area: Log
        Container(
          height: 60,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          color: theme.colorScheme.surfaceContainerHighest,
          child: Center(
            child: Text(
              session.history.isNotEmpty ? session.history.last.logMessage : 'Kampf beginnt!',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ),

        // Bottom area: Player
        Expanded(
          flex: 4,
          child: Container(
            color: Colors.blue.withValues(alpha: 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.pets, size: 80, color: Colors.blue),
                const SizedBox(height: 16),
                _BattleParticipantCard(participant: session.player),
              ],
            ),
          ),
        ),

        // Actions
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ActionButton(
                label: 'Angriff',
                icon: Icons.flash_on,
                color: Colors.red,
                onPressed: session.isPlayerTurn 
                    ? () => ref.read(battleProvider(activeCreature.activeCreature!).notifier).executePlayerAction(BattleAction.attack)
                    : null,
              ),
              _ActionButton(
                label: 'Spezial',
                icon: Icons.auto_awesome,
                color: Colors.purple,
                onPressed: session.isPlayerTurn 
                    ? () => ref.read(battleProvider(activeCreature.activeCreature!).notifier).executePlayerAction(BattleAction.special)
                    : null,
              ),
              _ActionButton(
                label: 'Abwehr',
                icon: Icons.shield,
                color: Colors.blue,
                onPressed: session.isPlayerTurn 
                    ? () => ref.read(battleProvider(activeCreature.activeCreature!).notifier).executePlayerAction(BattleAction.defend)
                    : null,
              ),
              _ActionButton(
                label: 'Ausweichen',
                icon: Icons.directions_run,
                color: Colors.green,
                onPressed: session.isPlayerTurn 
                    ? () => ref.read(battleProvider(activeCreature.activeCreature!).notifier).executePlayerAction(BattleAction.dodge)
                    : null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BattleParticipantCard extends StatelessWidget {
  final BattleParticipant participant;
  final bool isOpponent;

  const _BattleParticipantCard({required this.participant, this.isOpponent = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                participant.creatureName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Lv. ${participant.level}'),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: participant.hpPercentage,
              minHeight: 12,
              backgroundColor: Colors.grey.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(
                participant.hpPercentage > 0.5 
                    ? Colors.green 
                    : (participant.hpPercentage > 0.2 ? Colors.orange : Colors.red),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${participant.currentHp} / ${participant.maxHp} HP',
            style: theme.textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton.filled(
          onPressed: onPressed,
          icon: Icon(icon),
          style: IconButton.styleFrom(
            backgroundColor: isDisabled ? Colors.grey.withValues(alpha: 0.1) : color.withValues(alpha: 0.1),
            foregroundColor: isDisabled ? Colors.grey : color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isDisabled ? Colors.grey : null,
          ),
        ),
      ],
    );
  }
}

class _BattleResultView extends StatelessWidget {
  final BattleSession session;

  const _BattleResultView({required this.session});

  @override
  Widget build(BuildContext context) {
    final result = session.result;
    if (result == null) return const Center(child: CircularProgressIndicator());

    final theme = Theme.of(context);
    final isWinner = result.winnerId == session.player.id;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isWinner ? Icons.emoji_events : Icons.sentiment_very_dissatisfied,
              size: 100,
              color: isWinner ? Colors.amber : Colors.grey,
            ),
            const SizedBox(height: 24),
            Text(
              isWinner ? 'SIEG!' : 'NIEDERLAGE',
              style: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: isWinner ? Colors.amber : Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isWinner 
                  ? 'Du hast den Kampf gewonnen!' 
                  : 'Deine Kreatur wurde besiegt, aber sie hat wertvolle Erfahrung gesammelt.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _RewardCard(
              xp: result.xpGained,
              sats: result.satoshisGained,
            ),
            const SizedBox(height: 48),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Zurück zur Übersicht'),
            ),
          ],
        ),
      ),
    );
  }
}

class _RewardCard extends StatelessWidget {
  final int xp;
  final int sats;

  const _RewardCard({required this.xp, required this.sats});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _RewardItem(label: 'XP', value: '+$xp', icon: Icons.trending_up, color: Colors.blue),
            const SizedBox(width: 48),
            _RewardItem(label: 'Sats', value: '+$sats', icon: Icons.currency_bitcoin, color: Colors.orange),
          ],
        ),
      ),
    );
  }
}

class _RewardItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _RewardItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
