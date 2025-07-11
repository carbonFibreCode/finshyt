import 'package:finshyt/Features/ai_budget_planning/data/remot_data_source_impl.dart';
import 'package:finshyt/Features/ai_budget_planning/data/remote_data_source.dart';
import 'package:finshyt/Features/ai_budget_planning/domain/repository/repository.dart';
import 'package:finshyt/Features/ai_budget_planning/domain/repository/repository_impl.dart';
import 'package:finshyt/Features/ai_budget_planning/domain/usecases/make_budget_draft.dart';
import 'package:finshyt/Features/ai_budget_planning/domain/usecases/save_bugdet_plan.dart';
import 'package:finshyt/Features/ai_budget_planning/presentation/cubit/budget_draft_cubit.dart';
import 'package:finshyt/Features/ai_budget_planning/presentation/cubit/budget_plan_cubit.dart';
import 'package:finshyt/Features/ai_budget_planning/presentation/cubit/budget_save_cubit.dart';
import 'package:finshyt/Features/expense/data/data_source/add_expense_remote_data_source_impl.dart';
import 'package:finshyt/Features/expense/data/repositoryimpl/repository_impl.dart';
import 'package:finshyt/Features/expense/domain/repository/repository.dart';
import 'package:finshyt/Features/expense/domain/usecases/add_expense.dart';
import 'package:finshyt/Features/insights/data/dataSources/insights_remote_data_source.dart/insights_remote_data_source.dart';
import 'package:finshyt/Features/insights/data/repositoryImpl/repository_impl.dart';
import 'package:finshyt/Features/insights/domain/repository/repository.dart';
import 'package:finshyt/Features/insights/domain/usecases/get_insights.dart';
import 'package:finshyt/core/cubits/app_user/app_user_cubit.dart';
import 'package:finshyt/Features/expense/presentation/expense/add_expense_cubit.dart';
import 'package:finshyt/Features/insights/presentation/insightsCubit/insight_cubit.dart';
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
  _initExpense();
  _initInsights();
  _initBudget();
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

void _initInsights() {
  serviceLocator
    ..registerFactory<InsightsRemoteDataSource>(
      () => InsightsRemoteDataSourceImpl(serviceLocator<SupabaseClient>()),
    )
    ..registerFactory<InsightsRepository>(
      () => InsightsRepositoryImpl(serviceLocator()),
    )
    ..registerFactory(() => GetInsights(serviceLocator()))
    ..registerFactory(() => InsightsCubit(serviceLocator<GetInsights>()));
}

void _initExpense() {
  serviceLocator
    ..registerFactory<ExpenseRemoteDataSource>(
      () => ExpenseRemoteDataSourceImpl(serviceLocator<SupabaseClient>()),
    )
    ..registerFactory<ExpenseRepository>(
      () => ExpenseRepositoryImpl(serviceLocator()),
    )
    ..registerFactory(() => AddExpense(serviceLocator()))
    ..registerFactory(() => AddExpenseCubit(serviceLocator()));
}

void _initBudget() {
  serviceLocator
    ..registerFactory<BudgetRemoteDataSource>(
      () => BudgetRemoteDataSourceImpl(serviceLocator<SupabaseClient>()),
    )
    ..registerFactory<BudgetRepository>(
      () => BudgetRepositoryImpl(serviceLocator()),
    )
    ..registerFactory(() => MakeBudgetDraft(serviceLocator()))
    ..registerFactory(() => SaveBudgetPlan(serviceLocator()))
    ..registerFactory(() => BudgetPlanCubit(serviceLocator(), serviceLocator()))
    ..registerFactory(() => BudgetDraftCubit(serviceLocator()))
    ..registerFactory(() => BudgetSaveCubit(serviceLocator()));
}
