import 'package:fpdart/fpdart.dart';
import 'package:finshyt/core/error/failures.dart';
import 'package:finshyt/core/usecase/usecase.dart';
import 'package:finshyt/Features/insights/domain/entity/insights_entity.dart';
import 'package:finshyt/Features/insights/domain/repository/repository.dart';

/// Use case for fetching all insights for a user.
///
/// This class implements the Usecase interface, providing a structured and
/// type-safe way to execute this specific business logic.
class GetAllInsights implements Usecase<Insights, GetAllInsightsParams> {
  final InsightsRepository _repository;

  GetAllInsights(this._repository);

  @override
  Future<Either<Failure, Insights>> call(GetAllInsightsParams params) async {
    try {
      final insights = await _repository.getAllInsights(params.userId);
      return Right(insights);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}

/// Parameters required for the GetAllInsights use case.
///
/// Encapsulating the `userId` in a dedicated class makes the use case signature
/// clean and aligns with the generic Usecase interface.
class GetAllInsightsParams {
  final String userId;

  GetAllInsightsParams({required this.userId});
}
