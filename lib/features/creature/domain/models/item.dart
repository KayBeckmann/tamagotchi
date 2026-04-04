import 'package:equatable/equatable.dart';

/// Category of item.
enum ItemCategory {
  food,
  medicine,
  toy,
  premium,
}

/// An item that can be used on creatures.
class Item extends Equatable {
  final String id;
  final String name;
  final String description;
  final ItemCategory category;

  // Effects on creature stats
  final int hungerEffect;
  final int happinessEffect;
  final int energyEffect;
  final int healthEffect;
  final int cleanlinessEffect;
  final double weightEffect;

  // Shop
  final int priceSatoshis;
  final bool isAvailable;

  // Visual
  final String iconPath;

  const Item({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    this.hungerEffect = 0,
    this.happinessEffect = 0,
    this.energyEffect = 0,
    this.healthEffect = 0,
    this.cleanlinessEffect = 0,
    this.weightEffect = 0,
    required this.priceSatoshis,
    this.isAvailable = true,
    required this.iconPath,
  });

  @override
  List<Object?> get props => [id];
}

/// Catalog of all available items.
class ItemCatalog {
  // Food items
  static const List<Item> food = [
    Item(
      id: 'food_normal',
      name: 'Normales Futter',
      description: 'Einfaches, nahrhaftes Futter.',
      category: ItemCategory.food,
      hungerEffect: 10,
      weightEffect: 0.2,
      priceSatoshis: 100,
      iconPath: 'assets/items/food_normal.png',
    ),
    Item(
      id: 'food_premium',
      name: 'Premium-Futter',
      description: 'Hochwertiges Futter, das auch glücklich macht.',
      category: ItemCategory.food,
      hungerEffect: 20,
      happinessEffect: 5,
      weightEffect: 0.1,
      priceSatoshis: 250,
      iconPath: 'assets/items/food_premium.png',
    ),
    Item(
      id: 'food_snack',
      name: 'Snack',
      description: 'Ein leckerer Snack für zwischendurch.',
      category: ItemCategory.food,
      hungerEffect: 5,
      happinessEffect: 10,
      weightEffect: 0.5,
      priceSatoshis: 150,
      iconPath: 'assets/items/food_snack.png',
    ),
    Item(
      id: 'food_gourmet',
      name: 'Gourmet-Mahlzeit',
      description: 'Eine exquisite Mahlzeit für besondere Anlässe.',
      category: ItemCategory.food,
      hungerEffect: 30,
      happinessEffect: 15,
      energyEffect: 5,
      weightEffect: 0.3,
      priceSatoshis: 500,
      iconPath: 'assets/items/food_gourmet.png',
    ),
  ];

  // Medicine items
  static const List<Item> medicine = [
    Item(
      id: 'medicine_basic',
      name: 'Basis-Medizin',
      description: 'Hilft bei leichten Beschwerden.',
      category: ItemCategory.medicine,
      healthEffect: 20,
      priceSatoshis: 200,
      iconPath: 'assets/items/medicine_basic.png',
    ),
    Item(
      id: 'medicine_advanced',
      name: 'Starke Medizin',
      description: 'Wirksame Medizin für ernstere Erkrankungen.',
      category: ItemCategory.medicine,
      healthEffect: 40,
      priceSatoshis: 400,
      iconPath: 'assets/items/medicine_advanced.png',
    ),
    Item(
      id: 'medicine_cure_all',
      name: 'Wunderheilung',
      description: 'Heilt alle Beschwerden und stellt volle Gesundheit her.',
      category: ItemCategory.medicine,
      healthEffect: 100,
      happinessEffect: 10,
      priceSatoshis: 1000,
      iconPath: 'assets/items/medicine_cure_all.png',
    ),
    Item(
      id: 'medicine_energy',
      name: 'Energie-Trank',
      description: 'Stellt Energie wieder her.',
      category: ItemCategory.medicine,
      energyEffect: 30,
      priceSatoshis: 300,
      iconPath: 'assets/items/medicine_energy.png',
    ),
  ];

  // Toy items
  static const List<Item> toys = [
    Item(
      id: 'toy_ball',
      name: 'Spielball',
      description: 'Ein bunter Ball zum Spielen.',
      category: ItemCategory.toy,
      happinessEffect: 15,
      energyEffect: -5,
      priceSatoshis: 150,
      iconPath: 'assets/items/toy_ball.png',
    ),
    Item(
      id: 'toy_plush',
      name: 'Plüschtier',
      description: 'Ein kuscheliges Plüschtier zum Kuscheln.',
      category: ItemCategory.toy,
      happinessEffect: 20,
      priceSatoshis: 250,
      iconPath: 'assets/items/toy_plush.png',
    ),
  ];

  /// Get all items.
  static List<Item> get all => [...food, ...medicine, ...toys];

  /// Get item by ID.
  static Item? getById(String id) {
    try {
      return all.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Get items by category.
  static List<Item> getByCategory(ItemCategory category) {
    return all.where((item) => item.category == category).toList();
  }
}

/// User's inventory entry.
class InventoryItem {
  final Item item;
  final int quantity;
  final DateTime acquiredAt;

  const InventoryItem({
    required this.item,
    required this.quantity,
    required this.acquiredAt,
  });

  InventoryItem copyWith({
    Item? item,
    int? quantity,
    DateTime? acquiredAt,
  }) {
    return InventoryItem(
      item: item ?? this.item,
      quantity: quantity ?? this.quantity,
      acquiredAt: acquiredAt ?? this.acquiredAt,
    );
  }
}
