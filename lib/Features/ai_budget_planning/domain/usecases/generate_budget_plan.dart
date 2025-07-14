import 'package:finshyt/Features/ai_budget_planning/domain/entities/budget.dart';
import 'package:finshyt/Features/ai_budget_planning/domain/repositories/budegt_repository.dart';
import 'package:finshyt/core/error/failures.dart';
import 'package:finshyt/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

/// Use case for generating a new budget plan.
///
/// Implements the Usecase interface to enforce a consistent architectural pattern,
/// returning an Either type to handle success and failure states explicitly.
class GenerateBudgetPlan
    implements Usecase<List<BudgetItem>, GenerateBudgetPlanParams> {
  final BudgetRepository _repository;

  GenerateBudgetPlan(this._repository);

  /// Executes the use case.
  @override
  Future<Either<Failure, List<BudgetItem>>> call(
    GenerateBudgetPlanParams params,
  ) async {
    try {
      final budgetItems = await _repository.generateBudgetPlan(
        monthlyBudget: params.monthlyBudget,
        description: params.description,
        eventDate: params.eventDate,
        city: params.city,
      );
      return Right(budgetItems);
    } catch (e) {
      // Catches exceptions from the repository/data layer and maps them to a Failure object.
      return Left(Failure(e.toString()));
    }
  }
}

/// Parameters required for the GenerateBudgetPlan use case.
///
/// Encapsulating parameters in a dedicated class improves readability and
/// makes it easier to pass data through the layers of the application.
class GenerateBudgetPlanParams {
  final double monthlyBudget;
  final String description;
  final DateTime? eventDate;
  final String? city;

  GenerateBudgetPlanParams({
    required this.monthlyBudget,
    required this.description,
    this.eventDate,
    this.city,
  });
}
