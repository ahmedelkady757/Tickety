
abstract class AuthState  {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String message;

  const AuthSuccess({this.message = 'Success'});

}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});


}
