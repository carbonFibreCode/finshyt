import 'package:finshyt/Features/ai_budget_planning/domain/entities/budget.dart';


abstract interface class BudgetRemoteDataSource {

  Future<List<BudgetItem>> generateBudgetPlan({
    required double monthlyBudget,
    required String description,
    DateTime? eventDate,
    String? city,
  });

  Future<void> saveBudgetPlan({
    required String userId,
    required DateTime startDate,
    required List<BudgetItem> items,
  });
}
