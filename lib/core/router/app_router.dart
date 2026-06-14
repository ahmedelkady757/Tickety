import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/onboarding/presentation/screens/splash_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/signin/presentation/screens/sign_in_screen.dart';
import '../../features/signup/presentation/screens/sign_up_screen.dart';
import '../../features/forgotpassword/presentation/screens/forgot_password_screen.dart';
import '../../features/event-details/presentation/screens/event_details_screen.dart';
import '../../features/events/presentation/screens/empty_events_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/events/presentation/screens/search_screen.dart';
import '../../features/events/presentation/screens/see_all_events_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const splash = '/';
  static const onboarding = '/onboarding';
  static const signIn = '/auth/sign-in';
  static const signUp = '/auth/sign-up';
  static const forgotPassword = '/auth/forgot-password';
  static const eventDetails = '/event-details';
  static const emptyEvents = '/empty-events';
  static const home = '/home';
  static const search = '/search';
  static const seeAllEvents = '/see-all-events';
  static const profile = '/profile';


}

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
    GoRoute(
      path: AppRoutes.eventDetails,
      builder: (_, __) => const EventDetailsScreen(),
    ),
    GoRoute(
      path: AppRoutes.emptyEvents,
      builder: (_, __) => const EmptyEventsScreen(),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (_, __) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.search,
      builder: (_, __) => const SearchScreen(),
    ),
    GoRoute(
      path: AppRoutes.seeAllEvents,
      builder: (_, __) => const SeeAllEventsScreen(),
    ),
    GoRoute(
      path: AppRoutes.profile,
      builder: (_, __) => const ProfileScreen(),
    ),
  ],
  errorBuilder: (context, state) => const Scaffold(
    body: Center(child: Text('Page not found')),
  ),
);
