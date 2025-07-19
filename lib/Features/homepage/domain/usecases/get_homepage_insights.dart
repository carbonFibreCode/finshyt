import 'package:finshyt/Features/homepage/domain/repository/homepage_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:finshyt/core/error/failures.dart';
import 'package:finshyt/core/usecase/usecase.dart';
import 'package:finshyt/features/homepage/domain/entities/homepage_insights.dart';

class GetHomepageInsights
    implements Usecase<HomepageInsights, GetHomepageInsightsParams> {
  final HomepageRepository _repository;

  GetHomepageInsights(this._repository);

  @override
  Future<Either<Failure, HomepageInsights>> call(
    GetHomepageInsightsParams params,
  ) async {
    try {
      final insights = await _repository.getHomepageInsights(params.userId);
      return Right(insights);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}

class GetHomepageInsightsParams {
  final String userId;

  GetHomepageInsightsParams({required this.userId});
}
