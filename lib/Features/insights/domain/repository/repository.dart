import 'package:finshyt/Features/insights/domain/entity/insights_entity.dart';

/// Abstract interface for the insights repository.
///
/// This defines the contract for data operations related to insights,
/// acting as a bridge between the domain and data layers.
abstract interface class InsightsRepository {
  /// Fetches all insights for a given user.
  ///
  /// Returns an [Insights] entity with aggregated data.
  /// Throws an exception if the operation fails.
  Future<Insights> getAllInsights(String userId);
}
