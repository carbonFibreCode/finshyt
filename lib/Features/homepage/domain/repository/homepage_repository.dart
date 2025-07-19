import 'package:finshyt/features/homepage/domain/entities/homepage_insights.dart';

abstract interface class HomepageRepository {
  Future<HomepageInsights> getHomepageInsights(String userId);
}
