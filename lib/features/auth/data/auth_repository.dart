import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Repository for authentication operations.
///
/// Handles:
/// - Login/Logout
/// - Registration
/// - Token storage
/// - Session management
class AuthRepository {
  final FlutterSecureStorage _secureStorage;

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _userIdKey = 'user_id';

  AuthRepository({FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ?? const FlutterSecureStorage();

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
    await _secureStorage.delete(key: _accessTokenKey);
    await _secureStorage.delete(key: _refreshTokenKey);
    await _secureStorage.delete(key: _userIdKey);
  }

  /// Request password reset email.
  Future<bool> requestPasswordReset(String email) async {
    // TODO: Replace with actual API call
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  /// Check if user is authenticated.
  Future<bool> isAuthenticated() async {
    final token = await _secureStorage.read(key: _accessTokenKey);
    return token != null;
  }

  /// Get stored access token.
  Future<String?> getAccessToken() async {
    return _secureStorage.read(key: _accessTokenKey);
  }

  /// Store authentication tokens.
  Future<void> _storeTokens({
    required String accessToken,
    required String refreshToken,
    required int userId,
  }) async {
    await _secureStorage.write(key: _accessTokenKey, value: accessToken);
    await _secureStorage.write(key: _refreshTokenKey, value: refreshToken);
    await _secureStorage.write(key: _userIdKey, value: userId.toString());
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
