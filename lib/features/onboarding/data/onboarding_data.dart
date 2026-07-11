import 'package:flutter/material.dart';
import '../domain/entities/onboarding_item.dart';

class OnboardingData {
  static const items = <OnboardingItem>[
    OnboardingItem(
      title: 'Discover Destinations',
      description: 'Explore the world with AI-powered trip ideas and beautiful city cards.',
      icon: Icons.travel_explore,
      backgroundColors: [Color(0xFF7F7FD5), Color(0xFF86A8E7)],
    ),
    OnboardingItem(
      title: 'Save & Revisit',
      description: 'Save your favorite itineraries and pick them up anytime from your profile.',
      icon: Icons.bookmark_border,
      backgroundColors: [Color(0xFF11998E), Color(0xFF38EF7D)],
    ),
    OnboardingItem(
      title: 'Smart Travel Planning',
      description: 'Create beautiful trips, see top sights, and manage your budget in one place.',
      icon: Icons.timeline,
      backgroundColors: [Color(0xFFFF512F), Color(0xFFDD2476)],
    ),
  ];
}
