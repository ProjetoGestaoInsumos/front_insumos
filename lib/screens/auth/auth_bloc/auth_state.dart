class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String name;
  final String email;
  final String userType;
  final String token;

  AuthAuthenticated({
    required this.name,
    required this.email,
    required this.userType,
    required this.token,
  });
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}
