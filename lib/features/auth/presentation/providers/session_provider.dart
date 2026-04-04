import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Session management provider for secure token storage.
class SessionManager {
  final FlutterSecureStorage _secureStorage;

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _userIdKey = 'user_id';
  static const _lastActivityKey = 'last_activity';

  SessionManager({FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  /// Check if user has an active session.
  Future<bool> hasActiveSession() async {
    final token = await _secureStorage.read(key: _accessTokenKey);
    if (token == null) return false;

    // Check for session timeout (optional)
    final lastActivity = await _secureStorage.read(key: _lastActivityKey);
    if (lastActivity != null) {
      final lastActivityTime = DateTime.tryParse(lastActivity);
      if (lastActivityTime != null) {
        final sessionTimeout = const Duration(days: 7);
        if (DateTime.now().difference(lastActivityTime) > sessionTimeout) {
          await clearSession();
          return false;
        }
      }
    }

    return true;
  }

  /// Get the stored access token.
  Future<String?> getAccessToken() async {
    return _secureStorage.read(key: _accessTokenKey);
  }

  /// Get the stored refresh token.
  Future<String?> getRefreshToken() async {
    return _secureStorage.read(key: _refreshTokenKey);
  }

  /// Get the stored user ID.
  Future<int?> getUserId() async {
    final userId = await _secureStorage.read(key: _userIdKey);
    return userId != null ? int.tryParse(userId) : null;
  }

  /// Store session data.
  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    required int userId,
  }) async {
    await Future.wait([
      _secureStorage.write(key: _accessTokenKey, value: accessToken),
      _secureStorage.write(key: _refreshTokenKey, value: refreshToken),
      _secureStorage.write(key: _userIdKey, value: userId.toString()),
      _secureStorage.write(key: _lastActivityKey, value: DateTime.now().toIso8601String()),
    ]);
  }

  /// Update last activity timestamp.
  Future<void> updateLastActivity() async {
    await _secureStorage.write(
      key: _lastActivityKey,
      value: DateTime.now().toIso8601String(),
    );
  }

  /// Clear all session data.
  Future<void> clearSession() async {
    await Future.wait([
      _secureStorage.delete(key: _accessTokenKey),
      _secureStorage.delete(key: _refreshTokenKey),
      _secureStorage.delete(key: _userIdKey),
      _secureStorage.delete(key: _lastActivityKey),
    ]);
  }
}

/// Provider for SessionManager.
final sessionManagerProvider = Provider<SessionManager>((ref) {
  return SessionManager();
});

/// Provider for checking if user is authenticated.
final isAuthenticatedProvider = FutureProvider<bool>((ref) async {
  final sessionManager = ref.watch(sessionManagerProvider);
  return sessionManager.hasActiveSession();
});
