import 'package:flutter/material.dart';
import 'package:smart_traveler/features/generate%20trip/models/activity_model.dart';
import 'package:smart_traveler/constants/app_theme.dart';
import 'package:smart_traveler/features/generate%20trip/services/photo_services.dart';
import 'package:cached_network_image/cached_network_image.dart';

class TimelineItemWidget extends StatelessWidget {
  final ActivityModel activity;
  final bool isLast;

  const TimelineItemWidget({
    super.key,
    required this.activity,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 70,
            child: Column(
              children: [
                Text(
                  activity.time,
                  style: const TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: Colors.grey.withValues(alpha: 0.3),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          child: FutureBuilder<String>(
                            future: PhotoServices().getPhoto(placeName: activity.searchableLocationName),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Container(
                                  height: 150,
                                  color: Colors.grey[200],
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                                return Container(
                                  height: 150,
                                  width: double.infinity,
                                  color: Colors.grey[300],
                                  child:  Center(
                                    child: Icon(Icons.image, size: 50, color: Colors.white)
                                  )
                                );
                              }
                              return CachedNetworkImage(
                                imageUrl: snapshot.data!,
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  height: 150,
                                  color: Colors.grey[200],
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  height: 150,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.broken_image, color: Colors.grey, size: 50),
                                ),
                              );
                            },
                          ),
                        ),
                        Positioned(
                          bottom: 8,
                          left: 8,
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.location_on, color: Colors.white, size: 12),
                                    SizedBox(width: 4),
                                    Text('See location', style: TextStyle(color: Colors.white, fontSize: 10)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Positioned(
                          top: 8,
                          right: 8,
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 16,
                                child: Icon(Icons.swap_horiz, color: Colors.black, size: 18),
                              ),
                              SizedBox(width: 8),
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 16,
                                child: Icon(Icons.edit, color: Colors.black, size: 18),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  activity.activityName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                '\$${activity.estimatedCost.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  activity.searchableLocationName,
                                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            activity.description,
                            style: TextStyle(color: Colors.grey[600], fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
