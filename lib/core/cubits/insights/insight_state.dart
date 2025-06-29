part of 'insight_cubit.dart';

sealed class InsightsState {}

final class InsightsLoading extends InsightsState {}

final class InsightsFailure extends InsightsState {
  InsightsFailure(this.msg);
  final String msg;
}

final class InsightsLoaded extends InsightsState {
  InsightsLoaded({
    required this.chart,
    required this.days,
    required this.totalBudget,
    required this.totalSpent,
  });

  final List<ChartData>         chart;       // daily budget vs spent
  final List<DailyExpenseGroup> days;        // grouped expenses
  final double                  totalBudget; // Σ daily budgets
  final double                  totalSpent;  // Σ expenses
}
