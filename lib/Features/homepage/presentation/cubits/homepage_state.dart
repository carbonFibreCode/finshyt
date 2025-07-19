part of 'homepage_cubit.dart';

abstract class HomepageState extends Equatable {
  const HomepageState();

  @override
  List<Object> get props => [];
}

class HomepageInitial extends HomepageState {}

class HomepageLoading extends HomepageState {}

class HomepageLoaded extends HomepageState {
  final HomepageInsights insights;

  const HomepageLoaded(this.insights);

  @override
  List<Object> get props => [insights];
}

class HomepageFailure extends HomepageState {
  final String message;

  const HomepageFailure(this.message);

  @override
  List<Object> get props => [message];
}
