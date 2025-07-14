import 'package:finshyt/core/cubits/app_user/app_user_cubit.dart';
import 'package:finshyt/core/secrets/app_secrets.dart';
import 'package:finshyt/Features/auth/data/dataSources/auth_remote_data_sources.dart';
import 'package:finshyt/Features/auth/data/repositories/auth_repository_impl.dart';
import 'package:finshyt/Features/auth/presentation/bloc/auth_bloc.dart';
import 'package:finshyt/Features/auth/domain/repository/auth_repository.dart';
import 'package:finshyt/Features/auth/domain/useCases/current_user.dart';
import 'package:finshyt/Features/auth/domain/useCases/user_email_verification.dart';
import 'package:finshyt/Features/auth/domain/useCases/user_login.dart';
import 'package:finshyt/Features/auth/domain/useCases/user_logout.dart';
import 'package:finshyt/Features/auth/domain/useCases/user_password_reset.dart';
import 'package:finshyt/Features/auth/domain/useCases/user_sign_up.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  final supabase = await Supabase.initialize(
    anonKey: AppSecrets.supabaseAnonKey,
    url: AppSecrets.supabaseUrl,
  );
  serviceLocator.registerLazySingleton(() => supabase.client);

  _initAuth();
  //core
  serviceLocator.registerLazySingleton(() => AppUserCubit());
}

void _initAuth() {
  //datasourc
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(serviceLocator()),
    )
    //repository
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(serviceLocator()),
    )
    //Usecases
    ..registerFactory(() => UserSignUp(serviceLocator()))
    ..registerFactory(() => UserLogin(serviceLocator()))
    ..registerFactory(() => UserLogout(authRepository: serviceLocator()))
    ..registerFactory(
      () => UserEmailVerification(authRepository: serviceLocator()),
    )
    ..registerFactory(() => UserPasswordReset(authRepository: serviceLocator()))
    ..registerFactory(() => CurrentUser(serviceLocator()))
    //bloc
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userLogin: serviceLocator(),
        userLogout: serviceLocator(),
        userEmailVerification: serviceLocator(),
        userPasswordReset: serviceLocator(),
        currentUser: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );
}
