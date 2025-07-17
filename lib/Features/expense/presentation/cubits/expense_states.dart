part of 'expense_cubit.dart';

abstract class ExpenseState extends Equatable {
  const ExpenseState();

  @override
  List<Object> get props => [];
}

/// The initial state before any action is taken.
class ExpenseInitial extends ExpenseState {}

/// State indicating that the expense is being saved to the database.
class ExpenseLoading extends ExpenseState {}

/// State representing the successful addition of an expense.
class ExpenseSuccess extends ExpenseState {}

/// State indicating that an error occurred while adding the expense.
class ExpenseFailure extends ExpenseState {
  final String message;

  const ExpenseFailure(this.message);

  @override
  List<Object> get props => [message];
}
