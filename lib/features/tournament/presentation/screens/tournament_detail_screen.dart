import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/responsive_layout.dart';
import '../../../arena/presentation/providers/reward_provider.dart';
import '../../../creature/presentation/providers/creature_provider.dart';
import '../providers/tournament_provider.dart';
import '../../domain/models/tournament.dart';

class TournamentDetailScreen extends ConsumerWidget {
  final String tournamentId;
  const TournamentDetailScreen({super.key, required this.tournamentId});

  static const _userId = 'user_1';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tournamentAsync = ref.watch(tournamentDetailProvider(tournamentId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Turnier Details')),
      body: tournamentAsync.when(
        data: (tournament) {
          if (tournament == null) {
            return const Center(child: Text('Turnier nicht gefunden.'));
          }
          return ResponsiveLayout(
            mobile: _buildContent(context, theme, ref, tournament),
            tablet: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: _buildContent(context, theme, ref, tournament),
              ),
            ),
            desktop: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: _buildContent(context, theme, ref, tournament),
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Fehler: $e')),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ThemeData theme,
    WidgetRef ref,
    Tournament tournament,
  ) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Header card
        _TournamentHeader(tournament: tournament, theme: theme),
        const SizedBox(height: 16),

        // Prize pot + entry fee
        _PrizeCard(tournament: tournament, theme: theme),
        const SizedBox(height: 16),

        // Registration / status actions
        if (tournament.status == TournamentStatus.registration)
          _RegistrationSection(
            tournament: tournament,
            ref: ref,
            theme: theme,
          ),

        if (tournament.status == TournamentStatus.active ||
            tournament.status == TournamentStatus.completed) ...[
          const SizedBox(height: 8),
          Text(
            'Turnierbaum',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          if (tournament.bracket != null)
            _BracketView(bracket: tournament.bracket!)
          else
            const Text('Bracket wird generiert...'),
          const SizedBox(height: 16),
        ],

        // Champion
        if (tournament.champion != null) ...[
          _ChampionCard(champion: tournament.champion!, theme: theme),
          const SizedBox(height: 16),
        ],

        // Participants
        Text(
          'Teilnehmer (${tournament.currentParticipants}/${tournament.maxParticipants})',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        _ParticipantList(participants: tournament.participants, theme: theme),
      ],
    );
  }
}

class _TournamentHeader extends StatelessWidget {
  final Tournament tournament;
  final ThemeData theme;
  const _TournamentHeader({required this.tournament, required this.theme});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd.MM.yyyy HH:mm');
    final statusColor = switch (tournament.status) {
      TournamentStatus.registration => Colors.blue,
      TournamentStatus.active => Colors.green,
      TournamentStatus.completed => Colors.grey,
      TournamentStatus.cancelled => Colors.red,
    };

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primaryContainer,
              theme.colorScheme.tertiaryContainer,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.emoji_events, size: 28),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    tournament.name,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    tournament.status.displayName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(tournament.description, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              children: [
                _DetailChip(label: tournament.format.displayName, icon: '🏆'),
                _DetailChip(
                  label: '${tournament.maxParticipants} Spieler',
                  icon: '👥',
                ),
                if (tournament.status == TournamentStatus.registration)
                  _DetailChip(
                    label:
                        'Anmeldung bis: ${dateFormat.format(tournament.registrationEndsAt)}',
                    icon: '⏰',
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailChip extends StatelessWidget {
  final String label;
  final String icon;
  const _DetailChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text('$icon $label', style: const TextStyle(fontSize: 12)),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}

class _PrizeCard extends StatelessWidget {
  final Tournament tournament;
  final ThemeData theme;
  const _PrizeCard({required this.tournament, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Preisgeld', style: theme.textTheme.labelMedium),
                  const SizedBox(height: 4),
                  Text(
                    '${tournament.prizePotSatoshis} Sats',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
            const VerticalDivider(width: 32),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Startgebühr', style: theme.textTheme.labelMedium),
                  const SizedBox(height: 4),
                  Text(
                    tournament.isFree
                        ? 'Kostenlos'
                        : '${tournament.entryFeeSatoshis} Sats',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RegistrationSection extends ConsumerWidget {
  final Tournament tournament;
  final WidgetRef ref;
  final ThemeData theme;

  const _RegistrationSection({
    required this.tournament,
    required this.ref,
    required this.theme,
  });

  @override
  Widget build(BuildContext context, WidgetRef widgetRef) {
    final regState = widgetRef.watch(tournamentRegistrationProvider);
    final rewardStats = widgetRef.watch(rewardProvider);
    final creatureState = widgetRef.watch(creatureListProvider('user_1'));
    final activeCreature = creatureState is CreatureListLoaded
        ? creatureState.activeCreature
        : null;

    final isParticipating = tournament.isCurrentUserParticipating;
    final canAfford = rewardStats.satoshiBalance >= tournament.entryFeeSatoshis;
    final canEnter =
        activeCreature != null && activeCreature.canEnterTournament;

    // Show result snackbar
    if (regState is TournamentRegistrationSuccess) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(regState.cancelled
              ? 'Anmeldung storniert. Gebühr wurde erstattet.'
              : 'Erfolgreich angemeldet!'),
          backgroundColor: regState.cancelled ? Colors.orange : Colors.green,
        ));
        widgetRef.read(tournamentRegistrationProvider.notifier).reset();
        widgetRef.invalidate(tournamentsProvider);
        widgetRef.invalidate(tournamentDetailProvider(tournament.id));
      });
    }

    if (regState is TournamentRegistrationError) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(regState.message),
          backgroundColor: Colors.red,
        ));
        widgetRef.read(tournamentRegistrationProvider.notifier).reset();
      });
    }

