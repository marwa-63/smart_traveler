
import 'package:smart_traveler/features/generate%20trip/models/day_model.dart';

class TripModel {

  final String city;
  final String tripTitle;
  final String lifestyleApplied;
  final double totalEstimatedCost;
  final List<DayModel> itinerary;
  final DateTime? beginDate;
  final DateTime? endDate;

  
  TripModel({
    required this.tripTitle,
    required this.lifestyleApplied,
    required this.totalEstimatedCost,
    required this.itinerary,
    required this.beginDate,
    required this.endDate, required this.city,
  });

  factory TripModel.fromJson(Map<String, dynamic> json ,{required DateTime startDate , required DateTime endDate}) {
    if (json['itinerary'] == null || (json['itinerary'] as List).isEmpty) {
      throw Exception("Missing itinerary data");
    }
    
    List<DayModel> parsedItinerary = (json['itinerary'] as List).map((e) {
      // Automatically assign the correct date based on the trip's begin date and the day number
      final dayDate = startDate.add(Duration(days: e['day'] - 1));
      var dayModel = DayModel.fromJson(e , dayDate:dayDate);
      
      return dayModel;
    }).toList();

    return TripModel(
      tripTitle: json['tripTitle'] ?? '',
      lifestyleApplied: json['lifestyleApplied'] ?? '',
      totalEstimatedCost: (json['totalEstimatedCost'] ?? 0).toDouble(),
      itinerary: parsedItinerary,
      beginDate: startDate,
      endDate: endDate, 
      city:json['city'],
    );
  }
}
