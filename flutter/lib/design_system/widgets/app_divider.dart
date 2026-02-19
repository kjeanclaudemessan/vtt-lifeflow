import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_spacing.dart';

/// A customizable divider.
class AppDivider extends StatelessWidget {
  /// Divider thickness.
  final double? thickness;

  /// Divider color.
  final Color? color;

  /// Indent from start.
  final double? indent;

  /// Indent from end.
  final double? endIndent;

  /// Creates an [AppDivider].
  const AppDivider({
    super.key,
    this.thickness,
    this.color,
    this.indent,
    this.endIndent,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Divider(
      thickness: thickness ?? 1,
      color: color ?? (isDark ? AppColors.dividerDark : AppColors.dividerLight),
      indent: indent,
      endIndent: endIndent,
      height: 1,
    );
  }
}

/// A vertical divider.
class AppVerticalDivider extends StatelessWidget {
  /// Divider thickness.
  final double? thickness;

  /// Divider color.
  final Color? color;

  /// Divider height.
  final double? height;

  /// Creates an [AppVerticalDivider].
  const AppVerticalDivider({
    super.key,
    this.thickness,
    this.color,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: thickness ?? 1,
      height: height ?? 20.h,
      color: color ?? (isDark ? AppColors.dividerDark : AppColors.dividerLight),
    );
  }
}

/// A section divider with optional label.
class AppSectionDivider extends StatelessWidget {
  /// Optional label text.
  final String? label;

  /// Creates an [AppSectionDivider].
  const AppSectionDivider({
    super.key,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (label == null) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
        child: const AppDivider(),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Row(
        children: [
          const Expanded(child: AppDivider()),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Text(
              label!,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? AppColors.textTertiaryDark
                    : AppColors.textTertiaryLight,
              ),
            ),
          ),
          const Expanded(child: AppDivider()),
        ],
      ),
    );
  }
}
