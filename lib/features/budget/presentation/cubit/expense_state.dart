import 'package:equatable/equatable.dart';
import '../../domain/entities/expense.dart';

class ExpenseState extends Equatable {
  final List<Expense> expenses;
  final double totalBudget;

  const ExpenseState({
    required this.expenses,
    required this.totalBudget,
  });

  factory ExpenseState.initial() {
    return const ExpenseState(
      expenses: [],
      totalBudget: 0.0,
    );
  }

  ExpenseState copyWith({
    List<Expense>? expenses,
    double? totalBudget,
  }) {
    return ExpenseState(
      expenses: expenses ?? this.expenses,
      totalBudget: totalBudget ?? this.totalBudget,
    );
  }

  double get totalSpent => expenses.fold(0.0, (sum, item) => sum + item.amount);

  @override
  List<Object?> get props => [expenses, totalBudget];
}
