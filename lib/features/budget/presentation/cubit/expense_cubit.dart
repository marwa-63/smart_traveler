import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/expense.dart';
import 'expense_state.dart';
import '../../../../core/database/database_helper.dart';
import '../../../Home/presentation/cubit/trip_cubit.dart';
import '../../../Home/presentation/cubit/trip_state.dart';
import '../../../Home/domain/entities/trip.dart';

class ExpenseCubit extends Cubit<ExpenseState> {
  final TripCubit tripCubit;
  late StreamSubscription<TripState> _tripSubscription;

  ExpenseCubit(this.tripCubit) : super(ExpenseState.initial()) {
    // React to the initial state
    _handleTripState(tripCubit.state);
    
    // Listen for future trip changes
    _tripSubscription = tripCubit.stream.listen(_handleTripState);
  }

  void _handleTripState(TripState tripState) {
    if (tripState.activeTrip != null) {
      loadTripData(tripState.activeTrip!);
    } else {
      resetData();
    }
  }

  Future<void> loadTripData(Trip trip) async {
    final expenses = await DatabaseHelper.instance.getExpensesForTrip(trip.id);
    
    emit(state.copyWith(
      expenses: expenses,
      totalBudget: trip.totalBudget,
    ));
  }

  Future<void> addExpense({
    required String tripId,
    required String title,
    required double amount,
    required String category,
    required DateTime date,
  }) async {
    final newExpense = Expense(
      id: const Uuid().v4(),
      tripId: tripId,
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

  Future<void> updateBudget(double newBudget) async {
    final activeTrip = tripCubit.state.activeTrip;
    if (activeTrip != null) {
      final updatedTrip = Trip(
        id: activeTrip.id,
        destination: activeTrip.destination,
        city: activeTrip.city,
        totalBudget: newBudget,
        startDate: activeTrip.startDate,
        endDate: activeTrip.endDate,
      );
      
      await DatabaseHelper.instance.updateTrip(updatedTrip);
      
      // We don't necessarily need to tell TripCubit to reload, 
      // but it's good practice so the Home screen UI updates if it shows budget.
      tripCubit.setActiveTrip(updatedTrip);
      
      emit(state.copyWith(
        totalBudget: newBudget,
      ));
    }
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
  
  @override
  Future<void> close() {
    _tripSubscription.cancel();
    return super.close();
  }
}
