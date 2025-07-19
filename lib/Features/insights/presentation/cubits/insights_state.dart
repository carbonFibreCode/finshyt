
part of 'insights_cubit.dart';

abstract class InsightsState extends Equatable {
  const InsightsState();

  @override
  List<Object> get props => [];
}


class InsightsInitial extends InsightsState {}


class InsightsLoading extends InsightsState {}


class InsightsLoaded extends InsightsState {
  final Insights insights;

  const InsightsLoaded(this.insights);

  @override
  List<Object> get props => [insights];
}


class InsightsFailure extends InsightsState {
  final String message;

  const InsightsFailure(this.message);

  @override
  List<Object> get props => [message];
}
