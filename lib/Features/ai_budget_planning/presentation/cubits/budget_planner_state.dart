part of 'budget_planner_cubit.dart';


abstract class BudgetPlannerState extends Equatable {
  const BudgetPlannerState();

  @override
  List<Object> get props => [];
}

/// The initial state before any action is taken.
class BudgetPlannerInitial extends BudgetPlannerState {}

/// State indicating that the AI is generating a budget plan.
class BudgetPlannerLoading extends BudgetPlannerState {}

/// State indicating that the plan is being saved to the database.
class BudgetSaving extends BudgetPlannerState {}

/// State representing the successful generation of a budget plan.
/// It holds the list of generated [BudgetItem] entities.
class BudgetPlannerSuccess extends BudgetPlannerState {
  final List<BudgetItem> items;

  const BudgetPlannerSuccess(this.items);

  @override
  List<Object> get props => [items];
}

/// State representing the successful saving of a budget plan.
class BudgetSaveSuccess extends BudgetPlannerState {}

/// State indicating that an error occurred during either generation or saving.
/// It contains a user-friendly error message.
class BudgetPlannerFailure extends BudgetPlannerState {
  final String message;

  const BudgetPlannerFailure(this.message);

  @override
  List<Object> get props => [message];
}
