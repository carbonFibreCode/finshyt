import 'package:finshyt/Features/expense/domain/models/expense_models.dart';
import 'package:finshyt/models/chart_data_models.dart';
import '../repository/repository.dart';

class GetInsights {
  GetInsights(this.repo);
  final InsightsRepository repo;

  Future<(List<ChartData>, List<DailyExpenseGroup>, double, double)> call(String userId, {DateTime? startDate}) =>
      repo.fetchInsights(userId,);
}
