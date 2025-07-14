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
  })  : _generateBudgetPlan = generateBudgetPlan,
        _saveBudgetPlan = saveBudgetPlan,
        super(BudgetPlannerInitial());

  /// Triggers the AI to generate a budget plan.
  ///
  /// It takes the parameters, emits a loading state, executes the use case,
  /// and then emits either a success or failure state based on the result.
  Future<void> generatePlan(GenerateBudgetPlanParams params) async {
    emit(BudgetPlannerLoading());
    final result = await _generateBudgetPlan(params);

    result.fold(
      (failure) => emit(BudgetPlannerFailure(failure.message)),
      (items) => emit(BudgetPlannerSuccess(items)),
    );
  }

  /// Saves the generated budget plan to the database.
  ///
  /// This method emits a saving state, calls the save use case, and handles
  /// the success or failure outcome.
  Future<void> savePlan(SaveBudgetPlanParams params) async {
    emit(BudgetSaving());
    final result = await _saveBudgetPlan(params);

    result.fold(
      (failure) => emit(BudgetPlannerFailure(failure.message)),
      (_) => emit(BudgetSaveSuccess()),
    );
  }
}
