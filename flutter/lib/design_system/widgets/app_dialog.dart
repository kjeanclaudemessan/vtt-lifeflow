import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';
import '../tokens/app_typography.dart';

/// Dialog variants.
enum AppDialogVariant {
  /// Standard alert dialog.
  alert,

  /// Confirmation dialog with actions.
  confirm,

  /// Success dialog with icon.
  success,

  /// Error dialog with icon.
  error,

  /// Warning dialog with icon.
  warning,

  /// Info dialog with icon.
  info,

  /// Fully custom dialog.
  custom,
}

/// A customizable dialog component following Porsche Design System.
///
/// Example:
/// ```dart
/// AppDialog.show(
///   context: context,
///   title: 'Confirm Action',
///   message: 'Are you sure you want to proceed?',
///   variant: AppDialogVariant.confirm,
///   primaryAction: AppDialogAction(label: 'Confirm', onPressed: () {}),
///   secondaryAction: AppDialogAction(label: 'Cancel'),
/// );
/// ```
class AppDialog extends StatelessWidget {
  /// Dialog title.
  final String? title;

  /// Dialog message/content.
  final String? message;

  /// Custom content widget (overrides message).
  final Widget? content;

  /// Dialog variant.
  final AppDialogVariant variant;

  /// Primary action button.
  final AppDialogAction? primaryAction;

  /// Secondary action button.
  final AppDialogAction? secondaryAction;

  /// Custom icon (for custom variant).
  final IconData? icon;

  /// Icon color (for custom variant).
  final Color? iconColor;

  /// Icon background color (for custom variant).
  final Color? iconBackgroundColor;

  /// Whether the dialog can be dismissed by tapping outside.
  final bool isDismissible;

  /// Creates an [AppDialog].
  const AppDialog({
    super.key,
    this.title,
    this.message,
    this.content,
    this.variant = AppDialogVariant.alert,
    this.primaryAction,
    this.secondaryAction,
    this.icon,
    this.iconColor,
    this.iconBackgroundColor,
    this.isDismissible = true,
  });

  /// Shows an alert dialog.
  static Future<T?> alert<T>({
    required BuildContext context,
    required String title,
    required String message,
    String buttonLabel = 'OK',
    VoidCallback? onPressed,
  }) {
    return show(
      context: context,
      title: title,
      message: message,
      variant: AppDialogVariant.alert,
      primaryAction: AppDialogAction(
        label: buttonLabel,
        onPressed: onPressed,
      ),
    );
  }

  /// Shows a confirmation dialog.
  static Future<bool?> confirm({
    required BuildContext context,
    required String title,
    required String message,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    bool isDestructive = false,
  }) async {
    return show<bool>(
      context: context,
      title: title,
      message: message,
      variant: AppDialogVariant.confirm,
      primaryAction: AppDialogAction(
        label: confirmLabel,
        isDestructive: isDestructive,
        onPressed: () => Navigator.of(context).pop(true),
      ),
      secondaryAction: AppDialogAction(
        label: cancelLabel,
        isSecondary: true,
        onPressed: () => Navigator.of(context).pop(false),
      ),
    );
  }

  /// Shows a success dialog.
  static Future<T?> success<T>({
    required BuildContext context,
    required String title,
    String? message,
    String buttonLabel = 'Done',
    VoidCallback? onPressed,
  }) {
    return show(
      context: context,
      title: title,
      message: message,
      variant: AppDialogVariant.success,
      primaryAction: AppDialogAction(
        label: buttonLabel,
        onPressed: onPressed,
      ),
    );
  }

  /// Shows an error dialog.
  static Future<T?> error<T>({
    required BuildContext context,
    required String title,
    String? message,
    String buttonLabel = 'OK',
    VoidCallback? onPressed,
  }) {
    return show(
      context: context,
      title: title,
      message: message,
      variant: AppDialogVariant.error,
      primaryAction: AppDialogAction(
        label: buttonLabel,
        onPressed: onPressed,
      ),
    );
  }

  /// Shows a warning dialog.
  static Future<T?> warning<T>({
    required BuildContext context,
    required String title,
    String? message,
    String buttonLabel = 'OK',
    VoidCallback? onPressed,
  }) {
    return show(
      context: context,
      title: title,
      message: message,
      variant: AppDialogVariant.warning,
      primaryAction: AppDialogAction(
        label: buttonLabel,
        onPressed: onPressed,
      ),
    );
  }

