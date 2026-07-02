import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_traveler/constants/app_theme.dart';
import 'package:smart_traveler/features/generate%20trip/presentation/views/trip_screen.dart';
import 'package:smart_traveler/features/planner/presentation/cubit/planner_cubit.dart';
import 'package:smart_traveler/features/planner/presentation/views/planner_screen.dart';
import 'package:smart_traveler/firebase_options.dart';
import 'package:smart_traveler/features/Home/presentation/screens/Home%20DashboardScreen.dart';
import 'features/budget/presentation/views/expense_tracker_screen.dart';
import 'features/budget/presentation/cubit/expense_cubit.dart';
import 'features/Home/presentation/cubit/trip_cubit.dart';

 
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
        BlocProvider<PlannerCubit>(
          create:  (context) => PlannerCubit(),
          ) ,


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
