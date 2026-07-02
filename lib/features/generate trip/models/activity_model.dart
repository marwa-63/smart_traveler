class ActivityModel {
  final String time;
  final String activityName;
  final String description;
  final double estimatedCost;
  final String searchableLocationName;
  
  ActivityModel({
    required this.time,
    required this.activityName,
    required this.description,
    required this.estimatedCost,
    required this.searchableLocationName,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      time: json['time'],
      activityName: json['activityName'],
      description: json['description'],
      estimatedCost: (json['estimatedCost'] as num?)?.toDouble() ?? 0.0,
      searchableLocationName: json['searchableLocationName'],
    );
  }
}