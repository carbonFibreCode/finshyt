import 'package:finshyt/Features/ai_budget_planning/data/remote_data_sources/budget_remote_data_source.dart';
import 'package:finshyt/Features/ai_budget_planning/domain/entities/budget.dart';
import 'package:finshyt/Features/ai_budget_planning/domain/repositories/budegt_repository.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  final BudgetRemoteDataSource remoteDataSource;

  BudgetRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<BudgetItem>> generateBudgetPlan({
    required double monthlyBudget,
    required String description,
    DateTime? eventDate,
    String? city,
  }) async {
    try {
      final List<BudgetItem> budgetItems = await remoteDataSource
          .generateBudgetPlan(
            monthlyBudget: monthlyBudget,
            description: description,
            eventDate: eventDate,
            city: city,
          );
      return budgetItems;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> saveBudgetPlan({
    required String userId,
    required DateTime startDate,
    required List<BudgetItem> items,
  }) async {
    try {
      await remoteDataSource.saveBudgetPlan(
        userId: userId,
        startDate: startDate,
        items: items,
      );
    } catch (e) {
      rethrow;
    }
  }
}
