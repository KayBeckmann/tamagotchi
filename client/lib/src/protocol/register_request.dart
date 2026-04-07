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

/// Request body for user registration.
abstract class RegisterRequest implements _i1.SerializableModel {
  RegisterRequest._({
    required this.username,
    required this.email,
    required this.password,
  });

  factory RegisterRequest({
    required String username,
    required String email,
    required String password,
  }) = _RegisterRequestImpl;

  factory RegisterRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return RegisterRequest(
      username: jsonSerialization['username'] as String,
      email: jsonSerialization['email'] as String,
      password: jsonSerialization['password'] as String,
    );
  }

  /// Desired username.
  String username;

  /// Email address.
  String email;

  /// Plain-text password (will be hashed server-side).
  String password;

  /// Returns a shallow copy of this [RegisterRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RegisterRequest copyWith({
    String? username,
    String? email,
    String? password,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _RegisterRequestImpl extends RegisterRequest {
  _RegisterRequestImpl({
    required String username,
    required String email,
    required String password,
  }) : super._(
          username: username,
          email: email,
          password: password,
        );

  /// Returns a shallow copy of this [RegisterRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RegisterRequest copyWith({
    String? username,
    String? email,
    String? password,
  }) {
    return RegisterRequest(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
