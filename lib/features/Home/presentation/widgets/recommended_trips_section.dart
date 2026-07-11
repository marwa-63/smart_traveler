import 'package:flutter/material.dart';
import 'package:smart_traveler/features/generate%20trip/services/photo_services.dart';
import '../screens/recommended_trip_detail.dart';

class RecommendedTripsSection extends StatelessWidget {
  const RecommendedTripsSection({super.key});

  // A small curated list of recommended trips with famous places
  List<Map<String, dynamic>> get _recommended => [
        {
          'city': 'Paris',
          'country': 'France',
          'tagline': 'City of Light',
          'bestTime': 'Apr - Jun, Sep - Oct',
          'places': [
            {'name': 'Eiffel Tower', 'info': 'Iconic wrought-iron tower with city views.', 'bestTime': 'Apr - Jun'},
            {'name': 'Louvre Museum', 'info': 'World-famous art museum, home of the Mona Lisa.', 'bestTime': 'Sep - Nov'},
            {'name': 'Notre-Dame', 'info': 'Gothic cathedral with rich history.', 'bestTime': 'Apr - Jun'},
          ],
        },
        {
          'city': 'Tokyo',
          'country': 'Japan',
          'tagline': 'Tradition & Futurism',
          'bestTime': 'Mar - May, Sep - Nov',
          'places': [
            {'name': 'Senso-ji', 'info': 'Ancient Buddhist temple in Asakusa.', 'bestTime': 'Mar - May'},
            {'name': 'Shibuya Crossing', 'info': 'Famous bustling intersection and shopping.', 'bestTime': 'Sep - Nov'},
            {'name': 'Meiji Shrine', 'info': 'Shinto shrine surrounded by forest.', 'bestTime': 'Mar - May'},
          ],
        },
        {
          'city': 'New York',
          'country': 'USA',
          'tagline': 'The Big Apple',
          'bestTime': 'Apr - Jun, Sep - Nov',
          'places': [
            {'name': 'Statue of Liberty', 'info': 'Symbol of freedom with harbor views.', 'bestTime': 'Apr - Jun'},
            {'name': 'Central Park', 'info': 'Urban park with lakes and paths.', 'bestTime': 'Sep - Nov'},
            {'name': 'Times Square', 'info': 'Bright lights, theaters and energy.', 'bestTime': 'Apr - Jun'},
          ],
        },
        {
          'city': 'Cairo',
          'country': 'Egypt',
          'tagline': 'Ancient Wonders',
          'bestTime': 'Oct - Apr',
          'places': [
            {'name': 'Giza Pyramids', 'info': 'Ancient pyramids and the Sphinx.', 'bestTime': 'Oct - Apr'},
            {'name': 'Egyptian Museum', 'info': 'Extensive collection of ancient artifacts.', 'bestTime': 'Oct - Apr'},
            {'name': 'Khan el-Khalili', 'info': 'Historic bazaar and market.', 'bestTime': 'Oct - Apr'},
          ],
        },
      ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Recommended Trips', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextButton(onPressed: () {}, child: const Text('See all')),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _recommended.length,
            separatorBuilder: (c, i) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = _recommended[index];
              final city = item['city'] as String;
              final country = item['country'] as String;
              final tagline = item['tagline'] as String;

              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => RecommendedTripDetail(data: item)),
                ),
                child: Container(
                  width: 320,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 6))],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: FutureBuilder<String>(
                            future: PhotoServices().getPhoto(placeName: city),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Container(color: Colors.grey.shade200);
                              }
                              final url = snapshot.data;
                              if (url == null) return Container(color: Colors.grey.shade200);
                              return Image.network(url, width: double.infinity, fit: BoxFit.cover);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('$city, $country', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(tagline, style: TextStyle(color: Colors.grey.shade600)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
