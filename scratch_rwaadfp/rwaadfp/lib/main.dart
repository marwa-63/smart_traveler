 import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'onboarding_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Roboto'),
      home: BlocProvider(
        create: (context) => OnboardingCubit(),
        child: const OnboardingScreen(),
      ),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingCubit, int>(
      listener: (context, state) {
        if (_pageController.hasClients && _pageController.page?.round() != state) {
          _pageController.animateToPage(
            state,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) => context.read<OnboardingCubit>().updateIndex(index),
                  children: const [
                    OnboardingPage1(),
                    OnboardingPage2(),
                    OnboardingPage3(),
                  ],
                ),
              ),
              _buildFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return BlocBuilder<OnboardingCubit, int>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (state > 0)
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 20),
                  onPressed: () => context.read<OnboardingCubit>().previous(),
                )
              else
                const SizedBox(width: 48),
              if (state < 2)
                TextButton(
                  onPressed: () => context.read<OnboardingCubit>().skip(),
                  child: const Text(
                    'Skip',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                )
              else
                const SizedBox(width: 48),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFooter(BuildContext context) {
    return BlocBuilder<OnboardingCubit, int>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: state == index ? 24 : 8,
                    decoration: BoxDecoration(
                      color: state == index ? const Color(0xFF2CB1F5) : const Color(0xFFE0E0E0),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    if (state < 2) {
                      context.read<OnboardingCubit>().next();
                    } else {
                      // Navigate to next screen or complete onboarding
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2CB1F5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state == 0 ? 'Next' : (state == 1 ? 'Continue' : 'Get Started'),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                      if (state < 2) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward, size: 20, color: Colors.white),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (state == 1)
                const Text(
                  'Step 2 of 3: Smart financial management for modern explorers.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                )
              else if (state == 2)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account? ',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        'Log in',
                        style: TextStyle(fontSize: 14, color: Color(0xFF2CB1F5), fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
              else
                const SizedBox(height: 14),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}

class OnboardingPage1 extends StatelessWidget {
  const OnboardingPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              'lib/assets/ai.jpg',
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 40),
          const Text(
            'AI trip planning',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const Text(
            'made effortless',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF2CB1F5)),
          ),
          const SizedBox(height: 20),
          const Text(
            'Experience the future of travel. Our intelligent assistant builds personalized itineraries tailored to your unique interests and budget in seconds.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage2 extends StatelessWidget {
  const OnboardingPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  image: const DecorationImage(
                    image: AssetImage('lib/assets/trip.jpg'),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
              ),
              Positioned(
                top: -20,
                right: -10,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.trending_up, color: Colors.black, size: 20),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('SAVED', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                          Text('\$240.50', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: -10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: const Color(0xFFE3F2FD), borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.account_balance_wallet_outlined, color: Color(0xFF2CB1F5), size: 18),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Spending limit', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Container(
                            height: 4,
                            width: 60,
                            decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(2)),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: 0.7,
                              child: Container(decoration: BoxDecoration(color: const Color(0xFF2CB1F5), borderRadius: BorderRadius.circular(2))),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'FEATURE HIGHLIGHT',
              style: TextStyle(color: Color(0xFF2CB1F5), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Track your trip',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const Text(
            'budget in real-time',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF2CB1F5)),
          ),
          const SizedBox(height: 16),
          const Text(
            'Manage expenses, set spending alerts, and convert currencies automatically. Never lose track of your travel funds again.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildChip(Icons.monetization_on_outlined, 'Currency Conversion'),
              const SizedBox(width: 12),
              _buildChip(Icons.pie_chart_outline, 'Expense Charts'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.blue),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class OnboardingPage3 extends StatelessWidget {
  const OnboardingPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: const Color(0xFFF0F4F8),
                  image: const DecorationImage(
                    image: AssetImage('lib/assets/f31141832d54a80bc2473f37568bc787.jpg'),
                    fit: BoxFit.cover,
                    opacity: 0.6,
                  ),
                ),
              ),
              // Map Pin - Food
              Positioned(
                top: 80,
                left: 100,
                child: _buildMapPin(Icons.restaurant, Colors.red),
              ),
              // Map Pin - Hotel
              Positioned(
                top: 150,
                right: 80,
                child: _buildMapPin(Icons.hotel, Colors.green),
              ),
              // Current Location Dot
              Positioned(
                top: 160,
                left: 150,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: Container(
                    height: 12,
                    width: 12,
                    decoration: const BoxDecoration(color: Color(0xFF2CB1F5), shape: BoxShape.circle),
                  ),
                ),
              ),
              // Recommendation Card
              Positioned(
                bottom: -30,
                child: Container(
                  width: 260,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: const Color(0xFFE3F2FD), borderRadius: BorderRadius.circular(12)),
                        child: const Icon(Icons.star_outline, color: Color(0xFF2CB1F5)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'RECOMMENDED',
                              style: TextStyle(fontSize: 10, color: Color(0xFF2CB1F5), fontWeight: FontWeight.bold),
                            ),
                            const Text(
                              'Hidden Gem: Cliffside Cafe',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: const [
                                Icon(Icons.location_on_outlined, size: 12, color: Colors.grey),
                                Text(' 2.4 miles away', style: TextStyle(fontSize: 10, color: Colors.grey)),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 60),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(color: Color(0xFFF1F8E9), shape: BoxShape.circle),
            child: const Icon(Icons.explore_outlined, color: Colors.green, size: 32),
          ),
          const SizedBox(height: 24),
          const Text(
            'Smart maps &',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const Text(
            'recommendations',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 16),
          const Text(
            'Explore like a local with AI-powered maps. Get personalized suggestions for sights, stays, and dining based on your unique travel style.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildMapPin(IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4)],
          ),
          child: Icon(icon, color: Colors.white, size: 16),
        ),
        Container(height: 10, width: 2, color: color),
      ],
    );
  }
}

Widget _buildChip(IconData icon, String label) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.grey[50],
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey[200]!),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.blue),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    ),
  );
}
