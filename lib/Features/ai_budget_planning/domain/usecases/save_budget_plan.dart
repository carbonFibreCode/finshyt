import 'package:finshyt/Features/ai_budget_planning/domain/entities/budget.dart';
import 'package:finshyt/Features/ai_budget_planning/domain/repositories/budegt_repository.dart';
import 'package:finshyt/core/error/failures.dart';
import 'package:finshyt/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

class SaveBudgetPlan implements Usecase<void, SaveBudgetPlanParams> {
  final BudgetRepository _repository;

  SaveBudgetPlan(this._repository);

  @override
  Future<Either<Failure, void>> call(SaveBudgetPlanParams params) async {
    try {
      await _repository.saveBudgetPlan(
        userId: params.userId,
        startDate: params.startDate,
        items: params.items,
      );

      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}

class SaveBudgetPlanParams {
  final String userId;
  final DateTime startDate;
  final List<BudgetItem> items;

  SaveBudgetPlanParams({
    required this.userId,
    required this.startDate,
    required this.items,
  });
}
