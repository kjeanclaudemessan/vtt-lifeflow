import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../tokens/app_colors.dart';
import '../../tokens/app_radius.dart';
import '../../tokens/app_shadows.dart';
import '../../tokens/app_spacing.dart';
import '../../tokens/app_typography.dart';

/// Trend direction for chart stats display.
enum AppChartStatsTrend {
  /// Value is increasing (positive).
  up,

  /// Value is decreasing (negative).
  down,

  /// Value is stable (no change).
  neutral,
}

/// Size variants for chart stats card.
enum AppChartStatsCardSize {
  /// Small compact card.
  small,

  /// Medium default card.
  medium,

  /// Large featured card.
  large,
}

/// A card displaying a chart statistic with optional trend indicator.
///
/// This is different from [AppStatsCard] in app_cards.dart as it provides
/// enhanced chart-specific functionality like trends and size variants.
///
/// Example:
/// ```dart
/// AppChartStatsCard(
///   title: 'Revenue',
///   value: '\$12,450',
///   trend: AppChartStatsTrend.up,
///   trendValue: '+12.5%',
///   icon: Icons.attach_money,
/// )
/// ```
class AppChartStatsCard extends StatelessWidget {
  /// The stat title/label.
  final String title;

  /// The main value to display.
  final String value;

  /// Optional trend direction.
  final AppChartStatsTrend? trend;

  /// Optional trend value (e.g., "+12.5%").
  final String? trendValue;

  /// Optional icon.
  final IconData? icon;

  /// Optional icon background color.
  final Color? iconBackgroundColor;

  /// Optional icon color.
  final Color? iconColor;

  /// Card size variant.
  final AppChartStatsCardSize size;

  /// Optional subtitle text.
  final String? subtitle;

  /// Callback when card is tapped.
  final VoidCallback? onTap;

  /// Creates an [AppChartStatsCard].
  const AppChartStatsCard({
    super.key,
    required this.title,
    required this.value,
    this.trend,
    this.trendValue,
    this.icon,
    this.iconBackgroundColor,
    this.iconColor,
    this.size = AppChartStatsCardSize.medium,
    this.subtitle,
    this.onTap,
  });

  /// Creates a compact stats card for grid layouts.
  const AppChartStatsCard.compact({
    super.key,
    required this.title,
    required this.value,
    this.trend,
    this.trendValue,
    this.icon,
    this.iconBackgroundColor,
    this.iconColor,
    this.subtitle,
    this.onTap,
  }) : size = AppChartStatsCardSize.small;

  /// Creates a featured stats card for hero display.
  const AppChartStatsCard.featured({
    super.key,
    required this.title,
    required this.value,
    this.trend,
    this.trendValue,
    this.icon,
    this.iconBackgroundColor,
    this.iconColor,
    this.subtitle,
    this.onTap,
  }) : size = AppChartStatsCardSize.large;

  // ─────────────────────────────────────────────────────────────────
  // Computed Properties
  // ─────────────────────────────────────────────────────────────────

  EdgeInsets get _padding => switch (size) {
        AppChartStatsCardSize.small => EdgeInsets.all(AppSpacing.sm.w),
        AppChartStatsCardSize.medium => EdgeInsets.all(AppSpacing.md.w),
        AppChartStatsCardSize.large => EdgeInsets.all(AppSpacing.lg.w),
      };

  double get _iconSize => switch (size) {
        AppChartStatsCardSize.small => 32.w,
        AppChartStatsCardSize.medium => 40.w,
        AppChartStatsCardSize.large => 48.w,
      };

  TextStyle get _titleStyle => switch (size) {
        AppChartStatsCardSize.small => AppTypography.labelSmall,
        AppChartStatsCardSize.medium => AppTypography.labelMedium,
        AppChartStatsCardSize.large => AppTypography.labelLarge,
      };

  TextStyle get _valueStyle => switch (size) {
        AppChartStatsCardSize.small => AppTypography.headlineSmall,
        AppChartStatsCardSize.medium => AppTypography.headlineMedium,
        AppChartStatsCardSize.large => AppTypography.displaySmall,
      };

  Color _getTrendColor(bool isDark) {
    if (trend == null)
      return isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    return switch (trend!) {
      AppChartStatsTrend.up => AppColors.success,
      AppChartStatsTrend.down => AppColors.error,
      AppChartStatsTrend.neutral =>
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
    };
  }

