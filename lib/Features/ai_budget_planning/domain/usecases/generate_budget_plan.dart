import 'package:finshyt/Features/ai_budget_planning/domain/entities/budget.dart';
import 'package:finshyt/Features/ai_budget_planning/domain/repositories/budegt_repository.dart';
import 'package:finshyt/core/error/failures.dart';
import 'package:finshyt/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

class GenerateBudgetPlan
    implements Usecase<List<BudgetItem>, GenerateBudgetPlanParams> {
  final BudgetRepository _repository;

  GenerateBudgetPlan(this._repository);

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
      return Left(Failure(e.toString()));
    }
  }
}

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
