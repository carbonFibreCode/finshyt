
import 'package:finshyt/Features/expense/domain/repositories/repository.dart';
import 'package:finshyt/core/entity/expense.dart';
import 'package:fpdart/fpdart.dart';
import 'package:finshyt/core/error/failures.dart';
import 'package:finshyt/core/usecase/usecase.dart';

class AddExpense implements Usecase<void, AddExpenseParams> {
  final ExpenseRepository _expenseRepository;

  AddExpense(this._expenseRepository);

  @override
  Future<Either<Failure, void>> call(AddExpenseParams params) async {
    try {
      final expense = Expense(
        id: '', 
        userId: params.userId,
        budgetId: params.budgetId,
        amount: params.amount,
        description: params.description,
        expenseDate: params.expenseDate,
      );
      await _expenseRepository.addExpense(expense);
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}

class AddExpenseParams {
  final String userId;
  final String? budgetId;
  final double amount;
  final String description;
  final DateTime expenseDate;

  AddExpenseParams({
    required this.userId,
    this.budgetId,
    required this.amount,
    required this.description,
    required this.expenseDate,
  });
}
