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
import 'app_user.dart' as _i2;

/// Response returned after successful login or token refresh.
abstract class AuthResponse implements _i1.SerializableModel {
  AuthResponse._({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
  });

  factory AuthResponse({
    required _i2.AppUser user,
    required String accessToken,
    required String refreshToken,
    required DateTime expiresAt,
  }) = _AuthResponseImpl;

  factory AuthResponse.fromJson(Map<String, dynamic> jsonSerialization) {
    return AuthResponse(
      user: _i2.AppUser.fromJson(
          (jsonSerialization['user'] as Map<String, dynamic>)),
      accessToken: jsonSerialization['accessToken'] as String,
      refreshToken: jsonSerialization['refreshToken'] as String,
      expiresAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['expiresAt']),
    );
  }

  /// The authenticated user's data.
  _i2.AppUser user;

  /// JWT access token for API calls.
  String accessToken;

  /// Refresh token for obtaining new access tokens.
  String refreshToken;

  /// Access token expiration time.
  DateTime expiresAt;

  /// Returns a shallow copy of this [AuthResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AuthResponse copyWith({
    _i2.AppUser? user,
    String? accessToken,
    String? refreshToken,
    DateTime? expiresAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expiresAt': expiresAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _AuthResponseImpl extends AuthResponse {
  _AuthResponseImpl({
    required _i2.AppUser user,
    required String accessToken,
    required String refreshToken,
    required DateTime expiresAt,
  }) : super._(
          user: user,
          accessToken: accessToken,
          refreshToken: refreshToken,
          expiresAt: expiresAt,
        );

  /// Returns a shallow copy of this [AuthResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AuthResponse copyWith({
    _i2.AppUser? user,
    String? accessToken,
    String? refreshToken,
    DateTime? expiresAt,
  }) {
    return AuthResponse(
      user: user ?? this.user.copyWith(),
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }
}