  IconData? get _trendIcon => switch (trend) {
        AppChartStatsTrend.up => Icons.trending_up_rounded,
        AppChartStatsTrend.down => Icons.trending_down_rounded,
        AppChartStatsTrend.neutral => Icons.trending_flat_rounded,
        null => null,
      };

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: _padding,
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.white,
          borderRadius: AppRadius.card,
          boxShadow: isDark ? AppShadows.darkSm : AppShadows.sm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(isDark),
            SizedBox(height: AppSpacing.sm.h),
            _buildValue(isDark),
            if (trend != null || trendValue != null) ...[
              SizedBox(height: AppSpacing.xs.h),
              _buildTrend(isDark),
            ],
            if (subtitle != null) ...[
              SizedBox(height: AppSpacing.xs.h),
              _buildSubtitle(isDark),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: _titleStyle.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (icon != null) _buildIcon(isDark),
      ],
    );
  }

  Widget _buildIcon(bool isDark) {
    final bgColor = iconBackgroundColor ??
        (isDark ? AppColors.primaryDark : AppColors.primary).withOpacity(0.1);
    final fgColor =
        iconColor ?? (isDark ? AppColors.primaryDark : AppColors.primary);

    return Container(
      width: _iconSize,
      height: _iconSize,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(_iconSize / 2),
      ),
      child: Icon(
        icon,
        size: _iconSize * 0.5,
        color: fgColor,
      ),
    );
  }

  Widget _buildValue(bool isDark) {
    return Text(
      value,
      style: _valueStyle.copyWith(
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildTrend(bool isDark) {
    final trendColor = _getTrendColor(isDark);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_trendIcon != null) ...[
          Icon(
            _trendIcon,
            size: 16.w,
            color: trendColor,
          ),
          SizedBox(width: AppSpacing.xxs.w),
        ],
        if (trendValue != null)
          Text(
            trendValue!,
            style: AppTypography.labelSmall.copyWith(
              color: trendColor,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }

  Widget _buildSubtitle(bool isDark) {
    return Text(
      subtitle!,
      style: AppTypography.bodySmall.copyWith(
        color:
            isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

/// A row of multiple chart stats displayed horizontally.
///
/// This is different from [AppStatsRow] in app_cards.dart - this version
/// is designed for chart/dashboard contexts with simpler data items.
///
/// Example:
/// ```dart
/// AppChartStatsRow(
///   stats: [
///     AppChartStatItem(label: 'Views', value: '1.2K'),
///     AppChartStatItem(label: 'Likes', value: '340'),
///     AppChartStatItem(label: 'Shares', value: '45'),
///   ],
/// )
/// ```
class AppChartStatsRow extends StatelessWidget {
  /// List of stat items to display.
  final List<AppChartStatItem> stats;

  /// Whether to show dividers between stats.
  final bool showDividers;

  /// Main axis alignment.
  final MainAxisAlignment mainAxisAlignment;

  /// Creates an [AppChartStatsRow].
  const AppChartStatsRow({
    super.key,
    required this.stats,
    this.showDividers = true,
    this.mainAxisAlignment = MainAxisAlignment.spaceEvenly,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dividerColor = isDark ? AppColors.borderDark : AppColors.borderLight;

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: [
        for (int i = 0; i < stats.length; i++) ...[
          Expanded(child: _buildStatItem(stats[i], isDark)),
          if (showDividers && i < stats.length - 1)
            Container(
              width: 1,
              height: 40.h,
              color: dividerColor,
            ),
        ],
      ],
    );
  }

  Widget _buildStatItem(AppChartStatItem stat, bool isDark) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          stat.value,
          style: AppTypography.titleMedium.copyWith(
            color:
                isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: AppSpacing.xxs.h),
        Text(
          stat.label,
          style: AppTypography.labelSmall.copyWith(
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }
}

/// A single stat item for use in [AppChartStatsRow].
class AppChartStatItem {
  /// The stat label.
  final String label;

  /// The stat value.
  final String value;

  /// Optional color for the value.
  final Color? valueColor;

  /// Creates an [AppChartStatItem].
  const AppChartStatItem({
    required this.label,
    required this.value,
    this.valueColor,
  });
}
