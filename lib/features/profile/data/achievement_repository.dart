import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../wallet/data/wallet_repository.dart';
import '../domain/models/achievement.dart';

class AchievementRepository {
  final WalletRepository _walletRepository;
  
  // In-memory storage for development
  final Map<String, List<Achievement>> _userAchievements = {};

  AchievementRepository(this._walletRepository);

  Future<List<Achievement>> getAchievements(String userId) async {
    // TODO: Replace with actual API call
    await Future.delayed(const Duration(milliseconds: 100));
    return _userAchievements[userId] ?? _initializeAchievements(userId);
  }

  List<Achievement> _initializeAchievements(String userId) {
    _userAchievements[userId] = AchievementCatalog.all;
    return _userAchievements[userId]!;
  }

  Future<void> updateProgress(String userId, String achievementId, double progress) async {
    // TODO: Replace with actual API call
    final achievements = await getAchievements(userId);
    final index = achievements.indexWhere((a) => a.id == achievementId);
    
    if (index >= 0) {
      final achievement = achievements[index];
      if (achievement.isUnlocked) return;
      
      final updatedProgress = (achievement.progress + progress).clamp(0.0, 1.0);
      bool isNowUnlocked = updatedProgress >= 1.0;
      
      achievements[index] = achievement.copyWith(
        progress: updatedProgress,
        isUnlocked: isNowUnlocked,
        unlockedAt: isNowUnlocked ? DateTime.now() : null,
      );
      
      if (isNowUnlocked) {
        // Reward user
        await _walletRepository.addSatoshi(
          userId, 
          achievement.rewardSatoshis, 
          'Errungenschaft: ${achievement.title}'
        );
      }
    }
  }

  /// Trigger an achievement by direct unlock (for simple ones)
  Future<void> unlockAchievement(String userId, String achievementId) async {
    await updateProgress(userId, achievementId, 1.0);
  }
}

final achievementRepositoryProvider = Provider<AchievementRepository>((ref) {
  final walletRepo = ref.watch(walletRepositoryProvider);
  return AchievementRepository(walletRepo);
});
