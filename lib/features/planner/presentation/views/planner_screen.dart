import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_traveler/constants/app_theme.dart';
import 'package:smart_traveler/features/generate%20trip/models/trip_model.dart';
import 'package:smart_traveler/features/generate%20trip/presentation/views/trip_screen.dart';
import 'package:smart_traveler/features/generate%20trip/services/trip_services.dart';
import '../cubit/planner_cubit.dart';
import '../widgets/destination_search_field.dart';
import '../widgets/budget_input_field.dart';
import '../widgets/duration_selector.dart';
import '../widgets/travel_style_selector.dart';
import '../widgets/interests_selector.dart';

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key});

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PlannerCubit(),
      child: const _PlannerScreenBody(),
    );
  }
}

class _PlannerScreenBody extends StatelessWidget {
  const _PlannerScreenBody();
   

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        title: Row(
          children: [
             const SizedBox(width: AppTheme.spacingMedium),
            // App icon
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF25AFF4), Color(0xFF1A7BA8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius:
                    BorderRadius.circular(AppTheme.borderRadiusMedium),
              ),
              child: const Icon(
                Icons.bolt,
                color: Colors.greenAccent,
                size: 20,
              ),
            ),
            const SizedBox(width: AppTheme.spacingMedium),
            const Text(
              'Smart Traveler',
              style: TextStyle(
                fontFamily: AppTheme.fontFamily,
                fontSize: AppTheme.fontSizeXLarge,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
              ),
            ),
          ],
        ),

      ),
      body: 
      BlocConsumer<PlannerCubit, PlannerState>(
        listener: (context, state) {
          if (state is PlannerFail) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is PlannerSuccess) {
            // Reset success state if needed, or simply navigate
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TripScreen(
                  response: state.tripResponse,
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<PlannerCubit>();
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingXLarge,
                vertical: AppTheme.spacingXXLarge,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header ──
                  const Text(
                    'Plan Your Journey',
                    style: TextStyle(
                      fontFamily: AppTheme.fontFamily,
                      fontSize: AppTheme.fontSizeTitle,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingSmall),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.warning_outlined,
                        color: Colors.amber.withAlpha(180),
                        size: AppTheme.fontSizeMedium,
                      ),
                      const SizedBox(width: AppTheme.spacingSmall),
                      Expanded(
                        child: Text(
                          'Make sure to fill in all the fields below to generate your trip plan.',
                          style: TextStyle(
                            fontFamily: AppTheme.fontFamily,
                            fontSize: AppTheme.fontSizeMedium,
                            color: AppTheme.textSecondaryColor.withAlpha(200),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppTheme.spacingHuge),

                  // ── Destination ──
                  DestinationSearchField(
                    currentDestination: state.destination,
                    suggestions: state.suggestedDestinations,
                    onDestinationChanged: cubit.updateDestination,
                  ),

                  const SizedBox(height: AppTheme.spacingXXLarge + 4),

                  // ── Budget & Duration (side by side) ──
                  Row(
                    children: [
                      Expanded(
                        child: BudgetInputField(
                          budget: state.budget,
                          onBudgetChanged: cubit.updateBudget,
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingMedium),
                      Expanded(
                        child: DurationSelector(
                          startDate: state.startDate,
                          endDate: state.endDate,
                          onStartDateChanged: cubit.updateStartDate,
                          onEndDateChanged: cubit.updateEndDate,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppTheme.spacingXXLarge + 4),

                  // ── Travel Style ──
                  TravelStyleSelector(
                    selectedStyle: state.travelStyle,
                    onStyleChanged: cubit.updateTravelStyle,
                  ),

                  const SizedBox(height: AppTheme.spacingXXLarge + 4),

                  // ── Divider ──
                  Divider(
                    color: AppTheme.textHintColor.withAlpha(60),
                    height: AppTheme.spacingHuge,
                  ),

                  const SizedBox(height: AppTheme.spacingSmall),

                  // ── Interests ──
                  InterestsSelector(
                    selectedInterests: state.interests,
                    onToggleInterest: cubit.toggleInterest,
                  ),

                  const SizedBox(height: AppTheme.spacingHuge + 8),

                  // ── Generate Button ──
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: (!state.isValid || state is PlannerLoading)
                          ? null
                          : () => cubit.generateTrip(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor:
                            AppTheme.primaryColor.withValues(alpha: 0.5),
                        disabledForegroundColor: Colors.white70,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppTheme.borderRadiusXLarge),
                        ),
                        shadowColor: AppTheme.primaryColor.withAlpha(80),
                      ),
                      child: state is PlannerLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.auto_awesome, size: 20),
                                SizedBox(width: AppTheme.spacingSmall),
                                Text(
                                  'Generate Trip Plan',
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontFamily,
                                    fontSize: AppTheme.fontSizeLarge,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),

                  const SizedBox(height: AppTheme.spacingHuge),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
