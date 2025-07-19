import 'package:finshyt/Features/insights/data/remote_data_source/remote_data_source.dart';
import 'package:finshyt/Features/insights/domain/entity/insights_entity.dart';
import 'package:finshyt/Features/insights/domain/repository/repository.dart';




class InsightsRepositoryImpl implements InsightsRepository {
  final InsightsRemoteDataSource remoteDataSource;

  InsightsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Insights> getAllInsights(String userId) async {
    try {
      
      return await remoteDataSource.getAllInsights(userId);
    } catch (e) {
      
      rethrow;
    }
  }
}
