import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../tokens/app_colors.dart';
import '../../tokens/app_radius.dart';
import '../../tokens/app_spacing.dart';
import '../../tokens/app_typography.dart';

/// Bar chart orientation.
enum AppBarChartOrientation {
  /// Vertical bars (default).
  vertical,

  /// Horizontal bars.
  horizontal,
}

/// A bar chart widget with customizable appearance.
///
/// Example:
/// ```dart
/// AppBarChart(
///   data: [
///     AppBarData(value: 100, label: 'Jan', color: Colors.blue),
///     AppBarData(value: 150, label: 'Feb', color: Colors.green),
///     AppBarData(value: 80, label: 'Mar', color: Colors.orange),
///   ],
/// )
/// ```
class AppBarChart extends StatelessWidget {
  /// List of bar data.
  final List<AppBarData> data;

  /// Chart height (for vertical) or width (for horizontal).
  final double height;

  /// Bar chart orientation.
  final AppBarChartOrientation orientation;

  /// Whether to show values on bars.
  final bool showValues;

  /// Whether to show labels.
  final bool showLabels;

  /// Whether to show grid lines.
  final bool showGrid;

  /// Whether to animate the chart.
  final bool animated;

  /// Animation duration.
  final Duration animationDuration;

  /// Space between bars (ratio 0.0 to 1.0).
  final double barSpacing;

  /// Corner radius for bars.
  final double barRadius;

  /// Default bar color if not specified in data.
  final Color? defaultColor;

  /// Maximum value for scaling (auto if null).
  final double? maxValue;

  /// Creates an [AppBarChart].
  const AppBarChart({
    super.key,
    required this.data,
    this.height = 200,
    this.orientation = AppBarChartOrientation.vertical,
    this.showValues = true,
    this.showLabels = true,
    this.showGrid = true,
    this.animated = true,
    this.animationDuration = const Duration(milliseconds: 800),
    this.barSpacing = 0.3,
    this.barRadius = 4,
    this.defaultColor,
    this.maxValue,
  });

  /// Creates a horizontal bar chart.
  const AppBarChart.horizontal({
    super.key,
    required this.data,
    this.height = 200,
    this.showValues = true,
    this.showLabels = true,
    this.showGrid = true,
    this.animated = true,
    this.animationDuration = const Duration(milliseconds: 800),
    this.barSpacing = 0.3,
    this.barRadius = 4,
    this.defaultColor,
    this.maxValue,
  }) : orientation = AppBarChartOrientation.horizontal;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return SizedBox(height: height);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final chartMax = maxValue ?? data.map((d) => d.value).reduce(math.max);

