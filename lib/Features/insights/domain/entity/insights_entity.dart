import 'package:finshyt/Features/expense/data/models/expense_models.dart';

class DailyExpenseGroup {
  final DateTime date;                 
  final double total;              
  final List<ExpenseItem> items;       

  const DailyExpenseGroup({
    required this.date,
    required this.total,
    required this.items,
  });
}