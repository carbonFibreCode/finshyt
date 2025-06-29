import 'package:bloc/bloc.dart';
import 'package:finshyt/core/entities/user.dart';

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
    }
  }
}