    return SizedBox(
      height: height + (showLabels ? 24.h : 0),
      child: Column(
        children: [
          Expanded(
            child: orientation == AppBarChartOrientation.vertical
                ? _buildVerticalChart(isDark, chartMax)
                : _buildHorizontalChart(isDark, chartMax),
          ),
          if (showLabels && orientation == AppBarChartOrientation.vertical)
            _buildLabels(isDark),
        ],
      ),
    );
  }

  Widget _buildVerticalChart(bool isDark, double chartMax) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final barWidth = constraints.maxWidth / data.length;
        final actualBarWidth = barWidth * (1 - barSpacing);

        return Stack(
          children: [
            if (showGrid) _buildGridLines(isDark, constraints),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: data.map((bar) {
                final barColor = bar.color ??
                    defaultColor ??
                    (isDark ? AppColors.primaryDark : AppColors.primary);
                final barHeight = chartMax > 0
                    ? (bar.value / chartMax) * constraints.maxHeight
                    : 0.0;

                return SizedBox(
                  width: barWidth,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (showValues)
                        Padding(
                          padding: EdgeInsets.only(bottom: AppSpacing.xxs.h),
                          child: Text(
                            bar.formattedValue ?? bar.value.toStringAsFixed(0),
                            style: AppTypography.labelSmall.copyWith(
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                            ),
                          ),
                        ),
                      animated
                          ? TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0, end: barHeight),
                              duration: animationDuration,
                              curve: Curves.easeOutCubic,
                              builder: (context, height, _) {
                                return _buildBar(
                                  actualBarWidth,
                                  height,
                                  barColor,
                                );
                              },
                            )
                          : _buildBar(actualBarWidth, barHeight, barColor),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHorizontalChart(bool isDark, double chartMax) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final barHeight = constraints.maxHeight / data.length;
        final actualBarHeight = barHeight * (1 - barSpacing);

        return Column(
          children: data.map((bar) {
            final barColor = bar.color ??
                defaultColor ??
                (isDark ? AppColors.primaryDark : AppColors.primary);
            final barWidth = chartMax > 0
                ? (bar.value / chartMax) * constraints.maxWidth
                : 0.0;

            return SizedBox(
              height: barHeight,
              child: Row(
                children: [
                  if (showLabels)
                    SizedBox(
                      width: 60.w,
                      child: Text(
                        bar.label,
                        style: AppTypography.labelSmall.copyWith(
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: animated
                          ? TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0, end: barWidth),
                              duration: animationDuration,
                              curve: Curves.easeOutCubic,
                              builder: (context, width, _) {
                                return _buildHorizontalBar(
                                  width,
                                  actualBarHeight,
                                  barColor,
                                );
                              },
                            )
                          : _buildHorizontalBar(
                              barWidth,
                              actualBarHeight,
                              barColor,
                            ),
                    ),
                  ),
                  if (showValues)
                    Padding(
                      padding: EdgeInsets.only(left: AppSpacing.xs.w),
                      child: Text(
                        bar.formattedValue ?? bar.value.toStringAsFixed(0),
                        style: AppTypography.labelSmall.copyWith(
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                    ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildBar(double width, double height, Color color) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(barRadius),
          topRight: Radius.circular(barRadius),
        ),
      ),
    );
  }

  Widget _buildHorizontalBar(double width, double height, Color color) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(barRadius),
          bottomRight: Radius.circular(barRadius),
        ),
      ),
    );
  }

  Widget _buildGridLines(bool isDark, BoxConstraints constraints) {
    final gridColor = isDark ? AppColors.borderDark : AppColors.borderLight;

    return Column(
      children: List.generate(
        5,
        (i) => Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: gridColor, width: 0.5),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabels(bool isDark) {
    return SizedBox(
      height: 24.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: data
            .map(
              (bar) => Expanded(
                child: Text(
                  bar.label,
                  style: AppTypography.labelSmall.copyWith(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

/// Data for a single bar in [AppBarChart].
class AppBarData {
  /// The bar value.
  final double value;

  /// The bar label.
  final String label;

  /// Optional bar color.
  final Color? color;

  /// Optional formatted value string.
  final String? formattedValue;

  /// Creates an [AppBarData].
  const AppBarData({
    required this.value,
    required this.label,
    this.color,
    this.formattedValue,
  });
}

/// A grouped bar chart for comparing multiple categories.
///
/// Example:
/// ```dart
/// AppGroupedBarChart(
///   groups: [
///     AppBarGroup(
///       label: 'Q1',
///       bars: [
///         AppBarData(value: 100, label: 'Sales'),
///         AppBarData(value: 80, label: 'Revenue'),
///       ],
///     ),
///   ],
/// )
/// ```
class AppGroupedBarChart extends StatelessWidget {
  /// List of bar groups.
  final List<AppBarGroup> groups;

  /// List of legend items with colors.
  final List<AppBarLegendItem> legend;

  /// Chart height.
  final double height;

  /// Whether to show values on bars.
  final bool showValues;

  /// Whether to show labels.
  final bool showLabels;

  /// Whether to show legend.
  final bool showLegend;

  /// Whether to animate the chart.
  final bool animated;

  /// Animation duration.
  final Duration animationDuration;

  /// Corner radius for bars.
  final double barRadius;

  /// Creates an [AppGroupedBarChart].
  const AppGroupedBarChart({
    super.key,
    required this.groups,
    required this.legend,
    this.height = 200,
    this.showValues = false,
    this.showLabels = true,
    this.showLegend = true,
    this.animated = true,
    this.animationDuration = const Duration(milliseconds: 800),
    this.barRadius = 4,
  });

  @override
  Widget build(BuildContext context) {
    if (groups.isEmpty) return SizedBox(height: height);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Find max value across all groups
    double chartMax = 0;
    for (final group in groups) {
      for (final bar in group.bars) {
        chartMax = math.max(chartMax, bar.value);
      }
    }

    return Column(
      children: [
        SizedBox(
          height: height + (showLabels ? 24.h : 0),
          child: Column(
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final groupWidth = constraints.maxWidth / groups.length;
                    final barCount = legend.length;
                    final barWidth = (groupWidth * 0.7) / barCount;

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: groups.map((group) {
                        return SizedBox(
                          width: groupWidth,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: List.generate(group.bars.length, (i) {
                              final bar = group.bars[i];
                              final color = i < legend.length
                                  ? legend[i].color
                                  : (isDark
                                      ? AppColors.primaryDark
                                      : AppColors.primary);
                              final barHeight = chartMax > 0
                                  ? (bar.value / chartMax) *
                                      constraints.maxHeight
                                  : 0.0;

                              return animated
                                  ? TweenAnimationBuilder<double>(
                                      tween: Tween(begin: 0, end: barHeight),
                                      duration: animationDuration,
                                      curve: Curves.easeOutCubic,
                                      builder: (context, height, _) {
                                        return Container(
                                          width: barWidth,
                                          height: height,
                                          margin: EdgeInsets.symmetric(
                                            horizontal: 1.w,
                                          ),
                                          decoration: BoxDecoration(
                                            color: color,
                                            borderRadius: BorderRadius.only(
                                              topLeft:
                                                  Radius.circular(barRadius),
                                              topRight:
                                                  Radius.circular(barRadius),
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : Container(
                                      width: barWidth,
                                      height: barHeight,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 1.w),
                                      decoration: BoxDecoration(
                                        color: color,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(barRadius),
                                          topRight: Radius.circular(barRadius),
                                        ),
                                      ),
                                    );
                            }),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
              if (showLabels) _buildLabels(isDark),
            ],
          ),
        ),
        if (showLegend) ...[
          SizedBox(height: AppSpacing.sm.h),
          _buildLegend(isDark),
        ],
      ],
    );
  }

  Widget _buildLabels(bool isDark) {
    return SizedBox(
      height: 24.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: groups
            .map(
              (group) => Expanded(
                child: Text(
                  group.label,
                  style: AppTypography.labelSmall.copyWith(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildLegend(bool isDark) {
    return Wrap(
      spacing: AppSpacing.md.w,
      runSpacing: AppSpacing.xs.h,
      children: legend
          .map(
            (item) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: item.color,
                    borderRadius: AppRadius.xs,
                  ),
                ),
                SizedBox(width: AppSpacing.xs.w),
                Text(
                  item.label,
                  style: AppTypography.labelSmall.copyWith(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          )
          .toList(),
    );
  }
}

/// A group of bars for [AppGroupedBarChart].
class AppBarGroup {
  /// Group label.
  final String label;

  /// List of bars in this group.
  final List<AppBarData> bars;

  /// Creates an [AppBarGroup].
  const AppBarGroup({
    required this.label,
    required this.bars,
  });
}

/// A legend item for [AppGroupedBarChart].
class AppBarLegendItem {
  /// Legend label.
  final String label;

  /// Legend color.
  final Color color;

  /// Creates an [AppBarLegendItem].
  const AppBarLegendItem({
    required this.label,
    required this.color,
  });
}
