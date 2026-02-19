import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_shadows.dart';
import '../tokens/app_spacing.dart';
import '../tokens/app_typography.dart';

/// FAB sizes.
enum AppFabSize {
  /// Small - 40dp
  small,

  /// Medium - 56dp (default)
  medium,

  /// Large - 72dp
  large,
}

/// FAB variants.
enum AppFabVariant {
  /// Primary color (default)
  primary,

  /// Secondary/surface color
  secondary,

  /// Tertiary color
  tertiary,

  /// Surface color (light)
  surface,
}

/// A styled Floating Action Button following Porsche Design System.
///
/// Example:
/// ```dart
/// AppFab(
///   icon: Icons.add,
///   onPressed: () {},
/// )
/// ```
class AppFab extends StatelessWidget {
  /// Icon to display.
  final IconData icon;

  /// Callback when pressed.
  final VoidCallback? onPressed;

  /// FAB size.
  final AppFabSize size;

  /// FAB variant.
  final AppFabVariant variant;

  /// Tooltip text.
  final String? tooltip;

  /// Hero tag for animations.
  final Object? heroTag;

  /// Custom background color.
  final Color? backgroundColor;

  /// Custom icon color.
  final Color? iconColor;

  /// Custom elevation.
  final double? elevation;

  /// Creates an [AppFab].
  const AppFab({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = AppFabSize.medium,
    this.variant = AppFabVariant.primary,
    this.tooltip,
    this.heroTag,
    this.backgroundColor,
    this.iconColor,
    this.elevation,
  });

  /// Creates a small FAB.
  const AppFab.small({
    super.key,
    required this.icon,
    this.onPressed,
    this.variant = AppFabVariant.primary,
    this.tooltip,
    this.heroTag,
    this.backgroundColor,
    this.iconColor,
    this.elevation,
  }) : size = AppFabSize.small;

  /// Creates a large FAB.
  const AppFab.large({
    super.key,
    required this.icon,
    this.onPressed,
    this.variant = AppFabVariant.primary,
    this.tooltip,
    this.heroTag,
    this.backgroundColor,
    this.iconColor,
    this.elevation,
  }) : size = AppFabSize.large;

  double _getSize() {
    switch (size) {
      case AppFabSize.small:
        return 40.w;
      case AppFabSize.medium:
        return 56.w;
      case AppFabSize.large:
        return 72.w;
    }
  }

  double _getIconSize() {
    switch (size) {
      case AppFabSize.small:
        return 20.sp;
      case AppFabSize.medium:
        return 24.sp;
      case AppFabSize.large:
        return 32.sp;
    }
  }

  Color _getBackgroundColor(BuildContext context) {
    if (backgroundColor != null) return backgroundColor!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (variant) {
      case AppFabVariant.primary:
        return AppColors.primary;
      case AppFabVariant.secondary:
        return isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
      case AppFabVariant.tertiary:
        return AppColors.primaryLight;
      case AppFabVariant.surface:
        return isDark
            ? AppColors.backgroundDark
            : AppColors.backgroundLight;
    }
  }

  Color _getIconColor(BuildContext context) {
    if (iconColor != null) return iconColor!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (variant) {
      case AppFabVariant.primary:
        return AppColors.white;
      case AppFabVariant.secondary:
        return isDark ? AppColors.white : AppColors.primary;
      case AppFabVariant.tertiary:
        return AppColors.primary;
      case AppFabVariant.surface:
        return isDark ? AppColors.white : AppColors.textPrimaryLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    final fabSize = _getSize();
    final fabIconSize = _getIconSize();
    final bgColor = _getBackgroundColor(context);
    final icColor = _getIconColor(context);

    return SizedBox(
      width: fabSize,
      height: fabSize,
      child: FloatingActionButton(
        onPressed: onPressed,
        heroTag: heroTag,
        tooltip: tooltip,
        elevation: elevation ?? 4,
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.card,
        ),
        child: Icon(
          icon,
          size: fabIconSize,
          color: icColor,
        ),
      ),
    );
  }
}

/// An extended Floating Action Button with label.
///
/// Example:
/// ```dart
/// AppFabExtended(
///   icon: Icons.add,
///   label: 'New Task',
///   onPressed: () {},
/// )
/// ```
class AppFabExtended extends StatelessWidget {
  /// Icon to display.
  final IconData? icon;

  /// Label text.
  final String label;

  /// Callback when pressed.
  final VoidCallback? onPressed;

  /// FAB variant.
  final AppFabVariant variant;

  /// Tooltip text.
  final String? tooltip;

  /// Hero tag for animations.
  final Object? heroTag;

  /// Custom background color.
  final Color? backgroundColor;

  /// Custom foreground color.
  final Color? foregroundColor;

  /// Custom elevation.
  final double? elevation;

  /// Whether icon is on the trailing side.
  final bool iconTrailing;

  /// Creates an [AppFabExtended].
  const AppFabExtended({
    super.key,
    this.icon,
    required this.label,
    this.onPressed,
    this.variant = AppFabVariant.primary,
    this.tooltip,
    this.heroTag,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.iconTrailing = false,
  });

