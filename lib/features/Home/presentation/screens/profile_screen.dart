import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smart_traveler/constants/app_theme.dart';
import 'package:smart_traveler/features/Home/domain/entities/trip.dart';
import 'package:smart_traveler/features/Home/presentation/cubit/trip_cubit.dart';
import 'package:smart_traveler/features/Home/presentation/cubit/trip_state.dart';
import 'package:smart_traveler/features/Home/presentation/screens/saved_trips_screen.dart';
import 'package:smart_traveler/core/database/database_helper.dart';
import 'package:smart_traveler/features/login/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<int> _savedTripsCount() async {
    final trips = await DatabaseHelper.instance.getAllTrips();
    return trips.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Container(
            height: 290,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primaryColor, AppTheme.primaryLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  StreamBuilder<User?>(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator(color: Colors.white));
                      }

                      final user = snapshot.data;
                      if (user == null) {
                        return _buildLoggedOutCard(context);
                      }

                      return _buildProfileHeader(user);
                    },
                  ),
                  const SizedBox(height: 24),
                  _buildStatsRow(),
                  const SizedBox(height: 22),
                  const Text('Active Trip', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimaryColor)),
                  const SizedBox(height: 12),
                  BlocBuilder<TripCubit, TripState>(
                    builder: (context, state) {
                      if (state.activeTrip == null) {
                        return _buildEmptyTripCard();
                      }
                      return _buildActiveTripCard(state.activeTrip!, state.itinerary.length, context);
                    },
                  ),
                  const SizedBox(height: 24),
                  _buildLogoutButton(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(User user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(230),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXLarge),
        boxShadow: AppTheme.shadowMedium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 52,
            backgroundColor: AppTheme.primaryLight,
            child: CircleAvatar(
              radius: 48,
              backgroundImage: user.photoURL != null ? NetworkImage(user.photoURL!) : null,
              backgroundColor: AppTheme.primaryColor,
              child: user.photoURL == null ? const Icon(Icons.person, size: 42, color: Colors.white) : null,
            ),
          ),
          const SizedBox(height: 16),
          Text(user.displayName ?? 'Traveler', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textPrimaryColor)),
          const SizedBox(height: 6),
          Text(user.email ?? 'No email provided', style: const TextStyle(fontSize: 14, color: AppTheme.textSecondaryColor)),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withAlpha(25),
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.star, color: AppTheme.primaryColor, size: 18),
                SizedBox(width: 8),
                Text('Premium Traveler', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoggedOutCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(230),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXLarge),
        boxShadow: AppTheme.shadowMedium,
      ),
      child: Column(
        children: [
          const Icon(Icons.account_circle_outlined, size: 90, color: AppTheme.textSecondaryColor),
          const SizedBox(height: 16),
          const Text('Welcome back, Guest', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.textPrimaryColor)),
          const SizedBox(height: 8),
          const Text('Sign in to save trips, continue your itinerary, and discover personalized recommendations.', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: AppTheme.textSecondaryColor)),
          const SizedBox(height: 18),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge)),
            ),
            child: const Text('Log In', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return FutureBuilder<int>(
      future: _savedTripsCount(),
      builder: (context, snapshot) {
        final savedCount = snapshot.data ?? 0;
        return Row(
          children: [
            Expanded(child: _buildStatCard('Saved Trips', savedCount.toString(), Icons.bookmark_border, AppTheme.primaryColor)),
            const SizedBox(width: 12),
            Expanded(child: _buildStatCard('Trips Ready', '1', Icons.flight_takeoff, AppTheme.secondaryColor)),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
        boxShadow: AppTheme.shadowSmall,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withAlpha(30),
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textPrimaryColor)),
              const SizedBox(height: 4),
              Text(label, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondaryColor)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyTripCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXLarge),
        boxShadow: AppTheme.shadowSmall,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('No active trip yet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimaryColor)),
          SizedBox(height: 8),
          Text('Start planning your next journey and save the best itinerary here.', style: TextStyle(fontSize: 14, color: AppTheme.textSecondaryColor)),
        ],
      ),
    );
  }

  Widget _buildActiveTripCard(Trip trip, int itineraryCount, BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXLarge),
        boxShadow: AppTheme.shadowSmall,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(trip.city, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textPrimaryColor)),
                    const SizedBox(height: 6),
                    Text('${trip.startDate.month}/${trip.startDate.day} - ${trip.endDate.month}/${trip.endDate.day}', style: const TextStyle(fontSize: 14, color: AppTheme.textSecondaryColor)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.secondaryLight,
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
                ),
                child: Text('$itineraryCount days', style: const TextStyle(color: AppTheme.secondaryDark, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(trip.destination, style: const TextStyle(fontSize: 16, color: AppTheme.textPrimaryColor)),
          const SizedBox(height: 14),
          Row(
            children: [
              _buildTripInfoChip(Icons.monetization_on_outlined, 'Budget', '\$${trip.totalBudget.toStringAsFixed(0)}'),
              const SizedBox(width: 10),
              _buildTripInfoChip(Icons.location_on_outlined, 'City', trip.city),
            ],
          ),
          const SizedBox(height: 18),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SavedTripsScreen()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge)),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: Text('View Saved Trips', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripInfoChip(IconData icon, String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.backgroundColor,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppTheme.primaryColor),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondaryColor)),
                  const SizedBox(height: 2),
                  Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimaryColor)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        await FirebaseAuth.instance.signOut();
        await GoogleSignIn().signOut();
        if (!context.mounted) return;
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      },
      icon: const Icon(Icons.logout),
      label: const Text('Sign Out', style: TextStyle(fontWeight: FontWeight.w600)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red.shade400,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge)),
      ),
    );
  }
}
