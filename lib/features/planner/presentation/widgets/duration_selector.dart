import 'package:flutter/material.dart';
import 'package:smart_traveler/constants/app_theme.dart';

class DurationSelector extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final ValueChanged<DateTime?> onStartDateChanged;
  final ValueChanged<DateTime?> onEndDateChanged;

  const DurationSelector({
    super.key,
    this.startDate,
    this.endDate,
    required this.onStartDateChanged,
    required this.onEndDateChanged
  });

  int get _nights {
    if (startDate == null || endDate == null) return 0;
    final diff = endDate!.difference(startDate!).inDays;
    return diff > 0 ? diff : 0;
  }

  String _formatShort(DateTime? d) {
    if (d == null) return '—';
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${d.day} ${months[d.month - 1]}';
  }

  Future<void> _pickRange(BuildContext context) async {
    final initial = startDate != null && endDate != null
        ? DateTimeRange(start: startDate!, end: endDate!)
        : null;

    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)), // up to 2 years
      initialDateRange: initial,
      helpText: 'SELECT TRAVEL DATES',
      saveText: 'CONFIRM',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryColor,
              onPrimary: Colors.white,
              secondary: AppTheme.primaryLight,
              onSecondary: Colors.white,
              surface: Colors.white,
              onSurface: AppTheme.textPrimaryColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primaryColor,
                textStyle: const TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            dialogTheme: DialogThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusXLarge),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onStartDateChanged(picked.start);
      onEndDateChanged(picked.end);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasRange = startDate != null && endDate != null;

    return GestureDetector(
      onTap: () => _pickRange(context),
      child: Container(
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
            // ── Header row ──
            Row(
              children: [
                // Icon badge — acts as the tap trigger hint
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withAlpha(25),
                    borderRadius:
                        BorderRadius.circular(AppTheme.borderRadiusMedium),
                  ),
                  child: const Icon(
                    Icons.calendar_month_rounded,
                    color: AppTheme.primaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingSmall),
                const Text(
                  'Duration',
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

            // ── Date range display ──
            AnimatedSwitcher(
              duration: AppTheme.durationFast,
              child: hasRange
                  ? _DateRangeDisplay(
                      key: const ValueKey('range'),
                      startDate: startDate!,
                      endDate: endDate!,
                      nights: _nights,
                      formatShort: _formatShort,
                    )
                  : _EmptyDateHint(
                      key: const ValueKey('empty'),
                      formatShort: _formatShort,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Filled state ──────────────────────────────────────────
class _DateRangeDisplay extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final int nights;
  final String Function(DateTime?) formatShort;

  const _DateRangeDisplay({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.nights,
    required this.formatShort,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // nights badge
        Row(
          children: [
            Text(
              '$nights',
              style: const TextStyle(
                fontFamily: AppTheme.fontFamily,
                fontSize: AppTheme.fontSizeHeading,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              'night${nights == 1 ? '' : 's'}',
              style: TextStyle(
                fontFamily: AppTheme.fontFamily,
                fontSize: AppTheme.fontSizeMedium,
                fontWeight: FontWeight.w500,
                color: AppTheme.textSecondaryColor.withAlpha(180),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingSmall),
        // start → end pill row
        Row(
          children: [
              _DatePill(label: 'From', date: startDate, formatShort: formatShort),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Icon(
                Icons.arrow_forward_rounded,
                size: 14,
                color: AppTheme.textHintColor,
              ),
            ),
              _DatePill(label: 'To', date: endDate, formatShort: formatShort),
          ],
        ),
        const SizedBox(height: AppTheme.spacingXSmall),
        Text(
          'Tap to change dates',
          style: TextStyle(
            fontFamily: AppTheme.fontFamily,
            fontSize: AppTheme.fontSizeSmall,
            color: AppTheme.textHintColor,
          ),
        ),
      ],
    );
  }
}

// ── Empty / placeholder state ─────────────────────────────
class _EmptyDateHint extends StatelessWidget {
  final String Function(DateTime?) formatShort;

  const _EmptyDateHint({super.key, required this.formatShort});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _DatePill(label: 'From', date: null, formatShort: formatShort),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Icon(
                Icons.arrow_forward_rounded,
                size: 14,
                color: AppTheme.textHintColor,
              ),
            ),
            _DatePill(label: 'To', date: null, formatShort: formatShort),
          ],
        ),
        const SizedBox(height: AppTheme.spacingXSmall),
        Text(
          'Tap to select travel dates',
          style: TextStyle(
            fontFamily: AppTheme.fontFamily,
            fontSize: AppTheme.fontSizeSmall,
            color: AppTheme.textSecondaryColor.withAlpha(160),
          ),
        ),
      ],
    );
  }
}

// ── Reusable date pill ────────────────────────────────────
class _DatePill extends StatelessWidget {
  final String label;
  final DateTime? date;
  final String Function(DateTime?) formatShort;

  const _DatePill({
    required this.label,
    required this.date,
    required this.formatShort,
  });

  @override
  Widget build(BuildContext context) {
    final bool filled = date != null;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: filled
              ? AppTheme.primaryColor.withAlpha(20)
              : AppTheme.backgroundColor,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
          border: Border.all(
            color: filled
                ? AppTheme.primaryColor.withAlpha(90)
                : AppTheme.textHintColor.withAlpha(100),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: AppTheme.fontFamily,
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: filled
                    ? AppTheme.primaryColor
                    : AppTheme.textHintColor,
                letterSpacing: 0.5,
              ),
            ),
            Text(
              filled ? formatShort(date) : '—',
              style: TextStyle(
                fontFamily: AppTheme.fontFamily,
                fontSize: AppTheme.fontSizeSmall,
                fontWeight: FontWeight.bold,
                color: filled
                    ? AppTheme.textPrimaryColor
                    : AppTheme.textHintColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
