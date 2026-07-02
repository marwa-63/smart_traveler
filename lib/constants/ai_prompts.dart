// lib/core/constants/ai_prompts.dart

class AIPrompts {
  static String buildItineraryPrompt({
    required String destination,
    required int duration,
    required double budget,
    required String lifestyle,
    required List<String>? interests,
  }) {
    return """
    You are an expert, local travel concierge...
    (Insert the full prompt template here)
    - Destination: $destination
    - Duration: $duration days
    - Total Budget: \$$budget as double
    - Travel Lifestyle: $lifestyle
    - Core Interests: $interests

    **STRICT RULES:**
1. GEOGRAPHIC LOGIC: Do not suggest activities on the same day that are hours apart. Group activities by neighborhood.
2. PACING: Respect the 'Lifestyle'. A 'Family' lifestyle needs slower pacing and breaks. A 'Backpacker' lifestyle can be fast-paced.
3. REALISTIC PRICING: Estimate costs accurately for the given destination.
4. FORMATTING: You must respond ONLY with a raw, valid JSON object. Do not include markdown tags like ```json or any conversational text before or after the JSON.

**OUTPUT JSON SCHEMA:**
{
  "tripTitle": "String (A catchy title for the trip)",
  "lifestyleApplied": "String",
  "totalEstimatedCost": Number (Total cost of activities and food in ),
  "itinerary": [
    {
      "day": Number,
      "dailyTheme": "String (e.g., 'Historic Downtown & Local Eats')",
      "activities": [
        {
          "time": "String (e.g., '09:00 AM')",
          "activityName": "String",
          "description": "String (1 short sentence explaining why it fits their interests)",
          "estimatedCost": Number,
          "searchableLocationName": "String (The exact name to pass to Google Places API, e.g., 'Louvre Museum, Paris')"
        }
      ]
    }
  ]
}
    ...
    """;
  }
}
