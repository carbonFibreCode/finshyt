import 'package:finshyt/Features/ai_budget_planning/data/remote_data_sources/budget_remote_data_source.dart';
import 'package:finshyt/Features/ai_budget_planning/data/remote_data_sources/budget_remote_data_source_impl.dart';
import 'package:finshyt/Features/ai_budget_planning/data/repository_impl/repository_impl.dart';
import 'package:finshyt/Features/ai_budget_planning/domain/repositories/budegt_repository.dart';
import 'package:finshyt/Features/ai_budget_planning/domain/usecases/generate_budget_plan.dart';
import 'package:finshyt/Features/ai_budget_planning/domain/usecases/save_budget_plan.dart';
import 'package:finshyt/Features/ai_budget_planning/presentation/cubits/budget_planner_cubit.dart';
import 'package:finshyt/Features/expense/data/repositories_impl/repository_impl.dart';
import 'package:finshyt/Features/homepage/domain/usecases/get_homepage_insights.dart';
import 'package:finshyt/Features/insights/data/remote_data_source/remote_data_source.dart';
import 'package:finshyt/Features/insights/data/remote_data_source/remote_data_source_impl.dart';
import 'package:finshyt/Features/insights/data/repository/repository_impl.dart';
import 'package:finshyt/Features/insights/domain/repository/repository.dart';
import 'package:finshyt/Features/insights/domain/usecases/get_all_insights.dart';
import 'package:finshyt/Features/insights/presentation/cubits/insights_cubit.dart';
import 'package:finshyt/core/cubits/budget_cubit/active_budget_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Core imports
import 'package:finshyt/core/cubits/app_user/app_user_cubit.dart';
import 'package:finshyt/core/secrets/app_secrets.dart';

// Auth imports
import 'package:finshyt/Features/auth/data/datasources/auth_remote_data_sources.dart';
import 'package:finshyt/Features/auth/data/repositories/auth_repository_impl.dart';
import 'package:finshyt/Features/auth/domain/repository/auth_repository.dart';
import 'package:finshyt/Features/auth/domain/useCases/current_user.dart';
import 'package:finshyt/Features/auth/domain/useCases/user_email_verification.dart';
import 'package:finshyt/Features/auth/domain/useCases/user_login.dart';
import 'package:finshyt/Features/auth/domain/useCases/user_logout.dart';
import 'package:finshyt/Features/auth/domain/useCases/user_password_reset.dart';
import 'package:finshyt/Features/auth/domain/useCases/user_sign_up.dart';
import 'package:finshyt/Features/auth/presentation/bloc/auth_bloc.dart';

// Expense imports
import 'package:finshyt/features/expense/data/datasources/expense_remote_data_source.dart';
import 'package:finshyt/features/expense/data/datasources/expense_remote_data_source_impl.dart';
import 'package:finshyt/Features/expense/domain/repositories/repository.dart';
import 'package:finshyt/features/expense/domain/usecases/add_expense.dart';
import 'package:finshyt/Features/expense/presentation/cubits/expense_cubit.dart';

// Homepage imports
import 'package:finshyt/Features/homepage/data/datasources/homepage_remote_data_sources.dart';
import 'package:finshyt/Features/homepage/data/datasources/homepage_remote_datasource_impl.dart';
import 'package:finshyt/Features/homepage/data/repository_impl/repository_impl.dart';
import 'package:finshyt/Features/homepage/domain/repository/homepage_repository.dart';
import 'package:finshyt/Features/homepage/presentation/cubits/homepage_cubit.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  // Initialize Supabase
  final supabase = await Supabase.initialize(
    anonKey: AppSecrets.supabaseAnonKey,
    url: AppSecrets.supabaseUrl,
  );
  serviceLocator.registerLazySingleton<SupabaseClient>(() => supabase.client);

  // Core registrations
  serviceLocator
  ..registerLazySingleton<AppUserCubit>(() => AppUserCubit(),)
  ..registerLazySingleton<ActiveBudgetCubit>(() => ActiveBudgetCubit(serviceLocator<AppUserCubit>()));

  // Feature-specific initializations
  _initAuth();
  _initExpense();
  _initHomepage();
  _initInsights();
  _initBudgetPlanner();
}

