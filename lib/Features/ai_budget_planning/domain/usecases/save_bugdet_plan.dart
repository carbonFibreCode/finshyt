import 'package:finshyt/Features/ai_budget_planning/domain/models/models.dart';
import 'package:finshyt/Features/ai_budget_planning/domain/repository/repository.dart';


class SaveBudgetPlan {
  SaveBudgetPlan(this.repo);
  final BudgetRepository repo;

  Future<void> call({
    required String userId,
    required double dailyBudget,
    required BudgetPlan plan,
  }) =>
      repo.savePlan(
        userId: userId,
        dailyBudget: dailyBudget,
        plan: plan,
      );
}