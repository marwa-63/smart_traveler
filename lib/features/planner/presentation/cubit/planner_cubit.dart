import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_traveler/features/generate%20trip/services/trip_services.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'planner_state.dart';

class PlannerCubit extends Cubit<PlannerState> {
  PlannerCubit() : super(const PlannerInitial());

  void updateDestination(String destination) {
    emit(state.copyWith(destination: destination));
  }

  void updateBudget(double budget) {
    emit(state.copyWith(budget: budget));
  }

  void updateStartDate(DateTime? date) {
    emit(state.copyWith(
      startDate: date,
      clearStartDate: date == null,
    ));
  }

  void updateEndDate(DateTime? date) {
    emit(state.copyWith(
      endDate: date,
      clearEndDate: date == null,
    ));
  }

  void updateTravelStyle(String style) {
    emit(state.copyWith(travelStyle: style));
  }

  void toggleInterest(String interest) {
    final current = List<String>.from(state.interests);
    if (current.contains(interest)) {
      current.remove(interest);
    } else {
      current.add(interest);
    }
    emit(state.copyWith(interests: current));
  }

  Future<void> generateTrip() async {
    if (!state.isValid) return;

    emit(state.toLoading());

    try {
      final response = await TripServices().generateTrip(
        state.destination,
        state.budget,
        state.durationDays,
        state.travelStyle,
        state.interests,
        state.startDate!,
        state.endDate!,
      );

      emit(state.toSuccess(response));
    } catch (e) {
      emit(state.toFail(e.toString()));
    }
  }
}
