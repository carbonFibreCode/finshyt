import 'package:finshyt/Features/ai_budget_planning/data/models/budget_model.dart';
import 'package:finshyt/Features/expense/data/models/expense_models.dart';
import 'package:finshyt/core/models/chart_data_models.dart';
import 'package:finshyt/features/homepage/domain/entities/homepage_insights.dart';

class HomepageInsightsModel extends HomepageInsights {
  const HomepageInsightsModel({
    required super.totalBudget,
    required super.totalSpent,
    required super.balance,
    required super.averageDailySpend,
    required super.chartData,
    required super.dailyExpenses,
  });


  factory HomepageInsightsModel.fromRawData({
    required List<BudgetItemModel> budgetItems,
    required List<ExpenseModel> expenses,
  }) {
    // Calculate total budget from the list of daily budget items.
    final double totalBudget =
        budgetItems.fold(0.0, (sum, item) => sum + item.amount);

    // Group expenses by day.
    final Map<DateTime, List<ExpenseModel>> expensesByDay = {};
    for (final expense in expenses) {
      final day = DateTime(expense.expenseDate.year, expense.expenseDate.month, expense.expenseDate.day);
      expensesByDay.putIfAbsent(day, () => []).add(expense);
    }

    // Create a list of DailyExpenseGroup entities.
    final List<DailyExpenseGroup> dailyGroups = expensesByDay.entries.map((entry) {
      final double totalForDay =
          entry.value.fold(0.0, (sum, item) => sum + item.amount);
      return DailyExpenseGroup(date: entry.key, total: totalForDay, items: entry.value);
    }).toList();

    // Calculate total spent.
    final double totalSpent =
        dailyGroups.fold(0.0, (sum, group) => sum + group.total);

    // Calculate remaining balance.
    final double balance = totalBudget - totalSpent;

    // Calculate average daily spending.
    final double averageDailySpend = dailyGroups.isEmpty ? 0.0 : totalSpent / dailyGroups.length;

    // Create data for the chart.
    final Map<DateTime, double> budgetMap = {
      for (var item in budgetItems) item.date: item.amount
    };
    final List<ChartData> chartData = dailyGroups.map((group) {
      return ChartData(
        label: '${group.date.day}/${group.date.month}',
        primaryValue: group.total, // Amount spent
        secondaryValue: budgetMap[group.date] ?? 0.0, // Budgeted amount
      );
    }).toList()
      ..sort((a, b) => a.label.compareTo(b.label)); // Sort by date for the chart

    return HomepageInsightsModel(
      totalBudget: totalBudget,
      totalSpent: totalSpent,
      balance: balance,
      averageDailySpend: averageDailySpend,
      chartData: chartData,
      dailyExpenses: dailyGroups,
    );
  }
  @override
  List<Object> get props => [
    totalBudget,
    totalSpent,
    balance,
    averageDailySpend,
    chartData,
    dailyExpenses,
  ]; 
}
