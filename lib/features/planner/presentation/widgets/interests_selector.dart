import 'package:flutter/material.dart';
import 'package:smart_traveler/constants/app_theme.dart';

class InterestsSelector extends StatelessWidget {
  final List<String> selectedInterests;
  final ValueChanged<String> onToggleInterest;

  const InterestsSelector({
    super.key,
    required this.selectedInterests,
    required this.onToggleInterest,
  });

  static const List<Map<String, dynamic>> _allInterests = [
    {'label': 'Culture', 'icon': Icons.museum},
    {'label': 'Foodie', 'icon': Icons.restaurant_menu},
    {'label': 'Adventure', 'icon': Icons.terrain},
    {'label': 'Nature', 'icon': Icons.park},
    {'label': 'Nightlife', 'icon': Icons.nightlife},
    {'label': 'Shopping', 'icon': Icons.shopping_bag},
    {'label': 'History', 'icon': Icons.account_balance},
    {'label': 'Relaxation', 'icon': Icons.spa},
    {'label': 'Photography', 'icon': Icons.camera_alt},
    {'label': 'Family', 'icon': Icons.family_restroom},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withAlpha(25),
                borderRadius:
                    BorderRadius.circular(AppTheme.borderRadiusMedium),
              ),
              child: const Icon(
                Icons.park,
                color: AppTheme.primaryColor,
                size: AppTheme.iconSizeSmall,
              ),
            ),
            const SizedBox(width: AppTheme.spacingSmall),
            const Text(
              'Your Interests',
              style: TextStyle(
                fontFamily: AppTheme.fontFamily,
                fontSize: AppTheme.fontSizeXLarge,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
              ),
            ),
          ],
        ),

        const SizedBox(height: AppTheme.spacingLarge),
        
        Wrap(
          spacing: AppTheme.spacingSmall + 2,
          runSpacing: AppTheme.spacingMedium,
          children: _allInterests.map((interest) {
            final label = interest['label'] as String;
            final isSelected = selectedInterests.contains(label);
            return GestureDetector(
              onTap: () => onToggleInterest(label),
              child: AnimatedContainer(
                duration: AppTheme.durationFast,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingXLarge,
                  vertical: AppTheme.spacingMedium,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primaryColor : AppTheme.surfaceColor,
                  borderRadius:
                      BorderRadius.circular(AppTheme.borderRadiusCircular),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.primaryColor
                        : AppTheme.textHintColor.withAlpha(100),
                    width: AppTheme.borderWidth,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppTheme.primaryColor.withAlpha(50),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    fontFamily: AppTheme.fontFamily,
                    fontSize: AppTheme.fontSizeMedium,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected
                        ? Colors.white
                        : AppTheme.textSecondaryColor,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
