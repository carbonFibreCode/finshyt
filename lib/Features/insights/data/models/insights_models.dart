import 'package:finshyt/Features/ai_budget_planning/data/models/budget_model.dart';
import 'package:finshyt/Features/expense/data/models/expense_models.dart';
import 'package:finshyt/Features/insights/domain/entity/insights_entity.dart';
import 'package:finshyt/core/models/chart_data_models.dart';

class InsightsModel extends Insights {
  const InsightsModel({
    required super.totalExpense,
    required super.balance,
    required super.avgSpendPerDay,
    required super.monthlyBudget,
    required super.chartData,
    required super.dailyGroups,
  });

  factory InsightsModel.fromRawData({
    required List<BudgetItemModel> budgetItems,
    required List<ExpenseModel> expenses,
  }) {
    final double totalBudget = budgetItems.fold(
      0.0,
      (sum, item) => sum + item.amount,
    );

    final Map<DateTime, List<ExpenseModel>> expensesByDay = {};
    for (final expense in expenses) {
      final day = DateTime(
        expense.expenseDate.year,
        expense.expenseDate.month,
        expense.expenseDate.day,
      );
      expensesByDay.putIfAbsent(day, () => []).add(expense);
    }

    final List<DailyExpenseGroup> dailyGroups = expensesByDay.entries.map((
      entry,
    ) {
      final double totalForDay = entry.value.fold(
        0.0,
        (sum, item) => sum + item.amount,
      );
      return DailyExpenseGroup(
        date: entry.key,
        total: totalForDay,
        items: entry.value,
      );
    }).toList();

    final double totalExpense = dailyGroups.fold(
      0.0,
      (sum, group) => sum + group.total,
    );
    final double balance = totalBudget - totalExpense;
    final double avgSpendPerDay = dailyGroups.isEmpty
        ? 0.0
        : totalExpense / dailyGroups.length;

    final Map<DateTime, double> budgetMap = {
      for (var item in budgetItems) item.date: item.amount,
    };
    final List<ChartData> chartData = dailyGroups.map((group) {
      return ChartData(
        label: '${group.date.day}/${group.date.month}',
        primaryValue: group.total,
        secondaryValue: budgetMap[group.date] ?? 0.0,
      );
    }).toList()..sort((a, b) => a.label.compareTo(b.label));

    return InsightsModel(
      totalExpense: totalExpense,
      balance: balance,
      avgSpendPerDay: avgSpendPerDay,
      monthlyBudget: totalBudget,
      chartData: chartData,
      dailyGroups: dailyGroups,
    );
  }
}
