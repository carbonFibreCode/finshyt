import 'package:finshyt/Features/insights/data/remote_data_source/remote_data_source.dart';
import 'package:finshyt/Features/insights/domain/entity/insights_entity.dart';
import 'package:finshyt/Features/insights/domain/repository/repository.dart';

/// Concrete implementation of the [InsightsRepository].
///
/// This class orchestrates data flow by delegating to the remote data source.
class InsightsRepositoryImpl implements InsightsRepository {
  final InsightsRemoteDataSource remoteDataSource;

  InsightsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Insights> getAllInsights(String userId) async {
    try {
      // Delegate the call to the remote data source
      return await remoteDataSource.getAllInsights(userId);
    } catch (e) {
      // Rethrow exceptions to be handled by the use case or presentation layer
      rethrow;
    }
  }
}
