
import 'package:finshyt/Features/expense/domain/models/expense_models.dart';

abstract interface class ExpenseRemoteDataSource {
  Future<ExpenseEntity> addExpense({
    required double amount,
    required String purpose,
  });
}
