import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';
import '../tokens/app_typography.dart';
import 'app_form_controls.dart';

/// A styled list tile following Porsche Design System.
///
/// Example:
/// ```dart
/// AppListTile(
///   leading: Icon(Icons.settings),
///   title: 'Settings',
///   subtitle: 'Configure app preferences',
///   trailing: Icon(Icons.chevron_right),
///   onTap: () {},
/// )
/// ```
class AppListTile extends StatelessWidget {
  /// Leading widget (icon, avatar, etc.).
  final Widget? leading;

  /// Title text or widget.
  final dynamic title;

  /// Subtitle text or widget.
  final dynamic subtitle;

  /// Trailing widget.
  final Widget? trailing;

  /// Callback when tapped.
  final VoidCallback? onTap;

  /// Callback when long-pressed.
  final VoidCallback? onLongPress;

  /// Whether the tile is enabled.
  final bool isEnabled;

  /// Whether the tile is selected.
  final bool isSelected;

  /// Whether the tile uses dense layout.
  final bool isDense;

  /// Content padding.
  final EdgeInsetsGeometry? contentPadding;

  /// Background color.
  final Color? backgroundColor;

  /// Tile shape.
  final ShapeBorder? shape;

  /// Horizontal title gap.
  final double? horizontalTitleGap;

  /// Minimum leading width.
  final double? minLeadingWidth;

  /// Whether to use three-line layout.
  final bool isThreeLine;

  /// Creates an [AppListTile].
  const AppListTile({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.isEnabled = true,
    this.isSelected = false,
    this.isDense = false,
    this.contentPadding,
    this.backgroundColor,
    this.shape,
    this.horizontalTitleGap,
    this.minLeadingWidth,
    this.isThreeLine = false,
  });

  /// Creates a navigation list tile with chevron trailing.
  factory AppListTile.navigation({
    Key? key,
    Widget? leading,
    required dynamic title,
    dynamic subtitle,
    VoidCallback? onTap,
    bool isEnabled = true,
    EdgeInsetsGeometry? contentPadding,
    Color? backgroundColor,
  }) {
    return AppListTile(
      key: key,
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: Icon(
        Icons.chevron_right,
        size: 24.sp,
        color: AppColors.contrastMediumLight,
      ),
      onTap: onTap,
      isEnabled: isEnabled,
      contentPadding: contentPadding,
      backgroundColor: backgroundColor,
    );
  }

  /// Creates a destructive list tile (red colored).
  factory AppListTile.destructive({
    Key? key,
    Widget? leading,
    required dynamic title,
    dynamic subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    EdgeInsetsGeometry? contentPadding,
  }) {
    return AppListTile(
      key: key,
      leading: leading != null
          ? IconTheme(
              data: const IconThemeData(color: AppColors.error),
              child: leading,
            )
          : null,
      title: title is String
          ? Text(
              title,
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.error,
              ),
            )
          : title,
      subtitle: subtitle,
      trailing: trailing,
      onTap: onTap,
      contentPadding: contentPadding,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveBackgroundColor = backgroundColor ??
        (isSelected
            ? (isDark
                ? AppColors.primary.withValues(alpha: 0.15)
                : AppColors.primary.withValues(alpha: 0.08))
            : Colors.transparent);

    Widget? titleWidget;
    if (title is String) {
      titleWidget = Text(
        title as String,
        style: AppTypography.bodyLarge.copyWith(
          color: isEnabled
              ? null
              : (isDark
                  ? AppColors.contrastMediumDark
                  : AppColors.contrastMediumLight),
        ),
      );
    } else if (title is Widget) {
      titleWidget = title as Widget;
    }

    Widget? subtitleWidget;
    if (subtitle is String) {
      subtitleWidget = Text(
        subtitle as String,
        style: AppTypography.bodySmall.copyWith(
          color: isDark
              ? AppColors.contrastMediumDark
              : AppColors.contrastMediumLight,
        ),
      );
    } else if (subtitle is Widget) {
      subtitleWidget = subtitle as Widget;
    }

    return ListTile(
      leading: leading,
      title: titleWidget,
      subtitle: subtitleWidget,
      trailing: trailing,
      onTap: isEnabled ? onTap : null,
      onLongPress: isEnabled ? onLongPress : null,
      enabled: isEnabled,
      selected: isSelected,
      dense: isDense,
      contentPadding: contentPadding ?? EdgeInsets.symmetric(horizontal: 16.w),
      tileColor: effectiveBackgroundColor,
      selectedTileColor: isDark
          ? AppColors.primary.withValues(alpha: 0.15)
          : AppColors.primary.withValues(alpha: 0.08),
      shape: shape ??
          RoundedRectangleBorder(
            borderRadius: AppRadius.card,
          ),
      horizontalTitleGap: horizontalTitleGap ?? 12.w,
      minLeadingWidth: minLeadingWidth ?? 40.w,
      isThreeLine: isThreeLine,
    );
  }
}

