
import 'package:finshyt/core/entity/expense.dart';

/// Abstract interface for the Expense repository.
///
/// This defines the contract for data operations related to expenses,
/// acting as a bridge between the domain and data layers.
abstract interface class ExpenseRepository {
  /// Adds a new expense.
  ///
  /// This method takes an [Expense] entity and persists it via a data source.
  /// It will throw an exception if the operation fails, which should be
  /// handled by the use case that calls it.
  Future<void> addExpense(Expense expense);
}
