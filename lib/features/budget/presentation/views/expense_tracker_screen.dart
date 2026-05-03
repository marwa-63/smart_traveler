import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/expense_cubit.dart';
import '../cubit/expense_state.dart';
import '../../../../features/Home/presentation/cubit/trip_cubit.dart';
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
                          return 'Please enter an expense name.';
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
                          return 'Please enter a valid amount.';
                        }
                        if (double.tryParse(value.trim()) == null) {
                          return 'Please enter a valid amount.';
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
                    final activeTrip = context.read<TripCubit>().state.activeTrip;
                    if (activeTrip == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please select an active trip first')),
                      );
                      return;
                    }

                    if (formKey.currentState!.validate()) {
                      final amount = double.parse(amountController.text.trim());
                      final title = titleController.text.trim();
                      
                      context.read<ExpenseCubit>().addExpense(
                        tripId: activeTrip.id,
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
    final formKey = GlobalKey<FormState>();
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
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: budgetController,
              decoration: const InputDecoration(labelText: 'Total Budget (\$)'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a valid amount.';
                }
                if (double.tryParse(value.trim()) == null) {
                  return 'Please enter a valid amount.';
                }
                return null;
              },
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
                  final budget = double.parse(budgetController.text.trim());
                  if (budget > 0) {
                    context.read<ExpenseCubit>().updateBudget(budget);
                    Navigator.pop(dialogContext);
                  }
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
    final canPop = Navigator.canPop(context);
    return Scaffold(
      backgroundColor: const Color(0xffF4F6F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: canPop ? IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ) : null,
        title: const Text("Budget Tracker", style: TextStyle(color: Colors.black87)),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: BlocBuilder<ExpenseCubit, ExpenseState>(
            builder: (context, state) {
              final activeTrip = context.watch<TripCubit>().state.activeTrip;
              
              if (activeTrip == null) {
                return const Center(
                  child: Text("No active trip selected.\nGo to Saved Trips to make one active.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 16)),
                );
              }

              final expenses = state.expenses;
              final totalBudget = state.totalBudget;
              final totalSpent = state.totalSpent;

              return Column(
                children: [
                  AppBar(
                    backgroundColor: const Color(0xFF0066EE),
                    centerTitle: true,
                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/logo.png',
                          height: 32,
                          errorBuilder: (context, error, stackTrace) {
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
                  Expanded(
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
                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
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
