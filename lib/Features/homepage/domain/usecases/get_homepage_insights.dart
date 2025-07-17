import 'package:finshyt/Features/homepage/domain/repository/homepage_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:finshyt/core/error/failures.dart';
import 'package:finshyt/core/usecase/usecase.dart';
import 'package:finshyt/features/homepage/domain/entities/homepage_insights.dart';

/// Use case for fetching the aggregated insights for the homepage.
///
/// This class implements the Usecase interface, providing a structured and
class GetHomepageInsights implements Usecase<HomepageInsights, GetHomepageInsightsParams> {
  final HomepageRepository _repository;

  GetHomepageInsights(this._repository);

  /// Executes the use case to fetch homepage data.
  /// It returns a Future<Either<Failure, HomepageInsights>> to explicitly handle
  /// success or failure.
  @override
  Future<Either<Failure, HomepageInsights>> call(GetHomepageInsightsParams params) async {
    try {
      final insights = await _repository.getHomepageInsights(params.userId);
      return Right(insights);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}

/// Parameters required for the GetHomepageInsights use case.
///
/// Encapsulating the `userId` in a dedicated class makes the use case signature
/// clean and aligns with the generic Usecase interface.
class GetHomepageInsightsParams {
  final String userId;

  GetHomepageInsightsParams({required this.userId});
}
