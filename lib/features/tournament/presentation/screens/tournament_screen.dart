import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/responsive_layout.dart';
import '../providers/tournament_provider.dart';
import '../../domain/models/tournament.dart';

class TournamentScreen extends ConsumerWidget {
  const TournamentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tournamentsAsync = ref.watch(tournamentsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Turniere')),
      body: ResponsiveLayout(
        mobile: _buildBody(context, theme, ref, tournamentsAsync),
        tablet: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: _buildBody(context, theme, ref, tournamentsAsync),
          ),
        ),
        desktop: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: _buildBody(context, theme, ref, tournamentsAsync),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    ThemeData theme,
    WidgetRef ref,
    AsyncValue<List<Tournament>> tournamentsAsync,
  ) {
    return tournamentsAsync.when(
      data: (tournaments) =>
          _buildTournamentList(context, theme, tournaments),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Fehler: $e')),
    );
  }

  Widget _buildTournamentList(
    BuildContext context,
    ThemeData theme,
    List<Tournament> tournaments,
  ) {
    final active =
        tournaments.where((t) => t.status == TournamentStatus.active).toList();
    final registration = tournaments
        .where((t) => t.status == TournamentStatus.registration)
        .toList();
    final completed = tournaments
        .where((t) => t.status == TournamentStatus.completed)
        .toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (active.isNotEmpty) ...[
          _SectionHeader(title: '🏟️ Laufende Turniere', theme: theme),
          ...active.map((t) => _TournamentCard(
                tournament: t,
                onTap: () => context.push('/tournament/${t.id}'),
              )),
          const SizedBox(height: 16),
        ],
        if (registration.isNotEmpty) ...[
          _SectionHeader(title: '📋 Anmeldung offen', theme: theme),
          ...registration.map((t) => _TournamentCard(
                tournament: t,
                onTap: () => context.push('/tournament/${t.id}'),
              )),
          const SizedBox(height: 16),
        ],
        if (completed.isNotEmpty) ...[
          _SectionHeader(title: '✅ Abgeschlossene Turniere', theme: theme),
          ...completed.map((t) => _TournamentCard(
                tournament: t,
                onTap: () => context.push('/tournament/${t.id}'),
              )),
        ],
        if (tournaments.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Text('Keine Turniere verfügbar.'),
            ),
          ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final ThemeData theme;
  const _SectionHeader({required this.title, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style:
            theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _TournamentCard extends StatelessWidget {
  final Tournament tournament;
  final VoidCallback onTap;

  const _TournamentCard({required this.tournament, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = switch (tournament.status) {
      TournamentStatus.registration => Colors.blue,
      TournamentStatus.active => Colors.green,
      TournamentStatus.completed => Colors.grey,
      TournamentStatus.cancelled => Colors.red,
    };

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      tournament.name,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      tournament.status.displayName,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                tournament.description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _InfoChip(
                    icon: Icons.people,
                    label:
                        '${tournament.currentParticipants}/${tournament.maxParticipants}',
                  ),
                  const SizedBox(width: 8),
                  _InfoChip(
                    icon: Icons.toll,
                    label: tournament.isFree
                        ? 'Kostenlos'
                        : '${tournament.entryFeeSatoshis} Sats',
                  ),
                  const SizedBox(width: 8),
                  _InfoChip(
                    icon: Icons.emoji_events,
                    label: tournament.format.displayName,
                  ),
                  const Spacer(),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 3),
        Text(
          label,
          style: theme.textTheme.labelSmall
              ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}
