import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/firebase_auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> signInWithEmailAndPassword(String email, String password) async {
    try {
      await remoteDataSource.signInWithEmailAndPassword(email, password);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signUpWithEmailAndPassword(String email, String password, String fullName) async {
    try {
      await remoteDataSource.signUpWithEmailAndPassword(email, password, fullName);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signInWithGoogle() async {
    try {
      final result = await remoteDataSource.signInWithGoogle();
      if (result == null) {
        return const Left(ServerFailure('Google sign in cancelled.'));
      }
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signInWithFacebook() async {
    try {
      final result = await remoteDataSource.signInWithFacebook();
      if (result == null) {
        return const Left(ServerFailure('Facebook sign in cancelled or failed.'));
      }
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String email) async {
    try {
      await remoteDataSource.forgotPassword(email);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<bool> checkUserLoggedIn() async {
    return remoteDataSource.checkUserLoggedIn();
  }
}
