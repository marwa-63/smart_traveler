import 'package:flutter/material.dart';
import '../../domain/entities/expense.dart';
import 'expense_list_item.dart';

class RecentExpensesList extends StatelessWidget {
  final List<Expense> expenses;
  final VoidCallback onViewHistory;

  const RecentExpensesList({
    super.key,
    required this.expenses,
    required this.onViewHistory,
  });

  @override
  Widget build(BuildContext context) {
    final sortedExpenses = List<Expense>.from(expenses)
      ..sort((a, b) => b.date.compareTo(a.date));

    final recentExpenses = sortedExpenses.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Expenses',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (expenses.isNotEmpty)
              Text(
                '${expenses.length} Total',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.5),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (recentExpenses.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Column(
                children: [
                  Icon(Icons.receipt_long, size: 48, color: Colors.grey.withValues(alpha: 0.5)),
                  const SizedBox(height: 16),
                  Text(
                    'No expenses yet',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          )
        else ...[
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recentExpenses.length,
            itemBuilder: (context, index) {
              return ExpenseListItem(expense: recentExpenses[index]);
            },
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onViewHistory,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'View All History',
                style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
