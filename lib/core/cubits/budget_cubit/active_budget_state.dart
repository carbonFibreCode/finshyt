
part of 'active_budget_cubit.dart';

sealed class ActiveBudgetState {}

final class ActiveBudgetInitial extends ActiveBudgetState {} // No active budget (null)

final class ActiveBudgetLoading extends ActiveBudgetState {}

final class ActiveBudgetLoaded extends ActiveBudgetState {
  final String? budgetId; // Null if not found

  ActiveBudgetLoaded(this.budgetId);
}
