import 'package:flutter/material.dart';
import '../../../../core/database/database_helper.dart';
import '../../domain/entities/trip.dart';
import '../../domain/entities/itinerary_item.dart';

class TripDetailScreen extends StatefulWidget {
  final Trip trip;
  const TripDetailScreen({super.key, required this.trip});

  @override
  State<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  List<ItineraryItem> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadItinerary();
  }

  Future<void> _loadItinerary() async {
    final items = await DatabaseHelper.instance.getItineraryForTrip(widget.trip.id);
    if (mounted) setState(() { _items = items; _isLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    final trip = widget.trip;
    final totalDays = trip.endDate.difference(trip.startDate).inDays > 0 ? trip.endDate.difference(trip.startDate).inDays : 1;

    // group items by day
    final Map<int, List<ItineraryItem>> byDay = {};
    for (var it in _items) {
      byDay.putIfAbsent(it.dayNumber, () => []).add(it);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(trip.destination),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(trip.destination, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text('From: ${_formatDateShort(trip.startDate)}', style: const TextStyle(color: Colors.grey)),
                          const SizedBox(width: 12),
                          Text('To: ${_formatDateShort(trip.endDate)}', style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('Budget: \$${trip.totalBudget.toStringAsFixed(0)}', style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Make active and go back
                          // Trip activation handled by caller if needed; here we just pop with result
                          Navigator.pop(context, {'activate': true, 'trip': trip});
                        },
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text('Activate Trip'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade50, foregroundColor: Colors.blue),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text('Itinerary', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                if (byDay.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                    child: const Text('No itinerary items for this trip.'),
                  )
                else
                  ...List.generate(totalDays, (i) {
                    final day = i + 1;
                    final items = byDay[day] ?? [];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(8)),
                              child: Text('Day $day', style: const TextStyle(color: Colors.white)),
                            ),
                            const SizedBox(width: 12),
                            Text(items.isNotEmpty ? '${items.length} item(s)' : 'Rest / Free day', style: const TextStyle(color: Colors.grey)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ...items.map((it) => _buildItineraryItem(it)).toList(),
                      ],
                    );
                  }),
              ],
            ),
    );
  }

  Widget _buildItineraryItem(ItineraryItem item) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Column(
            children: [
              Text(item.time, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Container(width: 2, height: 40, color: Colors.grey.shade300),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.description.isNotEmpty ? item.description : item.location, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(item.location, style: TextStyle(color: Colors.grey.shade700)),
                const SizedBox(height: 6),
                Text('Est: \$${item.estimatedCharge.toStringAsFixed(0)}', style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateShort(DateTime date) {
    const months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
    return "${months[date.month - 1]} ${date.day}";
  }
}