    final isLoading = regState is TournamentRegistrationLoading;

    return Column(
      children: [
        if (!canEnter && !isParticipating)
          Card(
            color: theme.colorScheme.errorContainer,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(Icons.warning, color: theme.colorScheme.onErrorContainer),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Deine aktive Kreatur muss erwachsen sein (15+ Tage), um an Turnieren teilzunehmen.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (!canAfford && !isParticipating && !tournament.isFree)
          Card(
            color: theme.colorScheme.errorContainer,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(Icons.toll, color: theme.colorScheme.onErrorContainer),
                  const SizedBox(width: 8),
                  Text(
                    'Nicht genug Satoshis (${rewardStats.satoshiBalance} / ${tournament.entryFeeSatoshis})',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onErrorContainer,
                    ),
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 12),
        if (isParticipating)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: isLoading
                  ? null
                  : () => widgetRef
                      .read(tournamentRegistrationProvider.notifier)
                      .cancelRegistration(tournament.id),
              icon: isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.cancel_outlined),
              label: const Text('Anmeldung stornieren'),
            ),
          )
        else
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: (isLoading ||
                      !canEnter ||
                      (!canAfford && !tournament.isFree) ||
                      tournament.isFull)
                  ? null
                  : () {
                      if (activeCreature == null) return;
                      widgetRef
                          .read(tournamentRegistrationProvider.notifier)
                          .register(
                            tournamentId: tournament.id,
                            userId: 'user_1',
                            username: 'Spieler1',
                            creatureId: activeCreature.id,
                            creatureName: activeCreature.name,
                            creatureTypeId: activeCreature.type.id,
                            eloRating: widgetRef.read(rewardProvider).eloRating,
                            currentSatoshis:
                                widgetRef.read(rewardProvider).satoshiBalance,
                          );
                    },
              icon: isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.sports_mma),
              label: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  tournament.isFull
                      ? 'Turnier ist voll'
                      : tournament.isFree
                          ? 'Kostenlos anmelden'
                          : 'Für ${tournament.entryFeeSatoshis} Sats anmelden',
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            ),
          ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _BracketView extends StatelessWidget {
  final TournamentBracket bracket;
  const _BracketView({required this.bracket});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int round = 1; round <= bracket.totalRounds; round++) ...[
            _RoundColumn(
              round: round,
              totalRounds: bracket.totalRounds,
              matches: bracket.matchesForRound(round),
            ),
            if (round < bracket.totalRounds)
              const SizedBox(width: 16),
          ],
        ],
      ),
    );
  }
}

