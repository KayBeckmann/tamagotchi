import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/auth_repository.dart';

/// Authentication state.
sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final int userId;
  const AuthAuthenticated(this.userId);
}

class AuthUnauthenticated extends AuthState {
  final String? message;
  const AuthUnauthenticated([this.message]);
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}

/// Notifier for authentication state.
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthNotifier(this._authRepository) : super(const AuthInitial()) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final isAuthenticated = await _authRepository.isAuthenticated();
    if (isAuthenticated) {
      state = const AuthAuthenticated(1); // TODO: Get actual user ID
    } else {
      state = const AuthUnauthenticated();
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AuthLoading();

    final result = await _authRepository.login(
      email: email,
      password: password,
    );

    if (result.isSuccess) {
      state = AuthAuthenticated(result.userId!);
    } else {
      state = AuthError(result.errorMessage ?? 'Login fehlgeschlagen');
    }
  }

  Future<void> register({
    required String email,
    required String username,
    required String password,
  }) async {
    state = const AuthLoading();

    final result = await _authRepository.register(
      email: email,
      username: username,
      password: password,
    );

    if (result.isSuccess) {
      state = AuthAuthenticated(result.userId!);
    } else {
      state = AuthError(result.errorMessage ?? 'Registrierung fehlgeschlagen');
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    state = const AuthUnauthenticated();
  }

  void clearError() {
    if (state is AuthError) {
      state = const AuthUnauthenticated();
    }
  }
}

/// Provider for auth state.
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});

/// Login form state.
class LoginFormState {
  final String email;
  final String password;
  final bool obscurePassword;
  final bool isSubmitting;
  final String? emailError;
  final String? passwordError;

  const LoginFormState({
    this.email = '',
    this.password = '',
    this.obscurePassword = true,
    this.isSubmitting = false,
    this.emailError,
    this.passwordError,
  });

  LoginFormState copyWith({
    String? email,
    String? password,
    bool? obscurePassword,
    bool? isSubmitting,
    String? emailError,
    String? passwordError,
    bool clearEmailError = false,
    bool clearPasswordError = false,
  }) {
    return LoginFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      emailError: clearEmailError ? null : (emailError ?? this.emailError),
      passwordError: clearPasswordError ? null : (passwordError ?? this.passwordError),
    );
  }

  bool get isValid =>
      email.isNotEmpty &&
      password.isNotEmpty &&
      emailError == null &&
      passwordError == null;
}

/// Notifier for login form.
class LoginFormNotifier extends StateNotifier<LoginFormState> {
  LoginFormNotifier() : super(const LoginFormState());

  void setEmail(String email) {
    state = state.copyWith(email: email, clearEmailError: true);
  }

  void setPassword(String password) {
    state = state.copyWith(password: password, clearPasswordError: true);
  }

  void togglePasswordVisibility() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  void setSubmitting(bool isSubmitting) {
    state = state.copyWith(isSubmitting: isSubmitting);
  }

  bool validate() {
    String? emailError;
    String? passwordError;

    if (state.email.isEmpty) {
      emailError = 'E-Mail ist erforderlich';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(state.email)) {
      emailError = 'Ungültiges E-Mail-Format';
    }

    if (state.password.isEmpty) {
      passwordError = 'Passwort ist erforderlich';
    }

    state = state.copyWith(emailError: emailError, passwordError: passwordError);
    return emailError == null && passwordError == null;
  }

  void reset() {
    state = const LoginFormState();
  }
}

final loginFormProvider = StateNotifierProvider.autoDispose<LoginFormNotifier, LoginFormState>((ref) {
  return LoginFormNotifier();
});

/// Register form state.
class RegisterFormState {
  final String email;
  final String username;
  final String password;
  final String confirmPassword;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final bool isSubmitting;
  final bool acceptedTerms;
  final String? emailError;
  final String? usernameError;
  final String? passwordError;
  final String? confirmPasswordError;

  const RegisterFormState({
    this.email = '',
    this.username = '',
    this.password = '',
    this.confirmPassword = '',
    this.obscurePassword = true,
    this.obscureConfirmPassword = true,
    this.isSubmitting = false,
    this.acceptedTerms = false,
    this.emailError,
    this.usernameError,
    this.passwordError,
    this.confirmPasswordError,
  });

