import 'package:flutter/material.dart';

class RecentActivitySection extends StatelessWidget {
  const RecentActivitySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Recent Activity",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 12),

        // First Card
        const ActivityCard(
          icon: Icons.trending_up,
          iconBg: Color(0xffE6F4EA),
          iconColor: Colors.green,
          title: "Budget updated",
          subtitle: "Dinner in Paris added • 2h ago",
          trailing: "-\$45.00",
        ),

        const SizedBox(height: 10),

        // Second Card
        const ActivityCard(
          icon: Icons.flight_takeoff,
          iconBg: Color(0xffEAF2FF),
          iconColor: Colors.blue,
          title: "Trip seeded",
          subtitle: "Rome exploration plan generated • Yesterday",
          isArrow: true,
        ),
      ],
    );
  }
}

class ActivityCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String? trailing;
  final bool isArrow;

  const ActivityCard({
    super.key,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.isArrow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 20),
          ),

          const SizedBox(width: 12),

          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),

          // Trailing
          if (trailing != null)
            Text(
              trailing!,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),

          if (isArrow)
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        ],
      ),
    );
  }
}
