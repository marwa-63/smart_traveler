import 'package:flutter/material.dart';
import 'package:smart_traveler/features/Home/presentation/widgets/Budget_section.dart';
import 'package:smart_traveler/features/Home/presentation/widgets/HeaderSection.dart';
import 'package:smart_traveler/features/Home/presentation/widgets/Quick_action.dart';
import 'package:smart_traveler/features/Home/presentation/widgets/Recommendation_Section.dart';
import 'package:smart_traveler/features/Home/presentation/widgets/recent_activity.dart';
import 'package:smart_traveler/features/Home/presentation/widgets/trip_card.dart';

import 'package:smart_traveler/features/budget/presentation/views/expense_tracker_screen.dart';
import 'package:smart_traveler/features/planner/presentation/views/planner_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const _HomeContent(),
    const PlannerScreen(),
    const Center(child: Text("Map Screen Placeholder", style: TextStyle(fontSize: 20))),
    const ExpenseTrackerScreen(),
    const Center(child: Text("Profile Screen Placeholder", style: TextStyle(fontSize: 20))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F6F8),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: _screens[_currentIndex],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.auto_awesome), label: "Planner"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: "Budget"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
    );
  }
}
