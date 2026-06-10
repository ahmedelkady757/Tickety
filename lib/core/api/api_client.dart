import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';
import '../constants/app_constants.dart';
import '../error/exceptions.dart';

/// Injects Ticketmaster API key into every request automatically.
class ApiKeyInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters['apikey'] = AppConstants.ticketmasterApiKey;
    super.onRequest(options, handler);
  }
}

/// Maps DioException types to domain exceptions.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        throw const NetworkException();
      case DioExceptionType.badResponse:
        final code = err.response?.statusCode ?? 0;
        final msg = _extractMessage(err.response?.data) ??
            'Server error ($code)';
        throw ServerException(msg, statusCode: code);
      default:
        throw ServerException(err.message ?? 'Unexpected error');
    }
  }

  String? _extractMessage(dynamic data) {
    if (data is Map) return data['message'] as String?;
    return null;
  }
}

/// GetIt injectable module registering the singleton Dio instance.
@module
abstract class ApiModule {
  @singleton
  Dio get dio {
    final baseUrl = dotenv.env['TICKETMASTER_BASE_URL'] ??
        AppConstants.ticketmasterBaseUrl;

    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 20),
        headers: {'Accept': 'application/json'},
      ),
    );

    dio.interceptors.addAll([
      ApiKeyInterceptor(),
      ErrorInterceptor(),
    ]);

    return dio;
  }
}
