import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/expense.dart';

class ExpenseNotifier extends Notifier<List<Expense>> {
  @override
  List<Expense> build() {
    // Initial empty state
    return [];
  }

  void addExpense({
    required String title,
    required double amount,
    required String category,
    required DateTime date,
  }) {
    final newExpense = Expense(
      id: const Uuid().v4(),
      title: title,
      amount: amount,
      category: category,
      date: date,
    );
    
    state = [...state, newExpense];
  }
}

final expensesProvider = NotifierProvider<ExpenseNotifier, List<Expense>>(() {
  return ExpenseNotifier();
});

class TotalBudgetNotifier extends Notifier<double> {
  @override
  double build() => 0.0;

  void updateBudget(double newBudget) {
    state = newBudget;
  }
}

final totalBudgetProvider = NotifierProvider<TotalBudgetNotifier, double>(() {
  return TotalBudgetNotifier();
});