  RegisterFormState copyWith({
    String? email,
    String? username,
    String? password,
    String? confirmPassword,
    bool? obscurePassword,
    bool? obscureConfirmPassword,
    bool? isSubmitting,
    bool? acceptedTerms,
    String? emailError,
    String? usernameError,
    String? passwordError,
    String? confirmPasswordError,
    bool clearEmailError = false,
    bool clearUsernameError = false,
    bool clearPasswordError = false,
    bool clearConfirmPasswordError = false,
  }) {
    return RegisterFormState(
      email: email ?? this.email,
      username: username ?? this.username,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureConfirmPassword: obscureConfirmPassword ?? this.obscureConfirmPassword,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      acceptedTerms: acceptedTerms ?? this.acceptedTerms,
      emailError: clearEmailError ? null : (emailError ?? this.emailError),
      usernameError: clearUsernameError ? null : (usernameError ?? this.usernameError),
      passwordError: clearPasswordError ? null : (passwordError ?? this.passwordError),
      confirmPasswordError: clearConfirmPasswordError ? null : (confirmPasswordError ?? this.confirmPasswordError),
    );
  }
}

/// Notifier for register form.
class RegisterFormNotifier extends StateNotifier<RegisterFormState> {
  RegisterFormNotifier() : super(const RegisterFormState());

  void setEmail(String email) {
    state = state.copyWith(email: email, clearEmailError: true);
  }

  void setUsername(String username) {
    state = state.copyWith(username: username, clearUsernameError: true);
  }

  void setPassword(String password) {
    state = state.copyWith(password: password, clearPasswordError: true);
  }

  void setConfirmPassword(String confirmPassword) {
    state = state.copyWith(confirmPassword: confirmPassword, clearConfirmPasswordError: true);
  }

  void togglePasswordVisibility() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  void toggleConfirmPasswordVisibility() {
    state = state.copyWith(obscureConfirmPassword: !state.obscureConfirmPassword);
  }

  void setAcceptedTerms(bool accepted) {
    state = state.copyWith(acceptedTerms: accepted);
  }

  void setSubmitting(bool isSubmitting) {
    state = state.copyWith(isSubmitting: isSubmitting);
  }

  bool validate() {
    String? emailError;
    String? usernameError;
    String? passwordError;
    String? confirmPasswordError;

    // Email validation
    if (state.email.isEmpty) {
      emailError = 'E-Mail ist erforderlich';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(state.email)) {
      emailError = 'Ungültiges E-Mail-Format';
    }

    // Username validation
    if (state.username.isEmpty) {
      usernameError = 'Benutzername ist erforderlich';
    } else if (state.username.length < 3) {
      usernameError = 'Mindestens 3 Zeichen';
    } else if (state.username.length > 20) {
      usernameError = 'Maximal 20 Zeichen';
    } else if (!RegExp(r'^[a-zA-Z][a-zA-Z0-9_]*$').hasMatch(state.username)) {
      usernameError = 'Nur Buchstaben, Zahlen und Unterstriche';
    }

    // Password validation
    if (state.password.isEmpty) {
      passwordError = 'Passwort ist erforderlich';
    } else if (state.password.length < 8) {
      passwordError = 'Mindestens 8 Zeichen';
    } else if (!RegExp(r'[A-Z]').hasMatch(state.password)) {
      passwordError = 'Min. 1 Großbuchstabe erforderlich';
    } else if (!RegExp(r'[a-z]').hasMatch(state.password)) {
      passwordError = 'Min. 1 Kleinbuchstabe erforderlich';
    } else if (!RegExp(r'[0-9]').hasMatch(state.password)) {
      passwordError = 'Min. 1 Zahl erforderlich';
    }

    // Confirm password validation
    if (state.confirmPassword.isEmpty) {
      confirmPasswordError = 'Bitte Passwort bestätigen';
    } else if (state.confirmPassword != state.password) {
      confirmPasswordError = 'Passwörter stimmen nicht überein';
    }

    state = state.copyWith(
      emailError: emailError,
      usernameError: usernameError,
      passwordError: passwordError,
      confirmPasswordError: confirmPasswordError,
    );

    return emailError == null &&
           usernameError == null &&
           passwordError == null &&
           confirmPasswordError == null &&
           state.acceptedTerms;
  }

  void reset() {
    state = const RegisterFormState();
  }
}

final registerFormProvider = StateNotifierProvider.autoDispose<RegisterFormNotifier, RegisterFormState>((ref) {
  return RegisterFormNotifier();
});
