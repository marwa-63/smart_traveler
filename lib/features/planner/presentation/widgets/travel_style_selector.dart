import 'package:flutter/material.dart';
import 'package:smart_traveler/constants/app_theme.dart';

class TravelStyleSelector extends StatelessWidget {
  final String selectedStyle;
  final ValueChanged<String> onStyleChanged;

  const TravelStyleSelector({
    super.key,
    required this.selectedStyle,
    required this.onStyleChanged,
  });

  static const List<Map<String, dynamic>> _travelStyles = [
    {'label': 'Adventure & Nature', 'icon': Icons.terrain},
    {'label': 'Cultural & Historical', 'icon': Icons.account_balance},
    {'label': 'Relaxation & Wellness', 'icon': Icons.spa},
    {'label': 'City & Nightlife', 'icon': Icons.nightlife},
    {'label': 'Family Friendly', 'icon': Icons.family_restroom},
    {'label': 'Luxury & Premium', 'icon': Icons.diamond},
    {'label': 'Budget Backpacking', 'icon': Icons.hiking},
    {'label': 'Foodie & Culinary', 'icon': Icons.restaurant},
  ];

  void _showStylePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTheme.borderRadiusXLarge),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppTheme.spacingXXLarge,
            horizontal: AppTheme.spacingLarge,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppTheme.textHintColor.withAlpha(120),
                      borderRadius:
                          BorderRadius.circular(AppTheme.borderRadiusCircular),
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingXLarge),
                const Text(
                  'Select Travel Style',
                  style: TextStyle(
                    fontFamily: AppTheme.fontFamily,
                    fontSize: AppTheme.fontSizeXXLarge,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingLarge),
                ...List.generate(_travelStyles.length, (index) {
                  final style = _travelStyles[index];
                  final isSelected = selectedStyle == style['label'];
                  return Padding(
                    padding:
                        const EdgeInsets.only(bottom: AppTheme.spacingSmall),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          onStyleChanged(style['label'] as String);
                          Navigator.pop(context);
                        },
                        borderRadius:
                            BorderRadius.circular(AppTheme.borderRadiusLarge),
                        child: AnimatedContainer(
                          duration: AppTheme.durationFast,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.spacingLarge,
                            vertical: AppTheme.spacingMedium,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.primaryColor.withAlpha(20)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(
                                AppTheme.borderRadiusLarge),
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.primaryColor
                                  : AppTheme.textHintColor.withAlpha(60),
                              width: isSelected
                                  ? AppTheme.borderWidthThick
                                  : AppTheme.borderWidth,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                style['icon'] as IconData,
                                color: isSelected
                                    ? AppTheme.primaryColor
                                    : AppTheme.textSecondaryColor,
                                size: AppTheme.iconSizeMedium,
                              ),
                              const SizedBox(width: AppTheme.spacingMedium),
                              Expanded(
                                child: Text(
                                  style['label'] as String,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontFamily,
                                    fontSize: AppTheme.fontSizeLarge,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                    color: isSelected
                                        ? AppTheme.primaryColor
                                        : AppTheme.textPrimaryColor,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                const Icon(
                                  Icons.check_circle,
                                  color: AppTheme.primaryColor,
                                  size: AppTheme.iconSizeMedium,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: AppTheme.spacingSmall),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Find icon for current selected style
    IconData currentIcon = Icons.terrain;
    for (final style in _travelStyles) {
      if (style['label'] == selectedStyle) {
        currentIcon = style['icon'] as IconData;
        break;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Travel Style',
          style: TextStyle(
            fontFamily: AppTheme.fontFamily,
            fontSize: AppTheme.fontSizeLarge,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: AppTheme.spacingMedium),
        GestureDetector(
          onTap: () => _showStylePicker(context),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingLarge,
              vertical: AppTheme.spacingMedium + 2,
            ),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius:
                  BorderRadius.circular(AppTheme.borderRadiusXLarge),
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
            child: Row(
              children: [
                // Icon badge
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withAlpha(25),
                    borderRadius:
                        BorderRadius.circular(AppTheme.borderRadiusMedium),
                  ),
                  child: Icon(
                    currentIcon,
                    color: AppTheme.primaryColor,
                    size: AppTheme.iconSizeMedium,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TRAVEL STYLE',
                        style: TextStyle(
                          fontFamily: AppTheme.fontFamily,
                          fontSize: AppTheme.fontSizeXSmall,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.0,
                          color: AppTheme.textSecondaryColor.withAlpha(180),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        selectedStyle,
                        style: const TextStyle(
                          fontFamily: AppTheme.fontFamily,
                          fontSize: AppTheme.fontSizeLarge,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: AppTheme.textHintColor,
                  size: AppTheme.iconSizeMedium,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
