import 'package:equatable/equatable.dart';

class Expense extends Equatable {
  final String id;
  final String userId;
  final String? budgetId; 
  final double amount;
  final String description;
  final DateTime expenseDate;

  const Expense({
    required this.id,
    required this.userId,
    this.budgetId,
    required this.amount,
    required this.description,
    required this.expenseDate,
  });

  @override
  List<Object?> get props => [id, userId, budgetId, amount, description, expenseDate];
}
