// lib/core/cubits/budget/budget_save_state.dart
part of 'budget_save_cubit.dart';

sealed class BudgetSaveState {}

final class BudgetSaveInitial extends BudgetSaveState {}

final class BudgetSaveLoading extends BudgetSaveState {}

final class BudgetSaveSuccess extends BudgetSaveState {}

final class BudgetSaveFailure extends BudgetSaveState {
  BudgetSaveFailure(this.message);
  final String message;
}
