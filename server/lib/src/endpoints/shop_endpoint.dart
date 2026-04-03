import 'package:serverpod/serverpod.dart';

/// Shop and inventory management endpoint.
///
/// Handles:
/// - Shop item listing
/// - Purchases
/// - Inventory management
class ShopEndpoint extends Endpoint {
  /// Get all items available in the shop.
  Future<List<ShopItem>> getShopItems(
    Session session, {
    String? category, // 'food', 'medicine', 'toy', 'premium'
  }) async {
    // TODO: Implement shop items retrieval
    throw UnimplementedError('Get shop items not yet implemented');
  }

  /// Purchase an item from the shop.
  Future<PurchaseResult> purchaseItem(
    Session session, {
    required int itemId,
    int quantity = 1,
  }) async {
    // TODO: Implement item purchase
    // 1. Verify item exists and is available
    // 2. Calculate total cost
    // 3. Check user balance
    // 4. Deduct satoshis
    // 5. Add item to inventory
    // 6. Create transaction record
    throw UnimplementedError('Purchase item not yet implemented');
  }

  /// Get user's inventory.
  Future<List<InventoryItem>> getInventory(Session session) async {
    // TODO: Implement inventory retrieval
    throw UnimplementedError('Get inventory not yet implemented');
  }

  /// Use an item from inventory (alias for creature interactions).
  Future<UseItemResult> useItem(
    Session session, {
    required int itemId,
    required int creatureId,
  }) async {
    // TODO: Implement item usage
    // This is essentially a wrapper around creature interactions
    throw UnimplementedError('Use item not yet implemented');
  }

  /// Get daily login reward status.
  Future<DailyRewardStatus> getDailyRewardStatus(Session session) async {
    // TODO: Implement daily reward status
    throw UnimplementedError('Get daily reward status not yet implemented');
  }

  /// Claim daily login reward.
  Future<DailyRewardClaim> claimDailyReward(Session session) async {
    // TODO: Implement daily reward claim
    // 1. Check if already claimed today
    // 2. Calculate reward based on streak
    // 3. Add satoshis to user balance
    // 4. Update streak
    throw UnimplementedError('Claim daily reward not yet implemented');
  }
}

/// Shop item information.
class ShopItem {
  final int id;
  final String name;
  final String description;
  final String category;
  final int priceSatoshis;
  final String iconUrl;
  // Effects preview
  final int hungerEffect;
  final int happinessEffect;
  final int energyEffect;
  final int healthEffect;
  final int cleanlinessEffect;

  ShopItem({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.priceSatoshis,
    required this.iconUrl,
    required this.hungerEffect,
    required this.happinessEffect,
    required this.energyEffect,
    required this.healthEffect,
    required this.cleanlinessEffect,
  });
}

/// Purchase result.
class PurchaseResult {
  final bool success;
  final String message;
  final int? newBalance;
  final int? quantityPurchased;
  final int? totalCost;

  PurchaseResult({
    required this.success,
    required this.message,
    this.newBalance,
    this.quantityPurchased,
    this.totalCost,
  });
}

/// Inventory item.
class InventoryItem {
  final int itemId;
  final String name;
  final String description;
  final String category;
  final String iconUrl;
  final int quantity;
  final DateTime lastAcquiredAt;

  InventoryItem({
    required this.itemId,
    required this.name,
    required this.description,
    required this.category,
    required this.iconUrl,
    required this.quantity,
    required this.lastAcquiredAt,
  });
}

/// Result of using an item.
class UseItemResult {
  final bool success;
  final String message;
  final int remainingQuantity;
  final Map<String, int> statChanges;

  UseItemResult({
    required this.success,
    required this.message,
    required this.remainingQuantity,
    required this.statChanges,
  });
}

/// Daily reward status.
class DailyRewardStatus {
  final bool canClaim;
  final int currentStreak;
  final int nextRewardSatoshis;
  final DateTime? lastClaimAt;
  final DateTime? nextClaimAvailableAt;

  DailyRewardStatus({
    required this.canClaim,
    required this.currentStreak,
    required this.nextRewardSatoshis,
    this.lastClaimAt,
    this.nextClaimAvailableAt,
  });
}

/// Daily reward claim result.
class DailyRewardClaim {
  final bool success;
  final int satoshisAwarded;
  final int newStreak;
  final int newBalance;
  final String message;

  DailyRewardClaim({
    required this.success,
    required this.satoshisAwarded,
    required this.newStreak,
    required this.newBalance,
    required this.message,
  });
}
