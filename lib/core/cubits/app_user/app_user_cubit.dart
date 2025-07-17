import 'package:bloc/bloc.dart';
import 'package:finshyt/core/cubits/budget_cubit/active_budget_cubit.dart';
import 'package:finshyt/core/entities/user.dart';
import 'package:finshyt/init_dependencies.dart';

part 'app_user_state.dart';

class AppUserCubit extends Cubit<AppUserState> {
  AppUserCubit() : super(AppUserInitial());

  User? get currentUser =>
      state is AppUserLoggedIn ? (state as AppUserLoggedIn).user : null;

  void updateUser(User? user) {
    if (user == null) {
      emit(AppUserInitial());
    } else {
      emit(AppUserLoggedIn(user));
      serviceLocator<ActiveBudgetCubit>().loadActiveBudgetId();
    }
  }
}
