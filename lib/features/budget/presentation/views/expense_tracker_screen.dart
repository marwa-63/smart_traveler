import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/expense_cubit.dart';
import '../cubit/expense_state.dart';
import '../widgets/budget_summary_card.dart';
import '../widgets/category_section.dart';
import '../widgets/recent_expenses_list.dart';
import 'expense_history_screen.dart';

class ExpenseTrackerScreen extends StatefulWidget {
  const ExpenseTrackerScreen({super.key});

  @override
  State<ExpenseTrackerScreen> createState() => _ExpenseTrackerScreenState();
}

class _ExpenseTrackerScreenState extends State<ExpenseTrackerScreen> {
  Future<void> _showAddExpenseDialog([String? initialCategory]) async {
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    
    // If initialCategory is passed (clicked from card), we lock it.
    // Otherwise (clicked from FAB), we show the dropdown and default to 'Others'.
    final isCategoryLocked = initialCategory != null;
    String selectedCategory = initialCategory ?? 'Others';
    final categories = ['Food', 'Transport', 'Activities', 'Stay', 'Others'];

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(isCategoryLocked ? 'Add $initialCategory Expense' : 'Add Expense'),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Expense Name (e.g. Sushi)'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'You have to add a name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: amountController,
                      decoration: const InputDecoration(labelText: 'Amount (\$)'),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'It needs to be numbers';
                        }
                        if (double.tryParse(value.trim()) == null) {
                          return 'It needs to be numbers';
                        }
                        return null;
                      },
                    ),
                    if (!isCategoryLocked) ...[
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: selectedCategory,
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
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      final amount = double.parse(amountController.text.trim());
                      final title = titleController.text.trim();
                      
                      // Note: Use context from the main screen for Cubit
                      context.read<ExpenseCubit>().addExpense(
                        title: title,
                        amount: amount,
                        category: selectedCategory,
                        date: DateTime.now(),
                      );
                      Navigator.pop(dialogContext);
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
    final currentBudget = context.read<ExpenseCubit>().state.totalBudget;
    if (currentBudget > 0) {
      budgetController.text = currentBudget.toStringAsFixed(2);
    }

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Set Total Budget'),
          content: TextField(
            controller: budgetController,
            decoration: const InputDecoration(labelText: 'Total Budget (\$)'),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final budget = double.tryParse(budgetController.text.trim());
                if (budget != null && budget > 0) {
                  context.read<ExpenseCubit>().updateBudget(budget);
                  Navigator.pop(dialogContext);
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.restart_alt, size: 18),
              label: const Text('Reset'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Reset Data'),
                    content: const Text('Are you sure you want to reset all your budget data and expenses? This cannot be undone.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<ExpenseCubit>().resetData();
                          Navigator.pop(ctx);
                        },
                        style: TextButton.styleFrom(foregroundColor: Colors.red),
                        child: const Text('Reset'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {},
          )
        ],
      ),
      body: BlocBuilder<ExpenseCubit, ExpenseState>(
        builder: (context, state) {
          final expenses = state.expenses;
          final totalBudget = state.totalBudget;
          final totalSpent = state.totalSpent;

          return Center(
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
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddExpenseDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
