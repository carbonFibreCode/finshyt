
import 'package:finshyt/Features/insights/domain/entity/insights_entity.dart';
import 'package:finshyt/Features/insights/domain/repository/repository.dart';
import 'package:finshyt/core/models/chart_data_models.dart';

class GetInsights {
  GetInsights(this.repo);
  final InsightsRepository repo;

  Future<(List<ChartData>, List<DailyExpenseGroup>, double, double)> call(String userId, {DateTime? startDate}) =>
      repo.fetchInsights(userId, startDate: startDate);
}
