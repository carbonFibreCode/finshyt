import 'package:finshyt/Features/insights/domain/entity/insights_entity.dart';

/// Abstract interface for fetching insights data from a remote source.
abstract interface class InsightsRemoteDataSource {
  /// Fetches all insights data for the given user.
  ///
  /// Returns an [Insights] entity containing aggregated data.
  /// Throws an [Exception] if the operation fails.
  Future<Insights> getAllInsights(String userId);
}
