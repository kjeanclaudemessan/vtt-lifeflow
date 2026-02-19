import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/core.dart';
import '../../../design_system/design_system.dart';

/// Navigation buttons for onboarding.
///
/// Includes Next/Get Started and optional Skip buttons.
class OnboardingNavigation extends StatelessWidget {
  /// Whether this is the last slide.
  final bool isLastSlide;

  /// Callback when Next/Get Started is tapped.
  final VoidCallback onNext;

  /// Callback when Skip is tapped.
  final VoidCallback? onSkip;

  /// Whether skip button is visible.
  final bool canSkip;

  /// Whether the next button is loading.
  final bool isLoading;

  const OnboardingNavigation({
    required this.isLastSlide,
    required this.onNext,
    this.onSkip,
    this.canSkip = true,
    this.isLoading = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        children: [
          // Skip button
          if (canSkip && !isLastSlide)
            TextButton(
              onPressed: onSkip,
              child: Text(
                l10n.skip,
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.textSecondaryLight,
                ),
              ),
            )
          else
            SizedBox(width: 80.w),

          const Spacer(),

          // Next/Get Started button
          SizedBox(
            width: 140.w,
            child: AppButton.primary(
              label: isLastSlide ? l10n.getStarted : l10n.next,
              onPressed: onNext,
              isLoading: isLoading,
            ),
          ),
        ],
      ),
    );
  }
}

/// Full-width navigation variant for bottom of screen.
class OnboardingNavigationFull extends StatelessWidget {
  /// Whether this is the last slide.
  final bool isLastSlide;

  /// Callback when Next/Get Started is tapped.
  final VoidCallback onNext;

  /// Callback when Skip is tapped.
  final VoidCallback? onSkip;

  /// Whether skip button is visible.
  final bool canSkip;

  /// Whether the next button is loading.
  final bool isLoading;

  const OnboardingNavigationFull({
    required this.isLastSlide,
    required this.onNext,
    this.onSkip,
    this.canSkip = true,
    this.isLoading = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Main action button
          AppButton.primary(
            label: isLastSlide ? l10n.getStarted : l10n.next,
            onPressed: onNext,
            isLoading: isLoading,
          ),

          // Skip button
          if (canSkip && !isLastSlide) ...[
            SizedBox(height: AppSpacing.md),
            TextButton(
              onPressed: onSkip,
              child: Text(
                l10n.skip,
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.textSecondaryLight,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
