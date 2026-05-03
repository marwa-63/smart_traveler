import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/expense.dart';
import 'expense_state.dart';
import '../../../../core/database/database_helper.dart';

class ExpenseCubit extends Cubit<ExpenseState> {
  ExpenseCubit() : super(ExpenseState.initial()) {
    _loadData();
  }

  Future<void> _loadData() async {
    final expenses = await DatabaseHelper.instance.getAllExpenses();
    emit(state.copyWith(expenses: expenses));
  }

  Future<void> addExpense({
    required String title,
    required double amount,
    required String category,
    required DateTime date,
  }) async {
    final newExpense = Expense(
      id: const Uuid().v4(),
      title: title,
      amount: amount,
      category: category,
      date: date,
    );
    
    await DatabaseHelper.instance.insertExpense(newExpense);
    
    emit(state.copyWith(
      expenses: [...state.expenses, newExpense],
    ));
  }

  void updateBudget(double newBudget) {
    emit(state.copyWith(
      totalBudget: newBudget,
    ));
  }

  Future<void> deleteExpense(String id) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
    emit(state.copyWith(
      expenses: state.expenses.where((e) => e.id != id).toList(),
    ));
  }

  Future<void> editExpense(Expense updatedExpense) async {
    await DatabaseHelper.instance.insertExpense(updatedExpense); // replace conflict algorithm will update
    emit(state.copyWith(
      expenses: state.expenses.map((e) => e.id == updatedExpense.id ? updatedExpense : e).toList(),
    ));
  }

  void resetData() {
    emit(ExpenseState.initial());
  }
}
