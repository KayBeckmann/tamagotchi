import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/auth_repository.dart';

/// State for forgot password form.
class ForgotPasswordState {
  final String email;
  final bool isSubmitting;
  final bool isSuccess;
  final String? error;

  const ForgotPasswordState({
    this.email = '',
    this.isSubmitting = false,
    this.isSuccess = false,
    this.error,
  });

  ForgotPasswordState copyWith({
    String? email,
    bool? isSubmitting,
    bool? isSuccess,
    String? error,
    bool clearError = false,
  }) {
    return ForgotPasswordState(
      email: email ?? this.email,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class ForgotPasswordNotifier extends StateNotifier<ForgotPasswordState> {
  final AuthRepository _authRepository;

  ForgotPasswordNotifier(this._authRepository) : super(const ForgotPasswordState());

  void setEmail(String email) {
    state = state.copyWith(email: email, clearError: true);
  }

  Future<void> submit() async {
    if (state.email.isEmpty) {
      state = state.copyWith(error: 'E-Mail ist erforderlich');
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(state.email)) {
      state = state.copyWith(error: 'Ungültiges E-Mail-Format');
      return;
    }

    state = state.copyWith(isSubmitting: true, clearError: true);

    try {
      await _authRepository.requestPasswordReset(state.email);
      state = state.copyWith(isSubmitting: false, isSuccess: true);
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        error: 'Ein Fehler ist aufgetreten. Bitte versuche es später erneut.',
      );
    }
  }

  void reset() {
    state = const ForgotPasswordState();
  }
}

final forgotPasswordProvider = StateNotifierProvider.autoDispose<ForgotPasswordNotifier, ForgotPasswordState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return ForgotPasswordNotifier(repository);
});

class ForgotPasswordScreen extends ConsumerWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(forgotPasswordProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Passwort zurücksetzen'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/login'),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: state.isSuccess
                  ? _buildSuccessContent(context, theme)
                  : _buildFormContent(context, ref, theme, state),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessContent(BuildContext context, ThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.mark_email_read_outlined,
          size: 80,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 24),
        Text(
          'E-Mail gesendet!',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Wenn ein Konto mit dieser E-Mail-Adresse existiert, haben wir dir einen Link zum Zurücksetzen deines Passworts gesendet.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Bitte überprüfe auch deinen Spam-Ordner.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () => context.go('/login'),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text('Zurück zum Login'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormContent(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    ForgotPasswordState state,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.lock_reset_outlined,
          size: 64,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 16),
        Text(
          'Passwort vergessen?',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Gib deine E-Mail-Adresse ein und wir senden dir einen Link zum Zurücksetzen deines Passworts.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),

        // Error message
        if (state.error != null) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  color: theme.colorScheme.onErrorContainer,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    state.error!,
                    style: TextStyle(
                      color: theme.colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Email field
        TextField(
          onChanged: ref.read(forgotPasswordProvider.notifier).setEmail,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          enabled: !state.isSubmitting,
          onSubmitted: (_) => ref.read(forgotPasswordProvider.notifier).submit(),
          decoration: const InputDecoration(
            labelText: 'E-Mail',
            hintText: 'deine@email.de',
            prefixIcon: Icon(Icons.email_outlined),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 24),

        // Submit button
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: state.isSubmitting
                ? null
                : () => ref.read(forgotPasswordProvider.notifier).submit(),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: state.isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Link senden'),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Back to login
        TextButton(
          onPressed: state.isSubmitting ? null : () => context.go('/login'),
          child: const Text('Zurück zum Login'),
        ),
      ],
    );
  }
}
