import 'package:flutter/material.dart';
import 'package:smart_traveler/features/generate%20trip/models/trip_model.dart';
import 'package:smart_traveler/constants/app_theme.dart';
import 'package:smart_traveler/features/generate%20trip/presentation/widgets/days_list_widget.dart';
import 'package:smart_traveler/features/generate%20trip/presentation/widgets/day_summary_widget.dart';
import 'package:smart_traveler/features/generate%20trip/presentation/widgets/timeline_item_widget.dart';

class TripScreen extends StatefulWidget {
  final dynamic response;
  const TripScreen({super.key, required this.response});

  @override
  State<TripScreen> createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  int selectedDayIndex = 0;
  late TripModel trip;

  @override
  void initState() {
    super.initState();
    trip = widget.response as TripModel;
  }

  @override
  Widget build(BuildContext context) {
    if (trip.itinerary.isEmpty) return const Scaffold(body: Center(child: Text("No data")));
    final currentDay = trip.itinerary[selectedDayIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            const Text(
              'ITINERARY',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            Text(
              trip.tripTitle,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),


      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Plan Details',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '\$${trip.totalEstimatedCost.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),


          SliverToBoxAdapter(
            child: DaysListWidget(
              trip: trip,
              selectedDayIndex: selectedDayIndex,
              onDaySelected: (index) {
                setState(() {
                  selectedDayIndex = index;
                });
              },
            ),
          ),
          
          SliverToBoxAdapter(
            child: DaySummaryWidget(day: currentDay),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return TimelineItemWidget(
                    activity: currentDay.activities[index],
                    isLast: index == currentDay.activities.length - 1,
                  );
                },
                childCount: currentDay.activities.length,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ElevatedButton(
            onPressed: () {
              // TODO: Implement save trip logic
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Save Trip',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}