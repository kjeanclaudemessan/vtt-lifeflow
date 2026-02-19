import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../tokens/app_colors.dart';
import '../../tokens/app_spacing.dart';
import '../../tokens/app_typography.dart';

/// Pie chart display style.
enum AppPieChartStyle {
  /// Standard pie chart.
  pie,

  /// Donut chart with hole in center.
  donut,
}

/// Size variants for pie chart.
enum AppPieChartSize {
  /// Small chart (100px).
  small,

  /// Medium chart (150px).
  medium,

  /// Large chart (200px).
  large,

  /// Extra large chart (250px).
  extraLarge,
}

/// A pie or donut chart widget.
///
/// Example:
/// ```dart
/// AppPieChart(
///   data: [
///     AppPieData(value: 40, label: 'Sales', color: Colors.blue),
///     AppPieData(value: 30, label: 'Marketing', color: Colors.green),
///     AppPieData(value: 20, label: 'R&D', color: Colors.orange),
///     AppPieData(value: 10, label: 'Other', color: Colors.grey),
///   ],
/// )
/// ```
class AppPieChart extends StatelessWidget {
  /// List of pie data segments.
  final List<AppPieData> data;

  /// Chart size variant.
  final AppPieChartSize size;

  /// Chart display style.
  final AppPieChartStyle style;

  /// Whether to show legend.
  final bool showLegend;

  /// Legend position.
  final AppPieLegendPosition legendPosition;

  /// Whether to animate the chart.
  final bool animated;

  /// Animation duration.
  final Duration animationDuration;

  /// Donut hole ratio (0.0 to 1.0).
  final double donutHoleRatio;

  /// Optional center widget (for donut style).
  final Widget? centerWidget;

  /// Gap between segments in degrees.
  final double gapDegrees;

  /// Start angle in degrees (0 = right, 90 = bottom).
  final double startAngle;

  /// Creates an [AppPieChart].
  const AppPieChart({
    super.key,
    required this.data,
    this.size = AppPieChartSize.medium,
    this.style = AppPieChartStyle.pie,
    this.showLegend = true,
    this.legendPosition = AppPieLegendPosition.right,
    this.animated = true,
    this.animationDuration = const Duration(milliseconds: 1000),
    this.donutHoleRatio = 0.5,
    this.centerWidget,
    this.gapDegrees = 2,
    this.startAngle = -90,
  });

  /// Creates a donut chart.
  const AppPieChart.donut({
    super.key,
    required this.data,
    this.size = AppPieChartSize.medium,
    this.showLegend = true,
    this.legendPosition = AppPieLegendPosition.right,
    this.animated = true,
    this.animationDuration = const Duration(milliseconds: 1000),
    this.donutHoleRatio = 0.6,
    this.centerWidget,
    this.gapDegrees = 2,
    this.startAngle = -90,
  }) : style = AppPieChartStyle.donut;

  /// Creates a small donut chart without legend.
  const AppPieChart.compact({
    super.key,
    required this.data,
    this.style = AppPieChartStyle.donut,
    this.animated = true,
    this.animationDuration = const Duration(milliseconds: 1000),
    this.donutHoleRatio = 0.6,
    this.centerWidget,
    this.gapDegrees = 2,
    this.startAngle = -90,
  })  : size = AppPieChartSize.small,
        showLegend = false,
        legendPosition = AppPieLegendPosition.bottom;

  // ─────────────────────────────────────────────────────────────────
  // Computed Properties
  // ─────────────────────────────────────────────────────────────────

