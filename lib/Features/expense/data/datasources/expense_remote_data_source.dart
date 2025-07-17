

import 'package:finshyt/core/entity/expense.dart';

/// Abstract interface for handling expense-related data operations
/// with a remote data store (e.g., Supabase).
abstract interface class ExpenseRemoteDataSource {
  /// Adds a new expense record to the database.
  ///
  /// Takes an [Expense] entity, converts it to a model, and persists it.
  /// Throws an [Exception] if the operation fails.
  Future<void> addExpense(Expense expense);
}
