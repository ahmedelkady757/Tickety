import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/sign_in_screen.dart';
import '../../features/auth/presentation/screens/sign_up_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';

/// Route path constants — add new routes as features are built.
class AppRoutes {
  AppRoutes._();

  static const splash = '/';
  static const onboarding = '/onboarding';
  static const signIn = '/auth/sign-in';
  static const signUp = '/auth/sign-up';
  static const forgotPassword = '/auth/forgot-password';

  // Phase 2+ (uncomment as implemented)
  // static const home = '/home';
  // static const explore = '/explore';
  // static const eventDetails = '/event/:id';
  // static const tickets = '/tickets';
  // static const profile = '/profile';
}

/// Central router — routes are added progressively with each feature sprint.
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  debugLogDiagnostics: false,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (_, __) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (_, __) => const OnboardingScreen(),
    ),
    GoRoute(
      path: AppRoutes.signIn,
      builder: (_, __) => const SignInScreen(),
    ),
    GoRoute(
      path: AppRoutes.signUp,
      builder: (_, __) => const SignUpScreen(),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      builder: (_, __) => const ForgotPasswordScreen(),
    ),
  ],
  errorBuilder: (context, state) => const Scaffold(
    body: Center(child: Text('Page not found')),
  ),
);
