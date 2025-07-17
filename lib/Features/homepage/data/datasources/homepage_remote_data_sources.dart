import 'package:finshyt/features/homepage/domain/entities/homepage_insights.dart';

/// Abstract interface for fetching data required for the homepage.
///
/// This contract ensures that any implementation provides a consistent method
/// for retrieving the aggregated insights needed by the application's dashboard.
abstract interface class HomepageRemoteDataSource {
  /// Fetches and processes data for the user's latest budget cycle to
  /// create a [HomepageInsights] object.
  ///
  /// This method retrieves the most recent budget, its associated daily items,
  /// and the expenses recorded within that budget period.
  ///
  /// Throws an [Exception] if the data fetching fails.
  Future<HomepageInsights> getHomepageInsights(String userId);
}
