import 'package:serverpod/serverpod.dart';

/// User profile and settings management endpoint.
///
/// Handles:
/// - Profile retrieval and updates
/// - User statistics
/// - Settings management
class UserEndpoint extends Endpoint {
  /// Get the current user's profile.
  Future<UserProfile> getProfile(Session session) async {
    // TODO: Implement profile retrieval
    // 1. Get authenticated user from session
    // 2. Fetch user data from database
    // 3. Include statistics (wins, losses, XP, etc.)
    throw UnimplementedError('Get profile not yet implemented');
  }

  /// Update the current user's profile.
  Future<UserProfile> updateProfile(
    Session session, {
    String? username,
    String? avatarUrl,
  }) async {
    // TODO: Implement profile update
    // 1. Validate input
    // 2. Check username uniqueness if changed
    // 3. Update user in database
    throw UnimplementedError('Update profile not yet implemented');
  }

  /// Get a user's public profile by ID.
  Future<PublicUserProfile> getPublicProfile(
    Session session, {
    required int userId,
  }) async {
    // TODO: Implement public profile retrieval
    // 1. Fetch user data (limited fields)
    // 2. Include public statistics
    throw UnimplementedError('Get public profile not yet implemented');
  }

  /// Get user statistics and achievements.
  Future<UserStats> getStats(Session session) async {
    // TODO: Implement stats retrieval
    // 1. Aggregate battle statistics
    // 2. Aggregate tournament statistics
    // 3. Get achievement progress
    throw UnimplementedError('Get stats not yet implemented');
  }

  /// Get the global leaderboard.
  Future<List<LeaderboardEntry>> getLeaderboard(
    Session session, {
    required String type, // 'elo', 'wins', 'xp'
    int limit = 50,
    int offset = 0,
  }) async {
    // TODO: Implement leaderboard retrieval
    // 1. Query users ordered by specified metric
    // 2. Return paginated results
    throw UnimplementedError('Get leaderboard not yet implemented');
  }
}

/// Full user profile for the authenticated user.
class UserProfile {
  final int id;
  final String email;
  final String username;
  final String? avatarUrl;
  final int experiencePoints;
  final int level;
  final int satoshiBalance;
  final int eloRating;
  final int totalWins;
  final int totalLosses;
  final int maxCreatureSlots;
  final DateTime createdAt;

  UserProfile({
    required this.id,
    required this.email,
    required this.username,
    this.avatarUrl,
    required this.experiencePoints,
    required this.level,
    required this.satoshiBalance,
    required this.eloRating,
    required this.totalWins,
    required this.totalLosses,
    required this.maxCreatureSlots,
    required this.createdAt,
  });
}

/// Public user profile (limited info).
class PublicUserProfile {
  final int id;
  final String username;
  final String? avatarUrl;
  final int level;
  final int eloRating;
  final int totalWins;
  final int totalLosses;

  PublicUserProfile({
    required this.id,
    required this.username,
    this.avatarUrl,
    required this.level,
    required this.eloRating,
    required this.totalWins,
    required this.totalLosses,
  });
}

/// User statistics summary.
class UserStats {
  final int totalBattles;
  final int arenaWins;
  final int arenaLosses;
  final int tournamentsEntered;
  final int tournamentsWon;
  final int creaturesOwned;
  final int creaturesLost;
  final int achievementsUnlocked;
  final int totalSatoshisEarned;

  UserStats({
    required this.totalBattles,
    required this.arenaWins,
    required this.arenaLosses,
    required this.tournamentsEntered,
    required this.tournamentsWon,
    required this.creaturesOwned,
    required this.creaturesLost,
    required this.achievementsUnlocked,
    required this.totalSatoshisEarned,
  });
}

/// Leaderboard entry.
class LeaderboardEntry {
  final int rank;
  final int userId;
  final String username;
  final String? avatarUrl;
  final int value; // The metric value (ELO, wins, XP)

  LeaderboardEntry({
    required this.rank,
    required this.userId,
    required this.username,
    this.avatarUrl,
    required this.value,
  });
}
