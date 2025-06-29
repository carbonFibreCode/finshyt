
import 'package:equatable/equatable.dart';
import 'package:finshyt/Features/expense/domain/models/expense_models.dart';

sealed class AddExpenseState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class AddExpenseInitial extends AddExpenseState {}

final class AddExpenseLoading extends AddExpenseState {}

final class AddExpenseSuccess extends AddExpenseState {
  final ExpenseEntity expense;
  AddExpenseSuccess(this.expense);
  @override
  List<Object?> get props => [expense];
}

final class AddExpenseFailure extends AddExpenseState {
  final String msg;
  AddExpenseFailure(this.msg);
  @override
  List<Object?> get props => [msg];
}
