import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> signInWithEmailAndPassword(String email, String password);
  Future<Either<Failure, void>> signUpWithEmailAndPassword(String email, String password, String fullName);
  Future<Either<Failure, void>> signInWithGoogle();
  Future<Either<Failure, void>> signInWithFacebook();
  Future<Either<Failure, void>> forgotPassword(String email);
  Future<Either<Failure, void>> signOut();
  Future<bool> checkUserLoggedIn();
}
