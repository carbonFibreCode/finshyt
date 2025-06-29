import 'package:finshyt/Features/expense/domain/models/expense_models.dart';
import 'package:finshyt/models/chart_data_models.dart';


abstract interface class InsightsRepository {
  Future<(List<ChartData>, List<DailyExpenseGroup>, double, double)> fetchInsights(
    String userId, {DateTime? startDate}
  );

}


abstract interface class ExpenseRepository {
  Future<ExpenseEntity> addExpense({
    required double amount,
    required String purpose,
  });
}


