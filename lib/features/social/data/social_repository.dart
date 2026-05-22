import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/social.dart';

class SocialRepository {
  // In-memory storage for development
  final List<RankEntry> _rankings = [
    RankEntry(rank: 1, name: 'ProGamer99', level: 45, points: 98500),
    RankEntry(rank: 2, name: 'DragonMaster', level: 23, points: 72300),
    RankEntry(rank: 3, name: 'MegaFighter', level: 38, points: 65100),
    RankEntry(rank: 4, name: 'StarPlayer', level: 30, points: 54200),
    RankEntry(rank: 5, name: 'Spieler_42', level: 12, points: 43800),
    RankEntry(rank: 6, name: 'CryptoKnight', level: 15, points: 38900),
    RankEntry(rank: 7, name: 'Pixel_Queen', level: 8, points: 31200),
    RankEntry(rank: 8, name: 'SatoshiCollector', level: 20, points: 28500),
    RankEntry(rank: 9, name: 'Kay', level: 5, points: 15200),
  ];

  final List<Friend> _friends = [
    Friend(
      id: 'user_2',
      username: 'Spieler_42',
      creatureName: 'Flamara',
      creatureLevel: 12,
      creatureTypeId: 'fox',
      isOnline: true,
      lastActive: DateTime.now(),
    ),
    Friend(
      id: 'user_3',
      username: 'DragonMaster',
      creatureName: 'Voltix',
      creatureLevel: 23,
      creatureTypeId: 'dragon',
      isOnline: true,
      lastActive: DateTime.now(),
    ),
    Friend(
      id: 'user_4',
      username: 'Pixel_Queen',
      creatureName: 'Aquari',
      creatureLevel: 8,
      creatureTypeId: 'bird',
      isOnline: false,
      lastActive: DateTime.now().subtract(const Duration(hours: 5)),
    ),
  ];

  final List<TradeOffer> _tradeOffers = [
    TradeOffer(
      id: 'trade_1',
      fromUserId: 'user_2',
      fromUsername: 'Spieler_42',
      offeredItemId: 'food_apple_gold',
      offeredItemName: 'Goldener Apfel',
      offeredQuantity: 1,
      wantedItemId: 'toy_wand',
      wantedItemName: 'Zauberstab',
      wantedQuantity: 1,
      status: TradeStatus.open,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  Future<List<RankEntry>> getRankings() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _rankings;
  }

  Future<RankEntry> getPlayerRank(String userId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _rankings.firstWhere((r) => r.name == 'Kay');
  }

  Future<List<Friend>> getFriends(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _friends;
  }

  Future<List<TradeOffer>> getTradeOffers() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _tradeOffers;
  }

  Future<void> addFriend(String userId, String friendUsername) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Simulation: Einfach hinzufügen
    _friends.add(Friend(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      username: friendUsername,
      creatureName: 'Unbekannt',
      creatureLevel: 1,
      creatureTypeId: 'slime',
      isOnline: false,
      lastActive: DateTime.now(),
    ));
  }

  Future<void> acceptTrade(String userId, String tradeId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _tradeOffers.indexWhere((o) => o.id == tradeId);
    if (index >= 0) {
      _tradeOffers[index] = TradeOffer(
        id: _tradeOffers[index].id,
        fromUserId: _tradeOffers[index].fromUserId,
        fromUsername: _tradeOffers[index].fromUsername,
        offeredItemId: _tradeOffers[index].offeredItemId,
        offeredItemName: _tradeOffers[index].offeredItemName,
        offeredQuantity: _tradeOffers[index].offeredQuantity,
        wantedItemId: _tradeOffers[index].wantedItemId,
        wantedItemName: _tradeOffers[index].wantedItemName,
        wantedQuantity: _tradeOffers[index].wantedQuantity,
        status: TradeStatus.completed,
        createdAt: _tradeOffers[index].createdAt,
      );
    }
  }
}

class RankEntry {
  final int rank;
  final String name;
  final int level;
  final int points;

  RankEntry({
    required this.rank,
    required this.name,
    required this.level,
    required this.points,
  });
}

final socialRepositoryProvider = Provider<SocialRepository>((ref) {
  return SocialRepository();
});

final rankingsProvider = FutureProvider<List<RankEntry>>((ref) async {
  final repo = ref.watch(socialRepositoryProvider);
  return repo.getRankings();
});

final playerRankProvider = FutureProvider.family<RankEntry, String>((ref, userId) async {
  final repo = ref.watch(socialRepositoryProvider);
  return repo.getPlayerRank(userId);
});

final friendsProvider = FutureProvider.family<List<Friend>, String>((ref, userId) async {
  final repo = ref.watch(socialRepositoryProvider);
  return repo.getFriends(userId);
});

final tradeOffersProvider = FutureProvider<List<TradeOffer>>((ref) async {
  final repo = ref.watch(socialRepositoryProvider);
  return repo.getTradeOffers();
});
