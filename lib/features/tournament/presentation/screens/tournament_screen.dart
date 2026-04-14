import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../providers/tournament_provider.dart';
import '../domain/models/tournament.dart';

class TournamentScreen extends ConsumerWidget {
  const TournamentScreen({super.key});

  // TODO: Get actual user ID from auth
  static const _userId = 'user_1';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final tournamentListState = ref.watch(tournamentListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Turniere'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(tournamentListProvider),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(tournamentListProvider),
        child: tournamentListState.when(
          data: (tournaments) {
            final active = tournaments.where((t) => t.status == TournamentStatus.ongoing).toList();
            final upcoming = tournaments.where((t) => t.status == TournamentStatus.registration).toList();
            final finished = tournaments.where((t) => t.status == TournamentStatus.finished).toList();

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (active.isNotEmpty) ...[
                  Text(
                    'Laufende Turniere',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...active.map((t) => _TournamentCard(tournament: t)),
                  const SizedBox(height: 24),
                ],

                if (upcoming.isNotEmpty) ...[
                  Text(
                    'Kommende Turniere',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...upcoming.map((t) => _TournamentCard(tournament: t)),
                  const SizedBox(height: 24),
                ],

                if (finished.isNotEmpty) ...[
                  Text(
                    'Vergangene Turniere',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...finished.map((t) => _TournamentCard(tournament: t)),
                ],
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Fehler: $err')),
        ),
      ),
    );
  }
}

class _TournamentCard extends ConsumerWidget {
  final Tournament tournament;

  const _TournamentCard({required this.tournament});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd.MM.yyyy, HH:mm', 'de_DE');
    final isJoined = tournament.participantIds.contains('user_1');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/tournament/${tournament.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _getStatusGradient(tournament.status, theme),
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Row(
                children: [
                  Icon(
                    _getStatusIcon(tournament.status),
                    color: Colors.white,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tournament.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _getStatusText(tournament.status),
                          style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  if (isJoined)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Angemeldet',
                        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tournament.description),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _InfoItem(
                        label: 'Eintritt',
                        value: '${tournament.entryFeeSats} Sats',
                        icon: Icons.toll,
                      ),
                      _InfoItem(
                        label: 'Preispool',
                        value: '${tournament.prizePoolSats} Sats',
                        icon: Icons.emoji_events,
                        iconColor: Colors.amber,
                      ),
                      _InfoItem(
                        label: 'Teilnehmer',
                        value: '${tournament.currentParticipants} / ${tournament.maxParticipants}',
                        icon: Icons.people,
                      ),
                    ],
                  ),
                  const Divider(height: 32),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 16, color: theme.colorScheme.onSurfaceVariant),
                      const SizedBox(width: 8),
                      Text(
                        'Start: ${dateFormat.format(tournament.startTime)}',
                        style: theme.textTheme.bodySmall,
                      ),
                      const Spacer(),
                      if (tournament.status == TournamentStatus.registration)
                        FilledButton(
                          onPressed: isJoined ? null : () => _joinTournament(context, ref),
                          child: Text(isJoined ? 'Warten auf Start' : 'Teilnehmen'),
                        )
                      else
                        OutlinedButton(
                          onPressed: () => context.push('/tournament/${tournament.id}'),
                          child: const Text('Details'),
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

  void _joinTournament(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Turnier beitreten'),
        content: Text('Möchtest du dem Turnier "${tournament.title}" für ${tournament.entryFeeSats} Satoshis beitreten?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Abbrechen')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Beitreten')),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(tournamentActionProvider.notifier).join('user_1', tournament.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erfolgreich für "${tournament.title}" angemeldet!')),
        );
      }
    }
  }

  List<Color> _getStatusGradient(TournamentStatus status, ThemeData theme) {
    switch (status) {
      case TournamentStatus.registration:
        return [theme.colorScheme.primary, theme.colorScheme.secondary];
      case TournamentStatus.ongoing:
        return [Colors.orange, Colors.deepOrange];
      case TournamentStatus.finished:
        return [Colors.grey, Colors.blueGrey];
      case TournamentStatus.cancelled:
        return [Colors.red, Colors.redAccent];
    }
  }

  IconData _getStatusIcon(TournamentStatus status) {
    switch (status) {
      case TournamentStatus.registration: return Icons.how_to_reg;
      case TournamentStatus.ongoing: return Icons.play_circle_outline;
      case TournamentStatus.finished: return Icons.emoji_events;
      case TournamentStatus.cancelled: return Icons.cancel;
    }
  }

  String _getStatusText(TournamentStatus status) {
    switch (status) {
      case TournamentStatus.registration: return 'Anmeldung offen';
      case TournamentStatus.ongoing: return 'Turnier läuft';
      case TournamentStatus.finished: return 'Beendet';
      case TournamentStatus.cancelled: return 'Abgesagt';
    }
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? iconColor;

  const _InfoItem({
    required this.label,
    required this.value,
    required this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(icon, size: 20, color: iconColor ?? theme.colorScheme.primary),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        Text(label, style: theme.textTheme.labelSmall?.copyWith(fontSize: 10)),
      ],
    );
  }
}