  double get _diameter => switch (size) {
        AppPieChartSize.small => 100.w,
        AppPieChartSize.medium => 150.w,
        AppPieChartSize.large => 200.w,
        AppPieChartSize.extraLarge => 250.w,
      };

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return SizedBox(width: _diameter, height: _diameter);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final chart = SizedBox(
      width: _diameter,
      height: _diameter,
      child: Stack(
        alignment: Alignment.center,
        children: [
          animated
              ? TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: animationDuration,
                  curve: Curves.easeOutCubic,
                  builder: (context, progress, _) {
                    return CustomPaint(
                      size: Size(_diameter, _diameter),
                      painter: _PieChartPainter(
                        data: data,
                        style: style,
                        donutHoleRatio: donutHoleRatio,
                        gapDegrees: gapDegrees,
                        startAngle: startAngle,
                        animationProgress: progress,
                        backgroundColor: isDark
                            ? AppColors.surfaceSecondaryDark
                            : AppColors.surfaceSecondaryLight,
                      ),
                    );
                  },
                )
              : CustomPaint(
                  size: Size(_diameter, _diameter),
                  painter: _PieChartPainter(
                    data: data,
                    style: style,
                    donutHoleRatio: donutHoleRatio,
                    gapDegrees: gapDegrees,
                    startAngle: startAngle,
                    backgroundColor: isDark
                        ? AppColors.surfaceSecondaryDark
                        : AppColors.surfaceSecondaryLight,
                  ),
                ),
          if (style == AppPieChartStyle.donut && centerWidget != null)
            centerWidget!,
        ],
      ),
    );

    if (!showLegend) return chart;

    return switch (legendPosition) {
      AppPieLegendPosition.right => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            chart,
            SizedBox(width: AppSpacing.md.w),
            Flexible(child: _buildLegend(isDark, Axis.vertical)),
          ],
        ),
      AppPieLegendPosition.left => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(child: _buildLegend(isDark, Axis.vertical)),
            SizedBox(width: AppSpacing.md.w),
            chart,
          ],
        ),
      AppPieLegendPosition.bottom => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            chart,
            SizedBox(height: AppSpacing.md.h),
            _buildLegend(isDark, Axis.horizontal),
          ],
        ),
      AppPieLegendPosition.top => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLegend(isDark, Axis.horizontal),
            SizedBox(height: AppSpacing.md.h),
            chart,
          ],
        ),
    };
  }

  Widget _buildLegend(bool isDark, Axis axis) {
    final total = data.fold<double>(0, (sum, d) => sum + d.value);

    final items = data.map((item) {
      final percentage =
          total > 0 ? ((item.value / total) * 100).toStringAsFixed(1) : '0';

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: item.color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: AppSpacing.xs.w),
          Flexible(
            child: Text(
              '${item.label} ($percentage%)',
              style: AppTypography.labelSmall.copyWith(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    }).toList();

    if (axis == Axis.vertical) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items
            .map(
              (item) => Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.xxs.h),
                child: item,
              ),
            )
            .toList(),
      );
    }

    return Wrap(
      spacing: AppSpacing.md.w,
      runSpacing: AppSpacing.xs.h,
      children: items,
    );
  }
}

/// Position for pie chart legend.
enum AppPieLegendPosition {
  /// Legend on the right.
  right,

  /// Legend on the left.
  left,

  /// Legend below the chart.
  bottom,

  /// Legend above the chart.
  top,
}

/// Data for a pie chart segment.
class AppPieData {
  /// Segment value.
  final double value;

  /// Segment label.
  final String label;

  /// Segment color.
  final Color color;

  /// Creates an [AppPieData].
  const AppPieData({
    required this.value,
    required this.label,
    required this.color,
  });
}

// ─────────────────────────────────────────────────────────────────
// Custom Painter
// ─────────────────────────────────────────────────────────────────

class _PieChartPainter extends CustomPainter {
  final List<AppPieData> data;
  final AppPieChartStyle style;
  final double donutHoleRatio;
  final double gapDegrees;
  final double startAngle;
  final double animationProgress;
  final Color backgroundColor;

