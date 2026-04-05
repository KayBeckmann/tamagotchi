import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../creature/presentation/providers/creature_provider.dart';

/// User profile data.
class UserProfile {
  final int id;
  final String username;
  final String email;
  final int level;
  final int experiencePoints;
  final int totalBattles;
  final int battlesWon;
  final int tournamentsWon;
  final int satoshiBalance;
  final DateTime memberSince;

  const UserProfile({
    required this.id,
    required this.username,
    required this.email,
    this.level = 1,
    this.experiencePoints = 0,
    this.totalBattles = 0,
    this.battlesWon = 0,
    this.tournamentsWon = 0,
    this.satoshiBalance = 0,
    required this.memberSince,
  });

  int get experienceToNextLevel => level * 100;
  double get levelProgress => experiencePoints / experienceToNextLevel;
  double get winRate => totalBattles > 0 ? battlesWon / totalBattles : 0;
}

/// Profile state.
sealed class ProfileState {
  const ProfileState();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  final UserProfile profile;
  const ProfileLoaded(this.profile);
}

class ProfileError extends ProfileState {
  final String message;
  const ProfileError(this.message);
}

/// Notifier for profile state.
class ProfileNotifier extends StateNotifier<ProfileState> {
  final int _userId;

  ProfileNotifier(this._userId) : super(const ProfileLoading()) {
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    // TODO: Load from server
    // For now, return mock data
    await Future.delayed(const Duration(milliseconds: 300));

    state = ProfileLoaded(UserProfile(
      id: _userId,
      username: 'Spieler$_userId',
      email: 'spieler$_userId@example.com',
      level: 5,
      experiencePoints: 350,
      totalBattles: 42,
      battlesWon: 28,
      tournamentsWon: 2,
      satoshiBalance: 125000,
      memberSince: DateTime.now().subtract(const Duration(days: 30)),
    ));
  }

  Future<void> refresh() async {
    state = const ProfileLoading();
    await _loadProfile();
  }
}

/// Provider for user profile.
final profileProvider = StateNotifierProvider.family<ProfileNotifier, ProfileState, int>(
  (ref, userId) => ProfileNotifier(userId),
);

/// Statistics summary for a user.
class UserStatistics {
  final int totalCreatures;
  final int aliveCreatures;
  final int deadCreatures;
  final int totalDaysPlayed;
  final int longestCreatureAge;
  final String? favoriteCreatureType;

  const UserStatistics({
    this.totalCreatures = 0,
    this.aliveCreatures = 0,
    this.deadCreatures = 0,
    this.totalDaysPlayed = 0,
    this.longestCreatureAge = 0,
    this.favoriteCreatureType,
  });
}

/// Provider for user statistics based on creatures.
final userStatisticsProvider = Provider.family<UserStatistics, String>((ref, userId) {
  final creatureState = ref.watch(creatureListProvider(userId));

  if (creatureState is! CreatureListLoaded) {
    return const UserStatistics();
  }

  final creatures = creatureState.creatures;
  final alive = creatures.where((c) => !c.isDead).toList();
  final dead = creatures.where((c) => c.isDead).toList();

  int longestAge = 0;
  String? favoriteType;
  final Map<String, int> typeCounts = {};

  for (final creature in creatures) {
    if (creature.ageInDays > longestAge) {
      longestAge = creature.ageInDays;
    }
    typeCounts[creature.type.id] = (typeCounts[creature.type.id] ?? 0) + 1;
  }

  if (typeCounts.isNotEmpty) {
    favoriteType = typeCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  return UserStatistics(
    totalCreatures: creatures.length,
    aliveCreatures: alive.length,
    deadCreatures: dead.length,
    longestCreatureAge: longestAge,
    favoriteCreatureType: favoriteType,
  );
});
