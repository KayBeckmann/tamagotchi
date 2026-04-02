import 'package:flutter/material.dart';

class CreatureSelectionScreen extends StatelessWidget {
  const CreatureSelectionScreen({super.key});

  static const _creatures = [
    _CreatureType(
      name: 'Flamara',
      element: 'Feuer',
      icon: Icons.local_fire_department,
      color: Colors.deepOrange,
      description: 'Ein feuriges Wesen mit starkem Willen.',
    ),
    _CreatureType(
      name: 'Aquari',
      element: 'Wasser',
      icon: Icons.water,
      color: Colors.blue,
      description: 'Ein sanftes Wesen aus der Tiefe des Ozeans.',
    ),
    _CreatureType(
      name: 'Blattling',
      element: 'Pflanze',
      icon: Icons.eco,
      color: Colors.green,
      description: 'Ein naturverbundenes, friedliches Wesen.',
    ),
    _CreatureType(
      name: 'Steinchen',
      element: 'Erde',
      icon: Icons.landscape,
      color: Colors.brown,
      description: 'Ein robustes Wesen mit unerschütterlicher Stärke.',
    ),
    _CreatureType(
      name: 'Voltix',
      element: 'Blitz',
      icon: Icons.bolt,
      color: Colors.amber,
      description: 'Ein blitzschnelles, elektrisches Wesen.',
    ),
    _CreatureType(
      name: 'Schatti',
      element: 'Schatten',
      icon: Icons.dark_mode,
      color: Colors.deepPurple,
      description: 'Ein mysteriöses Wesen der Dunkelheit.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wähle dein Wesen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welches Wesen soll dich begleiten?',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                itemCount: _creatures.length,
                itemBuilder: (context, index) {
                  final creature = _creatures[index];
                  return _CreatureCard(creature: creature);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CreatureType {
  final String name;
  final String element;
  final IconData icon;
  final Color color;
  final String description;

  const _CreatureType({
    required this.name,
    required this.element,
    required this.icon,
    required this.color,
    required this.description,
  });
}

class _CreatureCard extends StatelessWidget {
  final _CreatureType creature;

  const _CreatureCard({required this.creature});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          // TODO: Wesen auswählen
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${creature.name} ausgewählt!'),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: creature.color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  creature.icon,
                  size: 40,
                  color: creature.color,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                creature.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Chip(
                label: Text(
                  creature.element,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: creature.color,
                  ),
                ),
                backgroundColor: creature.color.withValues(alpha: 0.1),
                side: BorderSide.none,
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),
              const SizedBox(height: 4),
              Text(
                creature.description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
