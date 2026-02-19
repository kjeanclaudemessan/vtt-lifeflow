import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../design_system/design_system.dart';
import '../config/onboarding_config.dart';

/// Progress indicator for onboarding slides.
///
/// Supports different styles: dots, line, and numbers.
class OnboardingIndicator extends StatelessWidget {
  /// Current slide index.
  final int currentIndex;

  /// Total number of slides.
  final int totalCount;

  /// Indicator style.
  final IndicatorStyle style;

  /// Active color.
  final Color? activeColor;

  /// Inactive color.
  final Color? inactiveColor;

  const OnboardingIndicator({
    required this.currentIndex,
    required this.totalCount,
    this.style = IndicatorStyle.dots,
    this.activeColor,
    this.inactiveColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final active = activeColor ?? AppColors.primary;
    final inactive = inactiveColor ?? AppColors.neutral300;

    return switch (style) {
      IndicatorStyle.dots => _buildDots(active, inactive),
      IndicatorStyle.line => _buildLine(active, inactive),
      IndicatorStyle.numbers => _buildNumbers(context, active),
    };
  }

  Widget _buildDots(Color active, Color inactive) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalCount, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          width: isActive ? 24.w : 8.w,
          height: 8.w,
          decoration: BoxDecoration(
            color: isActive ? active : inactive,
            borderRadius: BorderRadius.circular(4.r),
          ),
        );
      }),
    );
  }

  Widget _buildLine(Color active, Color inactive) {
    final progress = totalCount > 0 ? (currentIndex + 1) / totalCount : 0.0;
    return Container(
      height: 4.h,
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      decoration: BoxDecoration(
        color: inactive,
        borderRadius: BorderRadius.circular(2.r),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: constraints.maxWidth * progress,
                height: 4.h,
                decoration: BoxDecoration(
                  color: active,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNumbers(BuildContext context, Color active) {
    return Text(
      '${currentIndex + 1}/$totalCount',
      style: AppTypography.labelMedium.copyWith(
        color: active,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
