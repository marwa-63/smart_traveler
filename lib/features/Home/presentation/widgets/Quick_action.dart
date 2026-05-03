import 'package:flutter/material.dart';
import 'package:smart_traveler/core/database/database_helper.dart';
import 'package:smart_traveler/features/Home/domain/entities/trip.dart';
import 'package:smart_traveler/features/budget/presentation/views/expense_tracker_screen.dart';
import 'package:smart_traveler/features/Home/presentation/screens/ai_planner_screen.dart';
import 'package:smart_traveler/features/Home/presentation/screens/saved_trips_screen.dart';

class QuickActions extends StatefulWidget {
  const QuickActions({super.key});

  @override
  State<QuickActions> createState() => _QuickActionsState();
}

class _QuickActionsState extends State<QuickActions> {
  int selectedIndex = -1;

  final List<Map<String, dynamic>> actions = [
    {
      "title": "Plan Trip",
      "subtitle": "AI-powered itineraries",
      "icon": Icons.auto_awesome,
      "color": Colors.blue,
    },
    {
      "title": "Budget",
      "subtitle": "Track every penny",
      "icon": Icons.account_balance_wallet_rounded,
      "color": Colors.green,
    },
    {
      "title": "Explore Map",
      "subtitle": "Nearby attractions",
      "icon": Icons.map_rounded,
      "color": Colors.orange,
    },
    {
      "title": "Saved Trips",
      "subtitle": "Your past adventures",
      "icon": Icons.history_rounded,
      "color": Colors.purple,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: actions.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 1.2,
      ),
      itemBuilder: (context, index) {
        final item = actions[index];

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedIndex = index;
            });
            if (item["title"] == "Budget") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ExpenseTrackerScreen()),
              );
            } else if (item["title"] == "Plan Trip") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AiPlannerScreen()),
              );
            } else if (item["title"] == "Explore Map") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => _MapPlaceholderScreen()),
              );
            } else if (item["title"] == "Saved Trips") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SavedTripsScreen()),
              );
            }
          },
          child: ActionCard(
            title: item["title"],
            subtitle: item["subtitle"],
            icon: item["icon"],
            color: item["color"],
            isHighlighted: selectedIndex == index,
          ),
        );
      },
    );
  }
}

class _MapPlaceholderScreen extends StatelessWidget {
  const _MapPlaceholderScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Explore Map")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.map, size: 80, color: Colors.blue.shade200),
            const SizedBox(height: 16),
            const Text("Map Integration Coming Soon", style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}

class ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool isHighlighted;

  const ActionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isHighlighted ? color.withOpacity(0.5) : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, size: 24, color: color),
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
