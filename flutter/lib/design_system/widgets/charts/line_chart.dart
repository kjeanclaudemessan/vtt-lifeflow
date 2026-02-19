import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// A simple line chart widget for displaying time series data.
///
/// Example:
/// ```dart
/// SimpleLineChart(
///   data: [
///     ChartDataPoint(x: 0, y: 10),
///     ChartDataPoint(x: 1, y: 25),
///     ChartDataPoint(x: 2, y: 15),
///     ChartDataPoint(x: 3, y: 30),
///   ],
///   lineColor: Colors.blue,
///   showDots: true,
///   showGradient: true,
/// )
/// ```
class SimpleLineChart extends StatefulWidget {
  /// The data points for the chart.
  final List<ChartDataPoint> data;

  /// The color of the line.
  final Color? lineColor;

  /// The width of the line.
  final double lineWidth;

  /// Whether to show dots at data points.
  final bool showDots;

  /// The radius of dots.
  final double dotRadius;

  /// Whether to show gradient fill under the line.
  final bool showGradient;

  /// Whether to show grid lines.
  final bool showGrid;

  /// Whether to show X-axis labels.
  final bool showXLabels;

  /// Whether to show Y-axis labels.
  final bool showYLabels;

  /// Custom X-axis labels.
  final List<String>? xLabels;

  /// Number of Y-axis divisions.
  final int yDivisions;

  /// Whether to animate on load.
  final bool animate;

  /// Animation duration.
  final Duration animationDuration;

  /// Whether to use curved line.
  final bool curved;

  /// Padding around the chart.
  final EdgeInsets padding;

  /// Height of the chart.
  final double height;

  /// Optional callback when a point is tapped.
  final void Function(ChartDataPoint)? onPointTap;

  const SimpleLineChart({
    super.key,
    required this.data,
    this.lineColor,
    this.lineWidth = 2,
    this.showDots = true,
    this.dotRadius = 4,
    this.showGradient = true,
    this.showGrid = true,
    this.showXLabels = true,
    this.showYLabels = true,
    this.xLabels,
    this.yDivisions = 5,
    this.animate = true,
    this.animationDuration = const Duration(milliseconds: 1500),
    this.curved = true,
    this.padding = const EdgeInsets.fromLTRB(40, 16, 16, 32),
    this.height = 200,
    this.onPointTap,
  });

  @override
  State<SimpleLineChart> createState() => _SimpleLineChartState();
}

