import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

class SignInUseCase {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  Future<Either<Failure, void>> call(String email, String password) async {
    return await repository.signInWithEmailAndPassword(email, password);
  }
}

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<Either<Failure, void>> call(String email, String password, String fullName) async {
    return await repository.signUpWithEmailAndPassword(email, password, fullName);
  }
}

class GoogleSignInUseCase {
  final AuthRepository repository;

  GoogleSignInUseCase(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.signInWithGoogle();
  }
}

class FacebookSignInUseCase {
  final AuthRepository repository;

  FacebookSignInUseCase(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.signInWithFacebook();
  }
}

class ForgotPasswordUseCase {
  final AuthRepository repository;

  ForgotPasswordUseCase(this.repository);

  Future<Either<Failure, void>> call(String email) async {
    return await repository.forgotPassword(email);
  }
}

class SignOutUseCase {
  final AuthRepository repository;

  SignOutUseCase(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.signOut();
  }
}
