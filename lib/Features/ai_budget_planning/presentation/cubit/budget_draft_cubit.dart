import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finshyt/Features/ai_budget_planning/domain/models/models.dart';
import 'package:finshyt/Features/ai_budget_planning/domain/repository/repository.dart';

part 'budget_draft_state.dart';

class BudgetDraftCubit extends Cubit<BudgetDraftState> {
  BudgetDraftCubit(this._repo) : super(BudgetDraftInitial());

  final BudgetRepository _repo;               // uses repo.makeDraft[7]

  Future<void> makeDraft({
    required String userId,
    required double dailyBudget,
    required String description,
    required String city,
    required DateTime eventDate
  }) async {
    emit(BudgetDraftLoading());
    try {
      final plan = await _repo.makeDraft(      // remote call wired in repo[6]
        userId: userId,
        dailyBudget: dailyBudget,
        description: description,
        city: city,
        eventDate: eventDate

      );
      emit(BudgetDraftLoaded(plan));
    } catch (e) {
      emit(BudgetDraftError(e.toString()));
    }
  }
}
