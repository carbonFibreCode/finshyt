
part of 'insights_cubit.dart';

abstract class InsightsState extends Equatable {
  const InsightsState();

  @override
  List<Object> get props => [];
}

/// Initial state before any data is fetched.
class InsightsInitial extends InsightsState {}

/// State when data is being fetched.
class InsightsLoading extends InsightsState {}

/// State when data is successfully loaded.
class InsightsLoaded extends InsightsState {
  final Insights insights;

  const InsightsLoaded(this.insights);

  @override
  List<Object> get props => [insights];
}

/// State when an error occurs during fetching.
class InsightsFailure extends InsightsState {
  final String message;

  const InsightsFailure(this.message);

  @override
  List<Object> get props => [message];
}
