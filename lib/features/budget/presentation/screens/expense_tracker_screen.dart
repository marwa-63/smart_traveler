import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/expense_providers.dart';
import '../widgets/budget_summary_card.dart';
import '../widgets/category_section.dart';
import '../widgets/recent_expenses_list.dart';
import 'expense_history_screen.dart';

class ExpenseTrackerScreen extends ConsumerStatefulWidget {
  const ExpenseTrackerScreen({super.key});

  @override
  ConsumerState<ExpenseTrackerScreen> createState() => _ExpenseTrackerScreenState();
}

class _ExpenseTrackerScreenState extends ConsumerState<ExpenseTrackerScreen> {
  Future<void> _showAddExpenseDialog([String? initialCategory]) async {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    String selectedCategory = initialCategory ?? 'Food';
    final categories = ['Food', 'Transport', 'Activities', 'Stay'];

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add Expense'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Expense Name (e.g. Sushi)'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: amountController,
                    decoration: const InputDecoration(labelText: 'Amount (\$)'),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: selectedCategory,
                    decoration: const InputDecoration(labelText: 'Category'),
                    items: categories.map((cat) {
                      return DropdownMenuItem(
                        value: cat,
                        child: Text(cat),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          selectedCategory = val;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final amount = double.tryParse(amountController.text.trim());
                    final title = titleController.text.trim();
                    if (amount != null && title.isNotEmpty) {
                      ref.read(expensesProvider.notifier).addExpense(
                        title: title,
                        amount: amount,
                        category: selectedCategory,
                        date: DateTime.now(),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          }
        );
      },
    );
  }

  Future<void> _showAddBudgetDialog() async {
    final budgetController = TextEditingController();
    final currentBudget = ref.read(totalBudgetProvider);
    if (currentBudget > 0) {
      budgetController.text = currentBudget.toStringAsFixed(2);
    }

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Set Total Budget'),
          content: TextField(
            controller: budgetController,
            decoration: const InputDecoration(labelText: 'Total Budget (\$)'),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final budget = double.tryParse(budgetController.text.trim());
                if (budget != null && budget > 0) {
                  ref.read(totalBudgetProvider.notifier).updateBudget(budget);
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final expenses = ref.watch(expensesProvider);
    final totalBudget = ref.watch(totalBudgetProvider);

    final totalSpent = expenses.fold(0.0, (sum, item) => sum + item.amount);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0066EE), // Solid blue to match original
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/logo.png',
              height: 32,
              errorBuilder: (context, error, stackTrace) {
                // Fallback icon until the user adds the logo.png to assets
                return const Icon(Icons.mode_of_travel, color: Colors.white, size: 28);
              },
            ),
            const SizedBox(width: 12),
            const Text(
              'Budget Tracker', 
              style: TextStyle(
                color: Colors.white, 
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {},
          )
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BudgetSummaryCard(
                  totalBudget: totalBudget,
                  totalSpent: totalSpent,
                  onAddBudget: _showAddBudgetDialog,
                ),
                const SizedBox(height: 32),
                CategorySection(
                  expenses: expenses,
                  onAddExpense: (category) => _showAddExpenseDialog(category),
                ),
                const SizedBox(height: 32),
                RecentExpensesList(
                  expenses: expenses,
                  onViewHistory: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ExpenseHistoryScreen()),
                    );
                  },
                ),
                const SizedBox(height: 80), // Padding for FAB
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddExpenseDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
