import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finshyt/Features/ai_budget_planning/domain/models/models.dart';
import 'package:finshyt/Features/ai_budget_planning/domain/repository/repository.dart';

part 'budget_save_state.dart';

class BudgetSaveCubit extends Cubit<BudgetSaveState> {
  BudgetSaveCubit(this._repo) : super(BudgetSaveInitial());

  final BudgetRepository _repo;               // uses repo.savePlan[7]

  Future<void> savePlan({
    required String userId,
    required double dailyBudget,
    required BudgetPlan plan,
  }) async {
    emit(BudgetSaveLoading());
    try {
      await _repo.savePlan(                   // remote call wired in repo[6]
        userId: userId,
        dailyBudget: dailyBudget,
        plan: plan,
      );
      emit(BudgetSaveSuccess());
    } catch (e) {
      emit(BudgetSaveFailure(e.toString()));
    }
  }
}
