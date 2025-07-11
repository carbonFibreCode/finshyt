import 'package:finshyt/Features/expense/data/models/expense_models.dart';
import 'package:finshyt/core/models/chart_data_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:finshyt/Features/insights/domain/entity/insights_entity.dart';

abstract class InsightsRemoteDataSource {
  Future<(List<ChartData>, List<DailyExpenseGroup>, double, double)> fetchInsights(String userId, {DateTime? startDate});
}

class InsightsRemoteDataSourceImpl implements InsightsRemoteDataSource {
  final SupabaseClient _client;

  InsightsRemoteDataSourceImpl(this._client);

  @override
  Future<(List<ChartData>, List<DailyExpenseGroup>, double, double)> fetchInsights(String userId, {DateTime? startDate}) async {
    List budRows;
    if (startDate != null) {
      budRows = await _client
          .from('daily_budget')
          .select()
          .eq('user_id', userId)
          .gte('date', startDate.toIso8601String().substring(0, 10));
      final endDate = startDate.add(const Duration(days: 29));
      final endDateStr = endDate.toIso8601String().substring(0, 10);
      budRows = budRows.where((r) {
        final dateStr = r['date'] as String;
        return dateStr.compareTo(endDateStr) <= 0;
      }).toList();
    } else {
      budRows = await _client
          .from('daily_budget')
          .select()
          .eq('user_id', userId);
    }

    if (budRows.isEmpty) {
      return (<ChartData>[], <DailyExpenseGroup>[], 0.0, 0.0);
    }

    final budgetByDate = {
      for (final r in budRows) DateTime.parse(r['date'] as String): (r['amount'] as num).toDouble(),
    };
    final totalBudget = budgetByDate.values.fold<double>(0, (s, v) => s + v);

    List expRows;
    if (startDate != null) {
      expRows = await _client
          .from('expenses')
          .select()
          .eq('user_id', userId)
          .gte('ts', startDate.toIso8601String());
      final endDate = startDate.add(const Duration(days: 29));
      final endDateStr = endDate.toIso8601String();
      expRows = expRows.where((r) {
        final tsStr = r['ts'] as String;
        return tsStr.compareTo(endDateStr) <= 0;
      }).toList();
    } else {
      expRows = await _client
          .from('expenses')
          .select()
          .eq('user_id', userId);
    }

    final items = expRows.map((e) => ExpenseItem.fromJson(e as Map<String, dynamic>)).toList();

    final map = <DateTime, List<ExpenseItem>>{};
    for (final e in items) {
      final d = DateTime(e.ts.year, e.ts.month, e.ts.day);
      map.putIfAbsent(d, () => []).add(e);
    }

    final groups = map.entries
        .map((e) => DailyExpenseGroup(date: e.key, total: e.value.fold(0, (s, i) => s + i.amount), items: e.value))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    final totalSpent = groups.fold<double>(0, (s, g) => s + g.total);

    final chart = groups.reversed
        .map((g) => ChartData(label: '${g.date.day}/${g.date.month}', primaryValue: g.total, secondaryValue: budgetByDate[g.date] ?? 0))
        .toList();

    return (chart, groups, totalBudget, totalSpent);
  }
}
// 
