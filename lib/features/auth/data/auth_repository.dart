import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Repository for authentication operations.
///
/// Handles:
/// - Login/Logout
/// - Registration
/// - Token storage
/// - Session management
class AuthRepository {
  final FlutterSecureStorage _secureStorage;
  SharedPreferences? _prefs;

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _userIdKey = 'user_id';

  AuthRepository({FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  Future<SharedPreferences> get _sharedPrefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // Use SharedPreferences for web, FlutterSecureStorage for mobile
  Future<String?> _read(String key) async {
    if (kIsWeb) {
      final prefs = await _sharedPrefs;
      return prefs.getString(key);
    }
    return _secureStorage.read(key: key);
  }

  Future<void> _write(String key, String value) async {
    if (kIsWeb) {
      final prefs = await _sharedPrefs;
      await prefs.setString(key, value);
    } else {
      await _secureStorage.write(key: key, value: value);
    }
  }

  Future<void> _delete(String key) async {
    if (kIsWeb) {
      final prefs = await _sharedPrefs;
      await prefs.remove(key);
    } else {
      await _secureStorage.delete(key: key);
    }
  }

  /// Login with email and password.
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    // TODO: Replace with actual API call to server
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Mock validation
    if (email.isEmpty || password.isEmpty) {
      return AuthResult.failure('E-Mail und Passwort sind erforderlich');
    }

    // Mock successful login
    if (email == 'test@example.com' && password == 'Test123!') {
      await _storeTokens(
        accessToken: 'mock_access_token',
        refreshToken: 'mock_refresh_token',
        userId: 1,
      );
      return AuthResult.success(userId: 1);
    }

    return AuthResult.failure('Ungültige E-Mail oder Passwort');
  }

  /// Register a new user.
  Future<AuthResult> register({
    required String email,
    required String username,
    required String password,
  }) async {
    // TODO: Replace with actual API call to server
    await Future.delayed(const Duration(seconds: 1));

    // Mock validation
    if (email.isEmpty || username.isEmpty || password.isEmpty) {
      return AuthResult.failure('Alle Felder sind erforderlich');
    }

    // Validate email format
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return AuthResult.failure('Ungültiges E-Mail-Format');
    }

    // Validate username
    if (username.length < 3) {
      return AuthResult.failure('Benutzername muss mindestens 3 Zeichen lang sein');
    }

    // Validate password strength
    if (password.length < 8) {
      return AuthResult.failure('Passwort muss mindestens 8 Zeichen lang sein');
    }

    // Mock successful registration
    await _storeTokens(
      accessToken: 'mock_access_token',
      refreshToken: 'mock_refresh_token',
      userId: 1,
    );
    return AuthResult.success(userId: 1);
  }

  /// Logout and clear stored tokens.
  Future<void> logout() async {
    await _delete(_accessTokenKey);
    await _delete(_refreshTokenKey);
    await _delete(_userIdKey);
  }

  /// Request password reset email.
  Future<bool> requestPasswordReset(String email) async {
    // TODO: Replace with actual API call
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  /// Check if user is authenticated.
  Future<bool> isAuthenticated() async {
    try {
      final token = await _read(_accessTokenKey);
      return token != null;
    } catch (e) {
      // On web, storage might fail initially
      return false;
    }
  }

  /// Get stored access token.
  Future<String?> getAccessToken() async {
    return _read(_accessTokenKey);
  }

  /// Store authentication tokens.
  Future<void> _storeTokens({
    required String accessToken,
    required String refreshToken,
    required int userId,
  }) async {
    await _write(_accessTokenKey, accessToken);
    await _write(_refreshTokenKey, refreshToken);
    await _write(_userIdKey, userId.toString());
  }
}

/// Result of an authentication operation.
class AuthResult {
  final bool isSuccess;
  final int? userId;
  final String? errorMessage;

  AuthResult._({
    required this.isSuccess,
    this.userId,
    this.errorMessage,
  });

  factory AuthResult.success({required int userId}) {
    return AuthResult._(isSuccess: true, userId: userId);
  }

  factory AuthResult.failure(String message) {
    return AuthResult._(isSuccess: false, errorMessage: message);
  }
}

/// Provider for AuthRepository.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});
