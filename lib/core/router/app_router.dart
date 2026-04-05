import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/creature/presentation/screens/home_screen.dart';
import '../../features/creature/presentation/screens/creature_selection_screen.dart';
import '../../features/arena/presentation/screens/arena_screen.dart';
import '../../features/tournament/presentation/screens/tournament_screen.dart';
import '../../features/shop/presentation/screens/shop_screen.dart';
import '../../features/inventory/presentation/screens/inventory_screen.dart';
import '../../features/social/presentation/screens/social_screen.dart';
import '../../features/wallet/presentation/screens/wallet_screen.dart';
import '../widgets/app_shell.dart';

/// Routes that don't require authentication.
const _publicRoutes = ['/login', '/register', '/forgot-password'];

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: GoRouterRefreshStream(ref, authProvider),
    redirect: (context, state) {
      final isAuthenticated = authState is AuthAuthenticated;
      final isPublicRoute = _publicRoutes.contains(state.matchedLocation);

      // If not authenticated and trying to access protected route
      if (!isAuthenticated && !isPublicRoute) {
        return '/login';
      }

      // If authenticated and trying to access login/register
      if (isAuthenticated && isPublicRoute) {
        return '/';
      }

      return null;
    },
    routes: [
      // Public routes (no authentication required)
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        name: 'forgotPassword',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      // Protected routes (authentication required)
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/creature-selection',
            name: 'creatureSelection',
            builder: (context, state) => const CreatureSelectionScreen(),
          ),
          GoRoute(
            path: '/arena',
            name: 'arena',
            builder: (context, state) => const ArenaScreen(),
          ),
          GoRoute(
            path: '/tournament',
            name: 'tournament',
            builder: (context, state) => const TournamentScreen(),
          ),
          GoRoute(
            path: '/shop',
            name: 'shop',
            builder: (context, state) => const ShopScreen(),
          ),
          GoRoute(
            path: '/inventory',
            name: 'inventory',
            builder: (context, state) => const InventoryScreen(),
          ),
          GoRoute(
            path: '/social',
            name: 'social',
            builder: (context, state) => const SocialScreen(),
          ),
          GoRoute(
            path: '/wallet',
            name: 'wallet',
            builder: (context, state) => const WalletScreen(),
          ),
        ],
      ),
    ],
  );
});

/// Helper class to make GoRouter refresh on auth state changes.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Ref ref, ProviderListenable provider) {
    ref.listen(provider, (_, __) => notifyListeners());
  }
}
