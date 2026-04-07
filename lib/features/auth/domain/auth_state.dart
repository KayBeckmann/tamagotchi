import 'package:tamagotchi_server_client/tamagotchi_server_client.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState {
  final AuthStatus status;
  final AppUser? user;
  final String? accessToken;
  final String? refreshToken;
  final String? error;
  final bool isLoading;

  const AuthState({
    this.status = AuthStatus.unknown,
    this.user,
    this.accessToken,
    this.refreshToken,
    this.error,
    this.isLoading = false,
  });

  const AuthState.initial()
      : status = AuthStatus.unknown,
        user = null,
        accessToken = null,
        refreshToken = null,
        error = null,
        isLoading = true;

  AuthState copyWith({
    AuthStatus? status,
    AppUser? user,
    String? accessToken,
    String? refreshToken,
    String? error,
    bool? isLoading,
    bool clearError = false,
    bool clearUser = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: clearUser ? null : (user ?? this.user),
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      error: clearError ? null : (error ?? this.error),
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