/// A list tile with a leading icon and consistent styling.
///
/// Example:
/// ```dart
/// AppIconListTile(
///   icon: Icons.settings,
///   title: 'Settings',
///   onTap: () {},
/// )
/// ```
class AppIconListTile extends StatelessWidget {
  /// Icon to display.
  final IconData icon;

  /// Title text.
  final String title;

  /// Subtitle text.
  final String? subtitle;

  /// Callback when tapped.
  final VoidCallback? onTap;

  /// Icon color.
  final Color? iconColor;

  /// Icon background color.
  final Color? iconBackgroundColor;

  /// Whether to show chevron trailing.
  final bool showChevron;

  /// Whether the tile is enabled.
  final bool isEnabled;

  /// Custom trailing widget.
  final Widget? trailing;

  /// Whether this is a destructive action.
  final bool isDestructive;

  /// Creates an [AppIconListTile].
  const AppIconListTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.iconColor,
    this.iconBackgroundColor,
    this.showChevron = true,
    this.isEnabled = true,
    this.trailing,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveIconColor = isDestructive
        ? AppColors.error
        : (iconColor ??
            (isDark
                ? AppColors.contrastHighDark
                : AppColors.contrastHighLight));
    final effectiveIconBgColor = iconBackgroundColor ??
        (isDark ? AppColors.surfaceDark : AppColors.surfaceLight);

    return AppListTile(
      leading: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: effectiveIconBgColor,
          borderRadius: AppRadius.button,
        ),
        child: Icon(
          icon,
          size: 20.sp,
          color: effectiveIconColor,
        ),
      ),
      title: Text(
        title,
        style: AppTypography.bodyLarge.copyWith(
          color: isDestructive
              ? AppColors.error
              : (isEnabled
                  ? null
                  : (isDark
                      ? AppColors.contrastMediumDark
                      : AppColors.contrastMediumLight)),
        ),
      ),
      subtitle: subtitle,
      trailing: trailing ??
          (showChevron
              ? Icon(
                  Icons.chevron_right,
                  size: 24.sp,
                  color: isDark
                      ? AppColors.contrastMediumDark
                      : AppColors.contrastMediumLight,
                )
              : null),
      onTap: onTap,
      isEnabled: isEnabled,
    );
  }
}

/// A list tile with switch for settings.
///
/// Example:
/// ```dart
/// AppSwitchListTile(
///   icon: Icons.dark_mode,
///   title: 'Dark Mode',
///   value: isDarkMode,
///   onChanged: (value) => toggleDarkMode(),
/// )
/// ```
class AppSwitchListTile extends StatelessWidget {
  /// Leading icon.
  final IconData? icon;

  /// Title text.
  final String title;

  /// Subtitle text.
  final String? subtitle;

  /// Switch value.
  final bool value;

  /// Callback when changed.
  final ValueChanged<bool>? onChanged;

  /// Whether the tile is enabled.
  final bool isEnabled;

  /// Content padding.
  final EdgeInsetsGeometry? contentPadding;

