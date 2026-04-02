import 'package:flutter/material.dart';

class TournamentScreen extends StatelessWidget {
  const TournamentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Turniere'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Active tournament banner
          Card(
            clipBehavior: Clip.antiAlias,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.tertiary,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.emoji_events,
                        color: Colors.white,
                        size: 28,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Aktives Turnier',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Frühlingsmeisterschaft 2026',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Runde 2 von 4 · 128 Teilnehmer',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.tonal(
                    onPressed: () {
                      // TODO: Turnier-Details
                    },
                    child: const Text('Details anzeigen'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Upcoming tournaments
          Text(
            'Kommende Turniere',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _TournamentTile(
            name: 'Wochenend-Duell',
            date: 'Sa, 04. Apr 2026',
            participants: '32/64',
            entryFee: '500 Sats',
            prize: '25.000 Sats',
            status: TournamentStatus.open,
          ),
          _TournamentTile(
            name: 'Elite-Turnier',
            date: 'Mo, 06. Apr 2026',
            participants: '8/16',
            entryFee: '2.000 Sats',
            prize: '50.000 Sats',
            status: TournamentStatus.open,
          ),
          _TournamentTile(
            name: 'Anfänger-Cup',
            date: 'Mi, 08. Apr 2026',
            participants: '0/32',
            entryFee: 'Kostenlos',
            prize: '5.000 Sats',
            status: TournamentStatus.upcoming,
          ),

          const SizedBox(height: 24),
          Text(
            'Vergangene Turniere',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _TournamentTile(
            name: 'Winter-Meisterschaft',
            date: '15. Mär 2026',
            participants: '64/64',
            entryFee: '1.000 Sats',
            prize: '50.000 Sats',
            status: TournamentStatus.finished,
            placement: '3. Platz',
          ),
        ],
      ),
    );
  }
}

enum TournamentStatus { open, upcoming, finished }

class _TournamentTile extends StatelessWidget {
  final String name;
  final String date;
  final String participants;
  final String entryFee;
  final String prize;
  final TournamentStatus status;
  final String? placement;

  const _TournamentTile({
    required this.name,
    required this.date,
    required this.participants,
    required this.entryFee,
    required this.prize,
    required this.status,
    this.placement,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _statusChip(theme),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14,
                    color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 4),
                Text(date, style: theme.textTheme.bodySmall),
                const SizedBox(width: 16),
                Icon(Icons.people, size: 14,
                    color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 4),
                Text(participants, style: theme.textTheme.bodySmall),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.toll, size: 14,
                    color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 4),
                Text('Eintritt: $entryFee', style: theme.textTheme.bodySmall),
                const SizedBox(width: 16),
                Icon(Icons.emoji_events, size: 14, color: Colors.amber),
                const SizedBox(width: 4),
                Text('Preis: $prize', style: theme.textTheme.bodySmall),
              ],
            ),
            if (placement != null) ...[
              const SizedBox(height: 8),
              Chip(
                avatar: const Icon(Icons.military_tech, size: 16),
                label: Text(placement!),
                visualDensity: VisualDensity.compact,
              ),
            ],
            if (status == TournamentStatus.open) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    // TODO: Turnier beitreten
                  },
                  child: const Text('Teilnehmen'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _statusChip(ThemeData theme) {
    final (label, color) = switch (status) {
      TournamentStatus.open => ('Offen', Colors.green),
      TournamentStatus.upcoming => ('Bald', Colors.orange),
      TournamentStatus.finished => ('Beendet', Colors.grey),
    };

    return Chip(
      label: Text(
        label,
        style: TextStyle(color: color, fontSize: 12),
      ),
      backgroundColor: color.withValues(alpha: 0.1),
      side: BorderSide.none,
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
    );
  }
}