void _initAuth() {
  serviceLocator
    // Data source
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(serviceLocator<SupabaseClient>()),
    )
    // Repository
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(serviceLocator<AuthRemoteDataSource>()),
    )
    // Use cases
    ..registerFactory<UserSignUp>(
      () => UserSignUp(serviceLocator<AuthRepository>()),
    )
    ..registerFactory<UserLogin>(
      () => UserLogin(serviceLocator<AuthRepository>()),
    )
    ..registerFactory<UserLogout>(
      () => UserLogout(authRepository: serviceLocator<AuthRepository>()),
    )
    ..registerFactory<UserEmailVerification>(
      () => UserEmailVerification(
        authRepository: serviceLocator<AuthRepository>(),
      ),
    )
    ..registerFactory<UserPasswordReset>(
      () => UserPasswordReset(authRepository: serviceLocator<AuthRepository>()),
    )
    ..registerFactory<CurrentUser>(
      () => CurrentUser(serviceLocator<AuthRepository>()),
    )
    // Bloc
    ..registerLazySingleton<AuthBloc>(
      () => AuthBloc(
        userSignUp: serviceLocator<UserSignUp>(),
        userLogin: serviceLocator<UserLogin>(),
        userLogout: serviceLocator<UserLogout>(),
        userEmailVerification: serviceLocator<UserEmailVerification>(),
        userPasswordReset: serviceLocator<UserPasswordReset>(),
        currentUser: serviceLocator<CurrentUser>(),
        appUserCubit: serviceLocator<AppUserCubit>(),
      ),
    );
}

void _initExpense() {
  serviceLocator
    // Data source
    ..registerLazySingleton<ExpenseRemoteDataSource>(
      () => ExpenseRemoteDataSourceImpl(serviceLocator<SupabaseClient>()),
    )
    // Repository
    ..registerLazySingleton<ExpenseRepository>(
      () => ExpenseRepositoryImpl(
        remoteDataSource: serviceLocator<ExpenseRemoteDataSource>(),
      ),
    )
    // Use case
    ..registerFactory<AddExpense>(
      () => AddExpense(serviceLocator<ExpenseRepository>()),
    )
    // Cubit
    ..registerFactory<ExpenseCubit>(
      () => ExpenseCubit(addExpense: serviceLocator<AddExpense>()),
    );
}

void _initHomepage() {
  serviceLocator
    // Data source
    ..registerLazySingleton<HomepageRemoteDataSource>(
      () => HomepageRemoteDataSourceImpl(serviceLocator<SupabaseClient>()),
    )
    // Repository
    ..registerLazySingleton<HomepageRepository>(
      () => HomepageRepositoryImpl(
        remoteDataSource: serviceLocator<HomepageRemoteDataSource>(),
      ),
    )
    // Use case
    ..registerFactory<GetHomepageInsights>(
      () => GetHomepageInsights(serviceLocator<HomepageRepository>()),
    )
    // Cubit
    ..registerFactory<HomepageCubit>(
      () => HomepageCubit(
        getHomepageInsights: serviceLocator<GetHomepageInsights>(),
      ),
    );
}

void _initInsights() {
  serviceLocator
    // Data source
    ..registerLazySingleton<InsightsRemoteDataSource>(
      () => InsightsRemoteDataSourceImpl(serviceLocator<SupabaseClient>()),
    )
    // Repository
    ..registerLazySingleton<InsightsRepository>(
      () => InsightsRepositoryImpl(
        remoteDataSource: serviceLocator<InsightsRemoteDataSource>(),
      ),
    )
    // Use case
    ..registerFactory<GetAllInsights>(
      () => GetAllInsights(serviceLocator<InsightsRepository>()),
    )
    // Cubit
    ..registerFactory<InsightsCubit>(
      () => InsightsCubit(getAllInsights: serviceLocator<GetAllInsights>()),
    );
}

void _initBudgetPlanner() {
  serviceLocator
  //data sources
    ..registerLazySingleton<BudgetRemoteDataSource>(
      () => BudgetRemoteDataSourceImpl(serviceLocator<SupabaseClient>()),
    )
    //repository
    ..registerLazySingleton<BudgetRepository>(
      () => BudgetRepositoryImpl(
        remoteDataSource: serviceLocator<BudgetRemoteDataSource>(),
      ),
    )
    //usecases
    ..registerFactory<GenerateBudgetPlan>(
      () => GenerateBudgetPlan(serviceLocator<BudgetRepository>()),
    )
    ..registerFactory<SaveBudgetPlan>(
      () => SaveBudgetPlan(serviceLocator<BudgetRepository>()),
    )
    //cubits
    ..registerFactory<BudgetPlannerCubit>(
      () => BudgetPlannerCubit(
        generateBudgetPlan: serviceLocator<GenerateBudgetPlan>(),
        saveBudgetPlan: serviceLocator<SaveBudgetPlan>(),
      ),
    );
}
