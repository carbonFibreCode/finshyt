// lib/Features/auth/domain/presentation/bloc/auth_state.dart

part of 'auth_bloc.dart';

sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {
  final User user;
  const AuthSuccess(this.user);
}

final class AuthFailure extends AuthState {
  final String message;
  const AuthFailure(this.message);
}

final class AuthLoggedOut extends AuthState {
  const AuthLoggedOut();
}


final class AuthPasswordResetInitiated extends AuthState {
  const AuthPasswordResetInitiated();
}


final class AuthPasswordResetSent extends AuthState {
  const AuthPasswordResetSent();
}

final class AuthEmailVerificationInitiated extends AuthState{
  const AuthEmailVerificationInitiated();
}
