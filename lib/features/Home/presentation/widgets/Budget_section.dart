import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_traveler/features/budget/presentation/cubit/expense_cubit.dart';
import 'package:smart_traveler/features/budget/presentation/cubit/expense_state.dart';
import 'package:smart_traveler/features/budget/presentation/views/expense_tracker_screen.dart';

class BudgetSection extends StatelessWidget {
  const BudgetSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseCubit, ExpenseState>(
      builder: (context, state) {
        final totalBudget = state.totalBudget > 0 ? state.totalBudget : 3550.0; // Fallback for UI if not set
        final totalSpent = state.totalSpent;
        final left = totalBudget - totalSpent;
        final double progress = totalBudget > 0 ? (totalSpent / totalBudget).clamp(0.0, 1.0) : 0.0;
        final percent = (progress * 100).toInt();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Budget Tracker",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ExpenseTrackerScreen()),
                    );
                  },
                  child: const Text(
                    "View Details",
                    style: TextStyle(color: Colors.blue, fontSize: 13),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Card
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ExpenseTrackerScreen()),
                );
              },
              child: Container(
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
                            children: [
                              const Text(
                                "Trip Budget",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "\$${left.toStringAsFixed(0)} left",
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          // Progress bar
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 8,
                              backgroundColor: const Color(0xffE6EAF0),
                              color: progress > 0.9 ? Colors.red : Colors.blue,
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Bottom text
                          Text(
                            "Spent \$${totalSpent.toStringAsFixed(0)} of \$${totalBudget.toStringAsFixed(0)} total",
                            style: const TextStyle(color: Colors.grey, fontSize: 12),
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
                        children: [
                          const Icon(Icons.pie_chart, color: Colors.blue),
                          const SizedBox(height: 6),
                          Text(
                            "$percent%",
                            style: const TextStyle(
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
            ),
          ],
        );
      },
    );
  }
}
