import 'package:flutter/material.dart';
import 'package:smart_traveler/features/generate%20trip/services/photo_services.dart';

class RecommendedTripDetail extends StatelessWidget {
  final Map<String, dynamic> data;
  const RecommendedTripDetail({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final city = data['city'] as String;
    final country = data['country'] as String;
    final tagline = data['tagline'] as String;
    final places = List<Map<String, String>>.from(data['places'] as List);

    return Scaffold(
      appBar: AppBar(
        title: Text('$city, $country'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        titleTextStyle: const TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      backgroundColor: const Color(0xffF4F6F8),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tagline, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Famous places to visit in $city', style: TextStyle(color: Colors.grey.shade700)),
                const SizedBox(height: 12),
                ...places.map((p) {
                  final placeName = p['name'] ?? '';
                  final placeInfo = p['info'] ?? '';
                  final best = p['bestTime'] ?? '';

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder<String>(
                          future: PhotoServices().getPhoto(placeName: '$placeName, $city'),
                          builder: (context, snap) {
                            if (snap.connectionState == ConnectionState.waiting) {
                              return Container(width: 96, height: 72, color: Colors.grey.shade200);
                            }
                            final url = snap.data;
                            return Container(
                              width: 96,
                              height: 72,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.grey.shade200),
                              child: url != null ? ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(url, fit: BoxFit.cover)) : null,
                            );
                          },
                        ),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(placeName, style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(placeInfo, style: TextStyle(color: Colors.grey.shade700)),
                              const SizedBox(height: 6),
                              Text('Best time to visit: $best', style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w600, fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                const SizedBox(height: 12),
                Text('Best time to visit $city: ${data['bestTime'] ?? ''}', style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
