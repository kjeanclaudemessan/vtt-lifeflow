import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../design_system/design_system.dart';

/// Auth header widget with logo and title.
///
/// Renders with staggered fade-in animation for a warm entrance.
///
/// Example:
/// ```dart
/// AuthHeader(
///   title: 'Welcome back',
///   subtitle: 'Sign in to continue',
/// )
/// ```
class AuthHeader extends StatelessWidget {
  /// Main title text.
  final String title;

  /// Subtitle text.
  final String? subtitle;

  /// Optional logo widget.
  final Widget? logo;

  /// Logo asset path.
  final String? logoAsset;

  /// Logo size.
  final double logoSize;

  /// Alignment of the content.
  final CrossAxisAlignment alignment;

  const AuthHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.logo,
    this.logoAsset,
    this.logoSize = 80,
    this.alignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return AppStaggeredFadeIn(
      index: 0,
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          // Logo
          if (logo != null || logoAsset != null) ...[
            _buildLogo(context),
            SizedBox(height: AppSpacing.xl),
          ],

          // Title
          Text(
            title,
            style: AppTypography.headlineLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: alignment == CrossAxisAlignment.center
                ? TextAlign.center
                : TextAlign.start,
          ),

          // Subtitle
          if (subtitle != null) ...[
            SizedBox(height: AppSpacing.xs),
            Text(
              subtitle!,
              style: AppTypography.bodyMedium.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
              textAlign: alignment == CrossAxisAlignment.center
                  ? TextAlign.center
                  : TextAlign.start,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    if (logo != null) {
      return Semantics(label: 'App logo', child: logo!);
    }

    if (logoAsset != null) {
      return Semantics(
        label: 'App logo',
        child: Image.asset(logoAsset!, width: logoSize.w, height: logoSize.w),
      );
    }

    // Default logo placeholder
    return Semantics(
      label: 'App logo',
      child: Container(
        width: logoSize.w,
        height: logoSize.w,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: AppRadius.lg,
        ),
        child: Icon(
          Icons.lock_rounded,
          size: (logoSize * 0.5).sp,
          color: context.colorScheme.onPrimary,
        ),
      ),
    );
  }
}
