import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/core.dart';
import '../../../design_system/design_system.dart';
import '../config/onboarding_config.dart';

/// Individual onboarding slide widget.
///
/// Displays image/icon, title, and description based on style.
/// Each element staggers in with [AppStaggeredFadeIn] for a
/// warm, choreographed entrance.
class OnboardingSlideWidget extends StatelessWidget {
  /// Slide data.
  final OnboardingSlide slide;

  /// Visual style.
  final OnboardingStyle style;

  const OnboardingSlideWidget({
    required this.slide,
    this.style = OnboardingStyle.cards,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: _getLocalizedText(context.l10n, slide.titleKey),
      child: switch (style) {
        OnboardingStyle.cards => _buildCards(context),
        OnboardingStyle.fullscreen => _buildFullscreen(context),
        OnboardingStyle.minimal => _buildMinimal(context),
      },
    );
  }

  Widget _buildCards(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image or icon — enters first
          AppStaggeredFadeIn(
            index: 0,
            offsetY: 16,
            child: _buildImage(context, height: 280.h),
          ),

          SizedBox(height: AppSpacing.xl),

          // Title — enters second
          AppStaggeredFadeIn(
            index: 2,
            offsetY: 12,
            child: Text(
              _getLocalizedText(l10n, slide.titleKey),
              style: AppTypography.headlineMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(height: AppSpacing.md),

          // Description — enters third
          AppStaggeredFadeIn(
            index: 4,
            offsetY: 12,
            child: Text(
              _getLocalizedText(l10n, slide.descriptionKey),
              style: AppTypography.bodyMedium.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Optional action button — enters last
          if (slide.action != null) ...[
            SizedBox(height: AppSpacing.lg),
            AppStaggeredFadeIn(
              index: 6,
              child: AppButton.ghost(
                label: _getLocalizedText(l10n, slide.action!.labelKey),
                onPressed: slide.action!.onTap,
                isFullWidth: false,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFullscreen(BuildContext context) {
    final l10n = context.l10n;

    return Stack(
      fit: StackFit.expand,
      children: [
        // Background image
        if (slide.image.isNotEmpty)
          Positioned.fill(
            child: slide.image.endsWith('.svg')
                ? SvgPicture.asset(slide.image, fit: BoxFit.cover)
                : Image.asset(slide.image, fit: BoxFit.cover),
          ),

        // Gradient overlay
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.7),
                ],
              ),
            ),
          ),
        ),

        // Text content
        Positioned(
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          bottom: 120.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppStaggeredFadeIn(
                index: 0,
                child: Text(
                  _getLocalizedText(l10n, slide.titleKey),
                  style: AppTypography.headlineLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.colorScheme.onInverseSurface,
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.md),
              AppStaggeredFadeIn(
                index: 2,
                child: Text(
                  _getLocalizedText(l10n, slide.descriptionKey),
                  style: AppTypography.bodyLarge.copyWith(
                    color: context.colorScheme.onInverseSurface.withValues(
                      alpha: 0.9,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMinimal(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon or small image
          AppStaggeredFadeIn(
            index: 0,
            child: slide.icon != null
                ? Container(
                    width: 100.w,
                    height: 100.w,
                    decoration: BoxDecoration(
                      color: context.colorScheme.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      slide.icon,
                      size: 48.sp,
                      color: context.colorScheme.primary,
                    ),
                  )
                : _buildImage(context, height: 200.h),
          ),

          SizedBox(height: AppSpacing.xxl),

          // Title
          AppStaggeredFadeIn(
            index: 2,
            child: Text(
              _getLocalizedText(l10n, slide.titleKey),
              style: AppTypography.titleLarge.copyWith(
                fontWeight: FontWeight.w600,
                color: context.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(height: AppSpacing.sm),

          // Description
          AppStaggeredFadeIn(
            index: 4,
            child: Text(
              _getLocalizedText(l10n, slide.descriptionKey),
              style: AppTypography.bodyMedium.copyWith(
                color: context.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(BuildContext context, {required double height}) {
    if (slide.icon != null) {
      return Container(
        width: height,
        height: height,
        decoration: BoxDecoration(
          color:
              slide.backgroundColor ??
              context.colorScheme.primary.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          slide.icon,
          size: height * 0.5,
          color: context.colorScheme.primary,
        ),
      );
    }

    if (slide.image.isEmpty) {
      return SizedBox(height: height);
    }

    // Lottie animation — auto-fallback to SVG if .json not found
    if (slide.image.endsWith('.json')) {
      final svgFallback = slide.image
          .replaceFirst('assets/lottie/', 'assets/images/onboarding/')
          .replaceFirst('.json', '.svg');
      return AppLottieAnimation(
        asset: slide.image,
        height: height,
        placeholder: SvgPicture.asset(
          svgFallback,
          height: height,
          fit: BoxFit.contain,
        ),
      );
    }

    // Rive animation — auto-fallback to SVG if .riv not found
    if (slide.image.endsWith('.riv')) {
      final svgFallback = slide.image
          .replaceFirst('assets/rive/', 'assets/images/onboarding/')
          .replaceFirst('.riv', '.svg');
      return AppRiveAnimation(
        asset: slide.image,
        stateMachineName: 'idle',
        height: height,
        placeholder: SvgPicture.asset(
          svgFallback,
          height: height,
          fit: BoxFit.contain,
        ),
      );
    }

    if (slide.image.endsWith('.svg')) {
      return SvgPicture.asset(slide.image, height: height, fit: BoxFit.contain);
    }

    return Image.asset(slide.image, height: height, fit: BoxFit.contain);
  }

  /// Get localized text from key.
  String _getLocalizedText(AppLocalizations l10n, String key) {
    try {
      return switch (key) {
        'onboardingSlide1Title' => l10n.onboardingSlide1Title,
        'onboardingSlide1Description' => l10n.onboardingSlide1Description,
        'onboardingSlide2Title' => l10n.onboardingSlide2Title,
        'onboardingSlide2Description' => l10n.onboardingSlide2Description,
        'onboardingSlide3Title' => l10n.onboardingSlide3Title,
        'onboardingSlide3Description' => l10n.onboardingSlide3Description,
        _ => key,
      };
    } catch (_) {
      return key;
    }
  }
}
