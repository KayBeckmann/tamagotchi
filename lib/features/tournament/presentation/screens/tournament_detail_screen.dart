import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/tournament_provider.dart';
import '../domain/models/tournament.dart';

class TournamentDetailScreen extends ConsumerWidget {
  final String tournamentId;

  const TournamentDetailScreen({super.key, required this.tournamentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tournamentState = ref.watch(tournamentDetailProvider(tournamentId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Turnier-Details'),
      ),
      body: tournamentState.when(
        data: (tournament) => tournament == null
            ? const Center(child: Text('Turnier nicht gefunden'))
            : _buildContent(context, ref, tournament),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Fehler: $err')),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, Tournament tournament) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd. MMMM yyyy, HH:mm', 'de_DE');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tournament.title,
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(tournament.description),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _Stat(label: 'Eintritt', value: '${tournament.entryFeeSats} Sats'),
                      _Stat(label: 'Preispool', value: '${tournament.prizePoolSats} Sats', isHighlight: true),
                      _Stat(label: 'Teilnehmer', value: '${tournament.currentParticipants}/${tournament.maxParticipants}'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Status & Zeit
          Row(
            children: [
              const Icon(Icons.info_outline, size: 20),
              const SizedBox(width: 8),
              Text(
                'Status: ${_getStatusText(tournament.status)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                dateFormat.format(tournament.startTime),
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
          const Divider(height: 32),

          // Bracket / Turnierbaum
          Text(
            'Turnierbaum',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (tournament.brackets.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text('Der Turnierbaum wird nach Anmeldeschluss generiert.'),
              ),
            )
          else
            _buildBracketView(context, tournament),

          const SizedBox(height: 32),
          
          // Join Button if applicable
          if (tournament.status == TournamentStatus.registration && 
              !tournament.participantIds.contains('user_1'))
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => _joinTournament(context, ref, tournament),
                icon: const Icon(Icons.add),
                label: const Text('Jetzt teilnehmen'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBracketView(BuildContext context, Tournament tournament) {
    return Column(
      children: tournament.brackets.map((bracket) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Runde ${bracket.round}',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: bracket.matches.map((match) => _MatchCard(match: match)).toList(),
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
      }).toList(),
    );
  }

  String _getStatusText(TournamentStatus status) {
    switch (status) {
      case TournamentStatus.registration: return 'Anmeldung offen';
      case TournamentStatus.ongoing: return 'Läuft';
      case TournamentStatus.finished: return 'Beendet';
      case TournamentStatus.cancelled: return 'Abgesagt';
    }
  }

  void _joinTournament(BuildContext context, WidgetRef ref, Tournament tournament) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Beitreten'),
        content: Text('Kosten: ${tournament.entryFeeSats} Sats'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Abbrechen')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Bestätigen')),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(tournamentActionProvider.notifier).join('user_1', tournament.id);
    }
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final bool isHighlight;

  const _Stat({required this.label, required this.value, this.isHighlight = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: isHighlight ? Colors.amber.shade800 : null,
          ),
        ),
        Text(label, style: theme.textTheme.labelSmall),
      ],
    );
  }
}

class _MatchCard extends StatelessWidget {
  final TournamentMatch match;

  const _MatchCard({required this.match});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: theme.colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              _ParticipantRow(
                id: match.player1Id, 
                isWinner: match.winnerId == match.player1Id,
              ),
              const Divider(height: 8),
              _ParticipantRow(
                id: match.player2Id, 
                isWinner: match.winnerId == match.player2Id,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ParticipantRow extends StatelessWidget {
  final String? id;
  final bool isWinner;

  const _ParticipantRow({this.id, required this.isWinner});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 10,
          backgroundColor: id == null ? Colors.grey : (isWinner ? Colors.green : Colors.blue),
          child: const Icon(Icons.person, size: 12, color: Colors.white),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            id ?? 'TBD',
            style: TextStyle(
              fontSize: 12,
              fontWeight: isWinner ? FontWeight.bold : FontWeight.normal,
              color: id == null ? Colors.grey : null,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (isWinner) const Icon(Icons.check_circle, size: 14, color: Colors.green),
      ],
    );
  }
}
