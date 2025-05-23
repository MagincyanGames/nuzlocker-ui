import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nuzlocker_ui/screens/locke_details_screen.dart';
import 'package:nuzlocker_ui/screens/lockes_screen.dart';
import 'package:nuzlocker_ui/screens/new_locke_screen.dart';
import 'package:nuzlocker_ui/screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'package:nuzlocker_ui/screens/statistics_screen.dart';

// Create a key for the navigator
final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final GoRouter router = GoRouter(
  // Use navigator key to enable pop operations
  navigatorKey: _rootNavigatorKey,

  // Enable debug logging
  debugLogDiagnostics: true,

  // Define initial route
  initialLocation: '/',

  // Use a flat route structure instead of nested routes
  routes: [
    // Home route
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),

    // Authentication routes
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
      // Use parentNavigatorKey to ensure this is built at the root level
      parentNavigatorKey: _rootNavigatorKey,
    ),

    // Lockes list route
    GoRoute(
      path: '/lockes',
      name: 'lockes',
      builder: (context, state) => const LockesScreen(),
      parentNavigatorKey: _rootNavigatorKey,
    ),

    // New locke route
    GoRoute(
      path: '/lockes/new',
      name: 'new_locke',
      builder: (context, state) => const NewLockeScreen(),
      parentNavigatorKey: _rootNavigatorKey,
    ),

    // Locke details with parameter
    GoRoute(
      path: '/locke/:id',
      name: 'locke_details',
      builder: (context, state) {
        final lockeId = state.pathParameters['id']!;
        return LockeDetailsScreen(lockeId: lockeId);
      },
      parentNavigatorKey: _rootNavigatorKey,
    ),
    GoRoute(
      path: '/signup', // Added route for sign-up
      builder: (BuildContext context, GoRouterState state) {
        return const SignUpScreen();
      },
    ),
    GoRoute(
      path: '/statistics',
      builder: (context, state) => const StatisticsScreen(),
    ),
  ],

  // Error page
  errorBuilder:
      (context, state) => Scaffold(
        appBar: AppBar(title: const Text('Page Not Found')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Route not found', style: TextStyle(fontSize: 24)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.push('/'),
                child: const Text('Go to Home'),
              ),
            ],
          ),
        ),
      ),
);
