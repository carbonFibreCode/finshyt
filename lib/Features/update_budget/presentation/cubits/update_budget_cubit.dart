import 'package:bloc/bloc.dart';
import 'package:finshyt/Features/update_budget/presentation/cubits/update_budget_state.dart';
import 'package:finshyt/Features/update_budget/presentation/services/location_service.dart';


class UpdateBudgetCubit extends Cubit<UpdateBudgetState> {
  UpdateBudgetCubit() : super(const UpdateBudgetState());

  Future<void> fetchLocation() async {
    emit(state.copyWith(isLoading: true));
    try {
      final location = await LocationService.getCity();
      emit(state.copyWith(
        city: location?.city,
        position: location?.pos,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: 'Failed to get location: $e'));
    }
  }

  void updateBudget(double budget) {
    emit(state.copyWith(budget: budget));
  }

  void updateDescription(String description) {
    emit(state.copyWith(description: description));
  }

  void updateEventDate(DateTime date) {
    emit(state.copyWith(eventDate: date));
  }

  bool validate() {
    return state.budget > 0 && state.eventDate != null && state.city != null;
  }
}
