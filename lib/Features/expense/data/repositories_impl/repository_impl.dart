
import 'package:finshyt/Features/expense/domain/repositories/repository.dart';
import 'package:finshyt/core/entity/expense.dart';
import 'package:finshyt/features/expense/data/datasources/expense_remote_data_source.dart';


class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseRemoteDataSource remoteDataSource;

  ExpenseRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> addExpense(Expense expense) async {
    try {
      // Delegate the call to the remote data source. The repository trusts
      // the data source to handle the specifics of the database interaction.
      return await remoteDataSource.addExpense(expense);
    } catch (e) {
      // Re-throw the exception to be handled by the calling use case.
      // This ensures that failures in the data layer are propagated
      // up to the presentation layer for user feedback.
      rethrow;
    }
  }
}
