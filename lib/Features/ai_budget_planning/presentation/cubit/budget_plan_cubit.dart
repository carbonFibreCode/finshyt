import 'package:bloc/bloc.dart';
import 'package:finshyt/Features/ai_budget_planning/domain/models/models.dart';
import 'package:finshyt/Features/ai_budget_planning/domain/usecases/make_budget_draft.dart';
import 'package:finshyt/Features/ai_budget_planning/domain/usecases/save_bugdet_plan.dart';
import 'package:finshyt/Features/ai_budget_planning/presentation/cubit/budget_plan_state.dart';

class BudgetPlanCubit extends Cubit<BudgetPlanState> {
  BudgetPlanCubit(this._makeDraft, this._savePlan)
      : super(BudgetPlanInitial());
  final MakeBudgetDraft _makeDraft;
  final SaveBudgetPlan  _savePlan;

  BudgetPlan? _draft;
  double?     _draftBudget;

  Future<void> generate({
    required String userId,
    required double dailyBudget,
    required String description,
    required String city,
    required DateTime eventDate
  }) async {
    emit(BudgetPlanLoading());
    try {
      _draft = await _makeDraft(
        userId: userId,
        dailyBudget: dailyBudget,
        description: description,
        city: city,
        eventDate: eventDate
      );
      _draftBudget = dailyBudget;
      emit(BudgetPlanDraftReady(_draft!));
    } catch (e) {
      emit(BudgetPlanFailure(e.toString()));
    }
  }

  Future<void> approve(String userId) async {
    if (_draft == null) return;
    emit(BudgetPlanSaving());
    try {
      await _savePlan(
        userId: userId,
        dailyBudget: _draftBudget!,
        plan: _draft!,
      );
      emit(BudgetPlanSaved(_draft!));
    } catch (e) {
      emit(BudgetPlanFailure(e.toString()));
    }
  }
}
