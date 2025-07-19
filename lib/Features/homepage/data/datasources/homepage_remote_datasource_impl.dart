import 'dart:developer';

import 'package:finshyt/Features/ai_budget_planning/data/models/budget_model.dart';
import 'package:finshyt/Features/expense/data/models/expense_models.dart';
import 'package:finshyt/Features/homepage/data/datasources/homepage_remote_data_sources.dart';
import 'package:finshyt/Features/homepage/data/models/home_insights_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:finshyt/features/homepage/domain/entities/homepage_insights.dart';

class HomepageRemoteDataSourceImpl implements HomepageRemoteDataSource {
  final SupabaseClient _client;

  HomepageRemoteDataSourceImpl(this._client);

  @override
  Future<HomepageInsights> getHomepageInsights(String userId) async {
    try {
      final latestBudgetResponse = await _client
          .from('budgets')
          .select('id')
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (latestBudgetResponse == null) {
        return HomepageInsightsModel.fromRawData(budgetItems: [], expenses: []);
      }

      final String latestBudgetId = latestBudgetResponse['id'];

      final [budgetItemsResponse, expensesResponse] = await Future.wait([
        _client.from('budget_items').select().eq('budget_id', latestBudgetId),
        _client.from('expenses').select().eq('budget_id', latestBudgetId),
      ]);

      final budgetItems = (budgetItemsResponse as List)
          .map((item) => BudgetItemModel.fromJson(item as Map<String, dynamic>))
          .toList();

      final expenses = (expensesResponse as List)
          .map((item) => ExpenseModel.fromJson(item as Map<String, dynamic>))
          .toList();

      return HomepageInsightsModel.fromRawData(
        budgetItems: budgetItems,
        expenses: expenses,
      );
    } on PostgrestException catch (e) {
      throw Exception('Database Error: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }
}
