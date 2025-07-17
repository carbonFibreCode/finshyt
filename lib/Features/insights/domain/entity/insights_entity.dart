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

class Insights extends Equatable {
  final double totalExpense;
  final double balance;
  final double avgSpendPerDay;
  final double monthlyBudget;
  final List<ChartData> chartData;
  final List<DailyExpenseGroup> dailyGroups;

  const Insights({
    required this.totalExpense,
    required this.balance,
    required this.avgSpendPerDay,
    required this.monthlyBudget,
    required this.chartData,
    required this.dailyGroups,
  });

  @override
  List<Object?> get props => [
        totalExpense,
        balance,
        avgSpendPerDay,
        monthlyBudget,
        chartData,
        dailyGroups,
      ];
}
