import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tamagotchi_server_client/tamagotchi_server_client.dart';

import '../../../core/services/serverpod_client.dart';
import '../../../core/services/secure_storage_service.dart';
import '../domain/auth_state.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    client: ref.watch(clientProvider),
    storage: ref.watch(secureStorageProvider),
  );
});

class AuthNotifier extends StateNotifier<AuthState> {
  final Client client;
  final SecureStorageService storage;

  AuthNotifier({required this.client, required this.storage})
      : super(const AuthState.initial()) {
    _tryRestoreSession();
  }

  /// Try to restore a session from secure storage on app start.
  Future<void> _tryRestoreSession() async {
    try {
      final refreshToken = await storage.getRefreshToken();
      if (refreshToken == null) {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          isLoading: false,
        );
        return;
      }

      // Try to refresh the token
      final response = await client.auth.refreshToken(refreshToken);
      await _handleAuthResponse(response);
    } catch (_) {
      await storage.clearAll();
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        isLoading: false,
      );
    }
  }

  /// Register a new user account.
  Future<void> register({
    required String username,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final response = await client.auth.register(username, email, password);
      await _handleAuthResponse(response);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _extractError(e),
      );
    }
  }

  /// Login with email and password.
  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final response = await client.auth.login(email, password);
      await _handleAuthResponse(response);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _extractError(e),
      );
    }
  }

  /// Logout the current user.
  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    try {
      final refreshToken = await storage.getRefreshToken();
      if (refreshToken != null) {
        await client.auth.logout(refreshToken);
      }
    } catch (_) {
      // Ignore logout errors
    } finally {
      await storage.clearAll();
      state = const AuthState(
        status: AuthStatus.unauthenticated,
        isLoading: false,
      );
    }
  }

  /// Delete the user account.
  Future<void> deleteAccount(String password) async {
    final userId = state.user?.id;
    if (userId == null) return;

    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await client.auth.deleteAccount(userId, password);
      await storage.clearAll();
      state = const AuthState(
        status: AuthStatus.unauthenticated,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _extractError(e),
      );
    }
  }

  /// Refresh the access token.
  Future<bool> refreshAccessToken() async {
    try {
      final refreshToken = await storage.getRefreshToken();
      if (refreshToken == null) return false;

      final response = await client.auth.refreshToken(refreshToken);
      await _handleAuthResponse(response);
      return true;
    } catch (_) {
      await logout();
      return false;
    }
  }

  Future<void> _handleAuthResponse(AuthResponse response) async {
    await storage.saveTokens(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
      userId: response.user.id!,
    );

    state = AuthState(
      status: AuthStatus.authenticated,
      user: response.user,
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
      isLoading: false,
    );
  }

  String _extractError(dynamic e) {
    final msg = e.toString();
    // Serverpod wraps exceptions - extract the message
    if (msg.contains('ArgumentError')) {
      final match = RegExp(r'Invalid argument\(s\): (.+)').firstMatch(msg);
      if (match != null) return match.group(1)!;
    }
    if (msg.contains('ServerpodClientException')) {
      return 'Verbindungsfehler. Bitte versuche es erneut.';
    }
    return 'Ein unerwarteter Fehler ist aufgetreten.';
  }
}
