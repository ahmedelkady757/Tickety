import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../api/api_client.dart';
import '../services/location_service.dart';
import '../services/remember_me_service.dart';
import '../db/app_database.dart';
import '../favorites/favorites_dao.dart';
import '../favorites/favorites_service.dart';
import '../favorites/favorites_cubit.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/auth_usecases.dart';
import '../../features/auth/data/datasources/firebase_auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/home/data/datasources/home_remote_data_source.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/domain/usecases/get_nearby_events_usecase.dart';
import '../../features/home/domain/usecases/get_upcoming_events_usecase.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../../features/events/data/datasources/events_remote_data_source.dart';
import '../../features/events/data/repositories/events_repository_impl.dart';
import '../../features/events/domain/repositories/events_repository.dart';
import '../../features/events/domain/usecases/get_all_events_usecase.dart';
import '../../features/events/domain/usecases/get_event_details_usecase.dart';
import '../../features/events/domain/usecases/search_events_usecase.dart';
import '../../features/events/presentation/cubit/events_cubit.dart';
import '../../features/event-details/presentation/cubit/map_cubit.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Core & Network
  getIt.registerLazySingleton<Dio>(() => createDioClient());
  getIt.registerLazySingleton(() => LocationService());
  final prefs = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => prefs);
  getIt.registerLazySingleton(() => const FlutterSecureStorage());
  getIt.registerLazySingleton<RememberMeService>(
    () => RememberMeService(prefs: getIt(), secureStorage: getIt()),
  );
  getIt.registerLazySingleton(() => AppDatabase());
  getIt.registerLazySingleton(() => FavoritesDao(db: getIt()));
  getIt.registerLazySingleton(() => FavoritesService(dao: getIt(), auth: getIt()));

  // ---------------------------------------------------------------------------
  getIt.registerLazySingleton(() => FirebaseAuth.instance);
  getIt.registerLazySingleton(() => GoogleSignIn.instance);
  getIt.registerLazySingleton(() => FacebookAuth.instance);

  // Data Sources
  // ---------------------------------------------------------------------------
  getIt.registerLazySingleton<FirebaseAuthRemoteDataSource>(
    () => FirebaseAuthRemoteDataSourceImpl(
      firebaseAuth: getIt(),
      googleSignIn: getIt(),
      facebookAuth: getIt(),
    ),
  );

  getIt.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(dio: getIt()),
  );

  getIt.registerLazySingleton<EventsRemoteDataSource>(
    () => EventsRemoteDataSourceImpl(dio: getIt()),
  );

  // Repositories
  // ---------------------------------------------------------------------------
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: getIt()),
  );

  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(remoteDataSource: getIt()),
  );

  getIt.registerLazySingleton<EventsRepository>(
    () => EventsRepositoryImpl(remoteDataSource: getIt()),
  );

  // Use Cases
  // ---------------------------------------------------------------------------
  getIt.registerLazySingleton(() => SignInUseCase(getIt()));
  getIt.registerLazySingleton(() => SignUpUseCase(getIt()));
  getIt.registerLazySingleton(() => GoogleSignInUseCase(getIt()));
  getIt.registerLazySingleton(() => FacebookSignInUseCase(getIt()));
  getIt.registerLazySingleton(() => ForgotPasswordUseCase(getIt()));
  getIt.registerLazySingleton(() => SignOutUseCase(getIt()));

  getIt.registerLazySingleton(() => GetUpcomingEventsUseCase(getIt()));
  getIt.registerLazySingleton(() => GetNearbyEventsUseCase(getIt()));

  getIt.registerLazySingleton(() => SearchEventsUseCase(getIt()));
  getIt.registerLazySingleton(() => GetEventDetailsUseCase(getIt()));
  getIt.registerLazySingleton(() => GetAllEventsUseCase(getIt()));

  // Cubits / ViewModels
  // ---------------------------------------------------------------------------
  getIt.registerLazySingleton(
    () => AuthCubit(
      signInUseCase: getIt(),
      signUpUseCase: getIt(),
      googleSignInUseCase: getIt(),
      facebookSignInUseCase: getIt(),
      forgotPasswordUseCase: getIt(),
      signOutUseCase: getIt(),
    ),
  );

  getIt.registerFactory(
    () => HomeCubit(
      getUpcomingEventsUseCase: getIt(),
      getNearbyEventsUseCase: getIt(),
      locationService: getIt(),
    ),
  );

  getIt.registerFactory(
    () => EventsCubit(
      searchEventsUseCase: getIt(),
      getEventDetailsUseCase: getIt(),
      getAllEventsUseCase: getIt(),
    ),
  );

  getIt.registerFactory(
    () => MapCubit(
      getNearbyEventsUseCase: getIt(),
      locationService: getIt(),
    ),
  );

  getIt.registerFactory(
    () => FavoritesCubit(service: getIt()),
  );
}
