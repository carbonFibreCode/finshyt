import 'package:finshyt/core/cubits/app_user/app_user_cubit.dart';
import 'package:finshyt/core/noParamsClass/no_params.dart';
import 'package:finshyt/core/entities/user.dart';
import 'package:finshyt/Features/auth/domain/useCases/current_user.dart';
import 'package:finshyt/Features/auth/domain/useCases/user_email_verification.dart';
import 'package:finshyt/Features/auth/domain/useCases/user_login.dart';
import 'package:finshyt/Features/auth/domain/useCases/user_logout.dart';
import 'package:finshyt/Features/auth/domain/useCases/user_password_reset.dart';
import 'package:finshyt/Features/auth/domain/useCases/user_sign_up.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@lazySingleton
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  final UserLogout _userLogout;
  final UserPasswordReset _userPasswordReset;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;

  AuthBloc({
    required UserSignUp userSignUp,
    required UserLogin userLogin,
    required UserLogout userLogout,
    required UserEmailVerification userEmailVerification,
    required UserPasswordReset userPasswordReset,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
  }) : _userSignUp = userSignUp,
       _userLogin = userLogin,
       _userLogout = userLogout,
       _userPasswordReset = userPasswordReset,
       _currentUser = currentUser,
       _appUserCubit = appUserCubit,
       super(AuthInitial()) {
    on<AuthEventIsUserLoggedIn>(_onAuthEventIsUserLoggedIn);
    on<AuthEventSignUp>(_onAuthEventSignUp);
    on<AuthEventLogin>(_onAuthEventLogin);
    on<AuthEventLogout>(_onAuthEventLogout);
    on<AuthEventSendPasswordReset>(_onAuthEventSendPasswordReset);
    on<AuthEventNavigateToPasswordReset>(_onAuthEventNavigateToPasswordReset);
  }

  void _onAuthEventIsUserLoggedIn(
    AuthEventIsUserLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final res = await _currentUser(NoParams());
    res.fold((l) {
      _appUserCubit.updateUser(null);
      emit(const AuthLoggedOut());
    }, (user) => _emitAuthSuccess(user, emit));
  }

  void _onAuthEventSignUp(
    AuthEventSignUp event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final res = await _userSignUp(
      UserSignUpParams(
        email: event.email,
        password: event.password,
        name: event.name,
      ),
    );
    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) => _emitAuthSuccess(r, emit),
    );
  }

  void _onAuthEventLogin(AuthEventLogin event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _userLogin(
      UserLoginParams(email: event.email, password: event.password),
    );
    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _onAuthEventLogout(
    AuthEventLogout event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final res = await _userLogout(NoParams());
    res.fold((l) => emit(AuthFailure(l.message)), (_) {
      _appUserCubit.updateUser(null);
      emit(const AuthLoggedOut());
    });
  }

  void _onAuthEventSendPasswordReset(
    AuthEventSendPasswordReset event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final res = await _userPasswordReset(
      UserPasswordResetParams(email: event.email),
    );
    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (_) => emit(const AuthPasswordResetSent()),
    );
  }

  void _onAuthEventNavigateToPasswordReset(
    AuthEventNavigateToPasswordReset event,
    Emitter<AuthState> emit,
  ) {
    emit(const AuthPasswordResetInitiated());
  }

  void _emitAuthSuccess(User user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user));
  }
}
