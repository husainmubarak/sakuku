// lib/core/routes/app_router.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../widgets/main_navigation_screen.dart';
import '../../features/summary/presentation/screens/summary_screen.dart';
import '../../features/transaction/presentation/screens/transaction_screen.dart';
import '../../features/transaction/presentation/screens/add_transaction_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/summary',
    routes: [
      // 1. StatefulShellRoute untuk Tab BottomNavigationBar
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainNavigationScreen(navigationShell: navigationShell);
        },
        branches: [
          // Branch Tab 1: Ringkasan
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/summary',
                name: 'summary',
                builder: (context, state) => const SummaryScreen(),
              ),
            ],
          ),

          // Branch Tab 2: Transaksi
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/transactions',
                name: 'transactions',
                builder: (context, state) => const TransactionScreen(),
              ),
            ],
          ),
        ],
      ),

      // 2. Route Terpisah di luar Shell (untuk Form Tambah Transaksi)
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/add-transaction',
        name: 'add-transaction',
        builder: (context, state) => const AddTransactionScreen(),
      ),
    ],
  );
});