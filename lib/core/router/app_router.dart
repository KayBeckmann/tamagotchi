import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/domain/auth_state.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/creature/presentation/screens/home_screen.dart';
import '../../features/creature/presentation/screens/creature_selection_screen.dart';
import '../../features/arena/presentation/screens/arena_screen.dart';
import '../../features/tournament/presentation/screens/tournament_screen.dart';
import '../../features/shop/presentation/screens/shop_screen.dart';
import '../../features/social/presentation/screens/social_screen.dart';
import '../../features/wallet/presentation/screens/wallet_screen.dart';
import '../widgets/app_shell.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isAuth = authState.status == AuthStatus.authenticated;
      final isLoading = authState.status == AuthStatus.unknown;
      final location = state.uri.toString();
      final isAuthRoute = location == '/login' || location == '/register';

      // While checking stored session, don't redirect
      if (isLoading) return null;

      // Not authenticated -> send to login (unless already there)
      if (!isAuth && !isAuthRoute) return '/login';

      // Authenticated but on auth page -> send to home
      if (isAuth && isAuthRoute) return '/';

      return null;
    },
    routes: [
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
