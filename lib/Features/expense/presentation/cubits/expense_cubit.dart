import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finshyt/features/expense/domain/usecases/add_expense.dart';

part 'expense_states.dart';

class ExpenseCubit extends Cubit<ExpenseState> {
  final AddExpense _addExpense;

  ExpenseCubit({required AddExpense addExpense})
    : _addExpense = addExpense,
      super(ExpenseInitial());

  Future<void> addExpense(AddExpenseParams params) async {
    emit(ExpenseLoading());
    final result = await _addExpense(params);

    result.fold(
      (failure) => emit(ExpenseFailure(failure.message)),
      (_) => emit(ExpenseSuccess()),
    );
  }
}
