import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../tokens/app_colors.dart';

/// A loading indicator.
///
/// Example:
/// ```dart
/// AppLoader()
/// AppLoader.small()
/// AppLoader.large(color: Colors.white)
/// ```
class AppLoader extends StatelessWidget {
  /// Loader size.
  final double? size;

  /// Loader color.
  final Color? color;

  /// Stroke width.
  final double? strokeWidth;

  /// Creates an [AppLoader].
  const AppLoader({
    super.key,
    this.size,
    this.color,
    this.strokeWidth,
  });

  /// Creates a small loader.
  const AppLoader.small({
    super.key,
    this.color,
  })  : size = 16,
        strokeWidth = 2;

  /// Creates a medium loader.
  const AppLoader.medium({
    super.key,
    this.color,
  })  : size = 24,
        strokeWidth = 2.5;

  /// Creates a large loader.
  const AppLoader.large({
    super.key,
    this.color,
  })  : size = 40,
        strokeWidth = 3;

  @override
  Widget build(BuildContext context) {
    final loaderSize = size ?? 24.w;
    final loaderStrokeWidth = strokeWidth ?? 2.5;

    return SizedBox(
      width: loaderSize,
      height: loaderSize,
      child: CircularProgressIndicator(
        strokeWidth: loaderStrokeWidth,
        valueColor: AlwaysStoppedAnimation(
          color ?? AppColors.primary,
        ),
      ),
    );
  }
}

/// A full-screen loading overlay.
class AppLoadingOverlay extends StatelessWidget {
  /// Whether the overlay is visible.
  final bool isLoading;

  /// Child widget.
  final Widget child;

  /// Optional loading message.
  final String? message;

  /// Creates an [AppLoadingOverlay].
  const AppLoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: AppColors.overlayBlack,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AppLoader.large(color: AppColors.white),
                  if (message != null) ...[
                    SizedBox(height: 16.h),
                    Text(
                      message!,
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// A skeleton/shimmer loading placeholder.
class AppSkeleton extends StatefulWidget {
  /// Width of the skeleton.
  final double? width;

  /// Height of the skeleton.
  final double? height;

  /// Border radius of the skeleton.
  final BorderRadius? borderRadius;

  /// Whether the skeleton is circular.
  final bool isCircular;

  /// Creates an [AppSkeleton].
  const AppSkeleton({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.isCircular = false,
  });

  /// Creates a circular skeleton (for avatars).
  const AppSkeleton.circle({
    super.key,
    required double size,
  })  : width = size,
        height = size,
        borderRadius = null,
        isCircular = true;

  /// Creates a text line skeleton.
  const AppSkeleton.text({
    super.key,
    this.width,
  })  : height = 14,
        borderRadius = null,
        isCircular = false;

  @override
  State<AppSkeleton> createState() => _AppSkeletonState();
}

class _AppSkeletonState extends State<AppSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _animation = Tween<double>(begin: -1, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width?.w,
          height: widget.height?.h,
          decoration: BoxDecoration(
            shape: widget.isCircular ? BoxShape.circle : BoxShape.rectangle,
            borderRadius: widget.isCircular
                ? null
                : widget.borderRadius ?? BorderRadius.circular(4.r),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: isDark
                  ? [
                      AppColors.surfaceSecondaryDark,
                      AppColors.surfaceDark,
                      AppColors.surfaceSecondaryDark,
                    ]
                  : [
                      AppColors.contrastLowLight,
                      AppColors.surfaceLight,
                      AppColors.contrastLowLight,
                    ],
              stops: [
                (_animation.value - 1).clamp(0.0, 1.0),
                _animation.value.clamp(0.0, 1.0),
                (_animation.value + 1).clamp(0.0, 1.0),
              ],
            ),
          ),
        );
      },
    );
  }
}
