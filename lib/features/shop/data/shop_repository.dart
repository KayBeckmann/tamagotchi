import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../creature/data/creature_repository.dart';
import '../../creature/domain/models/item.dart';
import '../../profile/data/achievement_repository.dart';
import '../../wallet/data/wallet_repository.dart';

class ShopRepository {
  final WalletRepository _walletRepository;
  final CreatureRepository _creatureRepository;
  final AchievementRepository _achievementRepository;

  ShopRepository(
    this._walletRepository,
    this._creatureRepository,
    this._achievementRepository,
  );

  Future<void> buyItem(String userId, String itemId, int quantity) async {
    final item = ItemCatalog.getById(itemId);
    if (item == null) throw Exception('Item not found');

    final totalCost = item.priceSatoshis * quantity;
    
    // 1. Deduct from wallet
    await _walletRepository.removeSatoshi(userId, totalCost, 'Shop-Einkauf: ${item.name} x$quantity');

    // 2. Add to inventory
    await _creatureRepository.addToInventory(userId, itemId, quantity);

    // 3. Update Achievements
    if (totalCost >= 10000) {
      await _achievementRepository.unlockAchievement(userId, 'wallet_big_spender');
    } else {
      // Progress towards big spender (not perfectly accurate as it's cumulative in reality, 
      // but let's say 10000 is a single purchase or cumulative progress)
      await _achievementRepository.updateProgress(userId, 'wallet_big_spender', totalCost / 10000);
    }
  }
}

final shopRepositoryProvider = Provider<ShopRepository>((ref) {
  final walletRepo = ref.watch(walletRepositoryProvider);
  final creatureRepo = ref.watch(creatureRepositoryProvider);
  final achievementRepo = ref.watch(achievementRepositoryProvider);
  return ShopRepository(walletRepo, creatureRepo, achievementRepo);
});
