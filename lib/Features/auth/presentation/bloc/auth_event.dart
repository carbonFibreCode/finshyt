part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {
  const AuthEvent();
}


final class AuthEventIsUserLoggedIn extends AuthEvent{
  const AuthEventIsUserLoggedIn();
}

final class AuthEventSignUp extends AuthEvent {
  final String name;
  final String email;
  final String password;

  const AuthEventSignUp({required this.name, required this.email, required this.password});
}

final class AuthEventLogin extends AuthEvent {
  final String email;
  final String password;

  const AuthEventLogin({required this.email, required this.password});
}

final class AuthEventLogout extends AuthEvent {
  const AuthEventLogout();
}

final class AuthEventSendPasswordReset extends AuthEvent {
  final String email;

  const AuthEventSendPasswordReset({required this.email});
}

final class AuthEventNavigateToPasswordReset extends AuthEvent{
  const AuthEventNavigateToPasswordReset();
}



 