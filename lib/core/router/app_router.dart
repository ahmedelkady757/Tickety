import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../di/injection.dart';
import '../widgets/main_shell.dart';
import '../../features/home/domain/entities/event_entity.dart';
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
import '../../features/events/presentation/cubit/events_cubit.dart';
import '../../features/events/domain/entities/see_all_config.dart';
import '../../features/event-details/presentation/cubit/map_cubit.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/event-details/presentation/screens/map_screen.dart';
import '../favorites/favorites_cubit.dart';

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
  static const map = '/map';
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
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
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, state) {
        final event = state.extra as EventEntity?;
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => getIt<EventsCubit>()),
            BlocProvider(create: (_) => getIt<FavoritesCubit>()..refresh()),
          ],
          child: EventDetailsScreen(event: event),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.emptyEvents,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => const EmptyEventsScreen(),
    ),
    GoRoute(
      path: AppRoutes.search,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => BlocProvider(
        create: (_) => getIt<EventsCubit>(),
        child: const SearchScreen(),
      ),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (_, __, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.home,
          pageBuilder: (_, __) => const NoTransitionPage(child: HomeScreen()),
        ),
        GoRoute(
          path: AppRoutes.seeAllEvents,
          pageBuilder: (_, state) {
            final config = SeeAllConfig.fromQuery(state.uri.queryParameters);
            return NoTransitionPage(
              child: BlocProvider(
                create: (_) => getIt<EventsCubit>(),
                child: SeeAllEventsScreen(config: config),
              ),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.map,
          pageBuilder: (_, state) {
            final focusEvent = state.extra as EventEntity?;
            return NoTransitionPage(
              child: BlocProvider(
                create: (_) => getIt<MapCubit>()..init(focusEvent: focusEvent),
                child: MapScreen(focusEvent: focusEvent),
              ),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.profile,
          pageBuilder: (_, __) => NoTransitionPage(
            child: BlocProvider(
              create: (_) => getIt<FavoritesCubit>()..refresh(),
              child: const ProfileScreen(),
            ),
          ),
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => const Scaffold(
    body: Center(child: Text('Page not found')),
  ),
);
