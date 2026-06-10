import '../error/failures.dart';

/// Base UseCase interface — enforces SRP and DIP.
///
/// [Type] = return type, [Params] = input parameters type.
/// Every use case is a single callable class.
abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

/// Use this when a use case takes no parameters.
class NoParams {
  const NoParams();
}

/// Convenience result wrapper using sealed classes.
/// Avoids importing Either from dartz — keeps dependencies lean.
sealed class Result<T> {
  const Result();
}

final class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

final class Failure_<T> extends Result<T> {
  final Failure failure;
  const Failure_(this.failure);
}
