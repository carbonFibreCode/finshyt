// lib/core/cubits/budget/budget_draft_state.dart
part of 'budget_draft_cubit.dart';

sealed class BudgetDraftState {}

final class BudgetDraftInitial extends BudgetDraftState {}

final class BudgetDraftLoading extends BudgetDraftState {}

final class BudgetDraftLoaded extends BudgetDraftState {
  BudgetDraftLoaded(this.plan);
  final BudgetPlan plan;
}

final class BudgetDraftError extends BudgetDraftState {
  BudgetDraftError(this.message);
  final String message;
}
