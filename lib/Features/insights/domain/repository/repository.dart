import 'package:finshyt/Features/insights/domain/entity/insights_entity.dart';
import 'package:finshyt/core/models/chart_data_models.dart';

abstract interface class InsightsRepository {
  Future<(List<ChartData>, List<DailyExpenseGroup>, double, double)> fetchInsights(
    String userId, {DateTime? startDate}
  );

}
