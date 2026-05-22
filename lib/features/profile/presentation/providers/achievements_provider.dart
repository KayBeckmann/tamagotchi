import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/achievement_repository.dart';
import '../domain/models/achievement.dart';

final achievementsProvider = FutureProvider.family<List<Achievement>, String>((ref, userId) async {
  final repo = ref.watch(achievementRepositoryProvider);
  return repo.getAchievements(userId);
});
