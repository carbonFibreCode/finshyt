import 'package:fpdart/fpdart.dart';
import 'package:finshyt/core/error/failures.dart';
import 'package:finshyt/core/usecase/usecase.dart';
import 'package:finshyt/Features/insights/domain/entity/insights_entity.dart';
import 'package:finshyt/Features/insights/domain/repository/repository.dart';

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

class GetAllInsightsParams {
  final String userId;

  GetAllInsightsParams({required this.userId});
}
