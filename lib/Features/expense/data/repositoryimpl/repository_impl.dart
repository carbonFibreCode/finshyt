import 'dart:async';
import 'package:finshyt/Features/expense/data/data_source/add_expense_remote_data_source_impl.dart';
import 'package:finshyt/Features/expense/domain/enitity/expense_entity.dart';
import 'package:finshyt/Features/expense/domain/repository/repository.dart';

final class ExpenseRepositoryImpl implements ExpenseRepository {
  ExpenseRepositoryImpl(this._remote);
  final ExpenseRemoteDataSource _remote;

  @override
  Future<ExpenseEntity> addExpense({
    required double amount,
    required String purpose,
  }) =>
      _remote.addExpense(amount: amount, purpose: purpose);
}
