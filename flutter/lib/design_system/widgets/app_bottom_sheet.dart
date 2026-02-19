import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_typography.dart';

/// Bottom sheet variants.
enum AppBottomSheetVariant {
  /// Standard modal sheet.
  modal,

  /// Action sheet with list of actions.
  action,

  /// Draggable/expandable sheet.
  draggable,
}

/// A customizable bottom sheet component following Porsche Design System.
///
/// Example:
/// ```dart
/// AppBottomSheet.show(
///   context: context,
///   title: 'Select Option',
///   child: MyCustomContent(),
/// );
///
/// // Or with actions
/// AppBottomSheet.showActions(
///   context: context,
///   title: 'Choose Action',
///   actions: [
///     AppSheetAction(label: 'Share', icon: Icons.share, onTap: () {}),
///     AppSheetAction(label: 'Delete', icon: Icons.delete, isDestructive: true),
///   ],
/// );
/// ```
class AppBottomSheet extends StatelessWidget {
  /// Sheet title.
  final String? title;

  /// Sheet subtitle.
  final String? subtitle;

  /// Sheet content.
  final Widget child;

  /// Whether to show the drag handle.
  final bool showDragHandle;

  /// Whether to show close button.
  final bool showCloseButton;

  /// Whether the sheet is dismissible.
  final bool isDismissible;

  /// Whether to enable drag to dismiss.
  final bool enableDrag;

  /// Padding for the content.
  final EdgeInsets? contentPadding;

  /// Creates an [AppBottomSheet].
  const AppBottomSheet({
    super.key,
    this.title,
    this.subtitle,
    required this.child,
    this.showDragHandle = true,
    this.showCloseButton = false,
    this.isDismissible = true,
    this.enableDrag = true,
    this.contentPadding,
  });

  /// Shows a modal bottom sheet.
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    String? subtitle,
    bool showDragHandle = true,
    bool showCloseButton = false,
    bool isDismissible = true,
    bool enableDrag = true,
    bool isScrollControlled = true,
    double? maxHeight,
    EdgeInsets? contentPadding,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent,
      constraints:
          maxHeight != null ? BoxConstraints(maxHeight: maxHeight) : null,
      builder: (context) => AppBottomSheet(
        title: title,
        subtitle: subtitle,
        showDragHandle: showDragHandle,
        showCloseButton: showCloseButton,
        isDismissible: isDismissible,
        enableDrag: enableDrag,
        contentPadding: contentPadding,
        child: child,
      ),
    );
  }

  /// Shows an action sheet.
  static Future<T?> showActions<T>({
    required BuildContext context,
    required List<AppSheetAction> actions,
    String? title,
    String? subtitle,
    bool showCancel = true,
    String cancelLabel = 'Cancel',
  }) {
    return show<T>(
      context: context,
      title: title,
      subtitle: subtitle,
      contentPadding: EdgeInsets.zero,
      child: _ActionsContent(
        actions: actions,
        showCancel: showCancel,
        cancelLabel: cancelLabel,
      ),
    );
  }

  /// Shows a draggable bottom sheet.
  static void showDraggable({
    required BuildContext context,
    required Widget Function(BuildContext, ScrollController) builder,
    double initialChildSize = 0.5,
    double minChildSize = 0.25,
    double maxChildSize = 0.9,
    bool expand = true,
    bool snap = true,
    List<double>? snapSizes,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: initialChildSize,
        minChildSize: minChildSize,
        maxChildSize: maxChildSize,
        expand: expand,
        snap: snap,
        snapSizes: snapSizes,
        builder: (context, scrollController) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppRadius.lg.topLeft.x),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _DragHandle(),
                Expanded(child: builder(context, scrollController)),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.lg.topLeft.x),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag handle
            if (showDragHandle) _DragHandle(),

            // Header
            if (title != null || showCloseButton)
              _Header(
                title: title,
                subtitle: subtitle,
                showCloseButton: showCloseButton,
                isDark: isDark,
              ),

            // Content
            Flexible(
              child: Padding(
                padding:
                    contentPadding ?? EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Drag handle indicator.
class _DragHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 12.h),
        width: 40.w,
        height: 4.h,
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.contrastMediumDark
              : AppColors.contrastMediumLight,
          borderRadius: BorderRadius.circular(2.r),
        ),
      ),
    );
  }
}

/// Header with title and close button.
class _Header extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final bool showCloseButton;
  final bool isDark;

  const _Header({
    this.title,
    this.subtitle,
    required this.showCloseButton,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 16.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null)
                  Text(
                    title!,
                    style: AppTypography.titleLarge.copyWith(
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                    ),
                  ),
                if (subtitle != null) ...[
                  SizedBox(height: 4.h),
                  Text(
                    subtitle!,
                    style: AppTypography.bodySmall.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (showCloseButton)
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(
                Icons.close_rounded,
                color: isDark
                    ? AppColors.contrastHighDark
                    : AppColors.contrastHighLight,
              ),
            ),
        ],
      ),
    );
  }
}

/// Action content for action sheets.
class _ActionsContent extends StatelessWidget {
  final List<AppSheetAction> actions;
  final bool showCancel;
  final String cancelLabel;

  const _ActionsContent({
    required this.actions,
    required this.showCancel,
    required this.cancelLabel,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...actions.map((action) => _ActionTile(action: action, isDark: isDark)),
        if (showCancel) ...[
          Divider(
            height: 1,
            thickness: 8.h,
            color:
                isDark ? AppColors.borderDark : AppColors.surfaceSecondaryLight,
          ),
          _ActionTile(
            action: AppSheetAction(
              label: cancelLabel,
              icon: Icons.close_rounded,
              onTap: () => Navigator.of(context).pop(),
            ),
            isDark: isDark,
          ),
        ],
      ],
    );
  }
}

/// Single action tile.
class _ActionTile extends StatelessWidget {
  final AppSheetAction action;
  final bool isDark;

  const _ActionTile({required this.action, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final color = action.isDestructive
        ? AppColors.error
        : isDark
            ? AppColors.textPrimaryDark
            : AppColors.textPrimaryLight;

    return InkWell(
      onTap: () {
        Navigator.of(context).pop(action.value);
        action.onTap?.call();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Row(
          children: [
            if (action.icon != null) ...[
              Icon(action.icon, color: color, size: 24.sp),
              SizedBox(width: 16.w),
            ],
            Expanded(
              child: Text(
                action.label,
                style: AppTypography.bodyLarge.copyWith(
                  color: color,
                  fontWeight:
                      action.isDestructive ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
            if (action.trailing != null) action.trailing!,
          ],
        ),
      ),
    );
  }
}

/// Action configuration for action sheets.
class AppSheetAction<T> {
  /// Action label.
  final String label;

  /// Optional leading icon.
  final IconData? icon;

  /// Optional trailing widget.
  final Widget? trailing;

  /// Callback when action is tapped.
  final VoidCallback? onTap;

  /// Whether this is a destructive action.
  final bool isDestructive;

  /// Optional value returned when action is selected.
  final T? value;

  /// Creates an [AppSheetAction].
  const AppSheetAction({
    required this.label,
    this.icon,
    this.trailing,
    this.onTap,
    this.isDestructive = false,
    this.value,
  });
}
