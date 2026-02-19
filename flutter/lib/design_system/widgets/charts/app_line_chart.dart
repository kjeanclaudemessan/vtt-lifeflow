import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../tokens/app_colors.dart';
import '../../tokens/app_spacing.dart';
import '../../tokens/app_typography.dart';

/// Line chart style variants.
enum AppLineChartStyle {
  /// Standard line.
  line,

  /// Curved/smooth line.
  curved,

  /// Area chart with fill.
  area,

  /// Curved area chart.
  curvedArea,
}

/// A simple line chart widget.
///
/// Example:
/// ```dart
/// AppLineChart(
///   data: [10, 25, 15, 30, 20, 45, 35],
///   labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
///   color: AppColors.primary,
/// )
/// ```
class AppLineChart extends StatelessWidget {
  /// Data points to plot.
  final List<double> data;

  /// Optional X-axis labels.
  final List<String>? labels;

  /// Line color.
  final Color? color;

  /// Chart height.
  final double height;

  /// Line style variant.
  final AppLineChartStyle style;

  /// Whether to show data points.
  final bool showPoints;

  /// Whether to show grid lines.
  final bool showGrid;

  /// Whether to show labels.
  final bool showLabels;

  /// Whether to animate the chart.
  final bool animated;

  /// Animation duration.
  final Duration animationDuration;

  /// Line stroke width.
  final double strokeWidth;

  /// Area fill opacity (for area styles).
  final double areaOpacity;

  /// Creates an [AppLineChart].
  const AppLineChart({
    super.key,
    required this.data,
    this.labels,
    this.color,
    this.height = 200,
    this.style = AppLineChartStyle.curved,
    this.showPoints = true,
    this.showGrid = true,
    this.showLabels = true,
    this.animated = true,
    this.animationDuration = const Duration(milliseconds: 800),
    this.strokeWidth = 2,
    this.areaOpacity = 0.2,
  });

  /// Creates a simple line chart without decorations.
  const AppLineChart.simple({
    super.key,
    required this.data,
    this.labels,
    this.color,
    this.height = 120,
    this.style = AppLineChartStyle.curved,
    this.strokeWidth = 2,
    this.areaOpacity = 0.2,
    this.animated = true,
    this.animationDuration = const Duration(milliseconds: 800),
  })  : showPoints = false,
        showGrid = false,
        showLabels = false;

  /// Creates an area chart.
  const AppLineChart.area({
    super.key,
    required this.data,
    this.labels,
    this.color,
    this.height = 200,
    this.showPoints = false,
    this.showGrid = true,
    this.showLabels = true,
    this.animated = true,
    this.animationDuration = const Duration(milliseconds: 800),
    this.strokeWidth = 2,
    this.areaOpacity = 0.3,
  }) : style = AppLineChartStyle.curvedArea;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return SizedBox(height: height);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lineColor =
        color ?? (isDark ? AppColors.primaryDark : AppColors.primary);

