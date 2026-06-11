import '../error/failures.dart';
abstract class UseCase<R, Params> {
  Future<R> call(Params params);
}

class NoParams {
  const NoParams();
}

sealed class Result<T> {
  const Result();
}

final class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

final class FailureResult<T> extends Result<T> {
  final Failure failure;
  const FailureResult(this.failure);
}
