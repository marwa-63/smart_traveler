class ItineraryItem {
  final String id;
  final String tripId;
  final int dayNumber;
  final String location;
  final String time;
  final double estimatedCharge;
  final String description;

  const ItineraryItem({
    required this.id,
    required this.tripId,
    required this.dayNumber,
    required this.location,
    required this.time,
    required this.estimatedCharge,
    this.description = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tripId': tripId,
      'dayNumber': dayNumber,
      'location': location,
      'time': time,
      'estimatedCharge': estimatedCharge,
      'description': description,
    };
  }

  factory ItineraryItem.fromMap(Map<String, dynamic> map) {
    return ItineraryItem(
      id: map['id'],
      tripId: map['tripId'],
      dayNumber: map['dayNumber'],
      location: map['location'],
      time: map['time'],
      estimatedCharge: map['estimatedCharge'],
      description: map['description'] ?? '',
    );
  }
}
