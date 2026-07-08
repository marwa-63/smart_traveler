import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/database/database_helper.dart';
import '../../domain/entities/trip.dart';
import '../cubit/trip_cubit.dart';

class SavedTripsScreen extends StatefulWidget {
  const SavedTripsScreen({super.key});

  @override
  State<SavedTripsScreen> createState() => _SavedTripsScreenState();
}

class _SavedTripsScreenState extends State<SavedTripsScreen> {
  List<Trip> _trips = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTrips();
  }

  Future<void> _loadTrips() async {
    final trips = await DatabaseHelper.instance.getAllTrips();
    if (mounted) {
      setState(() {
        _trips = trips;
        _isLoading = false;
      });
    }
  }

  void _deleteTrip(String id) async {
    final cubit = context.read<TripCubit>();
    final isActive = cubit.state.activeTrip?.id == id;

    await DatabaseHelper.instance.deleteTrip(id);
    _loadTrips();

    if (isActive) {
      cubit.loadActiveTrip(); // This will clear it if no other trips exist, or load the next available
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Trip deleted"), backgroundColor: Colors.red),
      );
    }
  }

  void _deleteAllTrips() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Clear All Trips"),
        content: const Text("Are you sure you want to delete ALL saved trips? This cannot be undone."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancel")),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Delete All"),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await DatabaseHelper.instance.deleteAllTrips();
      _loadTrips();
      if (mounted) {
        context.read<TripCubit>().loadActiveTrip(); // Refresh home if active was deleted
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("All trips deleted"), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _showRefineDialog(Trip trip) {
    final destController = TextEditingController(text: trip.destination);
    final budgetController = TextEditingController(text: trip.totalBudget.toStringAsFixed(0));

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Refine Trip"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: destController,
              decoration: const InputDecoration(labelText: "Destination"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: budgetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Budget (\$)"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final newDest = destController.text;
              final newBudget = double.tryParse(budgetController.text) ?? trip.totalBudget;

              final updatedTrip = Trip(
                id: trip.id,
                destination: newDest,
                totalBudget: newBudget,
                startDate: trip.startDate,
                endDate: trip.endDate,
              );

              await DatabaseHelper.instance.updateTrip(updatedTrip);
              if (mounted) {
                Navigator.pop(ctx);
                _loadTrips();
                
                // If it's the active trip, update Cubit
                final cubit = context.read<TripCubit>();
                if (cubit.state.activeTrip?.id == trip.id) {
                  cubit.setActiveTrip(updatedTrip);
                }
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved Trips"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _trips.isEmpty
              ? Center(
                  child: Text("No trips saved yet.", style: TextStyle(color: Colors.grey.shade600)),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _trips.length,
                  itemBuilder: (context, index) {
                    final trip = _trips[index];
                    return Dismissible(
                      key: Key(trip.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        color: Colors.red,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        _deleteTrip(trip.id);
                      },
                      child: Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      trip.destination,
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.grey),
                                    onPressed: () => _showRefineDialog(trip),
                                  )
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Budget: \$${trip.totalBudget.toStringAsFixed(0)}",
                                style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    context.read<TripCubit>().setActiveTrip(trip);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Trip activated!"), backgroundColor: Colors.green),
                                    );
                                    Navigator.pop(context); // Go back to home
                                  },
                                  icon: const Icon(Icons.check_circle_outline),
                                  label: const Text("Make Active Trip"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue.shade50,
                                    foregroundColor: Colors.blue,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
      persistentFooterButtons: _trips.isNotEmpty ? [
        SizedBox(
          width: double.infinity,
          child: TextButton.icon(
            onPressed: _deleteAllTrips,
            icon: const Icon(Icons.delete_sweep, color: Colors.red),
            label: const Text("Clear All Saved Data", style: TextStyle(color: Colors.red)),
          ),
        )
      ] : null,
    );
  }
}
