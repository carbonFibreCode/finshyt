import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finshyt/Features/insights/domain/entity/insights_entity.dart';
import 'package:finshyt/Features/insights/domain/usecases/get_all_insights.dart';
import 'package:finshyt/init_dependencies.dart';

part 'insights_state.dart';

class InsightsCubit extends Cubit<InsightsState> {
  final GetAllInsights _getAllInsights;

  InsightsCubit({required getAllInsights})
      : _getAllInsights = serviceLocator<GetAllInsights>(),
        super(InsightsInitial());

  
  
  
  Future<void> fetchInsights(String userId) async {
    emit(InsightsLoading());
    final params = GetAllInsightsParams(userId: userId);
    final result = await _getAllInsights(params);

    result.fold(
      (failure) => emit(InsightsFailure(failure.message)),
      (insights) => emit(InsightsLoaded(insights)),
    );
  }
}
