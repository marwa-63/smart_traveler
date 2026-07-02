import 'activity_model.dart';

class DayModel {
  final int day;
  final String dailyTheme;
  final List<ActivityModel> activities;
  final DateTime? date;
  
  DayModel({
    required this.day,
    required this.dailyTheme,
    required this.activities,
    this.date,
  });

  factory DayModel.fromJson(Map<String, dynamic> json, {required dayDate}) {
    return DayModel(
      day: json['day'] ?? 1,
      dailyTheme: json['dailyTheme'],
      activities: (json['activities'] as List).map((e) => ActivityModel.fromJson(e)).toList(),
      date: dayDate
    );
  }

  DayModel copyWith({
    int? day,
    String? dailyTheme,
    List<ActivityModel>? activities,
    DateTime? date,
  }) {
    return DayModel(
      day: day ?? this.day,
      dailyTheme: dailyTheme ?? this.dailyTheme,
      activities: activities ?? this.activities,
      date: date ?? this.date,
    );
  }
}
