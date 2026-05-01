import 'dart:convert';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:smart_traveler/constants/ai_prompts.dart';
import 'package:smart_traveler/features/generate trip/models/trip_model.dart';

class TripServices {
  final model = FirebaseAI.googleAI()
      .generativeModel(model: 'gemini-3-flash-preview');

  Future<TripModel> generateTrip(
    String destination,
    double budget,
    int duration,
    String travelStyle,
    List<String> interests,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final prompt = AIPrompts.buildItineraryPrompt(
      destination: destination,
      duration: duration,
      budget: budget,
      lifestyle: travelStyle,
      interests: interests,
    );

    try {
      final response =
          await model.generateContent([Content.text(prompt)]);

      ///  Extract text safely
      final String? rawText = response.text;

      if (rawText == null || rawText.isEmpty) {
        throw Exception("AI returned empty response");
      }

      /// Clean markdown (NOW it's a string)
      final cleanJson = rawText
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      ///  Decode JSON
      final decoded = jsonDecode(cleanJson);
      print("helllo hi dsk;ls decode $decoded");

      return TripModel.fromJson(
        decoded,
        startDate: startDate,
        endDate: endDate,
      );
    } catch (e) {
      throw Exception("Error generating trip: $e");
    }
  }
}