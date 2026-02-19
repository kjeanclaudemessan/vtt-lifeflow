import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_typography.dart';

/// A styled app bar component following Porsche Design System.
///
/// Example:
/// ```dart
/// Scaffold(
///   appBar: AppAppBar(
///     title: 'Settings',
///     leading: AppBackButton(),
///     actions: [
///       IconButton(icon: Icon(Icons.settings), onPressed: () {}),
///     ],
///   ),
/// );
/// ```
class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// App bar title text.
  final String? title;

  /// Custom title widget (overrides title).
  final Widget? titleWidget;

  /// Leading widget.
  final Widget? leading;

  /// Whether to show back button automatically.
  final bool automaticallyImplyLeading;

  /// Action widgets.
  final List<Widget>? actions;

  /// Background color.
  final Color? backgroundColor;

  /// Whether the title should be centered.
  final bool centerTitle;

  /// Elevation/shadow.
  final double elevation;

  /// Bottom widget (e.g., tabs).
  final PreferredSizeWidget? bottom;

  /// Creates an [AppAppBar].
  const AppAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.actions,
    this.backgroundColor,
    this.centerTitle = true,
    this.elevation = 0,
    this.bottom,
  });

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0),
      );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      title: titleWidget ??
          (title != null
              ? Text(
                  title!,
                  style: AppTypography.titleMedium.copyWith(
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : null),
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      actions: actions,
      backgroundColor: backgroundColor ??
          (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
      centerTitle: centerTitle,
      elevation: elevation,
      scrolledUnderElevation: elevation,
      bottom: bottom,
      iconTheme: IconThemeData(
        color:
            isDark ? AppColors.contrastHighDark : AppColors.contrastHighLight,
      ),
    );
  }
}

/// A styled back button.
///
/// Example:
/// ```dart
/// AppBackButton(
///   onPressed: () => Navigator.pop(context),
/// );
/// ```
class AppBackButton extends StatelessWidget {
  /// Callback when pressed. If null, pops the current route.
  final VoidCallback? onPressed;

  /// Custom icon.
  final IconData? icon;

  /// Creates an [AppBackButton].
  const AppBackButton({
    super.key,
    this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return IconButton(
      onPressed: onPressed ?? () => Navigator.of(context).maybePop(),
      icon: Icon(
        icon ?? Icons.arrow_back_ios_rounded,
        color:
            isDark ? AppColors.contrastHighDark : AppColors.contrastHighLight,
      ),
    );
  }
}

/// A large app bar with expanded content.
///
/// Example:
/// ```dart
/// CustomScrollView(
///   slivers: [
///     AppSliverAppBar(
///       title: 'Profile',
///       expandedContent: ProfileHeader(),
///       expandedHeight: 200,
///     ),
///     // Other slivers...
///   ],
/// );
/// ```
class AppSliverAppBar extends StatelessWidget {
  /// App bar title.
  final String title;

  /// Expanded content.
  final Widget? expandedContent;

  /// Expanded height.
  final double expandedHeight;

  /// Leading widget.
  final Widget? leading;

  /// Action widgets.
  final List<Widget>? actions;

  /// Whether the title should be centered.
  final bool centerTitle;

  /// Whether to pin the app bar.
  final bool pinned;

  /// Whether the app bar should float.
  final bool floating;

  /// Background color.
  final Color? backgroundColor;

