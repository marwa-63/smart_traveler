import 'package:flutter/material.dart';
import 'package:smart_traveler/features/generate%20trip/models/trip_model.dart';
import 'package:smart_traveler/constants/app_theme.dart';

class DaysListWidget extends StatelessWidget {
  final TripModel trip;
  final int selectedDayIndex;
  final ValueChanged<int> onDaySelected;

  const DaysListWidget({
    super.key,
    required this.trip,
    required this.selectedDayIndex,
    required this.onDaySelected,
  });

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: trip.itinerary.length,
        itemBuilder: (context, index) {
          final isSelected = selectedDayIndex == index;
          final dayModel = trip.itinerary[index];
          // Use the date from the model, fallback to calculated date if null
          final date = dayModel.date ?? DateTime.now().add(Duration(days: index));
          
          return GestureDetector(
            onTap: () => onDaySelected(index),
            child: Container(
              width: 70,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: isSelected ? null : Border.all(color: Colors.grey.shade300),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppTheme.primaryColor.withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ]
                    : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'DAY',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white70 : Colors.grey,
                    ),
                  ),
                  Text(
                    '${dayModel.day}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                  Text(
                    _formatDate(date),
                    style: TextStyle(
                      fontSize: 10,
                      color: isSelected ? Colors.white70 : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
