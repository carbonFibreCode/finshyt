
import 'package:equatable/equatable.dart';

class Budget extends Equatable {
  final String id;
  final String userId;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;
  final List<BudgetItem> items;

  const Budget({
    required this.id,
    required this.userId,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    this.items = const [],
  });

  @override
  List<Object?> get props => [id, userId, startDate, endDate, createdAt, items];
}

class BudgetItem extends Equatable {
  final String id;
  final String budgetId;
  final DateTime date;
  final double amount;

  const BudgetItem({
    required this.id,
    required this.budgetId,
    required this.date,
    required this.amount,
  });

  @override
  List<Object?> get props => [id, budgetId, date, amount];
}
