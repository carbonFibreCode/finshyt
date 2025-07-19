import 'package:finshyt/features/homepage/domain/entities/homepage_insights.dart';

abstract interface class HomepageRemoteDataSource {
  Future<HomepageInsights> getHomepageInsights(String userId);
}
