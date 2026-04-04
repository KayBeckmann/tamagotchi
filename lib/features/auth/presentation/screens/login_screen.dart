import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final formState = ref.watch(loginFormProvider);
    final authState = ref.watch(authProvider);

    // Navigate on successful login
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next is AuthAuthenticated) {
        context.go('/');
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo
                  Icon(
                    Icons.pets,
                    size: 80,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tamagotchi',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Willkommen zurück!',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 48),

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
                    onChanged: ref.read(loginFormProvider.notifier).setEmail,
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

                  // Password field
                  TextField(
                    onChanged: ref.read(loginFormProvider.notifier).setPassword,
                    obscureText: formState.obscurePassword,
                    textInputAction: TextInputAction.done,
                    enabled: !formState.isSubmitting,
                    onSubmitted: (_) => _handleLogin(ref, formState),
                    decoration: InputDecoration(
                      labelText: 'Passwort',
                      prefixIcon: const Icon(Icons.lock_outlined),
                      border: const OutlineInputBorder(),
                      errorText: formState.passwordError,
                      suffixIcon: IconButton(
                        icon: Icon(
                          formState.obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: ref.read(loginFormProvider.notifier).togglePasswordVisibility,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Forgot password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: formState.isSubmitting
                          ? null
                          : () => _showForgotPasswordDialog(context, ref),
                      child: const Text('Passwort vergessen?'),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Login button
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: formState.isSubmitting
                          ? null
                          : () => _handleLogin(ref, formState),
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
                            : const Text('Anmelden'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Register link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Noch kein Konto?',
                        style: theme.textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: formState.isSubmitting
                            ? null
                            : () => context.go('/register'),
                        child: const Text('Registrieren'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleLogin(WidgetRef ref, LoginFormState formState) {
    final notifier = ref.read(loginFormProvider.notifier);
    if (!notifier.validate()) return;

    notifier.setSubmitting(true);
    ref.read(authProvider.notifier).login(
      email: formState.email,
      password: formState.password,
    ).then((_) {
      notifier.setSubmitting(false);
    });
  }

  void _showForgotPasswordDialog(BuildContext context, WidgetRef ref) {
    final emailController = TextEditingController();
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Passwort zurücksetzen'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gib deine E-Mail-Adresse ein und wir senden dir einen Link zum Zurücksetzen deines Passworts.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'E-Mail',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () {
              // TODO: Implement password reset
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Wenn die E-Mail existiert, wurde ein Link gesendet.'),
                ),
              );
            },
            child: const Text('Senden'),
          ),
        ],
      ),
    );
  }
}
