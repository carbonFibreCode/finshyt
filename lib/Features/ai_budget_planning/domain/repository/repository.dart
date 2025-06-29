import 'package:finshyt/Features/ai_budget_planning/domain/models/models.dart';

abstract interface class BudgetRepository {
  Future<BudgetPlan> makeDraft({
    required String userId,
    required double dailyBudget,
    required String description,
    required String city,
    required DateTime eventDate
  });

  Future<void> savePlan({
    required String userId,
    required double dailyBudget,
    required BudgetPlan plan,
  });
}
