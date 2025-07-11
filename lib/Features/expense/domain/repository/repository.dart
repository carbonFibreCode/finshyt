
import 'package:finshyt/Features/expense/domain/enitity/expense_entity.dart';

abstract interface class ExpenseRepository {
  Future<ExpenseEntity> addExpense({
    required double amount,
    required String purpose,
  });
}


