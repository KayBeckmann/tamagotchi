import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../creature/domain/models/item.dart';
import '../../../creature/data/creature_repository.dart';

class InventoryScreen extends ConsumerWidget {
  const InventoryScreen({super.key});

  // TODO: Get actual user ID from auth
  static const _userId = 'user_1';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Inventar'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.restaurant), text: 'Futter'),
              Tab(icon: Icon(Icons.medical_services), text: 'Medizin'),
              Tab(icon: Icon(Icons.toys), text: 'Spielzeug'),
            ],
          ),
        ),
        body: FutureBuilder<List<InventoryItem>>(
          future: ref.read(creatureRepositoryProvider).getInventory(_userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Fehler: ${snapshot.error}'),
                  ],
                ),
              );
            }

            final inventory = snapshot.data ?? [];

            return TabBarView(
              children: [
                _InventoryTab(
                  inventory: inventory,
                  category: ItemCategory.food,
                  emptyMessage: 'Kein Futter im Inventar',
                  emptyIcon: Icons.restaurant_outlined,
                ),
                _InventoryTab(
                  inventory: inventory,
                  category: ItemCategory.medicine,
                  emptyMessage: 'Keine Medizin im Inventar',
                  emptyIcon: Icons.medical_services_outlined,
                ),
                _InventoryTab(
                  inventory: inventory,
                  category: ItemCategory.toy,
                  emptyMessage: 'Kein Spielzeug im Inventar',
                  emptyIcon: Icons.toys_outlined,
                ),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context.push('/shop'),
          icon: const Icon(Icons.shopping_cart),
          label: const Text('Zum Shop'),
        ),
      ),
    );
  }
}

class _InventoryTab extends StatelessWidget {
  final List<InventoryItem> inventory;
  final ItemCategory category;
  final String emptyMessage;
  final IconData emptyIcon;

  const _InventoryTab({
    required this.inventory,
    required this.category,
    required this.emptyMessage,
    required this.emptyIcon,
  });

  @override
  Widget build(BuildContext context) {
    final filteredItems = inventory
        .where((inv) => inv.item.category == category)
        .toList();

    if (filteredItems.isEmpty) {
      return _EmptyInventoryState(
        message: emptyMessage,
        icon: emptyIcon,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        final inventoryItem = filteredItems[index];
        return _InventoryItemCard(inventoryItem: inventoryItem);
      },
    );
  }
}

class _EmptyInventoryState extends StatelessWidget {
  final String message;
  final IconData icon;

  const _EmptyInventoryState({
    required this.message,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Besuche den Shop, um Items zu kaufen!',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}

class _InventoryItemCard extends StatelessWidget {
  final InventoryItem inventoryItem;

  const _InventoryItemCard({required this.inventoryItem});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final item = inventoryItem.item;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Item icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: _getCategoryColor(item.category).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getCategoryIcon(item.category),
                color: _getCategoryColor(item.category),
                size: 28,
              ),
            ),
            const SizedBox(width: 16),

            // Item info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _EffectsRow(item: item),
                ],
              ),
            ),

            // Quantity badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'x${inventoryItem.quantity}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(ItemCategory category) {
    switch (category) {
      case ItemCategory.food:
        return Colors.orange;
      case ItemCategory.medicine:
        return Colors.red;
      case ItemCategory.toy:
        return Colors.purple;
      case ItemCategory.premium:
        return Colors.amber;
    }
  }

  IconData _getCategoryIcon(ItemCategory category) {
    switch (category) {
      case ItemCategory.food:
        return Icons.restaurant;
      case ItemCategory.medicine:
        return Icons.medical_services;
      case ItemCategory.toy:
        return Icons.toys;
      case ItemCategory.premium:
        return Icons.star;
    }
  }
}

class _EffectsRow extends StatelessWidget {
  final Item item;

  const _EffectsRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final effects = <Widget>[];

    if (item.hungerEffect != 0) {
      effects.add(_EffectChip(
        icon: Icons.restaurant,
        value: item.hungerEffect,
        color: Colors.orange,
      ));
    }
    if (item.happinessEffect != 0) {
      effects.add(_EffectChip(
        icon: Icons.favorite,
        value: item.happinessEffect,
        color: Colors.pink,
      ));
    }
    if (item.energyEffect != 0) {
      effects.add(_EffectChip(
        icon: Icons.bolt,
        value: item.energyEffect,
        color: Colors.amber,
      ));
    }
    if (item.healthEffect != 0) {
      effects.add(_EffectChip(
        icon: Icons.favorite_border,
        value: item.healthEffect,
        color: Colors.green,
      ));
    }
    if (item.cleanlinessEffect != 0) {
      effects.add(_EffectChip(
        icon: Icons.water_drop,
        value: item.cleanlinessEffect,
        color: Colors.blue,
      ));
    }

    if (effects.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: effects,
    );
  }
}

class _EffectChip extends StatelessWidget {
  final IconData icon;
  final int value;
  final Color color;

  const _EffectChip({
    required this.icon,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = value > 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 2),
          Text(
            '${isPositive ? '+' : ''}$value',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
