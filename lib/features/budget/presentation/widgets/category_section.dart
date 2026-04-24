import 'package:flutter/material.dart';
import '../../domain/entities/expense.dart';

class CategorySection extends StatelessWidget {
  final List<Expense> expenses;
  final Function(String category) onAddExpense;

  const CategorySection({
    super.key,
    required this.expenses,
    required this.onAddExpense,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Categories',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 220,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.1,
          ),
          children: [
            _buildCategoryCard(
              context: context,
              name: 'Food',
              icon: Icons.fastfood_rounded,
              color: Colors.orange,
            ),
            _buildCategoryCard(
              context: context,
              name: 'Transport',
              icon: Icons.directions_car_rounded,
              color: Colors.blue,
            ),
            _buildCategoryCard(
              context: context,
              name: 'Activities',
              icon: Icons.local_activity_rounded,
              color: Colors.purple,
            ),
            _buildCategoryCard(
              context: context,
              name: 'Stay',
              icon: Icons.hotel_rounded,
              color: Colors.teal,
            ),
            _buildCategoryCard(
              context: context,
              name: 'Others',
              icon: Icons.receipt_rounded,
              color: Colors.blueGrey,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryCard({
    required BuildContext context,
    required String name,
    required IconData icon,
    required Color color,
  }) {
    final spent = expenses
        .where((e) => e.category == name)
        .fold(0.0, (sum, item) => sum + item.amount);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              InkWell(
                onTap: () => onAddExpense(name),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.add, color: Theme.of(context).primaryColor, size: 20),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            name,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '\$${spent.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: spent > 0 ? 1.0 : 0.0,
              minHeight: 4,
              backgroundColor: Colors.grey.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}
