

import 'package:finshyt/Features/ai_budget_planning/domain/models/models.dart';

sealed class BudgetPlanState {}
final class BudgetPlanInitial    extends BudgetPlanState {}
final class BudgetPlanLoading    extends BudgetPlanState {}
final class BudgetPlanDraftReady extends BudgetPlanState {
  final BudgetPlan plan;
  BudgetPlanDraftReady(this.plan);
}
final class BudgetPlanSaving     extends BudgetPlanState {}
final class BudgetPlanSaved      extends BudgetPlanState {
  final BudgetPlan plan;
  BudgetPlanSaved(this.plan);
}
final class BudgetPlanFailure    extends BudgetPlanState {
  final String msg;
  BudgetPlanFailure(this.msg);
}
