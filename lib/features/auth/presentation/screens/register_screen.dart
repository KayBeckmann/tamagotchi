import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';

class RegisterScreen extends ConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final formState = ref.watch(registerFormProvider);
    final authState = ref.watch(authProvider);

    // Navigate on successful registration
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next is AuthAuthenticated) {
        context.go('/creature-selection');
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrieren'),
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Icon(
                    Icons.person_add_outlined,
                    size: 64,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Konto erstellen',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Erstelle ein Konto, um dein Tamagotchi zu starten',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Error message
                  if (authState is AuthError) ...[
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
                              authState.message,
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
                    onChanged: ref.read(registerFormProvider.notifier).setEmail,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    enabled: !formState.isSubmitting,
                    decoration: InputDecoration(
                      labelText: 'E-Mail',
                      hintText: 'deine@email.de',
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: const OutlineInputBorder(),
                      errorText: formState.emailError,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Username field
                  TextField(
                    onChanged: ref.read(registerFormProvider.notifier).setUsername,
                    textInputAction: TextInputAction.next,
                    enabled: !formState.isSubmitting,
                    decoration: InputDecoration(
                      labelText: 'Benutzername',
                      hintText: 'dein_name',
                      prefixIcon: const Icon(Icons.person_outlined),
                      border: const OutlineInputBorder(),
                      errorText: formState.usernameError,
                      helperText: '3-20 Zeichen, Buchstaben, Zahlen, Unterstriche',
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Password field
                  TextField(
                    onChanged: ref.read(registerFormProvider.notifier).setPassword,
                    obscureText: formState.obscurePassword,
                    textInputAction: TextInputAction.next,
                    enabled: !formState.isSubmitting,
                    decoration: InputDecoration(
                      labelText: 'Passwort',
                      prefixIcon: const Icon(Icons.lock_outlined),
                      border: const OutlineInputBorder(),
                      errorText: formState.passwordError,
                      helperText: 'Min. 8 Zeichen, Groß-/Kleinbuchstaben, Zahl',
                      suffixIcon: IconButton(
                        icon: Icon(
                          formState.obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: ref.read(registerFormProvider.notifier).togglePasswordVisibility,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Confirm password field
                  TextField(
                    onChanged: ref.read(registerFormProvider.notifier).setConfirmPassword,
                    obscureText: formState.obscureConfirmPassword,
                    textInputAction: TextInputAction.done,
                    enabled: !formState.isSubmitting,
                    onSubmitted: (_) => _handleRegister(ref, formState),
                    decoration: InputDecoration(
                      labelText: 'Passwort bestätigen',
                      prefixIcon: const Icon(Icons.lock_outlined),
                      border: const OutlineInputBorder(),
                      errorText: formState.confirmPasswordError,
                      suffixIcon: IconButton(
                        icon: Icon(
                          formState.obscureConfirmPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: ref.read(registerFormProvider.notifier).toggleConfirmPasswordVisibility,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Terms checkbox
                  CheckboxListTile(
                    value: formState.acceptedTerms,
                    onChanged: formState.isSubmitting
                        ? null
                        : (value) => ref.read(registerFormProvider.notifier).setAcceptedTerms(value ?? false),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    title: Text.rich(
                      TextSpan(
                        text: 'Ich akzeptiere die ',
                        style: theme.textTheme.bodySmall,
                        children: [
                          TextSpan(
                            text: 'Nutzungsbedingungen',
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          const TextSpan(text: ' und '),
                          TextSpan(
                            text: 'Datenschutzerklärung',
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Register button
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: formState.isSubmitting || !formState.acceptedTerms
                          ? null
                          : () => _handleRegister(ref, formState),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: formState.isSubmitting
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Registrieren'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Login link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Bereits ein Konto?',
                        style: theme.textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: formState.isSubmitting
                            ? null
                            : () => context.go('/login'),
                        child: const Text('Anmelden'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleRegister(WidgetRef ref, RegisterFormState formState) {
    final notifier = ref.read(registerFormProvider.notifier);
    if (!notifier.validate()) return;

    notifier.setSubmitting(true);
    ref.read(authProvider.notifier).register(
      email: formState.email,
      username: formState.username,
      password: formState.password,
    ).then((_) {
      notifier.setSubmitting(false);
    });
  }
}
