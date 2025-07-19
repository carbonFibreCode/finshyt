import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finshyt/Features/ai_budget_planning/domain/entities/budget.dart';
import 'package:finshyt/Features/ai_budget_planning/domain/usecases/generate_budget_plan.dart';
import 'package:finshyt/Features/ai_budget_planning/domain/usecases/save_budget_plan.dart';

part 'budget_planner_state.dart';

class BudgetPlannerCubit extends Cubit<BudgetPlannerState> {
  final GenerateBudgetPlan _generateBudgetPlan;
  final SaveBudgetPlan _saveBudgetPlan;

  BudgetPlannerCubit({
    required GenerateBudgetPlan generateBudgetPlan,
    required SaveBudgetPlan saveBudgetPlan,
  }) : _generateBudgetPlan = generateBudgetPlan,
       _saveBudgetPlan = saveBudgetPlan,
       super(BudgetPlannerInitial());

  @override
  void emit(BudgetPlannerState state) {
    if (!isClosed) {
      super.emit(state);
    }
  }

  Future<void> generatePlan(GenerateBudgetPlanParams params) async {
    emit(BudgetPlannerLoading());
    final result = await _generateBudgetPlan(params);
    if (isClosed) {
      return;
    }
    result.fold(
      (failure) {
        emit(BudgetPlannerFailure(failure.message));
      },
      (items) {
        emit(BudgetPlannerSuccess(items));
      },
    );
  }

  Future<void> savePlan(SaveBudgetPlanParams params) async {
    emit(BudgetSaving());
    final result = await _saveBudgetPlan(params);
    if (isClosed) return;
    result.fold((failure) {
      emit(BudgetPlannerFailure(failure.message));
    }, (_) => emit(BudgetSaveSuccess()));
  }
}