  /// Shows a custom dialog.
  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    String? message,
    Widget? content,
    AppDialogVariant variant = AppDialogVariant.alert,
    AppDialogAction? primaryAction,
    AppDialogAction? secondaryAction,
    IconData? icon,
    Color? iconColor,
    Color? iconBackgroundColor,
    bool isDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: isDismissible,
      builder: (context) => AppDialog(
        title: title,
        message: message,
        content: content,
        variant: variant,
        primaryAction: primaryAction,
        secondaryAction: secondaryAction,
        icon: icon,
        iconColor: iconColor,
        iconBackgroundColor: iconBackgroundColor,
        isDismissible: isDismissible,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.dialog),
      child: Container(
        constraints: BoxConstraints(maxWidth: 400.w),
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            if (_hasIcon) ...[
              _buildIcon(isDark),
              SizedBox(height: 16.h),
            ],

            // Title
            if (title != null) ...[
              Text(
                title!,
                style: AppTypography.headlineSmall.copyWith(
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
            ],

            // Message or Content
            if (content != null)
              content!
            else if (message != null)
              Text(
                message!,
                style: AppTypography.bodyMedium.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
                textAlign: TextAlign.center,
              ),

            // Actions
            if (primaryAction != null || secondaryAction != null) ...[
              SizedBox(height: 24.h),
              _buildActions(context, isDark),
            ],
          ],
        ),
      ),
    );
  }

  bool get _hasIcon =>
      variant != AppDialogVariant.alert &&
      variant != AppDialogVariant.confirm &&
      variant != AppDialogVariant.custom ||
      (variant == AppDialogVariant.custom && icon != null);

  Widget _buildIcon(bool isDark) {
    final iconData = _getIcon();
    final bgColor = _getIconBackgroundColor(isDark);
    final fgColor = _getIconColor(isDark);

    return Container(
      width: 64.w,
      height: 64.w,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: Icon(
        iconData,
        size: 32.sp,
        color: fgColor,
      ),
    );
  }

  IconData _getIcon() {
    if (icon != null) return icon!;

    switch (variant) {
      case AppDialogVariant.success:
        return Icons.check_rounded;
      case AppDialogVariant.error:
        return Icons.close_rounded;
      case AppDialogVariant.warning:
        return Icons.warning_rounded;
      case AppDialogVariant.info:
        return Icons.info_outline_rounded;
      default:
        return Icons.info_outline_rounded;
    }
  }

  Color _getIconBackgroundColor(bool isDark) {
    if (iconBackgroundColor != null) return iconBackgroundColor!;

    switch (variant) {
      case AppDialogVariant.success:
        return AppColors.successLight;
      case AppDialogVariant.error:
        return AppColors.errorLight;
      case AppDialogVariant.warning:
        return AppColors.warningLight;
      case AppDialogVariant.info:
        return AppColors.infoLight;
      default:
        return isDark
            ? AppColors.surfaceSecondaryDark
            : AppColors.surfaceSecondaryLight;
    }
  }

  Color _getIconColor(bool isDark) {
    if (iconColor != null) return iconColor!;

    switch (variant) {
      case AppDialogVariant.success:
        return AppColors.success;
      case AppDialogVariant.error:
        return AppColors.error;
      case AppDialogVariant.warning:
        return AppColors.warning;
      case AppDialogVariant.info:
        return AppColors.info;
      default:
        return isDark
            ? AppColors.contrastHighDark
            : AppColors.contrastHighLight;
    }
  }

  Widget _buildActions(BuildContext context, bool isDark) {
    final hasSecondary = secondaryAction != null;

    if (hasSecondary) {
      return Row(
        children: [
          Expanded(
            child: _buildActionButton(context, secondaryAction!, isDark),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _buildActionButton(context, primaryAction!, isDark),
          ),
        ],
      );
    }

    return SizedBox(
      width: double.infinity,
      child: _buildActionButton(context, primaryAction!, isDark),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    AppDialogAction action,
    bool isDark,
  ) {
    final onPressed = action.onPressed ?? () => Navigator.of(context).pop();

    if (action.isSecondary) {
      return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: AppSpacing.buttonPadding,
          minimumSize: Size(0, AppSpacing.buttonHeightMd),
        ),
        child: Text(action.label),
      );
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            action.isDestructive ? AppColors.error : AppColors.primary,
        padding: AppSpacing.buttonPadding,
        minimumSize: Size(0, AppSpacing.buttonHeightMd),
      ),
      child: Text(action.label),
    );
  }
}

/// Action button configuration for dialogs.
class AppDialogAction {
  /// Button label.
  final String label;

  /// Callback when button is pressed.
  /// If null, dialog will be dismissed.
  final VoidCallback? onPressed;

  /// Whether this is a secondary (outlined) button.
  final bool isSecondary;

  /// Whether this is a destructive action.
  final bool isDestructive;

  /// Creates an [AppDialogAction].
  const AppDialogAction({
    required this.label,
    this.onPressed,
    this.isSecondary = false,
    this.isDestructive = false,
  });
}
