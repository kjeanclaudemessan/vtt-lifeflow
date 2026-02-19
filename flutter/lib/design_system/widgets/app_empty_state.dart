import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_spacing.dart';
import '../tokens/app_typography.dart';
import 'app_button.dart';

/// A styled empty state placeholder following Porsche Design System.
///
/// Use this when there's no content to display (empty lists, search results, etc.).
///
/// Example:
/// ```dart
/// AppEmptyState(
///   icon: Icons.inbox_outlined,
///   title: 'No messages',
///   description: 'Your inbox is empty',
///   actionLabel: 'Compose',
///   onAction: () {},
/// )
/// ```
class AppEmptyState extends StatelessWidget {
  /// Icon to display.
  final IconData? icon;

  /// Custom icon widget (overrides icon).
  final Widget? iconWidget;

  /// Title text.
  final String title;

  /// Description text.
  final String? description;

  /// Primary action button label.
  final String? actionLabel;

  /// Primary action callback.
  final VoidCallback? onAction;

  /// Secondary action button label.
  final String? secondaryActionLabel;

  /// Secondary action callback.
  final VoidCallback? onSecondaryAction;

  /// Custom icon size.
  final double? iconSize;

  /// Custom icon color.
  final Color? iconColor;

  /// Whether to use compact layout.
  final bool isCompact;

  /// Creates an [AppEmptyState].
  const AppEmptyState({
    super.key,
    this.icon,
    this.iconWidget,
    required this.title,
    this.description,
    this.actionLabel,
    this.onAction,
    this.secondaryActionLabel,
    this.onSecondaryAction,
    this.iconSize,
    this.iconColor,
    this.isCompact = false,
  });

