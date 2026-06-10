/// Custom exception types thrown by data layer.
/// Converted to [Failure] objects by repository implementations.
class ServerException implements Exception {
  final String message;
  final int? statusCode;
  const ServerException(this.message, {this.statusCode});
}

class NetworkException implements Exception {
  final String message;
  const NetworkException(
      [this.message = 'No internet connection. Please try again.']);
}

class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'Local data error. Please try again.']);
}

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);
}

class NotFoundException implements Exception {
  final String message;
  const NotFoundException([this.message = 'Resource not found.']);
}
