import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:finshyt/Features/expense/domain/models/expense_models.dart';
import 'package:finshyt/Features/expense/domain/usecases/get_insights.dart';
import 'package:finshyt/models/chart_data_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
part 'insight_state.dart';

class InsightsCubit extends Cubit<InsightsState> {
  InsightsCubit(this._getInsights) : super(InsightsLoading());
  final GetInsights _getInsights;

  StreamSubscription? _expSub;
  StreamSubscription? _budSub;

  Future<void> load(String userId, {DateTime? startDate}) async {
    if (isClosed) return;
    emit(InsightsLoading());
    await _refresh(userId, startDate);
    //subscription realtime sync

    final sb = Supabase.instance.client;

    _expSub?.cancel();
    _budSub?.cancel();

    _expSub = sb
        .from('expenses')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .listen((_) => _refresh(userId, startDate));

    _budSub = sb
        .from('daily_budget')
        .stream(primaryKey: ['user_id', 'date'])
        .eq('user_id', userId)
        .listen((_) => _refresh(userId, startDate));
  }

  Future<void> _refresh(String userId, DateTime? start) async {
    if (isClosed) return;
    try {
      final (chart, groups, totBudget, totSpent) = await _getInsights(
        userId,
        startDate: start,
      );
      if (!isClosed) {

        emit(
          InsightsLoaded(
            chart: chart,
            days: groups,
            totalBudget: totBudget,
            totalSpent: totSpent,
          ),
        );
      }
    } catch (e) {
      if (!isClosed) {
        emit(InsightsFailure(e.toString()));
      }
      
    }
  }

  @override
  Future<void> close() {
    _expSub?.cancel();
    _budSub?.cancel();
    return super.close();
  }
}
