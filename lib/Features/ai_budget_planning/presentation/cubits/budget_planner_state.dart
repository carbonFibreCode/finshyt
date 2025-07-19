part of 'budget_planner_cubit.dart';

abstract class BudgetPlannerState extends Equatable {
  const BudgetPlannerState();

  @override
  List<Object> get props => [];
}

class BudgetPlannerInitial extends BudgetPlannerState {}

class BudgetPlannerLoading extends BudgetPlannerState {}

class BudgetSaving extends BudgetPlannerState {}

class BudgetPlannerSuccess extends BudgetPlannerState {
  final List<BudgetItem> items;

  const BudgetPlannerSuccess(this.items);

  @override
  List<Object> get props => [items];
}

class BudgetSaveSuccess extends BudgetPlannerState {}

class BudgetPlannerFailure extends BudgetPlannerState {
  final String message;

  const BudgetPlannerFailure(this.message);

  @override
  List<Object> get props => [message];
}