  Color _getBackgroundColor(BuildContext context) {
    if (backgroundColor != null) return backgroundColor!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (variant) {
      case AppFabVariant.primary:
        return AppColors.primary;
      case AppFabVariant.secondary:
        return isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
      case AppFabVariant.tertiary:
        return AppColors.primaryLight;
      case AppFabVariant.surface:
        return isDark
            ? AppColors.backgroundDark
            : AppColors.backgroundLight;
    }
  }

  Color _getForegroundColor(BuildContext context) {
    if (foregroundColor != null) return foregroundColor!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (variant) {
      case AppFabVariant.primary:
        return AppColors.white;
      case AppFabVariant.secondary:
        return isDark ? AppColors.white : AppColors.primary;
      case AppFabVariant.tertiary:
        return AppColors.primary;
      case AppFabVariant.surface:
        return isDark ? AppColors.white : AppColors.textPrimaryLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _getBackgroundColor(context);
    final fgColor = _getForegroundColor(context);

    final iconWidget = icon != null
        ? Icon(icon, size: 20.sp, color: fgColor)
        : null;

    final labelWidget = Text(
      label,
      style: AppTypography.labelLarge.copyWith(
        color: fgColor,
        fontWeight: FontWeight.w600,
      ),
    );

    return FloatingActionButton.extended(
      onPressed: onPressed,
      heroTag: heroTag,
      tooltip: tooltip,
      elevation: elevation ?? 4,
      backgroundColor: bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.button,
      ),
      icon: iconTrailing ? null : iconWidget,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (iconTrailing && iconWidget == null) labelWidget,
          if (iconTrailing && iconWidget != null) ...[
            labelWidget,
            AppSpacing.horizontalXs,
            iconWidget,
          ],
          if (!iconTrailing && iconWidget != null) labelWidget,
          if (!iconTrailing && iconWidget == null) labelWidget,
        ],
      ),
    );
  }
}

/// A group of FABs that expand on tap.
///
/// Example:
/// ```dart
/// AppFabMenu(
///   icon: Icons.add,
///   items: [
///     AppFabMenuItem(
///       icon: Icons.camera,
///       label: 'Camera',
///       onPressed: () {},
///     ),
///     AppFabMenuItem(
///       icon: Icons.photo,
///       label: 'Gallery',
///       onPressed: () {},
///     ),
///   ],
/// )
/// ```
class AppFabMenu extends StatefulWidget {
  /// Main icon.
  final IconData icon;

  /// Icon when menu is open.
  final IconData? openIcon;

  /// Menu items.
  final List<AppFabMenuItem> items;

  /// FAB variant.
  final AppFabVariant variant;

  /// FAB size.
  final AppFabSize size;

  /// Spacing between items.
  final double? spacing;

  /// Creates an [AppFabMenu].
  const AppFabMenu({
    super.key,
    required this.icon,
    this.openIcon,
    required this.items,
    this.variant = AppFabVariant.primary,
    this.size = AppFabSize.medium,
    this.spacing,
  });

  @override
  State<AppFabMenu> createState() => _AppFabMenuState();
}

class _AppFabMenuState extends State<AppFabMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final spacing = widget.spacing ?? 12.h;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Menu items
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Opacity(
              opacity: _animation.value,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - _animation.value)),
                child: child,
              ),
            );
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: widget.items.map((item) {
              return Padding(
                padding: EdgeInsets.only(bottom: spacing),
                child: _FabMenuItemWidget(item: item),
              );
            }).toList(),
          ),
        ),
        // Main FAB
        AppFab(
          icon: _isOpen ? (widget.openIcon ?? Icons.close) : widget.icon,
          onPressed: _toggle,
          size: widget.size,
          variant: widget.variant,
          heroTag: 'fab_menu_main',
        ),
      ],
    );
  }
}

/// A FAB menu item.
class AppFabMenuItem {
  /// Icon.
  final IconData icon;

  /// Label text.
  final String? label;

  /// Callback when pressed.
  final VoidCallback? onPressed;

  /// Background color.
  final Color? backgroundColor;

  /// Icon color.
  final Color? iconColor;

  /// Creates an [AppFabMenuItem].
  const AppFabMenuItem({
    required this.icon,
    this.label,
    this.onPressed,
    this.backgroundColor,
    this.iconColor,
  });
}

class _FabMenuItemWidget extends StatelessWidget {
  final AppFabMenuItem item;

  const _FabMenuItemWidget({required this.item});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = item.backgroundColor ??
        (isDark ? AppColors.surfaceDark : AppColors.surfaceLight);
    final icColor = item.iconColor ?? AppColors.primary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (item.label != null) ...[
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 6.h,
            ),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: AppRadius.button,
              boxShadow: AppShadows.sm,
            ),
            child: Text(
              item.label!,
              style: AppTypography.labelMedium.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          AppSpacing.horizontalSm,
        ],
        SizedBox(
          width: 40.w,
          height: 40.w,
          child: FloatingActionButton(
            onPressed: item.onPressed,
            heroTag: 'fab_menu_${item.label ?? item.hashCode}',
            elevation: 2,
            backgroundColor: bgColor,
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.card,
            ),
            child: Icon(
              item.icon,
              size: 20.sp,
              color: icColor,
            ),
          ),
        ),
      ],
    );
  }
}
