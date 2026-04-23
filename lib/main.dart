import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_traveler/constants/app_theme.dart';
import 'features/budget/presentation/screens/expense_tracker_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Traveler',
      theme: AppTheme.lightTheme,
      home: const ExpenseTrackerScreen(),
    );
  }
}
