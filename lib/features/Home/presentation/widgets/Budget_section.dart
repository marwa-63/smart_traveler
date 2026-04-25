import 'package:flutter/material.dart';

class BudgetSection extends StatelessWidget {
  const BudgetSection({super.key});

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
              "Budget Tracker",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "View Details",
              style: TextStyle(color: Colors.blue, fontSize: 13),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              // LEFT SIDE
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Trip Budget",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "\$1,240 left",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: 0.65,
                        minHeight: 8,
                        backgroundColor: Color(0xffE6EAF0),
                        color: Colors.blue,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Bottom text
                    const Text(
                      "Spent \$2,310 of \$3,550 total",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // RIGHT SIDE (Circle Indicator)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xffF1F6FB),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: const [
                    Icon(Icons.pie_chart, color: Colors.blue),
                    SizedBox(height: 6),
                    Text(
                      "65%",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
