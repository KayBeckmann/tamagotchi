import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/responsive_layout.dart';
import '../../../creature/domain/models/item.dart';
import '../../../creature/data/creature_repository.dart';

class ShopScreen extends ConsumerStatefulWidget {
  const ShopScreen({super.key});

  @override
  ConsumerState<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends ConsumerState<ShopScreen> {
  // TODO: Get actual user ID and balance from auth/wallet
  static const _userId = 'user_1';
  int _userBalance = 10000; // Starting balance in Satoshis

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Shop'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.restaurant), text: 'Futter'),
              Tab(icon: Icon(Icons.medical_services), text: 'Medizin'),
              Tab(icon: Icon(Icons.toys), text: 'Spielzeug'),
            ],
          ),
        ),
        body: Column(
          children: [
            // Balance display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: theme.colorScheme.primaryContainer,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.currency_bitcoin,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Guthaben: $_userBalance Satoshis',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),

            // Shop items
            Expanded(
              child: TabBarView(
                children: [
                  _ShopTab(
                    items: ItemCatalog.food,
                    userBalance: _userBalance,
                    onBuy: _buyItem,
                  ),
                  _ShopTab(
                    items: ItemCatalog.medicine,
                    userBalance: _userBalance,
                    onBuy: _buyItem,
                  ),
                  _ShopTab(
                    items: ItemCatalog.toys,
                    userBalance: _userBalance,
                    onBuy: _buyItem,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _buyItem(Item item, int quantity) async {
    final totalCost = item.priceSatoshis * quantity;

    if (totalCost > _userBalance) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nicht genug Satoshis!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kauf bestätigen'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${item.name} x$quantity'),
            const SizedBox(height: 8),
            Text(
              'Kosten: $totalCost Satoshis',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Kaufen'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await ref.read(creatureRepositoryProvider).addToInventory(
        _userId,
        item.id,
        quantity,
      );

      setState(() {
        _userBalance -= totalCost;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${item.name} x$quantity gekauft!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

class _ShopTab extends StatelessWidget {
  final List<Item> items;
  final int userBalance;
  final Future<void> Function(Item item, int quantity) onBuy;

  const _ShopTab({
    required this.items,
    required this.userBalance,
    required this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    final columns = context.gridColumns;
    final padding = context.horizontalPadding;

    if (columns == 1) {
      // Mobile: Simple list
      return ListView.builder(
        padding: EdgeInsets.all(padding),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return _ShopItemCard(
            item: item,
            canAfford: userBalance >= item.priceSatoshis,
            onBuy: (quantity) => onBuy(item, quantity),
          );
        },
      );
    }

    // Tablet/Desktop: Grid layout
    return ConstrainedContent(
      maxWidth: 1200,
      padding: EdgeInsets.all(padding),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return _ShopItemCard(
            item: item,
            canAfford: userBalance >= item.priceSatoshis,
            onBuy: (quantity) => onBuy(item, quantity),
            compact: true,
          );
        },
      ),
    );
  }
}

class _ShopItemCard extends StatelessWidget {
  final Item item;
  final bool canAfford;
  final void Function(int quantity) onBuy;
  final bool compact;

  const _ShopItemCard({
    required this.item,
    required this.canAfford,
    required this.onBuy,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Effects
            _EffectsRow(item: item),
            const SizedBox(height: 12),

            // Price and buy buttons
            Row(
              children: [
                // Price
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.currency_bitcoin,
                        size: 16,
                        color: theme.colorScheme.onSecondaryContainer,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${item.priceSatoshis} sats',
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),

                // Buy buttons
                OutlinedButton(
                  onPressed: canAfford ? () => onBuy(1) : null,
                  child: const Text('x1'),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: canAfford ? () => onBuy(5) : null,
                  child: const Text('x5'),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: canAfford ? () => onBuy(10) : null,
                  child: const Text('x10'),
                ),
              ],
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            '${isPositive ? '+' : ''}$value',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
