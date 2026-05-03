import '../../domain/entities/trip.dart';
import '../../domain/entities/itinerary_item.dart';

class TripState {
  final Trip? activeTrip;
  final List<ItineraryItem> itinerary;

  TripState({
    this.activeTrip,
    this.itinerary = const [],
  });

  TripState copyWith({
    Trip? activeTrip,
    List<ItineraryItem>? itinerary,
    bool clearActiveTrip = false,
  }) {
    return TripState(
      activeTrip: clearActiveTrip ? null : (activeTrip ?? this.activeTrip),
      itinerary: itinerary ?? this.itinerary,
    );
  }
}
