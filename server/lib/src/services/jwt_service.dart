import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

/// Service for JWT token generation and validation.
///
/// Implements JWT with HS256 signing algorithm.
class JwtService {
  final String _secretKey;
  final Duration _accessTokenExpiry;
  final Duration _refreshTokenExpiry;

  JwtService({
    required String secretKey,
    Duration accessTokenExpiry = const Duration(minutes: 15),
    Duration refreshTokenExpiry = const Duration(days: 7),
  })  : _secretKey = secretKey,
        _accessTokenExpiry = accessTokenExpiry,
        _refreshTokenExpiry = refreshTokenExpiry;

  /// Generate a JWT access token for a user.
  String generateAccessToken({
    required int userId,
    required String email,
    Map<String, dynamic>? additionalClaims,
  }) {
    final now = DateTime.now().toUtc();
    final expiry = now.add(_accessTokenExpiry);

    final payload = <String, dynamic>{
      'sub': userId.toString(),
      'email': email,
      'iat': now.millisecondsSinceEpoch ~/ 1000,
      'exp': expiry.millisecondsSinceEpoch ~/ 1000,
      'type': 'access',
      ...?additionalClaims,
    };

    return _createToken(payload);
  }

  /// Generate a refresh token.
  String generateRefreshToken({
    required int userId,
  }) {
    final now = DateTime.now().toUtc();
    final expiry = now.add(_refreshTokenExpiry);

    final payload = <String, dynamic>{
      'sub': userId.toString(),
      'iat': now.millisecondsSinceEpoch ~/ 1000,
      'exp': expiry.millisecondsSinceEpoch ~/ 1000,
      'type': 'refresh',
      'jti': _generateTokenId(),
    };

    return _createToken(payload);
  }

  /// Validate a token and return its payload.
  TokenValidationResult validateToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        return TokenValidationResult.invalid('Invalid token format');
      }

      final header = parts[0];
      final payload = parts[1];
      final signature = parts[2];

      // Verify signature
      final expectedSignature = _sign('$header.$payload');
      if (signature != expectedSignature) {
        return TokenValidationResult.invalid('Invalid signature');
      }

      // Decode payload
      final payloadJson = _base64UrlDecode(payload);
      final payloadMap = json.decode(payloadJson) as Map<String, dynamic>;

      // Check expiration
      final exp = payloadMap['exp'] as int;
      final expiry = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      if (DateTime.now().toUtc().isAfter(expiry)) {
        return TokenValidationResult.expired();
      }

      return TokenValidationResult.valid(payloadMap);
    } catch (e) {
      return TokenValidationResult.invalid('Token validation failed: $e');
    }
  }

  /// Extract user ID from a valid token.
  int? getUserIdFromToken(String token) {
    final result = validateToken(token);
    if (!result.isValid) return null;

    final sub = result.payload?['sub'] as String?;
    return sub != null ? int.tryParse(sub) : null;
  }

  /// Create a JWT token from payload.
  String _createToken(Map<String, dynamic> payload) {
    final header = {
      'alg': 'HS256',
      'typ': 'JWT',
    };

    final headerB64 = _base64UrlEncode(json.encode(header));
    final payloadB64 = _base64UrlEncode(json.encode(payload));
    final signature = _sign('$headerB64.$payloadB64');

    return '$headerB64.$payloadB64.$signature';
  }

  /// Sign data using HMAC-SHA256.
  String _sign(String data) {
    final key = utf8.encode(_secretKey);
    final bytes = utf8.encode(data);
    final hmac = Hmac(sha256, key);
    final digest = hmac.convert(bytes);
    return _base64UrlEncode(String.fromCharCodes(digest.bytes));
  }

  /// Generate a unique token ID.
  String _generateTokenId() {
    final random = Random.secure();
    final values = List<int>.generate(16, (i) => random.nextInt(256));
    return base64UrlEncode(values);
  }

  /// Base64URL encode without padding.
  String _base64UrlEncode(String data) {
    return base64UrlEncode(utf8.encode(data))
        .replaceAll('=', '')
        .replaceAll('+', '-')
        .replaceAll('/', '_');
  }

  /// Base64URL decode.
  String _base64UrlDecode(String data) {
    var padded = data.replaceAll('-', '+').replaceAll('_', '/');
    switch (padded.length % 4) {
      case 2:
        padded += '==';
        break;
      case 3:
        padded += '=';
        break;
    }
    return utf8.decode(base64Decode(padded));
  }
}

/// Result of token validation.
class TokenValidationResult {
  final bool isValid;
  final bool isExpired;
  final String? error;
  final Map<String, dynamic>? payload;

  TokenValidationResult._({
    required this.isValid,
    this.isExpired = false,
    this.error,
    this.payload,
  });

  factory TokenValidationResult.valid(Map<String, dynamic> payload) {
    return TokenValidationResult._(
      isValid: true,
      payload: payload,
    );
  }

  factory TokenValidationResult.invalid(String error) {
    return TokenValidationResult._(
      isValid: false,
      error: error,
    );
  }

  factory TokenValidationResult.expired() {
    return TokenValidationResult._(
      isValid: false,
      isExpired: true,
      error: 'Token has expired',
    );
  }
}
