import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_typography.dart';

/// Snackbar variants.
enum AppSnackbarVariant {
  /// Default neutral snackbar.
  neutral,

  /// Success snackbar with green accent.
  success,

  /// Error snackbar with red accent.
  error,

  /// Warning snackbar with yellow accent.
  warning,

  /// Info snackbar with blue accent.
  info,
}

/// A customizable snackbar component following Porsche Design System.
///
/// Example:
/// ```dart
/// AppSnackbar.show(
///   context: context,
///   message: 'Item saved successfully',
///   variant: AppSnackbarVariant.success,
/// );
///
/// // With action
/// AppSnackbar.show(
///   context: context,
///   message: 'Item deleted',
///   action: AppSnackbarAction(
///     label: 'Undo',
///     onPressed: () => undoDelete(),
///   ),
/// );
/// ```
class AppSnackbar {
  AppSnackbar._();

  /// Shows a snackbar.
  static void show({
    required BuildContext context,
    required String message,
    AppSnackbarVariant variant = AppSnackbarVariant.neutral,
    AppSnackbarAction? action,
    Duration duration = const Duration(seconds: 4),
    IconData? icon,
    bool showIcon = true,
    SnackBarBehavior behavior = SnackBarBehavior.floating,
    EdgeInsets? margin,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = _getColors(variant, isDark);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: _SnackbarContent(
          message: message,
          icon: showIcon ? (icon ?? _getIcon(variant)) : null,
          iconColor: colors.icon,
          textColor: colors.text,
        ),
        backgroundColor: colors.background,
        behavior: behavior,
        margin: margin ?? EdgeInsets.all(16.w),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
        duration: duration,
        action: action != null
            ? SnackBarAction(
                label: action.label,
                textColor: colors.action,
                onPressed: action.onPressed,
              )
            : null,
      ),
    );
  }

  /// Shows a success snackbar.
  static void success(
    BuildContext context,
    String message, {
    AppSnackbarAction? action,
    Duration duration = const Duration(seconds: 4),
  }) {
    show(
      context: context,
      message: message,
      variant: AppSnackbarVariant.success,
      action: action,
      duration: duration,
    );
  }

  /// Shows an error snackbar.
  static void error(
    BuildContext context,
    String message, {
    AppSnackbarAction? action,
    Duration duration = const Duration(seconds: 4),
  }) {
    show(
      context: context,
      message: message,
      variant: AppSnackbarVariant.error,
      action: action,
      duration: duration,
    );
  }

  /// Shows a warning snackbar.
  static void warning(
    BuildContext context,
    String message, {
    AppSnackbarAction? action,
    Duration duration = const Duration(seconds: 4),
  }) {
    show(
      context: context,
      message: message,
      variant: AppSnackbarVariant.warning,
      action: action,
      duration: duration,
    );
  }

  /// Shows an info snackbar.
  static void info(
    BuildContext context,
    String message, {
    AppSnackbarAction? action,
    Duration duration = const Duration(seconds: 4),
  }) {
    show(
      context: context,
      message: message,
      variant: AppSnackbarVariant.info,
      action: action,
      duration: duration,
    );
  }

  /// Hides the current snackbar.
  static void hide(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  static IconData _getIcon(AppSnackbarVariant variant) {
    switch (variant) {
      case AppSnackbarVariant.success:
        return Icons.check_circle_rounded;
      case AppSnackbarVariant.error:
        return Icons.error_rounded;
      case AppSnackbarVariant.warning:
        return Icons.warning_rounded;
      case AppSnackbarVariant.info:
        return Icons.info_rounded;
      case AppSnackbarVariant.neutral:
        return Icons.notifications_rounded;
    }
  }

  static _SnackbarColors _getColors(AppSnackbarVariant variant, bool isDark) {
    switch (variant) {
      case AppSnackbarVariant.success:
        return _SnackbarColors(
          background: isDark ? AppColors.successDark : AppColors.success,
          text: AppColors.textOnPrimary,
          icon: AppColors.textOnPrimary,
          action: AppColors.textOnPrimary.withValues(alpha: 0.9),
        );
      case AppSnackbarVariant.error:
        return _SnackbarColors(
          background: isDark ? AppColors.errorDark : AppColors.error,
          text: AppColors.textOnPrimary,
          icon: AppColors.textOnPrimary,
          action: AppColors.textOnPrimary.withValues(alpha: 0.9),
        );
      case AppSnackbarVariant.warning:
        return _SnackbarColors(
          background: isDark ? AppColors.warningDark : AppColors.warning,
          text: AppColors.contrastHighLight,
          icon: AppColors.contrastHighLight,
          action: AppColors.contrastHighLight.withValues(alpha: 0.9),
        );
      case AppSnackbarVariant.info:
        return _SnackbarColors(
          background: isDark ? AppColors.infoDark : AppColors.info,
          text: AppColors.textOnPrimary,
          icon: AppColors.textOnPrimary,
          action: AppColors.textOnPrimary.withValues(alpha: 0.9),
        );
      case AppSnackbarVariant.neutral:
        return _SnackbarColors(
          background:
              isDark ? AppColors.contrastHighDark : AppColors.contrastHighLight,
          text: isDark ? AppColors.textPrimaryLight : AppColors.textPrimaryDark,
          icon: isDark ? AppColors.textPrimaryLight : AppColors.textPrimaryDark,
          action: AppColors.primary,
        );
    }
  }
}

/// Snackbar color configuration.
class _SnackbarColors {
  final Color background;
  final Color text;
  final Color icon;
  final Color action;

  const _SnackbarColors({
    required this.background,
    required this.text,
    required this.icon,
    required this.action,
  });
}

/// Snackbar content widget.
class _SnackbarContent extends StatelessWidget {
  final String message;
  final IconData? icon;
  final Color iconColor;
  final Color textColor;

  const _SnackbarContent({
    required this.message,
    this.icon,
    required this.iconColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, color: iconColor, size: 20.sp),
          SizedBox(width: 12.w),
        ],
        Expanded(
          child: Text(
            message,
            style: AppTypography.bodyMedium.copyWith(color: textColor),
          ),
        ),
      ],
    );
  }
}

/// Action configuration for snackbars.
class AppSnackbarAction {
  /// Action label.
  final String label;

  /// Callback when action is pressed.
  final VoidCallback onPressed;

  /// Creates an [AppSnackbarAction].
  const AppSnackbarAction({
    required this.label,
    required this.onPressed,
  });
}
