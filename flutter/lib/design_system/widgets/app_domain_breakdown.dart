import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_spacing.dart';
import '../tokens/app_typography.dart';
import 'app_card.dart';

/// A single item in [AppDomainBreakdown].
class AppBreakdownItem {
  /// Emoji or icon prefix (e.g. "🏋️").
  final String icon;

  /// Label (e.g. domain name).
  final String label;

  /// Numeric value (e.g. minutes).
  final int value;

  /// Formatted string for [value] (e.g. "1h30").
  final String formattedValue;

  const AppBreakdownItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.formattedValue,
  });
}

/// Card showing a breakdown of items with emoji + label + value per row,
/// a divider, and a total row.
///
/// Generic enough for: domain time breakdown, category budgets,
/// OKR key-result progress, weekly review summaries, etc.
///
/// Usage:
/// ```dart
/// AppDomainBreakdown(
///   title: l10n.todayDaySummary,
///   items: domains.map((d) => AppBreakdownItem(
///     icon: d.icon,
///     label: d.name,
///     value: minutes[d.id] ?? 0,
///     formattedValue: formatMinutes(minutes[d.id] ?? 0),
///   )).toList(),
///   totalLabel: l10n.total,
///   totalFormattedValue: formatMinutes(totalMinutes),
/// )
/// ```
class AppDomainBreakdown extends StatelessWidget {
  /// Card title.
  final String title;

  /// Breakdown items.
  final List<AppBreakdownItem> items;

  /// Label for the total row (e.g. "Total").
  final String totalLabel;

  /// Formatted total value (e.g. "2h30").
  final String totalFormattedValue;

  const AppDomainBreakdown({
    super.key,
    required this.title,
    required this.items,
    required this.totalLabel,
    required this.totalFormattedValue,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return AppCard.elevated(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textPrimary(brightness),
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          ...items.map((item) {
            final hasValue = item.value > 0;
            return Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.xxs),
              child: Row(
                children: [
                  Text(item.icon, style: TextStyle(fontSize: 16.sp)),
                  SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      item.label,
                      style: AppTypography.textSmall.copyWith(
                        color: hasValue
                            ? AppColors.textPrimary(brightness)
                            : AppColors.textSecondary(brightness),
                      ),
                    ),
                  ),
                  Text(
                    item.formattedValue,
                    style: AppTypography.textSmall.copyWith(
                      color: hasValue
                          ? AppColors.textPrimary(brightness)
                          : AppColors.textSecondary(brightness),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }),
          Divider(color: AppColors.border(brightness)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                totalLabel,
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.textPrimary(brightness),
                ),
              ),
              Text(
                totalFormattedValue,
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
