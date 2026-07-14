import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/auth_usecases.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final GoogleSignInUseCase googleSignInUseCase;
  final FacebookSignInUseCase facebookSignInUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;
  final SignOutUseCase signOutUseCase;

  AuthCubit({
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.googleSignInUseCase,
    required this.facebookSignInUseCase,
    required this.forgotPasswordUseCase,
    required this.signOutUseCase,
  }) : super(AuthInitial());

  Future<void> signIn(String email, String password) async {
    emit(AuthLoading());
    final result = await signInUseCase(email, password);
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(const AuthSuccess(message: 'Successfully signed in')),
    );
  }

  Future<void> signUp(String email, String password, String fullName) async {
    emit(AuthLoading());
    final result = await signUpUseCase(email, password, fullName);
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(const AuthSuccess(message: 'Successfully signed up')),
    );
  }

  Future<void> signInWithGoogle() async {
    emit(AuthLoading());
    final result = await googleSignInUseCase();
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(const AuthSuccess(message: 'Successfully signed in with Google')),
    );
  }

  Future<void> signInWithFacebook() async {
    emit(AuthLoading());
    final result = await facebookSignInUseCase();
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(const AuthSuccess(message: 'Successfully signed in with Facebook')),
    );
  }

  Future<void> forgotPassword(String email) async {
    emit(AuthLoading());
    final result = await forgotPasswordUseCase(email);
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(const AuthSuccess(message: 'Password reset link sent')),
    );
  }

  Future<void> signOut() async {
    emit(AuthLoading());
    final result = await signOutUseCase();
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(AuthInitial()), // Return to initial state after logout
    );
  }
}
