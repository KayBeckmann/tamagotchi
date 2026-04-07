import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/auth_service.dart';

class AuthEndpoint extends Endpoint {
  /// Register a new user account.
  Future<AuthResponse> register(
    Session session,
    String username,
    String email,
    String password,
  ) async {
    return AuthService.register(
      session,
      username: username,
      email: email,
      password: password,
    );
  }

  /// Login with email and password.
  Future<AuthResponse> login(
    Session session,
    String email,
    String password,
  ) async {
    return AuthService.login(
      session,
      email: email,
      password: password,
    );
  }

  /// Refresh the access token using a refresh token.
  Future<AuthResponse> refreshToken(
    Session session,
    String refreshToken,
  ) async {
    return AuthService.refreshToken(
      session,
      refreshToken: refreshToken,
    );
  }

  /// Logout - invalidate the refresh token.
  Future<void> logout(
    Session session,
    String refreshToken,
  ) async {
    await AuthService.logout(
      session,
      refreshToken: refreshToken,
    );
  }

  /// Logout from all devices.
  Future<void> logoutAll(
    Session session,
    int userId,
  ) async {
    await AuthService.logoutAll(session, userId: userId);
  }

  /// Delete user account (GDPR compliant).
  Future<void> deleteAccount(
    Session session,
    int userId,
    String password,
  ) async {
    await AuthService.deleteAccount(
      session,
      userId: userId,
      password: password,
    );
  }

  /// Get current user profile by ID.
  Future<AppUser?> getProfile(
    Session session,
    int userId,
  ) async {
    final user = await AppUser.db.findById(session, userId);
    if (user == null) return null;
    // Strip password hash
    return user.copyWith(passwordHash: '');
  }
}
