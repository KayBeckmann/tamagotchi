/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// A registered user of the Tamagotchi app.
abstract class AppUser implements _i1.SerializableModel {
  AppUser._({
    this.id,
    required this.username,
    required this.email,
    required this.passwordHash,
    required this.xp,
    required this.level,
    required this.eloRating,
    required this.walletBalanceSat,
    required this.totalWins,
    required this.totalLosses,
    required this.isActive,
    required this.createdAt,
    this.lastLoginAt,
  });

  factory AppUser({
    int? id,
    required String username,
    required String email,
    required String passwordHash,
    required int xp,
    required int level,
    required int eloRating,
    required int walletBalanceSat,
    required int totalWins,
    required int totalLosses,
    required bool isActive,
    required DateTime createdAt,
    DateTime? lastLoginAt,
  }) = _AppUserImpl;

  factory AppUser.fromJson(Map<String, dynamic> jsonSerialization) {
    return AppUser(
      id: jsonSerialization['id'] as int?,
      username: jsonSerialization['username'] as String,
      email: jsonSerialization['email'] as String,
      passwordHash: jsonSerialization['passwordHash'] as String,
      xp: jsonSerialization['xp'] as int,
      level: jsonSerialization['level'] as int,
      eloRating: jsonSerialization['eloRating'] as int,
      walletBalanceSat: jsonSerialization['walletBalanceSat'] as int,
      totalWins: jsonSerialization['totalWins'] as int,
      totalLosses: jsonSerialization['totalLosses'] as int,
      isActive: jsonSerialization['isActive'] as bool,
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      lastLoginAt: jsonSerialization['lastLoginAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastLoginAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Unique username chosen by the user.
  String username;

  /// Email address for login and notifications.
  String email;

  /// BCrypt-hashed password.
  String passwordHash;

  /// User experience points earned through battles and tournaments.
  int xp;

  /// User level calculated from XP.
  int level;

  /// ELO rating for arena matchmaking.
  int eloRating;

  /// Wallet balance in Satoshis.
  int walletBalanceSat;

  /// Total arena wins.
  int totalWins;

  /// Total arena losses.
  int totalLosses;

  /// Whether the account is active.
  bool isActive;

  /// Timestamp of account creation.
  DateTime createdAt;

  /// Timestamp of last login.
  DateTime? lastLoginAt;

  /// Returns a shallow copy of this [AppUser]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AppUser copyWith({
    int? id,
    String? username,
    String? email,
    String? passwordHash,
    int? xp,
    int? level,
    int? eloRating,
    int? walletBalanceSat,
    int? totalWins,
    int? totalLosses,
    bool? isActive,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'username': username,
      'email': email,
      'passwordHash': passwordHash,
      'xp': xp,
      'level': level,
      'eloRating': eloRating,
      'walletBalanceSat': walletBalanceSat,
      'totalWins': totalWins,
      'totalLosses': totalLosses,
      'isActive': isActive,
      'createdAt': createdAt.toJson(),
      if (lastLoginAt != null) 'lastLoginAt': lastLoginAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AppUserImpl extends AppUser {
  _AppUserImpl({
    int? id,
    required String username,
    required String email,
    required String passwordHash,
    required int xp,
    required int level,
    required int eloRating,
    required int walletBalanceSat,
    required int totalWins,
    required int totalLosses,
    required bool isActive,
    required DateTime createdAt,
    DateTime? lastLoginAt,
  }) : super._(
          id: id,
          username: username,
          email: email,
          passwordHash: passwordHash,
          xp: xp,
          level: level,
          eloRating: eloRating,
          walletBalanceSat: walletBalanceSat,
          totalWins: totalWins,
          totalLosses: totalLosses,
          isActive: isActive,
          createdAt: createdAt,
          lastLoginAt: lastLoginAt,
        );

  /// Returns a shallow copy of this [AppUser]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AppUser copyWith({
    Object? id = _Undefined,
    String? username,
    String? email,
    String? passwordHash,
    int? xp,
    int? level,
    int? eloRating,
    int? walletBalanceSat,
    int? totalWins,
    int? totalLosses,
    bool? isActive,
    DateTime? createdAt,
    Object? lastLoginAt = _Undefined,
  }) {
    return AppUser(
      id: id is int? ? id : this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      eloRating: eloRating ?? this.eloRating,
      walletBalanceSat: walletBalanceSat ?? this.walletBalanceSat,
      totalWins: totalWins ?? this.totalWins,
      totalLosses: totalLosses ?? this.totalLosses,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt is DateTime? ? lastLoginAt : this.lastLoginAt,
    );
  }
}
