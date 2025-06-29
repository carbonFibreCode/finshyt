

import 'package:finshyt/Features/expense/domain/models/expense_models.dart';
import 'package:finshyt/Features/expense/domain/repository/repository.dart';

class AddExpense {
  AddExpense(this._repo);
  final ExpenseRepository _repo;

  Future<ExpenseEntity> call({
    required double amount,
    required String purpose,
  }) =>
      _repo.addExpense(amount: amount, purpose: purpose);
}
