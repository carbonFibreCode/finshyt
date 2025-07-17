import 'package:finshyt/features/homepage/domain/entities/homepage_insights.dart';

/// Abstract interface for the Homepage repository.
///
/// This contract defines the data operations available for the homepage feature,
/// serving as the single source of truth for the domain layer on how to
/// retrieve dashboard data.
abstract interface class HomepageRepository {
  /// Fetches the aggregated insights for the homepage.
  ///
  /// This method is responsible for retrieving all the necessary data
  /// to build the homepage dashboard and returning it as a single,
  /// cohesive [HomepageInsights] entity. It will throw an exception
  /// if the operation fails.
  Future<HomepageInsights> getHomepageInsights(String userId);
}
