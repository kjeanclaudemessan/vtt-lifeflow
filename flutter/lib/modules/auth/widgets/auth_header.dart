import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../design_system/design_system.dart';

/// Auth header widget with logo and title.
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
    return Column(
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
              color: AppColors.textSecondary(Theme.of(context).brightness),
            ),
            textAlign: alignment == CrossAxisAlignment.center
                ? TextAlign.center
                : TextAlign.start,
          ),
        ],
      ],
    );
  }

  Widget _buildLogo(BuildContext context) {
    if (logo != null) return logo!;

    if (logoAsset != null) {
      return Image.asset(
        logoAsset!,
        width: logoSize.w,
        height: logoSize.w,
      );
    }

    // Default logo placeholder
    return Container(
      width: logoSize.w,
      height: logoSize.w,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: AppRadius.lg,
      ),
      child: Icon(
        Icons.lock_rounded,
        size: (logoSize * 0.5).sp,
        color: AppColors.white,
      ),
    );
  }
}