  /// Creates an [AppSwitchListTile].
  const AppSwitchListTile({
    super.key,
    this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    this.onChanged,
    this.isEnabled = true,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppListTile(
      leading: icon != null
          ? Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                borderRadius: AppRadius.button,
              ),
              child: Icon(
                icon,
                size: 20.sp,
                color: isDark
                    ? AppColors.contrastHighDark
                    : AppColors.contrastHighLight,
              ),
            )
          : null,
      title: Text(
        title,
        style: AppTypography.bodyLarge.copyWith(
          color: isEnabled
              ? null
              : (isDark
                  ? AppColors.contrastMediumDark
                  : AppColors.contrastMediumLight),
        ),
      ),
      subtitle: subtitle,
      trailing: AppSwitch(
        value: value,
        onChanged: isEnabled ? onChanged : null,
        isDisabled: !isEnabled,
      ),
      onTap: isEnabled ? () => onChanged?.call(!value) : null,
      isEnabled: isEnabled,
      contentPadding: contentPadding,
    );
  }
}

/// A section header for list grouping.
///
/// Example:
/// ```dart
/// AppListSection(
///   title: 'Account Settings',
///   children: [
///     AppIconListTile(...),
///     AppIconListTile(...),
///   ],
/// )
/// ```
class AppListSection extends StatelessWidget {
  /// Section title.
  final String? title;

  /// List of tiles.
  final List<Widget> children;

  /// Whether to show dividers between items.
  final bool showDividers;

  /// Padding around the section.
  final EdgeInsetsGeometry? padding;

  /// Background color.
  final Color? backgroundColor;

  /// Creates an [AppListSection].
  const AppListSection({
    super.key,
    this.title,
    required this.children,
    this.showDividers = true,
    this.padding,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: padding ?? EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 8.h,
              ),
              child: Text(
                title!.toUpperCase(),
                style: AppTypography.labelSmall.copyWith(
                  color: isDark
                      ? AppColors.contrastMediumDark
                      : AppColors.contrastMediumLight,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
          Container(
            decoration: BoxDecoration(
              color: backgroundColor ??
                  (isDark ? AppColors.surfaceDark : AppColors.backgroundLight),
              borderRadius: AppRadius.card,
            ),
            child: Column(
              children: showDividers
                  ? List.generate(
                      children.length * 2 - 1,
                      (index) {
                        if (index.isOdd) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Divider(
                              height: 1,
                              color: isDark
                                  ? AppColors.contrastLowDark
                                  : AppColors.contrastLowLight,
                            ),
                          );
                        }
                        return children[index ~/ 2];
                      },
                    )
                  : children,
            ),
          ),
        ],
      ),
    );
  }
}

/// A reorderable list tile.
///
/// Example:
/// ```dart
/// AppReorderableListTile(
///   key: ValueKey(item.id),
///   title: item.name,
///   leading: Icon(Icons.drag_handle),
/// )
/// ```
class AppReorderableListTile extends StatelessWidget {
  /// Title text or widget.
  final dynamic title;

  /// Subtitle text or widget.
  final dynamic subtitle;

  /// Leading widget.
  final Widget? leading;

  /// Trailing widget.
  final Widget? trailing;

  /// Whether to show drag handle.
  final bool showDragHandle;

  /// Content padding.
  final EdgeInsetsGeometry? contentPadding;

  /// Creates an [AppReorderableListTile].
  const AppReorderableListTile({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.showDragHandle = true,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: AppRadius.card,
      ),
      child: AppListTile(
        leading: leading,
        title: title,
        subtitle: subtitle,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (trailing != null) ...[
              trailing!,
              AppSpacing.horizontalSm,
            ],
            if (showDragHandle)
              ReorderableDragStartListener(
                index: 0,
                child: Icon(
                  Icons.drag_handle,
                  size: 24.sp,
                  color: isDark
                      ? AppColors.contrastMediumDark
                      : AppColors.contrastMediumLight,
                ),
              ),
          ],
        ),
        contentPadding: contentPadding,
      ),
    );
  }
}
