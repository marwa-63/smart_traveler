import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/database/database_helper.dart';
import '../../domain/entities/trip.dart';
import '../../domain/entities/itinerary_item.dart';
import 'trip_state.dart';

class TripCubit extends Cubit<TripState> {
  TripCubit() : super(TripState()) {
    loadActiveTrip();
  }

  Future<void> loadActiveTrip() async {
    final trips = await DatabaseHelper.instance.getAllTrips();
    if (trips.isNotEmpty) {
      final trip = trips.first;
      final items = await DatabaseHelper.instance.getItineraryForTrip(trip.id);
      emit(state.copyWith(activeTrip: trip, itinerary: items));
    } else {
      emit(state.copyWith(clearActiveTrip: true, itinerary: []));
    }
  }

  Future<void> setActiveTrip(Trip trip) async {
    final items = await DatabaseHelper.instance.getItineraryForTrip(trip.id);
    emit(state.copyWith(activeTrip: trip, itinerary: items));
  }

  Future<void> generateMockTrip() async {
    final newTrip = Trip(
      id: "mock_trip_123",
      destination: "Paris Getaway",
      totalBudget: 3500.0,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 7)),
    );
    
    await DatabaseHelper.instance.insertTrip(newTrip);

    // Mock itinerary items
    final item1 = ItineraryItem(
      id: "item1",
      tripId: newTrip.id,
      dayNumber: 1,
      description: "Eiffel Tower Visit",
      location: "Champ de Mars",
      time: "10:00 AM",
      estimatedCharge: 30.0,
    );
    final item2 = ItineraryItem(
      id: "item2",
      tripId: newTrip.id,
      dayNumber: 1,
      description: "Dinner at Le Jules Verne",
      location: "Eiffel Tower",
      time: "8:00 PM",
      estimatedCharge: 150.0,
    );

    await DatabaseHelper.instance.insertItineraryItem(item1);
    await DatabaseHelper.instance.insertItineraryItem(item2);

    await loadActiveTrip();
  }
}
