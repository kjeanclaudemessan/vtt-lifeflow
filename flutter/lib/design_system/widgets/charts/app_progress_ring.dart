import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../tokens/app_colors.dart';
import '../../tokens/app_spacing.dart';
import '../../tokens/app_typography.dart';

/// Size variants for progress ring.
enum AppProgressRingSize {
  /// Small ring (48px).
  small,

  /// Medium ring (80px).
  medium,

  /// Large ring (120px).
  large,

  /// Extra large ring (160px).
  extraLarge,
}

/// A circular progress indicator with customizable appearance.
///
/// Example:
/// ```dart
/// AppProgressRing(
///   value: 0.75,
///   label: '75%',
///   color: AppColors.primary,
/// )
/// ```
class AppProgressRing extends StatelessWidget {
  /// Progress value between 0.0 and 1.0.
  final double value;

  /// Optional center label text.
  final String? label;

  /// Optional secondary label below main label.
  final String? sublabel;

  /// Ring color.
  final Color? color;

  /// Background ring color.
  final Color? backgroundColor;

  /// Ring size variant.
  final AppProgressRingSize size;

  /// Ring stroke width (null for auto-calculated).
  final double? strokeWidth;

  /// Whether to animate the progress.
  final bool animated;

  /// Animation duration.
  final Duration animationDuration;

  /// Whether to show the label.
  final bool showLabel;

  /// Creates an [AppProgressRing].
  const AppProgressRing({
    super.key,
    required this.value,
    this.label,
    this.sublabel,
    this.color,
    this.backgroundColor,
    this.size = AppProgressRingSize.medium,
    this.strokeWidth,
    this.animated = true,
    this.animationDuration = const Duration(milliseconds: 800),
    this.showLabel = true,
  });

  /// Creates a small progress ring.
  const AppProgressRing.small({
    super.key,
    required this.value,
    this.label,
    this.sublabel,
    this.color,
    this.backgroundColor,
    this.strokeWidth,
    this.animated = true,
    this.animationDuration = const Duration(milliseconds: 800),
    this.showLabel = false,
  }) : size = AppProgressRingSize.small;

  /// Creates a large progress ring with labels.
  const AppProgressRing.large({
    super.key,
    required this.value,
    this.label,
    this.sublabel,
    this.color,
    this.backgroundColor,
    this.strokeWidth,
    this.animated = true,
    this.animationDuration = const Duration(milliseconds: 800),
    this.showLabel = true,
  }) : size = AppProgressRingSize.large;

  // ─────────────────────────────────────────────────────────────────
  // Computed Properties
  // ─────────────────────────────────────────────────────────────────

  double get _diameter => switch (size) {
        AppProgressRingSize.small => 48.w,
        AppProgressRingSize.medium => 80.w,
        AppProgressRingSize.large => 120.w,
        AppProgressRingSize.extraLarge => 160.w,
      };

  double get _strokeWidth =>
      strokeWidth ??
      switch (size) {
        AppProgressRingSize.small => 4.w,
        AppProgressRingSize.medium => 6.w,
        AppProgressRingSize.large => 8.w,
        AppProgressRingSize.extraLarge => 10.w,
      };

  TextStyle get _labelStyle => switch (size) {
        AppProgressRingSize.small => AppTypography.labelSmall,
        AppProgressRingSize.medium => AppTypography.titleMedium,
        AppProgressRingSize.large => AppTypography.headlineSmall,
        AppProgressRingSize.extraLarge => AppTypography.headlineMedium,
      };

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ringColor =
        color ?? (isDark ? AppColors.primaryDark : AppColors.primary);
    final bgColor = backgroundColor ??
        (isDark
            ? AppColors.surfaceSecondaryDark
            : AppColors.surfaceSecondaryLight);

    return SizedBox(
      width: _diameter,
      height: _diameter,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background ring
          CustomPaint(
            size: Size(_diameter, _diameter),
            painter: _RingPainter(
              progress: 1.0,
              color: bgColor,
              strokeWidth: _strokeWidth,
            ),
          ),
          // Progress ring
          if (animated)
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: value.clamp(0.0, 1.0)),
              duration: animationDuration,
              curve: Curves.easeOutCubic,
              builder: (context, animatedValue, _) {
                return CustomPaint(
                  size: Size(_diameter, _diameter),
                  painter: _RingPainter(
                    progress: animatedValue,
                    color: ringColor,
                    strokeWidth: _strokeWidth,
                  ),
                );
              },
            )
          else
            CustomPaint(
              size: Size(_diameter, _diameter),
              painter: _RingPainter(
                progress: value.clamp(0.0, 1.0),
                color: ringColor,
                strokeWidth: _strokeWidth,
              ),
            ),
          // Center label
          if (showLabel && (label != null || sublabel != null))
            _buildCenterLabel(isDark),
        ],
      ),
    );
  }

  Widget _buildCenterLabel(bool isDark) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null)
          Text(
            label!,
            style: _labelStyle.copyWith(
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
              fontWeight: FontWeight.bold,
            ),
          ),
        if (sublabel != null) ...[
          SizedBox(height: AppSpacing.xxs.h),
          Text(
            sublabel!,
            style: AppTypography.labelSmall.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
        ],
      ],
    );
  }
}

