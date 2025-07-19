import 'package:finshyt/core/entity/expense.dart';

class ExpenseModel extends Expense {
  const ExpenseModel({
    required super.id,
    required super.userId,
    super.budgetId,
    required super.amount,
    required super.description,
    required super.expenseDate,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      budgetId: json['budget_id'] as String?,
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] as String,
      expenseDate: DateTime.parse(json['expense_date'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'budget_id': budgetId,
      'amount': amount,
      'description': description,
      'expense_date': expenseDate.toIso8601String(),
    };
  }
}
