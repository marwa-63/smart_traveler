class Trip {
  final String id;
  final String destination;
  final double totalBudget;
  final DateTime startDate;
  final DateTime endDate;

  const Trip({
    required this.id,
    required this.destination,
    required this.totalBudget,
    required this.startDate,
    required this.endDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'destination': destination,
      'totalBudget': totalBudget,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }

  factory Trip.fromMap(Map<String, dynamic> map) {
    return Trip(
      id: map['id'],
      destination: map['destination'],
      totalBudget: map['totalBudget'],
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
    );
  }
}
