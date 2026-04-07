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

/// Stores refresh tokens for user sessions.
abstract class AuthToken implements _i1.SerializableModel {
  AuthToken._({
    this.id,
    required this.userId,
    required this.tokenHash,
    required this.expiresAt,
    this.deviceInfo,
    required this.createdAt,
  });

  factory AuthToken({
    int? id,
    required int userId,
    required String tokenHash,
    required DateTime expiresAt,
    String? deviceInfo,
    required DateTime createdAt,
  }) = _AuthTokenImpl;

  factory AuthToken.fromJson(Map<String, dynamic> jsonSerialization) {
    return AuthToken(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      tokenHash: jsonSerialization['tokenHash'] as String,
      expiresAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['expiresAt']),
      deviceInfo: jsonSerialization['deviceInfo'] as String?,
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Reference to the user who owns this token.
  int userId;

  /// The hashed refresh token string.
  String tokenHash;

  /// When the refresh token expires.
  DateTime expiresAt;

  /// Device or client identifier.
  String? deviceInfo;

  /// Timestamp when the token was created.
  DateTime createdAt;

  /// Returns a shallow copy of this [AuthToken]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AuthToken copyWith({
    int? id,
    int? userId,
    String? tokenHash,
    DateTime? expiresAt,
    String? deviceInfo,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'tokenHash': tokenHash,
      'expiresAt': expiresAt.toJson(),
      if (deviceInfo != null) 'deviceInfo': deviceInfo,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AuthTokenImpl extends AuthToken {
  _AuthTokenImpl({
    int? id,
    required int userId,
    required String tokenHash,
    required DateTime expiresAt,
    String? deviceInfo,
    required DateTime createdAt,
  }) : super._(
          id: id,
          userId: userId,
          tokenHash: tokenHash,
          expiresAt: expiresAt,
          deviceInfo: deviceInfo,
          createdAt: createdAt,
        );

  /// Returns a shallow copy of this [AuthToken]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AuthToken copyWith({
    Object? id = _Undefined,
    int? userId,
    String? tokenHash,
    DateTime? expiresAt,
    Object? deviceInfo = _Undefined,
    DateTime? createdAt,
  }) {
    return AuthToken(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      tokenHash: tokenHash ?? this.tokenHash,
      expiresAt: expiresAt ?? this.expiresAt,
      deviceInfo: deviceInfo is String? ? deviceInfo : this.deviceInfo,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