/// A multi-segment progress ring showing multiple values.
///
/// Example:
/// ```dart
/// AppMultiProgressRing(
///   segments: [
///     AppProgressSegment(value: 0.4, color: Colors.blue, label: 'Work'),
///     AppProgressSegment(value: 0.3, color: Colors.green, label: 'Exercise'),
///     AppProgressSegment(value: 0.2, color: Colors.orange, label: 'Leisure'),
///   ],
/// )
/// ```
class AppMultiProgressRing extends StatelessWidget {
  /// List of progress segments.
  final List<AppProgressSegment> segments;

  /// Ring size variant.
  final AppProgressRingSize size;

  /// Optional center widget.
  final Widget? centerWidget;

  /// Ring stroke width (null for auto-calculated).
  final double? strokeWidth;

  /// Gap between segments in degrees.
  final double gapDegrees;

  /// Whether to animate the progress.
  final bool animated;

  /// Animation duration.
  final Duration animationDuration;

  /// Creates an [AppMultiProgressRing].
  const AppMultiProgressRing({
    super.key,
    required this.segments,
    this.size = AppProgressRingSize.large,
    this.centerWidget,
    this.strokeWidth,
    this.gapDegrees = 4,
    this.animated = true,
    this.animationDuration = const Duration(milliseconds: 1000),
  });

  // ─────────────────────────────────────────────────────────────────
  // Computed Properties
  // ─────────────────────────────────────────────────────────────────

  double get _diameter => switch (size) {
        AppProgressRingSize.small => 48.w,
        AppProgressRingSize.medium => 80.w,
        AppProgressRingSize.large => 120.w,
        AppProgressRingSize.extraLarge => 160.w,
      };

  double get _strokeWidth =>
      strokeWidth ??
      switch (size) {
        AppProgressRingSize.small => 4.w,
        AppProgressRingSize.medium => 6.w,
        AppProgressRingSize.large => 8.w,
        AppProgressRingSize.extraLarge => 10.w,
      };

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark
        ? AppColors.surfaceSecondaryDark
        : AppColors.surfaceSecondaryLight;

    return SizedBox(
      width: _diameter,
      height: _diameter,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background ring
          CustomPaint(
            size: Size(_diameter, _diameter),
            painter: _RingPainter(
              progress: 1.0,
              color: bgColor,
              strokeWidth: _strokeWidth,
            ),
          ),
          // Multi-segment ring
          if (animated)
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: animationDuration,
              curve: Curves.easeOutCubic,
              builder: (context, animatedValue, _) {
                return CustomPaint(
                  size: Size(_diameter, _diameter),
                  painter: _MultiRingPainter(
                    segments: segments,
                    strokeWidth: _strokeWidth,
                    gapDegrees: gapDegrees,
                    animationProgress: animatedValue,
                  ),
                );
              },
            )
          else
            CustomPaint(
              size: Size(_diameter, _diameter),
              painter: _MultiRingPainter(
                segments: segments,
                strokeWidth: _strokeWidth,
                gapDegrees: gapDegrees,
              ),
            ),
          // Center widget
          if (centerWidget != null) centerWidget!,
        ],
      ),
    );
  }
}

/// A segment for [AppMultiProgressRing].
class AppProgressSegment {
  /// Segment value (0.0 to 1.0 of total).
  final double value;

  /// Segment color.
  final Color color;

  /// Optional label for legend.
  final String? label;

  /// Creates an [AppProgressSegment].
  const AppProgressSegment({
    required this.value,
    required this.color,
    this.label,
  });
}

// ─────────────────────────────────────────────────────────────────
// Custom Painters
// ─────────────────────────────────────────────────────────────────

class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  _RingPainter({
    required this.progress,
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

    final sweepAngle = 2 * math.pi * progress;
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
  bool shouldRepaint(covariant _RingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

class _MultiRingPainter extends CustomPainter {
  final List<AppProgressSegment> segments;
  final double strokeWidth;
  final double gapDegrees;
  final double animationProgress;

  _MultiRingPainter({
    required this.segments,
    required this.strokeWidth,
    required this.gapDegrees,
    this.animationProgress = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final totalValue =
        segments.fold<double>(0, (sum, segment) => sum + segment.value);
    if (totalValue == 0) return;

    final gapRadians = gapDegrees * math.pi / 180;
    final totalGap = gapRadians * segments.length;
    final availableSweep = (2 * math.pi - totalGap) * animationProgress;

    var currentAngle = -math.pi / 2;

    for (final segment in segments) {
      final segmentSweep = (segment.value / totalValue) * availableSweep;

      final paint = Paint()
        ..color = segment.color
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        currentAngle,
        segmentSweep,
        false,
        paint,
      );

      currentAngle += segmentSweep + gapRadians;
    }
  }

  @override
  bool shouldRepaint(covariant _MultiRingPainter oldDelegate) {
    return oldDelegate.segments != segments ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.gapDegrees != gapDegrees ||
        oldDelegate.animationProgress != animationProgress;
  }
}
