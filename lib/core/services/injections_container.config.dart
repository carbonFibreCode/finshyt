// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

import '../../Features/auth/data/dataSources/auth_remote_data_sources.dart'
    as _i236;
import '../../Features/auth/data/repositories/auth_repository_impl.dart'
    as _i298;
import '../../Features/auth/domain/repository/auth_repository.dart' as _i830;
import '../../Features/auth/domain/useCases/current_user.dart' as _i456;
import '../../Features/auth/domain/useCases/user_email_verification.dart'
    as _i292;
import '../../Features/auth/domain/useCases/user_login.dart' as _i211;
import '../../Features/auth/domain/useCases/user_logout.dart' as _i326;
import '../../Features/auth/domain/useCases/user_password_reset.dart' as _i376;
import '../../Features/auth/domain/useCases/user_sign_up.dart' as _i241;
import '../../Features/auth/presentation/bloc/auth_bloc.dart' as _i978;
import '../cubits/app_user/app_user_cubit.dart' as _i582;
import 'injection_module.dart' as _i212;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final injectionModule = _$InjectionModule();
    await gh.factoryAsync<_i454.Supabase>(
      () => injectionModule.supabase,
      preResolve: true,
    );
    gh.lazySingleton<_i454.SupabaseClient>(
      () => injectionModule.supabaseClient,
    );
    gh.lazySingleton<_i236.AuthRemoteDataSource>(
      () => _i236.AuthRemoteDataSourceImpl(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i830.AuthRepository>(
      () => _i298.AuthRepositoryImpl(gh<_i236.AuthRemoteDataSource>()),
    );
    gh.factory<_i241.UserSignUp>(
      () => _i241.UserSignUp(gh<_i830.AuthRepository>()),
    );
    gh.factory<_i211.UserLogin>(
      () => _i211.UserLogin(gh<_i830.AuthRepository>()),
    );
    gh.factory<_i456.CurrentUser>(
      () => _i456.CurrentUser(gh<_i830.AuthRepository>()),
    );
    gh.factory<_i292.UserEmailVerification>(
      () => _i292.UserEmailVerification(
        authRepository: gh<_i830.AuthRepository>(),
      ),
    );
    gh.factory<_i326.UserLogout>(
      () => _i326.UserLogout(authRepository: gh<_i830.AuthRepository>()),
    );
    gh.factory<_i376.UserPasswordReset>(
      () => _i376.UserPasswordReset(authRepository: gh<_i830.AuthRepository>()),
    );
    gh.lazySingleton<_i978.AuthBloc>(
      () => _i978.AuthBloc(
        userSignUp: gh<_i241.UserSignUp>(),
        userLogin: gh<_i211.UserLogin>(),
        userLogout: gh<_i326.UserLogout>(),
        userEmailVerification: gh<_i292.UserEmailVerification>(),
        userPasswordReset: gh<_i376.UserPasswordReset>(),
        currentUser: gh<_i456.CurrentUser>(),
        appUserCubit: gh<_i582.AppUserCubit>(),
      ),
    );
    return this;
  }
}

class _$InjectionModule extends _i212.InjectionModule {}
