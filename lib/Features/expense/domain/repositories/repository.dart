import 'package:finshyt/core/entity/expense.dart';

abstract interface class ExpenseRepository {
  Future<void> addExpense(Expense expense);
}