    return SizedBox(
      height: height + (showLabels ? 24.h : 0),
      child: Column(
        children: [
          Expanded(
            child: animated
                ? TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: animationDuration,
                    curve: Curves.easeOutCubic,
                    builder: (context, animationProgress, _) {
                      return CustomPaint(
                        size: Size.infinite,
                        painter: _LineChartPainter(
                          data: data,
                          color: lineColor,
                          style: style,
                          showPoints: showPoints,
                          showGrid: showGrid,
                          strokeWidth: strokeWidth,
                          areaOpacity: areaOpacity,
                          animationProgress: animationProgress,
                          gridColor: isDark
                              ? AppColors.borderDark
                              : AppColors.borderLight,
                        ),
                      );
                    },
                  )
                : CustomPaint(
                    size: Size.infinite,
                    painter: _LineChartPainter(
                      data: data,
                      color: lineColor,
                      style: style,
                      showPoints: showPoints,
                      showGrid: showGrid,
                      strokeWidth: strokeWidth,
                      areaOpacity: areaOpacity,
                      gridColor:
                          isDark ? AppColors.borderDark : AppColors.borderLight,
                    ),
                  ),
          ),
          if (showLabels && labels != null && labels!.isNotEmpty)
            _buildLabels(isDark),
        ],
      ),
    );
  }

  Widget _buildLabels(bool isDark) {
    return SizedBox(
      height: 24.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: labels!
            .map(
              (label) => Text(
                label,
                style: AppTypography.labelSmall.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

/// A multi-line chart for comparing multiple datasets.
///
/// Example:
/// ```dart
/// AppMultiLineChart(
///   series: [
///     AppChartSeries(data: [10, 20, 15], label: 'Sales', color: Colors.blue),
///     AppChartSeries(data: [8, 15, 25], label: 'Revenue', color: Colors.green),
///   ],
///   labels: ['Jan', 'Feb', 'Mar'],
/// )
/// ```
class AppMultiLineChart extends StatelessWidget {
  /// List of data series to plot.
  final List<AppChartSeries> series;

  /// Optional X-axis labels.
  final List<String>? labels;

  /// Chart height.
  final double height;

  /// Line style variant.
  final AppLineChartStyle style;

  /// Whether to show data points.
  final bool showPoints;

  /// Whether to show grid lines.
  final bool showGrid;

  /// Whether to show labels.
  final bool showLabels;

  /// Whether to show legend.
  final bool showLegend;

  /// Whether to animate the chart.
  final bool animated;

  /// Animation duration.
  final Duration animationDuration;

  /// Line stroke width.
  final double strokeWidth;

  /// Creates an [AppMultiLineChart].
  const AppMultiLineChart({
    super.key,
    required this.series,
    this.labels,
    this.height = 200,
    this.style = AppLineChartStyle.curved,
    this.showPoints = true,
    this.showGrid = true,
    this.showLabels = true,
    this.showLegend = true,
    this.animated = true,
    this.animationDuration = const Duration(milliseconds: 800),
    this.strokeWidth = 2,
  });

  @override
  Widget build(BuildContext context) {
    if (series.isEmpty) return SizedBox(height: height);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        SizedBox(
          height: height + (showLabels ? 24.h : 0),
          child: Column(
            children: [
              Expanded(
                child: animated
                    ? TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 1),
                        duration: animationDuration,
                        curve: Curves.easeOutCubic,
                        builder: (context, animationProgress, _) {
                          return CustomPaint(
                            size: Size.infinite,
                            painter: _MultiLineChartPainter(
                              series: series,
                              style: style,
                              showPoints: showPoints,
                              showGrid: showGrid,
                              strokeWidth: strokeWidth,
                              animationProgress: animationProgress,
                              gridColor: isDark
                                  ? AppColors.borderDark
                                  : AppColors.borderLight,
                            ),
                          );
                        },
                      )
                    : CustomPaint(
                        size: Size.infinite,
                        painter: _MultiLineChartPainter(
                          series: series,
                          style: style,
                          showPoints: showPoints,
                          showGrid: showGrid,
                          strokeWidth: strokeWidth,
                          gridColor: isDark
                              ? AppColors.borderDark
                              : AppColors.borderLight,
                        ),
                      ),
              ),
              if (showLabels && labels != null && labels!.isNotEmpty)
                _buildLabels(isDark),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: labels!
            .map(
              (label) => Text(
                label,
                style: AppTypography.labelSmall.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
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
      children: series
          .map(
            (s) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: s.color,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: AppSpacing.xs.w),
                Text(
                  s.label,
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

/// A data series for [AppMultiLineChart].
class AppChartSeries {
  /// Data points.
  final List<double> data;

  /// Series label for legend.
  final String label;

  /// Line color.
  final Color color;

  /// Creates an [AppChartSeries].
  const AppChartSeries({
    required this.data,
    required this.label,
    required this.color,
  });
}

// ─────────────────────────────────────────────────────────────────
// Custom Painters
// ─────────────────────────────────────────────────────────────────

class _LineChartPainter extends CustomPainter {
  final List<double> data;
  final Color color;
  final AppLineChartStyle style;
  final bool showPoints;
  final bool showGrid;
  final double strokeWidth;
  final double areaOpacity;
  final double animationProgress;
  final Color gridColor;

  _LineChartPainter({
    required this.data,
    required this.color,
    required this.style,
    required this.showPoints,
    required this.showGrid,
    required this.strokeWidth,
    required this.areaOpacity,
    this.animationProgress = 1.0,
    required this.gridColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final maxValue = data.reduce(math.max);
    final minValue = data.reduce(math.min);
    final range = maxValue - minValue;
    final padding = size.height * 0.1;

    // Draw grid
    if (showGrid) {
      _drawGrid(canvas, size);
    }

    // Calculate points
    final points = <Offset>[];
    final stepX = size.width / (data.length - 1);

    for (var i = 0; i < data.length; i++) {
      final normalizedY = range > 0 ? (data[i] - minValue) / range : 0.5;
      final x = i * stepX;
      final y =
          size.height - padding - (normalizedY * (size.height - padding * 2));
      points.add(Offset(x, y));
    }

    // Apply animation
    final animatedPoints = points
        .take(
            (points.length * animationProgress).ceil().clamp(1, points.length))
        .toList();

    if (animatedPoints.isEmpty) return;

    // Draw line/area
    final isCurved = style == AppLineChartStyle.curved ||
        style == AppLineChartStyle.curvedArea;
    final isArea = style == AppLineChartStyle.area ||
        style == AppLineChartStyle.curvedArea;

    final path = _createPath(animatedPoints, isCurved);

    // Draw area fill
    if (isArea) {
      final areaPath = Path.from(path);
      areaPath.lineTo(animatedPoints.last.dx, size.height);
      areaPath.lineTo(animatedPoints.first.dx, size.height);
      areaPath.close();

      final gradient = ui.Gradient.linear(
        const Offset(0, 0),
        Offset(0, size.height),
        [
          color.withOpacity(areaOpacity),
          color.withOpacity(0),
        ],
      );

      canvas.drawPath(
        areaPath,
        Paint()
          ..shader = gradient
          ..style = PaintingStyle.fill,
      );
    }

    // Draw line
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    // Draw points
    if (showPoints) {
      for (final point in animatedPoints) {
        canvas.drawCircle(
          point,
          strokeWidth * 2,
          Paint()..color = color,
        );
        canvas.drawCircle(
          point,
          strokeWidth,
          Paint()..color = Colors.white,
        );
      }
    }
  }

  void _drawGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = gridColor
      ..strokeWidth = 0.5;

    // Horizontal lines
    for (var i = 0; i <= 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  Path _createPath(List<Offset> points, bool curved) {
    final path = Path();

    if (points.isEmpty) return path;

    path.moveTo(points.first.dx, points.first.dy);

    if (!curved || points.length < 3) {
      for (var i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
    } else {
      // Cubic bezier curves
      for (var i = 0; i < points.length - 1; i++) {
        final p0 = i > 0 ? points[i - 1] : points[i];
        final p1 = points[i];
        final p2 = points[i + 1];
        final p3 = i < points.length - 2 ? points[i + 2] : p2;

        final cp1 = Offset(
          p1.dx + (p2.dx - p0.dx) / 6,
          p1.dy + (p2.dy - p0.dy) / 6,
        );
        final cp2 = Offset(
          p2.dx - (p3.dx - p1.dx) / 6,
          p2.dy - (p3.dy - p1.dy) / 6,
        );

        path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p2.dx, p2.dy);
      }
    }

    return path;
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) {
    return oldDelegate.data != data ||
        oldDelegate.color != color ||
        oldDelegate.animationProgress != animationProgress;
  }
}

class _MultiLineChartPainter extends CustomPainter {
  final List<AppChartSeries> series;
  final AppLineChartStyle style;
  final bool showPoints;
  final bool showGrid;
  final double strokeWidth;
  final double animationProgress;
  final Color gridColor;

  _MultiLineChartPainter({
    required this.series,
    required this.style,
    required this.showPoints,
    required this.showGrid,
    required this.strokeWidth,
    this.animationProgress = 1.0,
    required this.gridColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (series.isEmpty) return;

    // Find global min/max
    var maxValue = double.negativeInfinity;
    var minValue = double.infinity;
    var maxLength = 0;

    for (final s in series) {
      if (s.data.isEmpty) continue;
      maxValue = math.max(maxValue, s.data.reduce(math.max));
      minValue = math.min(minValue, s.data.reduce(math.min));
      maxLength = math.max(maxLength, s.data.length);
    }

    if (maxLength == 0) return;

    final range = maxValue - minValue;
    final padding = size.height * 0.1;

    // Draw grid
    if (showGrid) {
      _drawGrid(canvas, size);
    }

    final isCurved = style == AppLineChartStyle.curved ||
        style == AppLineChartStyle.curvedArea;

    // Draw each series
    for (final s in series) {
      if (s.data.isEmpty) continue;

      final points = <Offset>[];
      final stepX = size.width / (s.data.length - 1);

      for (var i = 0; i < s.data.length; i++) {
        final normalizedY = range > 0 ? (s.data[i] - minValue) / range : 0.5;
        final x = i * stepX;
        final y =
            size.height - padding - (normalizedY * (size.height - padding * 2));
        points.add(Offset(x, y));
      }

      final animatedPoints = points
          .take((points.length * animationProgress)
              .ceil()
              .clamp(1, points.length))
          .toList();

      if (animatedPoints.isEmpty) continue;

      final path = _createPath(animatedPoints, isCurved);

      canvas.drawPath(
        path,
        Paint()
          ..color = s.color
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );

      if (showPoints) {
        for (final point in animatedPoints) {
          canvas.drawCircle(
            point,
            strokeWidth * 2,
            Paint()..color = s.color,
          );
          canvas.drawCircle(
            point,
            strokeWidth,
            Paint()..color = Colors.white,
          );
        }
      }
    }
  }

  void _drawGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = gridColor
      ..strokeWidth = 0.5;

    for (var i = 0; i <= 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  Path _createPath(List<Offset> points, bool curved) {
    final path = Path();

    if (points.isEmpty) return path;

    path.moveTo(points.first.dx, points.first.dy);

    if (!curved || points.length < 3) {
      for (var i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
    } else {
      for (var i = 0; i < points.length - 1; i++) {
        final p0 = i > 0 ? points[i - 1] : points[i];
        final p1 = points[i];
        final p2 = points[i + 1];
        final p3 = i < points.length - 2 ? points[i + 2] : p2;

        final cp1 = Offset(
          p1.dx + (p2.dx - p0.dx) / 6,
          p1.dy + (p2.dy - p0.dy) / 6,
        );
        final cp2 = Offset(
          p2.dx - (p3.dx - p1.dx) / 6,
          p2.dy - (p3.dy - p1.dy) / 6,
        );

        path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p2.dx, p2.dy);
      }
    }

    return path;
  }

  @override
  bool shouldRepaint(covariant _MultiLineChartPainter oldDelegate) {
    return oldDelegate.series != series ||
        oldDelegate.animationProgress != animationProgress;
  }
}