class _RoundColumn extends StatelessWidget {
  final int round;
  final int totalRounds;
  final List<TournamentMatch> matches;

  const _RoundColumn({
    required this.round,
    required this.totalRounds,
    required this.matches,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final roundLabel = round == totalRounds
        ? 'Finale'
        : round == totalRounds - 1
            ? 'Halbfinale'
            : round == totalRounds - 2
                ? 'Viertelfinale'
                : 'Runde $round';

    return SizedBox(
      width: 180,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              roundLabel,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ),
          const SizedBox(height: 8),
          ...matches.map((m) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _MatchCard(match: m),
              )),
        ],
      ),
    );
  }
}

class _MatchCard extends StatelessWidget {
  final TournamentMatch match;
  const _MatchCard({required this.match});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget participantTile(TournamentParticipant? p, bool isWinner) {
      if (p == null) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Text(
            'TBD',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
        );
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: isWinner
            ? BoxDecoration(
                color: Colors.green.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(4),
              )
            : null,
        child: Row(
          children: [
            Text(
              _creatureEmoji(p.creatureTypeId),
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                p.username,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight:
                      isWinner ? FontWeight.bold : FontWeight.normal,
                  color: isWinner ? Colors.green : null,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isWinner)
              const Icon(Icons.star, size: 12, color: Colors.green),
          ],
        ),
      );
    }

    return Card(
      elevation: 1,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          participantTile(
            match.participant1,
            match.winner?.userId == match.participant1?.userId,
          ),
          const Divider(height: 1),
          participantTile(
            match.participant2,
            match.winner?.userId == match.participant2?.userId,
          ),
        ],
      ),
    );
  }

  String _creatureEmoji(String typeId) {
    const emojis = {
      'cat': '🐱', 'dog': '🐶', 'dragon': '🐲', 'rabbit': '🐰',
      'fox': '🦊', 'bird': '🐦', 'slime': '🟢', 'goblin': '👺',
      'ghost': '👻', 'elemental': '⚡', 'golem': '🪨', 'shadow_cat': '🐈‍⬛',
    };
    return emojis[typeId] ?? '🐾';
  }
}

class _ChampionCard extends StatelessWidget {
  final TournamentParticipant champion;
  final ThemeData theme;
  const _ChampionCard({required this.champion, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.amber.shade100,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Text('🏆', style: TextStyle(fontSize: 36)),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Champion', style: theme.textTheme.labelMedium),
                Text(
                  champion.username,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade900,
                  ),
                ),
                Text(
                  champion.creatureName,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ParticipantList extends StatelessWidget {
  final List<TournamentParticipant> participants;
  final ThemeData theme;
  const _ParticipantList({required this.participants, required this.theme});

  @override
  Widget build(BuildContext context) {
    if (participants.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(child: Text('Noch keine Teilnehmer.')),
      );
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: participants.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final p = participants[i];
        return ListTile(
          leading: Text(_creatureEmoji(p.creatureTypeId),
              style: const TextStyle(fontSize: 22)),
          title: Text(
            p.username,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight:
                  p.isCurrentUser ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          subtitle: Text('${p.creatureName} · ELO ${p.eloRating}'),
          trailing: p.isCurrentUser
              ? Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Du',
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontSize: 11,
                    ),
                  ),
                )
              : null,
        );
      },
    );
  }

  String _creatureEmoji(String typeId) {
    const emojis = {
      'cat': '🐱', 'dog': '🐶', 'dragon': '🐲', 'rabbit': '🐰',
      'fox': '🦊', 'bird': '🐦', 'slime': '🟢', 'goblin': '👺',
      'ghost': '👻', 'elemental': '⚡', 'golem': '🪨', 'shadow_cat': '🐈‍⬛',
    };
    return emojis[typeId] ?? '🐾';
  }
}
