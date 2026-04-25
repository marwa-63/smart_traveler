import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_traveler/constants/app_theme.dart';
import 'package:smart_traveler/features/Home/presentation/screens/Home%20DashboardScreen.dart';
import 'features/budget/presentation/views/expense_tracker_screen.dart';
import 'features/budget/presentation/cubit/expense_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExpenseCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Smart Traveler',
        theme: AppTheme.lightTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
