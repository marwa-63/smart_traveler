import 'package:flutter/material.dart';
import '../../../budget/presentation/views/expense_tracker_screen.dart';

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
    },
    {
      "title": "Budget",
      "subtitle": "Track every penny",
      "icon": Icons.access_time,
    },
    {
      "title": "Explore Map",
      "subtitle": "Nearby attractions",
      "icon": Icons.location_on,
    },
    {
      "title": "Saved Trips",
      "subtitle": "Your past adventures",
      "icon": Icons.bookmark_border,
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
                MaterialPageRoute(builder: (_) => const ExpenseTrackerScreen()),
              );
            }
          },
          child: ActionCard(
            title: item["title"],
            subtitle: item["subtitle"],
            icon: item["icon"],
            isHighlighted: selectedIndex == index,
          ),
        );
      },
    );
  }
}

class ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isHighlighted;

  const ActionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isHighlighted ? const Color(0xffCFE8D5) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20),
          ),
          const Spacer(),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