  /// Creates an empty inbox state.
  factory AppEmptyState.inbox({
    Key? key,
    String title = 'No messages',
    String? description = 'Your inbox is empty',
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return AppEmptyState(
      key: key,
      icon: Icons.inbox_outlined,
      title: title,
      description: description,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// Creates an empty search results state.
  factory AppEmptyState.search({
    Key? key,
    String title = 'No results found',
    String? description = 'Try adjusting your search criteria',
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return AppEmptyState(
      key: key,
      icon: Icons.search_off_outlined,
      title: title,
      description: description,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// Creates an empty favorites state.
  factory AppEmptyState.favorites({
    Key? key,
    String title = 'No favorites yet',
    String? description = 'Items you favorite will appear here',
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return AppEmptyState(
      key: key,
      icon: Icons.favorite_outline,
      title: title,
      description: description,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// Creates an empty cart state.
  factory AppEmptyState.cart({
    Key? key,
    String title = 'Your cart is empty',
    String? description = 'Add items to get started',
    String? actionLabel = 'Start Shopping',
    VoidCallback? onAction,
  }) {
    return AppEmptyState(
      key: key,
      icon: Icons.shopping_cart_outlined,
      title: title,
      description: description,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// Creates an empty notifications state.
  factory AppEmptyState.notifications({
    Key? key,
    String title = 'No notifications',
    String? description = 'You\'re all caught up!',
  }) {
    return AppEmptyState(
      key: key,
      icon: Icons.notifications_none_outlined,
      title: title,
      description: description,
    );
  }

  /// Creates an empty files state.
  factory AppEmptyState.files({
    Key? key,
    String title = 'No files',
    String? description = 'Upload files to get started',
    String? actionLabel = 'Upload',
    VoidCallback? onAction,
  }) {
    return AppEmptyState(
      key: key,
      icon: Icons.folder_outlined,
      title: title,
      description: description,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveIconSize = iconSize ?? (isCompact ? 48.sp : 64.sp);
    final effectiveIconColor = iconColor ??
        (isDark ? AppColors.contrastMediumDark : AppColors.contrastMediumLight);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(isCompact ? 16.w : 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            if (iconWidget != null)
              iconWidget!
            else if (icon != null)
              Container(
                width: effectiveIconSize + 24.w,
                height: effectiveIconSize + 24.w,
                decoration: BoxDecoration(
                  color:
                      isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: effectiveIconSize,
                  color: effectiveIconColor,
                ),
              ),
            if (icon != null || iconWidget != null)
              isCompact ? AppSpacing.verticalMd : AppSpacing.verticalLg,

            // Title
            Text(
              title,
              style: isCompact
                  ? AppTypography.titleMedium
                  : AppTypography.titleLarge,
              textAlign: TextAlign.center,
            ),

            // Description
            if (description != null) ...[
              AppSpacing.verticalXs,
              Text(
                description!,
                style: AppTypography.bodyMedium.copyWith(
                  color: isDark
                      ? AppColors.contrastMediumDark
                      : AppColors.contrastMediumLight,
                ),
                textAlign: TextAlign.center,
              ),
            ],

            // Actions
            if (actionLabel != null || secondaryActionLabel != null) ...[
              isCompact ? AppSpacing.verticalMd : AppSpacing.verticalLg,
              if (actionLabel != null)
                AppButton(
                  label: actionLabel!,
                  onPressed: onAction,
                  size: isCompact ? AppButtonSize.medium : AppButtonSize.large,
                ),
              if (secondaryActionLabel != null) ...[
                AppSpacing.verticalSm,
                AppButton.ghost(
                  label: secondaryActionLabel!,
                  onPressed: onSecondaryAction,
                  size: isCompact ? AppButtonSize.small : AppButtonSize.medium,
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

/// An error state placeholder.
///
/// Example:
/// ```dart
/// AppErrorState(
///   title: 'Something went wrong',
///   description: 'Please try again later',
///   onRetry: () {},
/// )
/// ```
class AppErrorState extends StatelessWidget {
  /// Icon to display.
  final IconData icon;

  /// Title text.
  final String title;

  /// Description text.
  final String? description;

  /// Retry button label.
  final String retryLabel;

  /// Retry callback.
  final VoidCallback? onRetry;

  /// Secondary action button label.
  final String? secondaryActionLabel;

  /// Secondary action callback.
  final VoidCallback? onSecondaryAction;

  /// Whether to use compact layout.
  final bool isCompact;

  /// Creates an [AppErrorState].
  const AppErrorState({
    super.key,
    this.icon = Icons.error_outline,
    required this.title,
    this.description,
    this.retryLabel = 'Try Again',
    this.onRetry,
    this.secondaryActionLabel,
    this.onSecondaryAction,
    this.isCompact = false,
  });

  /// Creates a network error state.
  factory AppErrorState.network({
    Key? key,
    String title = 'No Connection',
    String? description = 'Check your internet connection and try again',
    VoidCallback? onRetry,
  }) {
    return AppErrorState(
      key: key,
      icon: Icons.wifi_off_outlined,
      title: title,
      description: description,
      onRetry: onRetry,
    );
  }

  /// Creates a server error state.
  factory AppErrorState.server({
    Key? key,
    String title = 'Server Error',
    String? description = 'Something went wrong on our end. Please try again.',
    VoidCallback? onRetry,
  }) {
    return AppErrorState(
      key: key,
      icon: Icons.cloud_off_outlined,
      title: title,
      description: description,
      onRetry: onRetry,
    );
  }

  /// Creates a generic error state.
  factory AppErrorState.generic({
    Key? key,
    String title = 'Oops!',
    String? description = 'Something went wrong. Please try again.',
    VoidCallback? onRetry,
  }) {
    return AppErrorState(
      key: key,
      icon: Icons.error_outline,
      title: title,
      description: description,
      onRetry: onRetry,
    );
  }

  /// Creates a 404 not found state.
  factory AppErrorState.notFound({
    Key? key,
    String title = 'Not Found',
    String? description = 'The page you\'re looking for doesn\'t exist',
    String? secondaryActionLabel = 'Go Back',
    VoidCallback? onSecondaryAction,
  }) {
    return AppErrorState(
      key: key,
      icon: Icons.search_off_outlined,
      title: title,
      description: description,
      onRetry: null,
      secondaryActionLabel: secondaryActionLabel,
      onSecondaryAction: onSecondaryAction,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveIconSize = isCompact ? 48.sp : 64.sp;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(isCompact ? 16.w : 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: effectiveIconSize + 24.w,
              height: effectiveIconSize + 24.w,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: effectiveIconSize,
                color: AppColors.error,
              ),
            ),
            isCompact ? AppSpacing.verticalMd : AppSpacing.verticalLg,

            // Title
            Text(
              title,
              style: isCompact
                  ? AppTypography.titleMedium
                  : AppTypography.titleLarge,
              textAlign: TextAlign.center,
            ),

            // Description
            if (description != null) ...[
              AppSpacing.verticalXs,
              Text(
                description!,
                style: AppTypography.bodyMedium.copyWith(
                  color: isDark
                      ? AppColors.contrastMediumDark
                      : AppColors.contrastMediumLight,
                ),
                textAlign: TextAlign.center,
              ),
            ],

            // Actions
            if (onRetry != null || secondaryActionLabel != null) ...[
              isCompact ? AppSpacing.verticalMd : AppSpacing.verticalLg,
              if (onRetry != null)
                AppButton(
                  label: retryLabel,
                  onPressed: onRetry,
                  leftIcon: Icons.refresh,
                  size: isCompact ? AppButtonSize.medium : AppButtonSize.large,
                ),
              if (secondaryActionLabel != null) ...[
                AppSpacing.verticalSm,
                AppButton.ghost(
                  label: secondaryActionLabel!,
                  onPressed: onSecondaryAction,
                  size: isCompact ? AppButtonSize.small : AppButtonSize.medium,
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

/// A loading state placeholder.
///
/// Example:
/// ```dart
/// AppLoadingState(
///   message: 'Loading...',
/// )
/// ```
class AppLoadingState extends StatelessWidget {
  /// Loading message.
  final String? message;

  /// Whether to use compact layout.
  final bool isCompact;

  /// Custom indicator widget.
  final Widget? indicator;

  /// Creates an [AppLoadingState].
  const AppLoadingState({
    super.key,
    this.message,
    this.isCompact = false,
    this.indicator,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(isCompact ? 16.w : 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            indicator ??
                SizedBox(
                  width: isCompact ? 32.w : 48.w,
                  height: isCompact ? 32.w : 48.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 3.w,
                    valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                  ),
                ),
            if (message != null) ...[
              isCompact ? AppSpacing.verticalMd : AppSpacing.verticalLg,
              Text(
                message!,
                style: AppTypography.bodyMedium.copyWith(
                  color: isDark
                      ? AppColors.contrastMediumDark
                      : AppColors.contrastMediumLight,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A success state placeholder.
///
/// Example:
/// ```dart
/// AppSuccessState(
///   title: 'Order Placed!',
///   description: 'Your order has been successfully placed.',
///   actionLabel: 'View Order',
///   onAction: () {},
/// )
/// ```
class AppSuccessState extends StatelessWidget {
  /// Title text.
  final String title;

  /// Description text.
  final String? description;

  /// Action button label.
  final String? actionLabel;

  /// Action callback.
  final VoidCallback? onAction;

  /// Secondary action button label.
  final String? secondaryActionLabel;

  /// Secondary action callback.
  final VoidCallback? onSecondaryAction;

  /// Whether to use compact layout.
  final bool isCompact;

  /// Custom icon.
  final IconData icon;

  /// Creates an [AppSuccessState].
  const AppSuccessState({
    super.key,
    required this.title,
    this.description,
    this.actionLabel,
    this.onAction,
    this.secondaryActionLabel,
    this.onSecondaryAction,
    this.isCompact = false,
    this.icon = Icons.check_circle_outline,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveIconSize = isCompact ? 48.sp : 64.sp;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(isCompact ? 16.w : 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: effectiveIconSize + 24.w,
              height: effectiveIconSize + 24.w,
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: effectiveIconSize,
                color: AppColors.success,
              ),
            ),
            isCompact ? AppSpacing.verticalMd : AppSpacing.verticalLg,

            // Title
            Text(
              title,
              style: isCompact
                  ? AppTypography.titleMedium
                  : AppTypography.titleLarge,
              textAlign: TextAlign.center,
            ),

            // Description
            if (description != null) ...[
              AppSpacing.verticalXs,
              Text(
                description!,
                style: AppTypography.bodyMedium.copyWith(
                  color: isDark
                      ? AppColors.contrastMediumDark
                      : AppColors.contrastMediumLight,
                ),
                textAlign: TextAlign.center,
              ),
            ],

            // Actions
            if (actionLabel != null || secondaryActionLabel != null) ...[
              isCompact ? AppSpacing.verticalMd : AppSpacing.verticalLg,
              if (actionLabel != null)
                AppButton(
                  label: actionLabel!,
                  onPressed: onAction,
                  size: isCompact ? AppButtonSize.medium : AppButtonSize.large,
                ),
              if (secondaryActionLabel != null) ...[
                AppSpacing.verticalSm,
                AppButton.ghost(
                  label: secondaryActionLabel!,
                  onPressed: onSecondaryAction,
                  size: isCompact ? AppButtonSize.small : AppButtonSize.medium,
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
