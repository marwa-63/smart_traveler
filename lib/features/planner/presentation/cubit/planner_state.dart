part of 'planner_cubit.dart';

@immutable
sealed class PlannerState extends Equatable {
  final String destination;
  final double budget;
  final DateTime? startDate;
  final DateTime? endDate;
  final String travelStyle;
  final List<String> interests;
  final List<String> suggestedDestinations;

  const PlannerState({
    this.destination = '',
    this.budget = 1200,
    this.startDate,
    this.endDate,
    this.travelStyle = 'Adventure & Nature',
    this.interests = const [],
    this.suggestedDestinations = const ['Tokyo', 'Paris', 'New York', 'London', 'Dubai', 'Bali'],
  });

  /// Computed from the selected date range (0 if either date is null).
  int get durationDays {
    if (startDate == null || endDate == null) return 0;
    final diff = endDate!.difference(startDate!).inDays;
    return diff > 0 ? diff : 0;
  }

  bool get isValid =>
      destination.isNotEmpty &&
      startDate != null &&
      endDate != null ;

  PlannerInitial copyWith({
    String? destination,
    double? budget,
    DateTime? startDate,
    DateTime? endDate,
    bool clearStartDate = false,
    bool clearEndDate = false,
    String? travelStyle,
    List<String>? interests,
    List<String>? suggestedDestinations,
  }) {
    return PlannerInitial(
      destination: destination ?? this.destination,
      budget: budget ?? this.budget,
      startDate: clearStartDate ? null : startDate ?? this.startDate,
      endDate: clearEndDate ? null : endDate ?? this.endDate,
      travelStyle: travelStyle ?? this.travelStyle,
      interests: interests ?? this.interests,
      suggestedDestinations: suggestedDestinations ?? this.suggestedDestinations,
    );
  }

  PlannerLoading toLoading() {
    return PlannerLoading(
      destination: destination,
      budget: budget,
      startDate: startDate,
      endDate: endDate,
      travelStyle: travelStyle,
      interests: interests,
      suggestedDestinations: suggestedDestinations,
    );
  }

  PlannerSuccess toSuccess(dynamic response) {
    return PlannerSuccess(
      tripResponse: response,
      destination: destination,
      budget: budget,
      startDate: startDate,
      endDate: endDate,
      travelStyle: travelStyle,
      interests: interests,
      suggestedDestinations: suggestedDestinations,
    );
  }

  PlannerFail toFail(String error) {
    return PlannerFail(
      errorMessage: error,
      destination: destination,
      budget: budget,
      startDate: startDate,
      endDate: endDate,
      travelStyle: travelStyle,
      interests: interests,
      suggestedDestinations: suggestedDestinations,
    );
  }

  @override
  List<Object?> get props => [
        destination,
        budget,
        startDate,
        endDate,
        durationDays,
        travelStyle,
        interests,
        suggestedDestinations,
      ];
}

final class PlannerInitial extends PlannerState {
  const PlannerInitial({
    super.destination,
    super.budget,
    super.startDate,
    super.endDate,
    super.travelStyle,
    super.interests,
    super.suggestedDestinations,
  });
}

final class PlannerLoading extends PlannerState {
  const PlannerLoading({
    super.destination,
    super.budget,
    super.startDate,
    super.endDate,
    super.travelStyle,
    super.interests,
    super.suggestedDestinations,
  });
}

final class PlannerSuccess extends PlannerState {
  final dynamic tripResponse;

  const PlannerSuccess({
    required this.tripResponse,
    super.destination,
    super.budget,
    super.startDate,
    super.endDate,
    super.travelStyle,
    super.interests,
    super.suggestedDestinations,
  });

  @override
  List<Object?> get props => [...super.props, tripResponse];
}

final class PlannerFail extends PlannerState {
  final String errorMessage;

  const PlannerFail({
    required this.errorMessage,
    super.destination,
    super.budget,
    super.startDate,
    super.endDate,
    super.travelStyle,
    super.interests,
    super.suggestedDestinations,
  });

  @override
  List<Object?> get props => [...super.props, errorMessage];
}
