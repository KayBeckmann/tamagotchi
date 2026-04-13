import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    RankEntry(rank: 9, name: 'Kay', level: 5, points: 15200), // User's own entry
  ];

  Future<List<RankEntry>> getRankings() async {
    // TODO: Replace with actual API call
    await Future.delayed(const Duration(milliseconds: 300));
    return _rankings;
  }

  Future<RankEntry> getPlayerRank(String userId) async {
    // TODO: Replace with actual API call
    await Future.delayed(const Duration(milliseconds: 100));
    return _rankings.firstWhere((r) => r.name == 'Kay');
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
