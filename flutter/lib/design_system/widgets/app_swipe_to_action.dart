import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';

/// A pre-styled [Dismissible] wrapper for swipe-to-action patterns.
///
/// Provides a consistent swipe background with icon and color,
/// commonly used for archive, delete, or other destructive actions.
///
/// ```dart
/// AppSwipeToAction(
///   itemKey: ValueKey(item.id),
///   onAction: () => viewModel.archiveItem(item.id),
///   child: MyItemTile(...),
/// )
/// ```
class AppSwipeToAction extends StatelessWidget {
  /// Unique key for the dismissible item.
  final Key itemKey;

  /// The child widget to wrap.
  final Widget child;

  /// Called when the user swipes. Return `true` to remove the item,
  /// `false` to keep it (e.g., let a refresh handle removal).
  final Future<bool> Function()? onAction;

  /// The icon to display in the swipe background.
  /// Defaults to [Icons.archive_outlined].
  final IconData icon;

  /// The background color for the swipe area.
  /// Defaults to [AppColors.warning] at 15% opacity.
  final Color? backgroundColor;

  /// The icon color. Defaults to [AppColors.warning].
  final Color? iconColor;

  /// Swipe direction. Defaults to [DismissDirection.endToStart].
  final DismissDirection direction;

  const AppSwipeToAction({
    super.key,
    required this.itemKey,
    required this.child,
    this.onAction,
    this.icon = Icons.archive_outlined,
    this.backgroundColor,
    this.iconColor,
    this.direction = DismissDirection.endToStart,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor =
        backgroundColor ?? AppColors.warning.withValues(alpha: 0.15);
    final fgColor = iconColor ?? AppColors.warning;

    return Dismissible(
      key: itemKey,
      direction: direction,
      background: Container(
        alignment: direction == DismissDirection.endToStart
            ? Alignment.centerRight
            : Alignment.centerLeft,
        padding: EdgeInsets.only(
          right: direction == DismissDirection.endToStart ? AppSpacing.lg : 0,
          left: direction == DismissDirection.startToEnd ? AppSpacing.lg : 0,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: AppRadius.md,
        ),
        child: Icon(icon, color: fgColor),
      ),
      confirmDismiss: (_) async => await onAction?.call() ?? false,
      child: child,
    );
  }
}
