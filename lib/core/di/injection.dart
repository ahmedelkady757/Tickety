import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../api/api_client.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Core & Network
  // ---------------------------------------------------------------------------
  getIt.registerLazySingleton<Dio>(() => createDioClient());

}
