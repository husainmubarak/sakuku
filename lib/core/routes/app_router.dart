// lib/core/routes/app_router.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../widgets/main_navigation_screen.dart';
import '../../features/auth/presentation/screens/auth_screen.dart';
import '../../features/summary/presentation/screens/summary_screen.dart';
import '../../features/transaction/presentation/screens/transaction_screen.dart';
import '../../features/transaction/presentation/screens/add_transaction_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart'; // Import ProfileScreen

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/summary',
    redirect: (context, state) {
      final session = Supabase.instance.client.auth.currentSession;
      final isAuthRoute = state.matchedLocation == '/auth';

      if (session == null && !isAuthRoute) return '/auth';
      if (session != null && isAuthRoute) return '/summary';
      return null;
    },
    routes: [
      GoRoute(
        path: '/auth',
        name: 'auth',
        builder: (context, state) => const AuthScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainNavigationScreen(navigationShell: navigationShell);
        },
        branches: [
          // Branch 1: Ringkasan
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/summary',
                name: 'summary',
                builder: (context, state) => const SummaryScreen(),
              ),
            ],
          ),

          // Branch 2: Transaksi
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/transactions',
                name: 'transactions',
                builder: (context, state) => const TransactionScreen(),
              ),
            ],
          ),

          // Branch 3: Profil
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                name: 'profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/add-transaction',
        name: 'add-transaction',
        builder: (context, state) => const AddTransactionScreen(),
      ),
    ],
  );
});