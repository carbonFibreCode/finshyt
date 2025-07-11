import 'package:bloc/bloc.dart';
import 'package:finshyt/Features/expense/domain/usecases/add_expense.dart';
import 'package:finshyt/Features/expense/presentation/expense/add_expense_state.dart';

class AddExpenseCubit extends Cubit<AddExpenseState> {
  AddExpenseCubit(this._addExpense) : super(AddExpenseInitial());
  final AddExpense _addExpense;

  Future<void> add({
    required double amount,
    required String purpose,
  }) async {
    emit(AddExpenseLoading());
    try {
      final expense = await _addExpense(amount: amount, purpose: purpose);
      emit(AddExpenseSuccess(expense));
    } catch (e) {
      emit(AddExpenseFailure(e.toString()));
    }
  }
}
