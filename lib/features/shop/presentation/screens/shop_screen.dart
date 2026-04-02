import 'package:flutter/material.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Shop'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Chip(
                avatar: const Icon(Icons.toll, size: 16),
                label: Text(
                  '12.500 Sats',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                visualDensity: VisualDensity.compact,
              ),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.restaurant), text: 'Futter'),
              Tab(icon: Icon(Icons.medical_services), text: 'Medizin'),
              Tab(icon: Icon(Icons.toys), text: 'Spielzeug'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _ShopItemList(items: _foodItems),
            _ShopItemList(items: _medicineItems),
            _ShopItemList(items: _toyItems),
          ],
        ),
      ),
    );
  }
}

class _ShopItem {
  final String name;
  final String description;
  final String price;
  final IconData icon;
  final Color color;
  final String effect;

  const _ShopItem({
    required this.name,
    required this.description,
    required this.price,
    required this.icon,
    required this.color,
    required this.effect,
  });
}

const _foodItems = [
  _ShopItem(
    name: 'Apfel',
    description: 'Ein frischer, saftiger Apfel.',
    price: '50 Sats',
    icon: Icons.apple,
    color: Colors.red,
    effect: '+10 Hunger',
  ),
  _ShopItem(
    name: 'Steak',
    description: 'Ein saftiges Steak vom Grill.',
    price: '200 Sats',
    icon: Icons.lunch_dining,
    color: Colors.brown,
    effect: '+30 Hunger',
  ),
  _ShopItem(
    name: 'Kuchen',
    description: 'Ein leckerer Schokoladenkuchen.',
    price: '150 Sats',
    icon: Icons.cake,
    color: Colors.pink,
    effect: '+20 Hunger, +10 Glueck',
  ),
  _ShopItem(
    name: 'Goldener Apfel',
    description: 'Ein seltener, magischer Apfel.',
    price: '1.000 Sats',
    icon: Icons.apple,
    color: Colors.amber,
    effect: '+50 Hunger, +20 Gesundheit',
  ),
];

const _medicineItems = [
  _ShopItem(
    name: 'Heiltrank',
    description: 'Stellt die Gesundheit wieder her.',
    price: '100 Sats',
    icon: Icons.science,
    color: Colors.green,
    effect: '+25 Gesundheit',
  ),
  _ShopItem(
    name: 'Vitamintabletten',
    description: 'Staerkt das Immunsystem.',
    price: '300 Sats',
    icon: Icons.medication,
    color: Colors.orange,
    effect: '+15 Gesundheit, +10 Energie',
  ),
  _ShopItem(
    name: 'Energiedrink',
    description: 'Gibt sofort neue Energie.',
    price: '250 Sats',
    icon: Icons.battery_charging_full,
    color: Colors.lightBlue,
    effect: '+40 Energie',
  ),
  _ShopItem(
    name: 'Wundertrank',
    description: 'Heilt alle Beschwerden auf einmal.',
    price: '2.000 Sats',
    icon: Icons.auto_awesome,
    color: Colors.purple,
    effect: 'Volle Gesundheit',
  ),
];

const _toyItems = [
  _ShopItem(
    name: 'Ball',
    description: 'Ein einfacher Spielball.',
    price: '75 Sats',
    icon: Icons.sports_soccer,
    color: Colors.blue,
    effect: '+15 Glueck',
  ),
  _ShopItem(
    name: 'Teddybaer',
    description: 'Ein kuscheliger Begleiter.',
    price: '400 Sats',
    icon: Icons.smart_toy,
    color: Colors.brown,
    effect: '+30 Glueck',
  ),
  _ShopItem(
    name: 'Skateboard',
    description: 'Fuer coole Tricks und Spass.',
    price: '600 Sats',
    icon: Icons.skateboarding,
    color: Colors.deepOrange,
    effect: '+25 Glueck, +10 Energie',
  ),
  _ShopItem(
    name: 'Zauberstab',
    description: 'Ein mystischer Zauberstab.',
    price: '1.500 Sats',
    icon: Icons.auto_fix_high,
    color: Colors.deepPurple,
    effect: '+50 Glueck',
  ),
];

class _ShopItemList extends StatelessWidget {
  final List<_ShopItem> items;

  const _ShopItemList({required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _ShopItemCard(item: item);
      },
    );
  }
}

class _ShopItemCard extends StatelessWidget {
  final _ShopItem item;

  const _ShopItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: item.color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(item.icon, color: item.color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.effect,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              children: [
                Text(
                  item.price,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                FilledButton.tonal(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${item.name} gekauft!'),
                      ),
                    );
                  },
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                  child: const Text('Kaufen'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
