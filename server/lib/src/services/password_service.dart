import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

/// Service for secure password hashing and verification.
///
/// Uses PBKDF2 with SHA-256 for password hashing.
class PasswordService {
  static const int _saltLength = 32;
  static const int _iterations = 100000;
  static const int _keyLength = 64;

  /// Generate a cryptographically secure random salt.
  static String generateSalt() {
    final random = Random.secure();
    final saltBytes = Uint8List(_saltLength);
    for (var i = 0; i < _saltLength; i++) {
      saltBytes[i] = random.nextInt(256);
    }
    return base64Encode(saltBytes);
  }

  /// Hash a password with the given salt using PBKDF2.
  static String hashPassword(String password, String salt) {
    final saltBytes = base64Decode(salt);
    final passwordBytes = utf8.encode(password);

    // PBKDF2 implementation using HMAC-SHA256
    final hmac = Hmac(sha256, passwordBytes);
    var block = Uint8List(saltBytes.length + 4);
    block.setRange(0, saltBytes.length, saltBytes);

    var derivedKey = Uint8List(_keyLength);
    var blockCount = (_keyLength / 32).ceil();

    for (var blockNum = 1; blockNum <= blockCount; blockNum++) {
      // Set block number (big-endian)
      block[saltBytes.length] = (blockNum >> 24) & 0xff;
      block[saltBytes.length + 1] = (blockNum >> 16) & 0xff;
      block[saltBytes.length + 2] = (blockNum >> 8) & 0xff;
      block[saltBytes.length + 3] = blockNum & 0xff;

      var u = hmac.convert(block).bytes;
      var t = Uint8List.fromList(u);

      for (var i = 1; i < _iterations; i++) {
        u = hmac.convert(u).bytes;
        for (var j = 0; j < t.length; j++) {
          t[j] ^= u[j];
        }
      }

      var offset = (blockNum - 1) * 32;
      var length = min(32, _keyLength - offset);
      derivedKey.setRange(offset, offset + length, t);
    }

    return base64Encode(derivedKey);
  }

  /// Verify a password against a stored hash.
  static bool verifyPassword(String password, String salt, String storedHash) {
    final computedHash = hashPassword(password, salt);
    return _secureCompare(computedHash, storedHash);
  }

  /// Constant-time string comparison to prevent timing attacks.
  static bool _secureCompare(String a, String b) {
    if (a.length != b.length) return false;

    var result = 0;
    for (var i = 0; i < a.length; i++) {
      result |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return result == 0;
  }

  /// Validate password strength.
  ///
  /// Requirements:
  /// - Minimum 8 characters
  /// - At least one uppercase letter
  /// - At least one lowercase letter
  /// - At least one digit
  /// - At least one special character
  static PasswordValidation validatePassword(String password) {
    final errors = <String>[];

    if (password.length < 8) {
      errors.add('Password must be at least 8 characters long');
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      errors.add('Password must contain at least one uppercase letter');
    }
    if (!password.contains(RegExp(r'[a-z]'))) {
      errors.add('Password must contain at least one lowercase letter');
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      errors.add('Password must contain at least one digit');
    }
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      errors.add('Password must contain at least one special character');
    }

    return PasswordValidation(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }
}

/// Result of password validation.
class PasswordValidation {
  final bool isValid;
  final List<String> errors;

  PasswordValidation({
    required this.isValid,
    required this.errors,
  });
}
