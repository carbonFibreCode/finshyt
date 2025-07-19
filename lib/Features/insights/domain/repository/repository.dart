import 'package:finshyt/Features/insights/domain/entity/insights_entity.dart';

abstract interface class InsightsRepository {
  Future<Insights> getAllInsights(String userId);
}
