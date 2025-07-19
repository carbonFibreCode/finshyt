
import 'package:bloc/bloc.dart';
import 'package:finshyt/core/cubits/app_user/app_user_cubit.dart';
import 'package:finshyt/init_dependencies.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'active_budget_state.dart';

class ActiveBudgetCubit extends Cubit<ActiveBudgetState> {
  final AppUserCubit _appUserCubit;
  final SupabaseClient _supabase = serviceLocator<SupabaseClient>();

  ActiveBudgetCubit(this._appUserCubit) : super(ActiveBudgetInitial());

  String? get activeBudgetId =>
      state is ActiveBudgetLoaded ? (state as ActiveBudgetLoaded).budgetId : null;

  Future<void> loadActiveBudgetId() async {
    final user = _appUserCubit.currentUser;
    if (user == null) {
      emit(ActiveBudgetInitial());
      return;
    }

    emit(ActiveBudgetLoading());
    try {
      final now = DateTime.now();
      final response = await _supabase
          .from('budgets')
          .select('id, start_date, end_date')
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      String? budgetId;
      for (final budget in response) {
        final start = DateTime.parse(budget['start_date'] as String);
        final end = DateTime.parse(budget['end_date'] as String);
        if (now.isAfter(start.subtract(const Duration(days: 1))) &&
            now.isBefore(end.add(const Duration(days: 1)))) {
          budgetId = budget['id'] as String;
          break;
        }
      }
      emit(ActiveBudgetLoaded(budgetId));
    } catch (e) {
      emit(ActiveBudgetInitial());
    }
  }
  
}