class _SimpleLineChartState extends State<SimpleLineChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    if (widget.animate) {
      _controller.forward();
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant SimpleLineChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data && widget.animate) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return SizedBox(
        height: widget.height,
        child: const Center(
          child: Text('No data'),
        ),
      );
    }

    final theme = Theme.of(context);
    final color = widget.lineColor ?? theme.colorScheme.primary;

    return SizedBox(
      height: widget.height,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: _LineChartPainter(
              data: widget.data,
              lineColor: color,
              lineWidth: widget.lineWidth,
              showDots: widget.showDots,
              dotRadius: widget.dotRadius,
              showGradient: widget.showGradient,
              showGrid: widget.showGrid,
              showXLabels: widget.showXLabels,
              showYLabels: widget.showYLabels,
              xLabels: widget.xLabels,
              yDivisions: widget.yDivisions,
              curved: widget.curved,
              padding: widget.padding,
              animationProgress: _animation.value,
              gridColor: theme.colorScheme.outlineVariant,
              labelColor: theme.colorScheme.onSurfaceVariant,
              labelStyle: theme.textTheme.bodySmall!,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<ChartDataPoint> data;
  final Color lineColor;
  final double lineWidth;
  final bool showDots;
  final double dotRadius;
  final bool showGradient;
  final bool showGrid;
  final bool showXLabels;
  final bool showYLabels;
  final List<String>? xLabels;
  final int yDivisions;
  final bool curved;
  final EdgeInsets padding;
  final double animationProgress;
  final Color gridColor;
  final Color labelColor;
  final TextStyle labelStyle;

  _LineChartPainter({
    required this.data,
    required this.lineColor,
    required this.lineWidth,
    required this.showDots,
    required this.dotRadius,
    required this.showGradient,
    required this.showGrid,
    required this.showXLabels,
    required this.showYLabels,
    required this.xLabels,
    required this.yDivisions,
    required this.curved,
    required this.padding,
    required this.animationProgress,
    required this.gridColor,
    required this.labelColor,
    required this.labelStyle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final chartRect = Rect.fromLTRB(
      padding.left,
      padding.top,
      size.width - padding.right,
      size.height - padding.bottom,
    );

    // Calculate min/max
    final minX = data.map((p) => p.x).reduce(math.min);
    final maxX = data.map((p) => p.x).reduce(math.max);
    final minY = data.map((p) => p.y).reduce(math.min);
    final maxY = data.map((p) => p.y).reduce(math.max);

    final xRange = (maxX - minX == 0 ? 1 : maxX - minX).toDouble();
    final yRange = (maxY - minY == 0 ? 1 : maxY - minY).toDouble();

    // Grid
    if (showGrid) {
      _drawGrid(canvas, chartRect, minY, maxY, yRange);
    }

    // Y-axis labels
    if (showYLabels) {
      _drawYLabels(canvas, chartRect, minY, maxY);
    }

    // X-axis labels
    if (showXLabels) {
      _drawXLabels(canvas, chartRect, minX, maxX, xRange);
    }

    // Calculate points
    final points = <Offset>[];
    for (final point in data) {
      final x = chartRect.left + ((point.x - minX) / xRange) * chartRect.width;
      final y =
          chartRect.bottom - ((point.y - minY) / yRange) * chartRect.height;
      points.add(Offset(x, y));
    }

    // Create path
    final path = _createPath(points);

    // Animate path
    final pathMetrics = path.computeMetrics().toList();
    if (pathMetrics.isEmpty) return;

    final animatedPath = Path();
    for (final metric in pathMetrics) {
      final extractPath = metric.extractPath(
        0,
        metric.length * animationProgress,
      );
      animatedPath.addPath(extractPath, Offset.zero);
    }

    // Gradient fill
    if (showGradient && animationProgress > 0) {
      final gradientPath = Path.from(animatedPath);
      final lastPoint = points[((points.length - 1) * animationProgress)
          .floor()
          .clamp(0, points.length - 1)];
      gradientPath.lineTo(lastPoint.dx, chartRect.bottom);
      gradientPath.lineTo(points.first.dx, chartRect.bottom);
      gradientPath.close();

      final gradient = ui.Gradient.linear(
        Offset(0, chartRect.top),
        Offset(0, chartRect.bottom),
        [
          lineColor.withValues(alpha: 0.3),
          lineColor.withValues(alpha: 0.0),
        ],
      );

      canvas.drawPath(
        gradientPath,
        Paint()..shader = gradient,
      );
    }

    // Line
    canvas.drawPath(
      animatedPath,
      Paint()
        ..color = lineColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = lineWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    // Dots
    if (showDots && animationProgress > 0) {
      final visiblePoints = (points.length * animationProgress).floor();
      for (var i = 0; i < visiblePoints; i++) {
        canvas.drawCircle(
          points[i],
          dotRadius,
          Paint()..color = lineColor,
        );
        canvas.drawCircle(
          points[i],
          dotRadius - 2,
          Paint()..color = Colors.white,
        );
      }
    }
  }

  Path _createPath(List<Offset> points) {
    if (points.isEmpty) return Path();

    final path = Path();
    path.moveTo(points.first.dx, points.first.dy);

    if (curved && points.length > 2) {
      for (var i = 0; i < points.length - 1; i++) {
        final p0 = i > 0 ? points[i - 1] : points[i];
        final p1 = points[i];
        final p2 = points[i + 1];
        final p3 = i < points.length - 2 ? points[i + 2] : p2;

        final cp1x = p1.dx + (p2.dx - p0.dx) / 6;
        final cp1y = p1.dy + (p2.dy - p0.dy) / 6;
        final cp2x = p2.dx - (p3.dx - p1.dx) / 6;
        final cp2y = p2.dy - (p3.dy - p1.dy) / 6;

        path.cubicTo(cp1x, cp1y, cp2x, cp2y, p2.dx, p2.dy);
      }
    } else {
      for (var i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
    }

    return path;
  }

  void _drawGrid(
    Canvas canvas,
    Rect chartRect,
    double minY,
    double maxY,
    double yRange,
  ) {
    final paint = Paint()
      ..color = gridColor
      ..strokeWidth = 0.5;

    for (var i = 0; i <= yDivisions; i++) {
      final y = chartRect.bottom - (chartRect.height * i / yDivisions);
      canvas.drawLine(
        Offset(chartRect.left, y),
        Offset(chartRect.right, y),
        paint,
      );
    }
  }

  void _drawYLabels(Canvas canvas, Rect chartRect, double minY, double maxY) {
    final range = maxY - minY;

    for (var i = 0; i <= yDivisions; i++) {
      final value = minY + (range * i / yDivisions);
      final y = chartRect.bottom - (chartRect.height * i / yDivisions);

      final textSpan = TextSpan(
        text: _formatValue(value),
        style: labelStyle.copyWith(color: labelColor),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      textPainter.paint(
        canvas,
        Offset(
          chartRect.left - textPainter.width - 8,
          y - textPainter.height / 2,
        ),
      );
    }
  }

  void _drawXLabels(
    Canvas canvas,
    Rect chartRect,
    double minX,
    double maxX,
    double xRange,
  ) {
    final labels = xLabels ?? List.generate(data.length, (i) => i.toString());

    for (var i = 0; i < labels.length && i < data.length; i++) {
      final x =
          chartRect.left + ((data[i].x - minX) / xRange) * chartRect.width;

      final textSpan = TextSpan(
        text: labels[i],
        style: labelStyle.copyWith(color: labelColor),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      textPainter.paint(
        canvas,
        Offset(
          x - textPainter.width / 2,
          chartRect.bottom + 8,
        ),
      );
    }
  }

  String _formatValue(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    } else if (value == value.truncate()) {
      return value.toInt().toString();
    } else {
      return value.toStringAsFixed(1);
    }
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) {
    return oldDelegate.animationProgress != animationProgress ||
        oldDelegate.data != data ||
        oldDelegate.lineColor != lineColor;
  }
}

/// Data point for line chart.
class ChartDataPoint {
  final double x;
  final double y;
  final String? label;
  final dynamic metadata;

  const ChartDataPoint({
    required this.x,
    required this.y,
    this.label,
    this.metadata,
  });
}

/// Multiple line chart with multiple series.
class MultiLineChart extends StatelessWidget {
  final List<ChartSeries> series;
  final double height;
  final bool showLegend;
  final bool showGrid;
  final bool showDots;
  final bool curved;
  final EdgeInsets padding;
  final List<String>? xLabels;

  const MultiLineChart({
    super.key,
    required this.series,
    this.height = 200,
    this.showLegend = true,
    this.showGrid = true,
    this.showDots = true,
    this.curved = true,
    this.padding = const EdgeInsets.fromLTRB(40, 16, 16, 32),
    this.xLabels,
  });

  @override
  Widget build(BuildContext context) {
    if (series.isEmpty) {
      return SizedBox(
        height: height,
        child: const Center(child: Text('No data')),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showLegend) _buildLegend(context),
        SizedBox(
          height: height,
          child: Stack(
            children: [
              for (var i = 0; i < series.length; i++)
                SimpleLineChart(
                  data: series[i].data,
                  lineColor: series[i].color,
                  showGradient: i == 0,
                  showGrid: i == 0 && showGrid,
                  showXLabels: i == 0,
                  showYLabels: i == 0,
                  showDots: showDots,
                  curved: curved,
                  padding: padding,
                  xLabels: xLabels,
                  height: height,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLegend(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Wrap(
        spacing: 16,
        runSpacing: 8,
        alignment: WrapAlignment.center,
        children: [
          for (final s in series)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: s.color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  s.name,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
        ],
      ),
    );
  }
}

/// A series of data for multi-line chart.
class ChartSeries {
  final String name;
  final List<ChartDataPoint> data;
  final Color color;

  const ChartSeries({
    required this.name,
    required this.data,
    required this.color,
  });
}
