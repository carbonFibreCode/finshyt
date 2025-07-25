import 'package:finshyt/Features/ai_budget_planning/data/models/budget_model.dart';
import 'package:finshyt/Features/insights/data/remote_data_source/remote_data_source.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:finshyt/Features/insights/data/models/insights_models.dart';
import 'package:finshyt/Features/expense/data/models/expense_models.dart';
import 'package:finshyt/Features/insights/domain/entity/insights_entity.dart';

class InsightsRemoteDataSourceImpl implements InsightsRemoteDataSource {
  final SupabaseClient _client;

  InsightsRemoteDataSourceImpl(this._client);

  @override
  Future<Insights> getAllInsights(String userId) async {
    try {
      
      final latestBudgetResponse = await _client
          .from('budgets')
          .select('id')
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (latestBudgetResponse == null) {
        
        return InsightsModel.fromRawData(budgetItems: [], expenses: []);
      }

      final String latestBudgetId = latestBudgetResponse['id'] as String;

      
      final responses = await Future.wait([
        _client.from('budget_items').select().eq('budget_id', latestBudgetId),
        _client.from('expenses').select().eq('budget_id', latestBudgetId),
      ]);

      final budgetItemsRaw = responses[0] as List<dynamic>;
      final expensesRaw = responses[1] as List<dynamic>;

      
      final List<BudgetItemModel> budgetItems = budgetItemsRaw
          .map((item) => BudgetItemModel.fromJson(item as Map<String, dynamic>))
          .toList();

      final List<ExpenseModel> expenses = expensesRaw
          .map((item) => ExpenseModel.fromJson(item as Map<String, dynamic>))
          .toList();

      
      return InsightsModel.fromRawData(
        budgetItems: budgetItems,
        expenses: expenses,
      );
    } on PostgrestException catch (e) {
      throw Exception('Database error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: ${e.toString()}');
    }
  }
}
