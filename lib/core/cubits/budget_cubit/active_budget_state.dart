
part of 'active_budget_cubit.dart';

sealed class ActiveBudgetState {}

final class ActiveBudgetInitial extends ActiveBudgetState {}

final class ActiveBudgetLoading extends ActiveBudgetState {}

final class ActiveBudgetLoaded extends ActiveBudgetState {
  final String? budgetId;

  ActiveBudgetLoaded(this.budgetId);
}
