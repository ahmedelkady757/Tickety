import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Route path constants — add new routes here as features are built.
class AppRoutes {
  AppRoutes._();

  static const splash = '/';
  // Routes will be registered here as features are completed:
  // static const onboarding = '/onboarding';
  // static const login = '/auth/login';
  // static const main = '/main';
  // etc.
}

/// Central router — routes are added progressively with each feature sprint.
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  debugLogDiagnostics: false,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (_, __) => const _PlaceholderView(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(child: Text('Route not found: ${state.uri}')),
  ),
);

/// Temporary placeholder — replaced once each feature view is built.
class _PlaceholderView extends StatelessWidget {
  const _PlaceholderView();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
