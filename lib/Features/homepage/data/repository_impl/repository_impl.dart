import 'package:finshyt/Features/homepage/data/datasources/homepage_remote_data_sources.dart';
import 'package:finshyt/Features/homepage/domain/repository/homepage_repository.dart';
import 'package:finshyt/features/homepage/domain/entities/homepage_insights.dart';

/// Concrete implementation of the [HomepageRepository].
///
/// This class acts as the intermediary between the domain layer and the
/// data layer, calling the remote data source to fetch the necessary data.

class HomepageRepositoryImpl implements HomepageRepository {
  final HomepageRemoteDataSource remoteDataSource;

  HomepageRepositoryImpl({required this.remoteDataSource});

  @override
  Future<HomepageInsights> getHomepageInsights(String userId) async {
    try {
      // Delegate the call to the remote data source. The repository trusts
      // the data source to handle the complexities of fetching and processing
      // the raw data from Supabase.
      return await remoteDataSource.getHomepageInsights(userId);
    } catch (e) {
      // Re-throw any exceptions caught from the data source layer.
      // This allows the use case that calls this method to handle the error
      // and provide appropriate feedback to the presentation layer.
      rethrow;
    }
  }
}
