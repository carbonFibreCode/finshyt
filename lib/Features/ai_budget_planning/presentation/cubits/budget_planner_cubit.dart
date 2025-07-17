import 'dart:developer';

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

  /// Triggers the AI to generate a budget plan.
  ///
  /// It takes the parameters, emits a loading state, executes the use case,
  /// and then emits either a success or failure state based on the result.
  /// @override
  @override
  void emit(BudgetPlannerState state) {
    if (!isClosed) {
      log('Emitting state: $state'); // Debug emission
      super.emit(state);
    }
  }

  Future<void> generatePlan(GenerateBudgetPlanParams params) async {
    log(
      'Starting generatePlan with params: ${params.monthlyBudget}, ${params.description}',
    );
    emit(BudgetPlannerLoading());
    final result = await _generateBudgetPlan(params);
    if (isClosed) {
      log('generatePlan completed but cubit closed');
      return;
    }
    result.fold(
      (failure) {
        emit(BudgetPlannerFailure(failure.message));
        log('Emitted BudgetPlannerFailure: ${failure.message}');
      },
      (items) {
        emit(BudgetPlannerSuccess(items));
        log(
          'Emitted BudgetPlannerSuccess with ${items.length} items',
        ); // New log
      },
    );
    log('generatePlan emitted state');
  }

  /// Saves the generated budget plan to the database.
  ///
  /// This method emits a saving state, calls the save use case, and handles
  /// the success or failure outcome.
  Future<void> savePlan(SaveBudgetPlanParams params) async {
    log('Starting savePlan');
    emit(BudgetSaving());
    final result = await _saveBudgetPlan(params);
    if (isClosed) return;
    result.fold((failure) {
      emit(BudgetPlannerFailure(failure.message));
      log('Save failed: ${failure.message}');
    }, (_) => emit(BudgetSaveSuccess()));
  }
}
