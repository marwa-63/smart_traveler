import 'package:flutter/material.dart';
import 'package:smart_traveler/features/Home/presentation/widgets/RecommendationCard.dart';

class RecommendationsSection extends StatelessWidget {
  const RecommendationsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              "Smart Recommendations",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text("See all", style: TextStyle(color: Colors.blue, fontSize: 13)),
          ],
        ),

        const SizedBox(height: 12),

        // Horizontal list
        SizedBox(
          height: 230,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: recommendations.length,
            itemBuilder: (context, index) {
              final item = recommendations[index];
              return RecommendationCard(item: item);
            },
          ),
        ),
      ],
    );
  }
}

final List<Map<String, dynamic>> recommendations = [
  {
    "title": "Weekend in Tokyo",
    "image": "https://images.unsplash.com/photo-1549692520-acc6669e2f0c",
    "tag": "Cultural",
    "days": "2 Days",
  },
  {
    "title": "Dubai Luxury",
    "image": "https://images.unsplash.com/photo-1512453979798-5ea266f8880c",
    "tag": "Luxury",
    "days": "5 Days",
  },
  {
    "title": "Sydney Opera",
    "image": "https://images.unsplash.com/photo-1506973035872-a4ec16b8e8d9",
    "tag": "Iconic",
    "days": "4 Days",
  },
];
