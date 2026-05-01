import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_traveler/constants/app_theme.dart';

class BudgetInputField extends StatelessWidget {
  final double budget;
  final ValueChanged<double> onBudgetChanged;

  const BudgetInputField({
    super.key,
    required this.budget,
    required this.onBudgetChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLarge),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXLarge),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Icon + Label row ──
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withAlpha(25),
                  borderRadius:
                      BorderRadius.circular(AppTheme.borderRadiusMedium),
                ),
                child: const Icon(
                  Icons.attach_money_rounded,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppTheme.spacingSmall),
              const Text(
                'Budget',
                style: TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  fontSize: AppTheme.fontSizeLarge,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppTheme.spacingMedium),

          // ── Value input area ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '\$',
                style: TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  fontSize: AppTheme.fontSizeLarge,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textSecondaryColor.withAlpha(180),
                ),
              ),
              const SizedBox(width: 4),
              IntrinsicWidth(
                child: TextFormField(
                  initialValue: budget.toStringAsFixed(0),
                  onChanged: (value) {
                    final parsed = double.tryParse(value);
                    if (parsed != null) {
                      onBudgetChanged(parsed);
                    }
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  style: const TextStyle(
                    fontFamily: AppTheme.fontFamily,
                    fontSize: AppTheme.fontSizeHeading,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryColor,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: AppTheme.spacingXSmall,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppTheme.spacingXSmall),

          // ── Subtitle caption ──
          Text(
            'Estimated total spend',
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: AppTheme.fontSizeSmall,
              color: AppTheme.textSecondaryColor.withAlpha(180),
            ),
          ),
        ],
      ),
    );
  }
}
