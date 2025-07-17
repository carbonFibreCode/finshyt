import 'package:finshyt/Features/expense/data/models/expense_models.dart';
import 'package:finshyt/core/entity/expense.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'expense_remote_data_source.dart';


class ExpenseRemoteDataSourceImpl implements ExpenseRemoteDataSource {
  final SupabaseClient _client;

  ExpenseRemoteDataSourceImpl(this._client);

  @override
  Future<void> addExpense(Expense expense) async {
    try {
      final expenseModel = ExpenseModel(
        id: expense.id,
        userId: expense.userId,
        budgetId: expense.budgetId,
        amount: expense.amount,
        description: expense.description,
        expenseDate: expense.expenseDate,
      );
      await _client
          .from('expenses')
          .insert(expenseModel.toJson())
          .select()
          .single();
    } on PostgrestException catch (e) {
      throw Exception('Database error: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }
}
