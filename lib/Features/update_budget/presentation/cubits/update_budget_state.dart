import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

class UpdateBudgetState extends Equatable {
  final double budget;
  final String description;
  final DateTime? eventDate;
  final String? city;
  final Position? position;
  final bool isLoading;
  final String? errorMessage;

  const UpdateBudgetState({
    this.budget = 0.0,
    this.description = '',
    this.eventDate,
    this.city,
    this.position,
    this.isLoading = false,
    this.errorMessage,
  });

  UpdateBudgetState copyWith({
    double? budget,
    String? description,
    DateTime? eventDate,
    String? city,
    Position? position,
    bool? isLoading,
    String? errorMessage,
  }) {
    return UpdateBudgetState(
      budget: budget ?? this.budget,
      description: description ?? this.description,
      eventDate: eventDate ?? this.eventDate,
      city: city ?? this.city,
      position: position ?? this.position,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    budget,
    description,
    eventDate,
    city,
    position,
    isLoading,
    errorMessage,
  ];
}
