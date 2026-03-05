import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../design_system/design_system.dart';

/// Social login buttons widget.
///
/// Displays a row or column of social login buttons based on configuration.
///
/// Example:
/// ```dart
/// SocialLoginButtons(
///   showGoogle: true,
///   showApple: true,
///   onGoogleTap: () => viewModel.loginWithGoogle(),
///   onAppleTap: () => viewModel.loginWithApple(),
///   isLoading: viewModel.busy(googleBusyKey),
/// )
/// ```
class SocialLoginButtons extends StatelessWidget {
  /// Show Google login button.
  final bool showGoogle;

  /// Show Apple login button.
  final bool showApple;

  /// Show GitHub login button.
  final bool showGithub;

  /// Callback when Google button is tapped.
  final VoidCallback? onGoogleTap;

  /// Callback when Apple button is tapped.
  final VoidCallback? onAppleTap;

  /// Callback when GitHub button is tapped.
  final VoidCallback? onGithubTap;

  /// Whether Google login is loading.
  final bool isGoogleLoading;

  /// Whether Apple login is loading.
  final bool isAppleLoading;

  /// Whether GitHub login is loading.
  final bool isGithubLoading;

  /// Layout direction.
  final Axis direction;

  /// Spacing between buttons.
  final double spacing;

  const SocialLoginButtons({
    super.key,
    this.showGoogle = true,
    this.showApple = true,
    this.showGithub = false,
    this.onGoogleTap,
    this.onAppleTap,
    this.onGithubTap,
    this.isGoogleLoading = false,
    this.isAppleLoading = false,
    this.isGithubLoading = false,
    this.direction = Axis.vertical,
    this.spacing = 12,
  });

  @override
  Widget build(BuildContext context) {
    final buttons = <Widget>[];

    if (showGoogle) {
      buttons.add(_SocialButton(
        icon: Icons.g_mobiledata_rounded,
        label: context.l10n.loginWithGoogle,
        onTap: onGoogleTap,
        isLoading: isGoogleLoading,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        borderColor: AppColors.borderLight,
      ));
    }

    if (showApple) {
      buttons.add(_SocialButton(
        icon: Icons.apple_rounded,
        label: context.l10n.loginWithApple,
        onTap: onAppleTap,
        isLoading: isAppleLoading,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ));
    }

    if (showGithub) {
      buttons.add(_SocialButton(
        icon: Icons.code_rounded,
        label: context.l10n.loginWithGithub,
        onTap: onGithubTap,
        isLoading: isGithubLoading,
        backgroundColor: const Color(0xFF24292E),
        foregroundColor: Colors.white,
      ));
    }

    if (buttons.isEmpty) return const SizedBox.shrink();

    if (direction == Axis.horizontal) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: buttons
            .map((b) => Expanded(child: b))
            .toList()
            .expand((w) => [w, SizedBox(width: spacing)])
            .take(buttons.length * 2 - 1)
            .toList(),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: buttons
          .expand((w) => [w, SizedBox(height: spacing)])
          .take(buttons.length * 2 - 1)
          .toList(),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isLoading;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? borderColor;

  const _SocialButton({
    required this.icon,
    required this.label,
    this.onTap,
    this.isLoading = false,
    required this.backgroundColor,
    required this.foregroundColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: AppRadius.md,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: AppRadius.md,
        child: Container(
          height: 52.h,
          decoration: BoxDecoration(
            borderRadius: AppRadius.md,
            border:
                borderColor != null ? Border.all(color: borderColor!) : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading)
                SizedBox(
                  width: 24.w,
                  height: 24.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(foregroundColor),
                  ),
                )
              else ...[
                Icon(icon, color: foregroundColor, size: 24.sp),
                SizedBox(width: 12.w),
                Text(
                  label,
                  style: AppTypography.labelLarge.copyWith(
                    color: foregroundColor,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Divider with "or" text.
class OrDivider extends StatelessWidget {
  final String text;

  const OrDivider({
    super.key,
    this.text = 'or',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Row(
        children: [
          const Expanded(child: Divider()),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Text(
              text,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary(Theme.of(context).brightness),
              ),
            ),
          ),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }
}
