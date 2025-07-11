import 'package:finshyt/Features/expense/domain/enitity/expense_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class ExpenseRemoteDataSource {
  Future<ExpenseEntity> addExpense({
    required double amount,
    required String purpose,
  });
}

final class ExpenseRemoteDataSourceImpl implements ExpenseRemoteDataSource {
  ExpenseRemoteDataSourceImpl(this._client);
  final SupabaseClient _client;

  @override
  Future<ExpenseEntity> addExpense({
    required double amount,
    required String purpose,
  }) async {
    final userId = _client.auth.currentUser!.id;

    final row = await _client
        .from('expenses')
        .insert({
          'user_id': userId,
          'amount': amount,
          'purpose': purpose,
        })
        .select()
        .single();

    return ExpenseEntity(
      id:      row['id']     as String,
      amount:  (row['amount'] as num).toDouble(),
      purpose: row['purpose'] as String,
      ts:      DateTime.parse(row['ts'] as String),
    );
  }
}
