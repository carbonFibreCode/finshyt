import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finshyt/Features/homepage/domain/usecases/get_homepage_insights.dart';
import 'package:finshyt/features/homepage/domain/entities/homepage_insights.dart';

part 'homepage_state.dart';

class HomepageCubit extends Cubit<HomepageState> {
  final GetHomepageInsights _getHomepageInsights;

  HomepageCubit({required GetHomepageInsights getHomepageInsights})
    : _getHomepageInsights = getHomepageInsights,
      super(HomepageInitial());

  void emit(HomepageState state) {
    if (!isClosed) {
      super.emit(state);
    }
  }

  Future<void> loadInsights(String userId) async {
    emit(HomepageLoading());
    final params = GetHomepageInsightsParams(userId: userId);
    final result = await _getHomepageInsights(params);
    if (isClosed) return;
    result.fold(
      (failure) => emit(HomepageFailure(failure.message)),
      (insights) => emit(HomepageLoaded(insights)),
    );
  }
}
