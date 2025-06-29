
import 'package:finshyt/Features/ai_budget_planning/data/remote_data_source.dart';
import 'package:finshyt/Features/ai_budget_planning/domain/models/models.dart';
import 'package:finshyt/Features/ai_budget_planning/domain/repository/repository.dart';

final class BudgetRepositoryImpl implements BudgetRepository {
  BudgetRepositoryImpl(this._remote);
  final BudgetRemoteDataSource _remote;

  @override
  Future<BudgetPlan> makeDraft({
    required String userId,
    required double dailyBudget,
    required String description,
    required String city,
    required DateTime eventDate
  }) =>
      _remote.makeDraft(
        userId: userId,
        monthlyBudget: dailyBudget,
        description: description,
        city: city,
        eventDate: eventDate
      );

  @override
  Future<void> savePlan({
    required String userId,
    required double dailyBudget,
    required BudgetPlan plan,
  }) =>
      _remote.savePlan(
        userId: userId,
        dailyBudget: dailyBudget,
        plan: plan,
      );
}
