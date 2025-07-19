import 'package:finshyt/Features/expense/domain/repositories/repository.dart';
import 'package:finshyt/core/entity/expense.dart';
import 'package:finshyt/features/expense/data/datasources/expense_remote_data_source.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseRemoteDataSource remoteDataSource;

  ExpenseRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> addExpense(Expense expense) async {
    try {
      return await remoteDataSource.addExpense(expense);
    } catch (e) {
      rethrow;
    }
  }
}