  /// Creates an [AppSliverAppBar].
  const AppSliverAppBar({
    super.key,
    required this.title,
    this.expandedContent,
    this.expandedHeight = 200,
    this.leading,
    this.actions,
    this.centerTitle = true,
    this.pinned = true,
    this.floating = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SliverAppBar(
      expandedHeight: expandedHeight.h,
      leading: leading,
      actions: actions,
      centerTitle: centerTitle,
      pinned: pinned,
      floating: floating,
      backgroundColor: backgroundColor ??
          (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
      iconTheme: IconThemeData(
        color:
            isDark ? AppColors.contrastHighDark : AppColors.contrastHighLight,
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          title,
          style: AppTypography.titleMedium.copyWith(
            color:
                isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: centerTitle,
        background: expandedContent,
        collapseMode: CollapseMode.parallax,
      ),
    );
  }
}

/// A styled navigation drawer.
///
/// Example:
/// ```dart
/// Scaffold(
///   drawer: AppDrawer(
///     header: AppDrawerHeader(
///       title: 'John Doe',
///       subtitle: 'john@example.com',
///       avatar: 'https://...',
///     ),
///     items: [
///       AppDrawerItem(label: 'Home', icon: Icons.home, isSelected: true),
///       AppDrawerItem(label: 'Settings', icon: Icons.settings),
///     ],
///   ),
/// );
/// ```
class AppDrawer extends StatelessWidget {
  /// Drawer header.
  final Widget? header;

  /// Drawer items.
  final List<Widget> items;

  /// Footer widget.
  final Widget? footer;

  /// Background color.
  final Color? backgroundColor;

  /// Drawer width.
  final double? width;

  /// Creates an [AppDrawer].
  const AppDrawer({
    super.key,
    this.header,
    required this.items,
    this.footer,
    this.backgroundColor,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      width: width ?? 280.w,
      backgroundColor: backgroundColor ??
          (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
      shape: const RoundedRectangleBorder(),
      child: SafeArea(
        child: Column(
          children: [
            if (header != null) header!,
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                children: items,
              ),
            ),
            if (footer != null) footer!,
          ],
        ),
      ),
    );
  }
}

/// Drawer header with avatar and info.
class AppDrawerHeader extends StatelessWidget {
  /// User name/title.
  final String title;

  /// Subtitle (email, role, etc.).
  final String? subtitle;

  /// Avatar URL or asset path.
  final String? avatar;

  /// Custom avatar widget.
  final Widget? avatarWidget;

  /// Background decoration.
  final BoxDecoration? decoration;

  /// Callback when header is tapped.
  final VoidCallback? onTap;

  /// Creates an [AppDrawerHeader].
  const AppDrawerHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.avatar,
    this.avatarWidget,
    this.decoration,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(24.w),
        decoration: decoration ??
            BoxDecoration(
              color: isDark
                  ? AppColors.surfaceSecondaryDark
                  : AppColors.surfaceSecondaryLight,
              border: Border(
                bottom: BorderSide(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
            ),
        child: Row(
          children: [
            // Avatar
            avatarWidget ??
                CircleAvatar(
                  radius: 28.r,
                  backgroundColor: AppColors.primary,
                  backgroundImage:
                      avatar != null ? NetworkImage(avatar!) : null,
                  child: avatar == null
                      ? Text(
                          title.isNotEmpty ? title[0].toUpperCase() : '?',
                          style: AppTypography.headlineSmall.copyWith(
                            color: AppColors.textOnPrimary,
                          ),
                        )
                      : null,
                ),
            SizedBox(width: 16.w),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.titleMedium.copyWith(
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Drawer navigation item.
class AppDrawerItem extends StatelessWidget {
  /// Item label.
  final String label;

  /// Leading icon.
  final IconData icon;

  /// Whether this item is selected.
  final bool isSelected;

  /// Callback when item is tapped.
  final VoidCallback? onTap;

  /// Trailing widget.
  final Widget? trailing;

  /// Creates an [AppDrawerItem].
  const AppDrawerItem({
    super.key,
    required this.label,
    required this.icon,
    this.isSelected = false,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    const selectedColor = AppColors.primary;
    final defaultColor =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? selectedColor : defaultColor,
      ),
      title: Text(
        label,
        style: AppTypography.bodyMedium.copyWith(
          color: isSelected ? selectedColor : defaultColor,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
      trailing: trailing,
      selected: isSelected,
      selectedTileColor: selectedColor.withValues(alpha: 0.1),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 4.h),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
    );
  }
}

/// Drawer section divider.
class AppDrawerDivider extends StatelessWidget {
  /// Optional section title.
  final String? title;

  /// Creates an [AppDrawerDivider].
  const AppDrawerDivider({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (title == null) {
      return Divider(
        height: 1,
        thickness: 1,
        color: isDark ? AppColors.borderDark : AppColors.borderLight,
        indent: 24.w,
        endIndent: 24.w,
      );
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 8.h),
      child: Text(
        title!.toUpperCase(),
        style: AppTypography.labelSmall.copyWith(
          color: isDark
              ? AppColors.textSecondaryDark
              : AppColors.textSecondaryLight,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

/// A styled Material 3 Navigation Bar.
///
/// Example:
/// ```dart
/// AppNavigationBar(
///   selectedIndex: 0,
///   onDestinationSelected: (index) => setState(() => _index = index),
///   destinations: [
///     AppNavDestination(icon: Icons.home_outlined, selectedIcon: Icons.home, label: 'Home'),
///     AppNavDestination(icon: Icons.explore_outlined, selectedIcon: Icons.explore, label: 'Explore'),
///   ],
/// )
/// ```
class AppNavigationBar extends StatelessWidget {
  /// Current selected index.
  final int selectedIndex;

  /// Callback when a destination is selected.
  final ValueChanged<int> onDestinationSelected;

  /// Navigation destinations.
  final List<AppNavDestination> destinations;

  /// Background color override.
  final Color? backgroundColor;

  /// Indicator color override.
  final Color? indicatorColor;

  /// Height of the navigation bar.
  final double? height;

  /// Label behavior.
  final NavigationDestinationLabelBehavior? labelBehavior;

  /// Creates an [AppNavigationBar].
  const AppNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
    this.backgroundColor,
    this.indicatorColor,
    this.height,
    this.labelBehavior,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      backgroundColor:
          backgroundColor ?? (isDark ? AppColors.surfaceDark : AppColors.white),
      indicatorColor: indicatorColor ?? AppColors.primaryLight,
      height: height ?? 80.h,
      labelBehavior:
          labelBehavior ?? NavigationDestinationLabelBehavior.alwaysShow,
      destinations: destinations
          .map((d) => NavigationDestination(
                icon: Icon(d.icon),
                selectedIcon: Icon(d.selectedIcon ?? d.icon),
                label: d.label,
              ))
          .toList(),
    );
  }
}

/// Navigation destination data for [AppNavigationBar].
class AppNavDestination {
  /// Unselected icon.
  final IconData icon;

  /// Selected icon (falls back to icon if null).
  final IconData? selectedIcon;

  /// Label text.
  final String label;

  /// Badge count (optional).
  final int? badgeCount;

  /// Creates an [AppNavDestination].
  const AppNavDestination({
    required this.icon,
    this.selectedIcon,
    required this.label,
    this.badgeCount,
  });
}

/// A styled Navigation Rail for desktop/tablet layouts.
///
/// Example:
/// ```dart
/// AppNavigationRail(
///   selectedIndex: 0,
///   onDestinationSelected: (index) => setState(() => _index = index),
///   destinations: [
///     AppRailDestination(icon: Icons.home_outlined, selectedIcon: Icons.home, label: 'Home'),
///     AppRailDestination(icon: Icons.analytics_outlined, selectedIcon: Icons.analytics, label: 'Analytics'),
///   ],
/// )
/// ```
class AppNavigationRail extends StatelessWidget {
  /// Current selected index.
  final int selectedIndex;

  /// Callback when a destination is selected.
  final ValueChanged<int> onDestinationSelected;

  /// Navigation destinations.
  final List<AppRailDestination> destinations;

  /// Label type behavior.
  final NavigationRailLabelType? labelType;

  /// Leading widget (usually a FAB).
  final Widget? leading;

  /// Trailing widget.
  final Widget? trailing;

  /// Whether to use extended mode.
  final bool extended;

  /// Minimum width when not extended.
  final double? minWidth;

  /// Minimum extended width.
  final double? minExtendedWidth;

  /// Background color override.
  final Color? backgroundColor;

  /// Indicator color override.
  final Color? indicatorColor;

  /// Group alignment.
  final double? groupAlignment;

  /// Creates an [AppNavigationRail].
  const AppNavigationRail({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
    this.labelType,
    this.leading,
    this.trailing,
    this.extended = false,
    this.minWidth,
    this.minExtendedWidth,
    this.backgroundColor,
    this.indicatorColor,
    this.groupAlignment,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      labelType: labelType ?? NavigationRailLabelType.selected,
      leading: leading,
      trailing: trailing,
      extended: extended,
      minWidth: minWidth ?? 72.w,
      minExtendedWidth: minExtendedWidth ?? 200.w,
      backgroundColor:
          backgroundColor ?? (isDark ? AppColors.surfaceDark : AppColors.white),
      indicatorColor: indicatorColor ?? AppColors.primaryLight,
      groupAlignment: groupAlignment ?? -1,
      selectedIconTheme: IconThemeData(
        color: AppColors.primary,
        size: 24.sp,
      ),
      unselectedIconTheme: IconThemeData(
        color:
            isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
        size: 24.sp,
      ),
      selectedLabelTextStyle: AppTypography.labelMedium.copyWith(
        color: AppColors.primary,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelTextStyle: AppTypography.labelMedium.copyWith(
        color:
            isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
      ),
      destinations: destinations
          .map((d) => NavigationRailDestination(
                icon: Icon(d.icon),
                selectedIcon: Icon(d.selectedIcon ?? d.icon),
                label: Text(d.label),
              ))
          .toList(),
    );
  }
}

/// Navigation rail destination data for [AppNavigationRail].
class AppRailDestination {
  /// Unselected icon.
  final IconData icon;

  /// Selected icon (falls back to icon if null).
  final IconData? selectedIcon;

  /// Label text.
  final String label;

  /// Creates an [AppRailDestination].
  const AppRailDestination({
    required this.icon,
    this.selectedIcon,
    required this.label,
  });
}

/// A styled tab bar.
///
/// Example:
/// ```dart
/// AppTabBar(
///   controller: _tabController,
///   tabs: [
///     Tab(text: 'Overview'),
///     Tab(text: 'Details'),
///     Tab(text: 'Reviews'),
///   ],
/// );
/// ```
class AppTabBar extends StatelessWidget implements PreferredSizeWidget {
  /// Tab controller.
  final TabController controller;

  /// Tab items.
  final List<Widget> tabs;

  /// Whether tabs should be scrollable.
  final bool isScrollable;

  /// Tab alignment when scrollable.
  final TabAlignment? tabAlignment;

  /// Indicator color.
  final Color? indicatorColor;

  /// Indicator weight.
  final double indicatorWeight;

  /// Label color.
  final Color? labelColor;

  /// Unselected label color.
  final Color? unselectedLabelColor;

  /// Creates an [AppTabBar].
  const AppTabBar({
    super.key,
    required this.controller,
    required this.tabs,
    this.isScrollable = false,
    this.tabAlignment,
    this.indicatorColor,
    this.indicatorWeight = 3,
    this.labelColor,
    this.unselectedLabelColor,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kTextTabBarHeight);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TabBar(
      controller: controller,
      tabs: tabs,
      isScrollable: isScrollable,
      tabAlignment: tabAlignment,
      indicatorColor: indicatorColor ?? AppColors.primary,
      indicatorWeight: indicatorWeight,
      labelColor: labelColor ??
          (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
      unselectedLabelColor: unselectedLabelColor ??
          (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
      labelStyle: AppTypography.labelLarge,
      unselectedLabelStyle: AppTypography.labelLarge,
      dividerColor: isDark ? AppColors.borderDark : AppColors.borderLight,
    );
  }
}
