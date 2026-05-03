import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_traveler/constants/app_theme.dart';
import 'package:smart_traveler/features/Home/presentation/screens/Home%20DashboardScreen.dart';
import 'features/budget/presentation/views/expense_tracker_screen.dart';
import 'features/budget/presentation/cubit/expense_cubit.dart';
import 'features/Home/presentation/cubit/trip_cubit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => TripCubit()),
        BlocProvider(create: (context) => ExpenseCubit(context.read<TripCubit>())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Smart Traveler',
        theme: AppTheme.lightTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
