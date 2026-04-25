import 'package:flutter/material.dart';
import 'package:smart_traveler/features/Home/presentation/widgets/Budget_section.dart';
import 'package:smart_traveler/features/Home/presentation/widgets/HeaderSection.dart';
import 'package:smart_traveler/features/Home/presentation/widgets/Quick_action.dart';
import 'package:smart_traveler/features/Home/presentation/widgets/Recommendation_Section.dart';
import 'package:smart_traveler/features/Home/presentation/widgets/recent_activity.dart';
import 'package:smart_traveler/features/Home/presentation/widgets/trip_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F6F8),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            HomeTopSection(),
            SizedBox(height: 16),
            TripCard(),
            SizedBox(height: 20),
            BudgetSection(),
            SizedBox(height: 20),
            QuickActions(),
            SizedBox(height: 20),
            RecommendationsSection(),
            SizedBox(height: 20),
            RecentActivitySection(),
          ],
        ),
      ),
    );
  }
}