  _PieChartPainter({
    required this.data,
    required this.style,
    required this.donutHoleRatio,
    required this.gapDegrees,
    required this.startAngle,
    this.animationProgress = 1.0,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final innerRadius =
        style == AppPieChartStyle.donut ? radius * donutHoleRatio : 0.0;

    final total = data.fold<double>(0, (sum, d) => sum + d.value);
    if (total == 0) return;

    final gapRadians = gapDegrees * math.pi / 180;
    final totalGap = gapRadians * data.length;
    final availableSweep = (2 * math.pi - totalGap) * animationProgress;

    var currentAngle = startAngle * math.pi / 180;

    for (final segment in data) {
      final sweepAngle = (segment.value / total) * availableSweep;

      final path = Path();

      if (style == AppPieChartStyle.donut) {
        // Outer arc
        path.arcTo(
          Rect.fromCircle(center: center, radius: radius),
          currentAngle,
          sweepAngle,
          true,
        );

        // Line to inner arc
        final innerEndX =
            center.dx + innerRadius * math.cos(currentAngle + sweepAngle);
        final innerEndY =
            center.dy + innerRadius * math.sin(currentAngle + sweepAngle);
        path.lineTo(innerEndX, innerEndY);

        // Inner arc (reverse direction)
        path.arcTo(
          Rect.fromCircle(center: center, radius: innerRadius),
          currentAngle + sweepAngle,
          -sweepAngle,
          false,
        );

        path.close();
      } else {
        // Pie slice
        path.moveTo(center.dx, center.dy);
        path.arcTo(
          Rect.fromCircle(center: center, radius: radius),
          currentAngle,
          sweepAngle,
          false,
        );
        path.close();
      }

      canvas.drawPath(
        path,
        Paint()
          ..color = segment.color
          ..style = PaintingStyle.fill,
      );

      currentAngle += sweepAngle + gapRadians;
    }

    // Draw center hole background for donut
    if (style == AppPieChartStyle.donut) {
      canvas.drawCircle(
        center,
        innerRadius - 1,
        Paint()
          ..color = backgroundColor
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PieChartPainter oldDelegate) {
    return oldDelegate.data != data ||
        oldDelegate.animationProgress != animationProgress ||
        oldDelegate.style != style;
  }
}

/// A simple percentage indicator donut.
///
/// Example:
/// ```dart
/// AppPercentageDonut(
///   percentage: 75,
///   label: 'Progress',
///   color: AppColors.primary,
/// )
/// ```
class AppPercentageDonut extends StatelessWidget {
  /// Percentage value (0-100).
  final double percentage;

  /// Optional label below percentage.
  final String? label;

  /// Filled segment color.
  final Color? color;

  /// Background segment color.
  final Color? backgroundColor;

  /// Chart size.
  final double size;

  /// Whether to animate.
  final bool animated;

  /// Animation duration.
  final Duration animationDuration;

  /// Creates an [AppPercentageDonut].
  const AppPercentageDonut({
    super.key,
    required this.percentage,
    this.label,
    this.color,
    this.backgroundColor,
    this.size = 100,
    this.animated = true,
    this.animationDuration = const Duration(milliseconds: 800),
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fillColor =
        color ?? (isDark ? AppColors.primaryDark : AppColors.primary);
    final bgColor = backgroundColor ??
        (isDark
            ? AppColors.surfaceSecondaryDark
            : AppColors.surfaceSecondaryLight);

    final clampedPercentage = percentage.clamp(0.0, 100.0);

    return SizedBox(
      width: size.w,
      height: size.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          CustomPaint(
            size: Size(size.w, size.w),
            painter: _SimpleDonutPainter(
              percentage: 100,
              color: bgColor,
              strokeWidth: size.w * 0.12,
            ),
          ),
          // Progress circle
          animated
              ? TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: clampedPercentage),
                  duration: animationDuration,
                  curve: Curves.easeOutCubic,
                  builder: (context, value, _) {
                    return CustomPaint(
                      size: Size(size.w, size.w),
                      painter: _SimpleDonutPainter(
                        percentage: value,
                        color: fillColor,
                        strokeWidth: size.w * 0.12,
                      ),
                    );
                  },
                )
              : CustomPaint(
                  size: Size(size.w, size.w),
                  painter: _SimpleDonutPainter(
                    percentage: clampedPercentage,
                    color: fillColor,
                    strokeWidth: size.w * 0.12,
                  ),
                ),
          // Center text
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${clampedPercentage.toInt()}%',
                style: AppTypography.titleMedium.copyWith(
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (label != null)
                Text(
                  label!,
                  style: AppTypography.labelSmall.copyWith(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SimpleDonutPainter extends CustomPainter {
  final double percentage;
  final Color color;
  final double strokeWidth;

  _SimpleDonutPainter({
    required this.percentage,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final sweepAngle = (percentage / 100) * 2 * math.pi;
    const startAngle = -math.pi / 2;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _SimpleDonutPainter oldDelegate) {
    return oldDelegate.percentage != percentage || oldDelegate.color != color;
  }
}
