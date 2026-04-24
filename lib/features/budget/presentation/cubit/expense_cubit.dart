import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/expense.dart';
import 'expense_state.dart';

class ExpenseCubit extends Cubit<ExpenseState> {
  ExpenseCubit() : super(ExpenseState.initial());

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
    
    emit(state.copyWith(
      expenses: [...state.expenses, newExpense],
    ));
  }

  void updateBudget(double newBudget) {
    emit(state.copyWith(
      totalBudget: newBudget,
    ));
  }
}
