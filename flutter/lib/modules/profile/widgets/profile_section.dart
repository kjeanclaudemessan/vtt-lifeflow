import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/core.dart';
import '../../../design_system/design_system.dart';

/// Section container for profile fields.
///
/// Groups related fields with an optional title.
class ProfileSection extends StatelessWidget {
  /// Section title.
  final String? title;

  /// Child widgets.
  final List<Widget> children;

  /// Optional trailing action.
  final Widget? trailing;

  /// Padding around the section.
  final EdgeInsetsGeometry? padding;

  /// Whether to show dividers between children.
  final bool showDividers;

  const ProfileSection({
    this.title,
    required this.children,
    this.trailing,
    this.padding,
    this.showDividers = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.lg),
      padding: padding ?? EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: AppColors.neutral200,
          width: 1.w,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title!,
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
            SizedBox(height: AppSpacing.md),
          ],
          if (showDividers)
            ...children.expand((child) sync* {
              yield child;
              if (child != children.last) {
                yield Divider(
                  height: 1.h,
                  color: AppColors.neutral200,
                );
              }
            })
          else
            ...children,
        ],
      ),
    );
  }
}

/// Card-style section for profile.
class ProfileCard extends StatelessWidget {
  /// Child widget.
  final Widget child;

  /// Padding inside the card.
  final EdgeInsetsGeometry? padding;

  /// Callback when tapped.
  final VoidCallback? onTap;

  const ProfileCard({
    required this.child,
    this.padding,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colorScheme.surface,
      borderRadius: AppRadius.lg,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.lg,
        child: Container(
          padding: padding ?? EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: AppRadius.lg,
            border: Border.all(
              color: AppColors.neutral200,
              width: 1.w,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Action button for profile settings.
class ProfileActionButton extends StatelessWidget {
  /// Icon for the action.
  final IconData icon;

  /// Label text.
  final String label;

  /// Callback when tapped.
  final VoidCallback? onTap;

  /// Whether this is a destructive action.
  final bool isDestructive;

  /// Trailing widget (optional).
  final Widget? trailing;

  const ProfileActionButton({
    required this.icon,
    required this.label,
    this.onTap,
    this.isDestructive = false,
    this.trailing,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        isDestructive ? AppColors.error : context.colorScheme.onSurface;

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.md,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.sm,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20.sp,
              color: color,
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                label,
                style: AppTypography.bodyMedium.copyWith(
                  color: color,
                ),
              ),
            ),
            if (trailing != null)
              trailing!
            else
              Icon(
                Icons.chevron_right_rounded,
                size: 20.sp,
                color: AppColors.neutral400,
              ),
          ],
        ),
      ),
    );
  }
}
