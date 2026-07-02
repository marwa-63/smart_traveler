import 'package:flutter/material.dart';
import 'package:smart_traveler/constants/app_theme.dart';

class DestinationSearchField extends StatelessWidget {
  final String currentDestination;
  final List<String> suggestions;
  final ValueChanged<String> onDestinationChanged;

  const DestinationSearchField({
    super.key,
    required this.currentDestination,
    required this.suggestions,
    required this.onDestinationChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Where to?',
          style: TextStyle(
            fontFamily: AppTheme.fontFamily,
            fontSize: AppTheme.fontSizeLarge,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: AppTheme.spacingMedium),
        // Search input field
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusXLarge),
            border: Border.all(
              color: AppTheme.textHintColor.withAlpha(100),
              width: AppTheme.borderWidth,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x08000000),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            onChanged: onDestinationChanged,
            decoration: InputDecoration(
              hintText: 'Search city, region or airport...',
              hintStyle: TextStyle(
                fontFamily: AppTheme.fontFamily,
                fontSize: AppTheme.fontSizeMedium,
                color: AppTheme.textHintColor,
              ),
              prefixIcon: const Padding(
                padding: EdgeInsets.only(left: 16, right: 8),
                child: Icon(
                  Icons.search,
                  color: AppTheme.textSecondaryColor,
                  size: AppTheme.iconSizeMedium,
                ),
              ),
              suffixIcon: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Icon(
                  Icons.language,
                  color: AppTheme.textHintColor,
                  size: AppTheme.iconSizeMedium,
                ),
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingLarge,
                vertical: AppTheme.spacingMedium + 2,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppTheme.spacingMedium),
        // Quick suggestion chips
        Wrap(
          spacing: AppTheme.spacingSmall,
          runSpacing: AppTheme.spacingSmall,
          children: suggestions.take(3).map((city) {
            final isSelected = currentDestination == city;
            return GestureDetector(
              onTap: () => onDestinationChanged(city),
              child: AnimatedContainer(
                duration: AppTheme.durationFast,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingLarge,
                  vertical: AppTheme.spacingSmall,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primaryColor.withAlpha(25)
                      : AppTheme.surfaceColor,
                  borderRadius:
                      BorderRadius.circular(AppTheme.borderRadiusCircular),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.primaryColor
                        : AppTheme.textHintColor.withAlpha(100),
                    width: AppTheme.borderWidth,
                  ),
                ),
                child: Text(
                  city,
                  style: TextStyle(
                    fontFamily: AppTheme.fontFamily,
                    fontSize: AppTheme.fontSizeSmall,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected
                        ? AppTheme.primaryColor
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
