import 'package:equatable/equatable.dart';
import 'package:finshyt/core/entity/expense.dart';
import 'package:finshyt/core/models/chart_data_models.dart';

class DailyExpenseGroup extends Equatable {
  final DateTime date;
  final double total;
  final List<Expense> items;

  const DailyExpenseGroup({
    required this.date,
    required this.total,
    required this.items,
  });

  @override
  List<Object?> get props => [date, total, items];
}

class HomepageInsights extends Equatable {
  final double totalBudget;
  final double totalSpent;
  final double balance;
  final double averageDailySpend;
  final List<ChartData> chartData;
  final List<DailyExpenseGroup> dailyExpenses;

  const HomepageInsights({
    required this.totalBudget,
    required this.totalSpent,
    required this.balance,
    required this.averageDailySpend,
    required this.chartData,
    required this.dailyExpenses,
  });

  @override
  List<Object?> get props => [
    totalBudget,
    totalSpent,
    balance,
    averageDailySpend,
    chartData,
    dailyExpenses,
  ];
}
