import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_typography.dart';

/// Banner variants.
enum AppBannerVariant {
  /// Informational banner.
  info,

  /// Success banner.
  success,

  /// Warning banner.
  warning,

  /// Error banner.
  error,

  /// Neutral banner.
  neutral,
}

/// A customizable banner component following Porsche Design System.
///
/// Example:
/// ```dart
/// AppBanner(
///   title: 'Update Available',
///   message: 'A new version is available. Please update.',
///   variant: AppBannerVariant.info,
///   action: AppBannerAction(
///     label: 'Update',
///     onPressed: () => updateApp(),
///   ),
/// );
/// ```
class AppBanner extends StatelessWidget {
  /// Banner title.
  final String? title;

  /// Banner message.
  final String message;

  /// Banner variant.
  final AppBannerVariant variant;

  /// Custom icon.
  final IconData? icon;

  /// Primary action.
  final AppBannerAction? action;

  /// Secondary action.
  final AppBannerAction? secondaryAction;

  /// Whether the banner can be dismissed.
  final bool isDismissible;

  /// Callback when banner is dismissed.
  final VoidCallback? onDismiss;

  /// Whether to show the leading icon.
  final bool showIcon;

  /// Creates an [AppBanner].
  const AppBanner({
    super.key,
    this.title,
    required this.message,
    this.variant = AppBannerVariant.info,
    this.icon,
    this.action,
    this.secondaryAction,
    this.isDismissible = false,
    this.onDismiss,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = _getColors(isDark);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colors.background,
        border: Border(
          left: BorderSide(
            color: colors.accent,
            width: 4.w,
          ),
        ),
        borderRadius: AppRadius.sm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          if (showIcon) ...[
            Icon(
              icon ?? _getIcon(),
              color: colors.accent,
              size: 24.sp,
            ),
            SizedBox(width: 12.w),
          ],

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                if (title != null) ...[
                  Text(
                    title!,
                    style: AppTypography.labelLarge.copyWith(
                      color: colors.title,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                ],

                // Message
                Text(
                  message,
                  style: AppTypography.bodySmall.copyWith(
                    color: colors.text,
                  ),
                ),

                // Actions
                if (action != null || secondaryAction != null) ...[
                  SizedBox(height: 12.h),
                  _buildActions(colors),
                ],
              ],
            ),
          ),

          // Dismiss button
          if (isDismissible) ...[
            SizedBox(width: 8.w),
            GestureDetector(
              onTap: onDismiss,
              child: Icon(
                Icons.close_rounded,
                color: colors.title,
                size: 20.sp,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActions(_BannerColors colors) {
    return Wrap(
      spacing: 12.w,
      runSpacing: 8.h,
      children: [
        if (action != null)
          _ActionButton(
            action: action!,
            isPrimary: true,
            accentColor: colors.accent,
          ),
        if (secondaryAction != null)
          _ActionButton(
            action: secondaryAction!,
            isPrimary: false,
            accentColor: colors.accent,
          ),
      ],
    );
  }

  IconData _getIcon() {
    switch (variant) {
      case AppBannerVariant.info:
        return Icons.info_outline_rounded;
      case AppBannerVariant.success:
        return Icons.check_circle_outline_rounded;
      case AppBannerVariant.warning:
        return Icons.warning_amber_rounded;
      case AppBannerVariant.error:
        return Icons.error_outline_rounded;
      case AppBannerVariant.neutral:
        return Icons.notifications_none_rounded;
    }
  }

  _BannerColors _getColors(bool isDark) {
    switch (variant) {
      case AppBannerVariant.info:
        return _BannerColors(
          background:
              AppColors.infoLight.withValues(alpha: isDark ? 0.15 : 0.1),
          accent: AppColors.info,
          title:
              isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          text: isDark
              ? AppColors.textSecondaryDark
              : AppColors.textSecondaryLight,
        );
      case AppBannerVariant.success:
        return _BannerColors(
          background:
              AppColors.successLight.withValues(alpha: isDark ? 0.15 : 0.1),
          accent: AppColors.success,
          title:
              isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          text: isDark
              ? AppColors.textSecondaryDark
              : AppColors.textSecondaryLight,
        );
      case AppBannerVariant.warning:
        return _BannerColors(
          background:
              AppColors.warningLight.withValues(alpha: isDark ? 0.15 : 0.1),
          accent: AppColors.warning,
          title:
              isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          text: isDark
              ? AppColors.textSecondaryDark
              : AppColors.textSecondaryLight,
        );
      case AppBannerVariant.error:
        return _BannerColors(
          background:
              AppColors.errorLight.withValues(alpha: isDark ? 0.15 : 0.1),
          accent: AppColors.error,
          title:
              isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          text: isDark
              ? AppColors.textSecondaryDark
              : AppColors.textSecondaryLight,
        );
      case AppBannerVariant.neutral:
        return _BannerColors(
          background: isDark
              ? AppColors.surfaceSecondaryDark
              : AppColors.surfaceSecondaryLight,
          accent:
              isDark ? AppColors.contrastHighDark : AppColors.contrastHighLight,
          title:
              isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          text: isDark
              ? AppColors.textSecondaryDark
              : AppColors.textSecondaryLight,
        );
    }
  }
}

/// Banner color configuration.
class _BannerColors {
  final Color background;
  final Color accent;
  final Color title;
  final Color text;

  const _BannerColors({
    required this.background,
    required this.accent,
    required this.title,
    required this.text,
  });
}

/// Action button widget.
class _ActionButton extends StatelessWidget {
  final AppBannerAction action;
  final bool isPrimary;
  final Color accentColor;

  const _ActionButton({
    required this.action,
    required this.isPrimary,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action.onPressed,
      child: Text(
        action.label,
        style: AppTypography.labelMedium.copyWith(
          color: accentColor,
          fontWeight: isPrimary ? FontWeight.w600 : FontWeight.w500,
          decoration: isPrimary ? null : TextDecoration.underline,
        ),
      ),
    );
  }
}

/// Action configuration for banners.
class AppBannerAction {
  /// Action label.
  final String label;

  /// Callback when action is pressed.
  final VoidCallback onPressed;

  /// Creates an [AppBannerAction].
  const AppBannerAction({
    required this.label,
    required this.onPressed,
  });
}

/// An animated dismissible banner.
class AppDismissibleBanner extends StatefulWidget {
  /// Banner widget.
  final AppBanner banner;

  /// Animation duration.
  final Duration animationDuration;

  /// Creates an [AppDismissibleBanner].
  const AppDismissibleBanner({
    super.key,
    required this.banner,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  State<AppDismissibleBanner> createState() => _AppDismissibleBannerState();
}

class _AppDismissibleBannerState extends State<AppDismissibleBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _slideAnimation;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<double>(begin: 0.0, end: -1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _dismiss() {
    _controller.forward().then((_) {
      setState(() => _isVisible = false);
      widget.banner.onDismiss?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value * 20),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: AppBanner(
              title: widget.banner.title,
              message: widget.banner.message,
              variant: widget.banner.variant,
              icon: widget.banner.icon,
              action: widget.banner.action,
              secondaryAction: widget.banner.secondaryAction,
              isDismissible: true,
              onDismiss: _dismiss,
              showIcon: widget.banner.showIcon,
            ),
          ),
        );
      },
    );
  }
}
