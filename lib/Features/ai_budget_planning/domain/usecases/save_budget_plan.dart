import 'package:finshyt/Features/ai_budget_planning/domain/entities/budget.dart';
import 'package:finshyt/Features/ai_budget_planning/domain/repositories/budegt_repository.dart';
import 'package:finshyt/core/error/failures.dart';
import 'package:finshyt/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

/// Use case for saving a generated budget plan.
///
/// This follows the Usecase interface, returning a `Future<Either<Failure, void>>`
/// to clearly signal the success or failure of the save operation.
class SaveBudgetPlan implements Usecase<void, SaveBudgetPlanParams> {
  final BudgetRepository _repository;

  SaveBudgetPlan(this._repository);

  /// Executes the use case to save the plan.
  @override
  Future<Either<Failure, void>> call(SaveBudgetPlanParams params) async {
    try {
      await _repository.saveBudgetPlan(
        userId: params.userId,
        startDate: params.startDate,
        items: params.items,
      );
      // `Right(null)` or `Right(unit)` signifies a successful void operation.
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}

/// Parameters required for the SaveBudgetPlan use case.
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
