import 'package:finshyt/Features/homepage/data/datasources/homepage_remote_data_sources.dart';
import 'package:finshyt/Features/homepage/domain/repository/homepage_repository.dart';
import 'package:finshyt/features/homepage/domain/entities/homepage_insights.dart';

class HomepageRepositoryImpl implements HomepageRepository {
  final HomepageRemoteDataSource remoteDataSource;

  HomepageRepositoryImpl({required this.remoteDataSource});

  @override
  Future<HomepageInsights> getHomepageInsights(String userId) async {
    try {
      return await remoteDataSource.getHomepageInsights(userId);
    } catch (e) {
      rethrow;
    }
  }
}
