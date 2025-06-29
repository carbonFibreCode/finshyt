
import 'package:finshyt/Features/ai_budget_planning/domain/models/models.dart';

abstract interface class BudgetRemoteDataSource {
  Future<BudgetPlan> makeDraft({
    required String userId,
    required double monthlyBudget,
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
