import 'package:finshyt/Features/ai_budget_planning/domain/models/models.dart';
import 'package:finshyt/Features/ai_budget_planning/domain/repository/repository.dart';


class MakeBudgetDraft {
  MakeBudgetDraft(this.repo);
  final BudgetRepository repo;

  Future<BudgetPlan> call({
    required String userId,
    required double dailyBudget,
    required String description,
    required String city,
    required DateTime eventDate
  }) =>
      repo.makeDraft(
        userId: userId,
        dailyBudget: dailyBudget,
        description: description,
        city: city,
        eventDate: eventDate,
      );
}