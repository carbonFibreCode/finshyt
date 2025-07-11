import 'package:finshyt/Features/insights/data/dataSources/insights_remote_data_source.dart/insights_remote_data_source.dart';
import 'package:finshyt/Features/insights/domain/entity/insights_entity.dart';
import 'package:finshyt/Features/insights/domain/repository/repository.dart';
import 'package:finshyt/core/models/chart_data_models.dart';

class InsightsRepositoryImpl implements InsightsRepository {
  final InsightsRemoteDataSource remoteDataSource;

  InsightsRepositoryImpl(this.remoteDataSource);

  @override
  Future<(List<ChartData>, List<DailyExpenseGroup>, double, double)> fetchInsights(String userId, {DateTime? startDate}) async {
    return await remoteDataSource.fetchInsights(userId, startDate: startDate);
  }
}
