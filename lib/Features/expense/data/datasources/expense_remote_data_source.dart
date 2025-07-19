import 'package:finshyt/core/entity/expense.dart';

abstract interface class ExpenseRemoteDataSource {
  Future<void> addExpense(Expense expense);
}
