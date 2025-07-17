part of 'homepage_cubit.dart';

abstract class HomepageState extends Equatable {
  const HomepageState();

  @override
  List<Object> get props => [];
}

/// The initial state before any data has been loaded.
class HomepageInitial extends HomepageState {}

/// State indicating that the homepage insights are being fetched.
class HomepageLoading extends HomepageState {}

/// State representing the successful fetching of homepage data.
/// It holds the [HomepageInsights] entity containing all necessary data.
class HomepageLoaded extends HomepageState {
  final HomepageInsights insights;

  const HomepageLoaded(this.insights);

  @override
  List<Object> get props => [insights];
}

/// State indicating that an error occurred while fetching the data.
/// It contains a user-friendly error message.
class HomepageFailure extends HomepageState {
  final String message;

  const HomepageFailure(this.message);

  @override
  List<Object> get props => [message];
}
