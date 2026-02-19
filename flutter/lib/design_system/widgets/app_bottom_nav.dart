import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_shadows.dart';
import '../tokens/app_typography.dart';

/// Bottom navigation item data.
class AppBottomNavItem {
  /// Item icon (unselected).
  final IconData icon;

  /// Item icon (selected).
  final IconData? selectedIcon;

  /// Item label.
  final String label;

  /// Badge count (optional).
  final int? badgeCount;

  /// Creates an [AppBottomNavItem].
  const AppBottomNavItem({
    required this.icon,
    this.selectedIcon,
    required this.label,
    this.badgeCount,
  });
}

/// A customizable bottom navigation bar.
///
/// Example:
/// ```dart
/// AppBottomNav(
///   currentIndex: 0,
///   onTap: (index) => setState(() => _currentIndex = index),
///   items: [
///     AppBottomNavItem(icon: Icons.home_outlined, label: 'Home'),
///     AppBottomNavItem(icon: Icons.search_outlined, label: 'Search'),
///   ],
/// )
/// ```
class AppBottomNav extends StatelessWidget {
  /// Current selected index.
  final int currentIndex;

  /// Callback when an item is tapped.
  final ValueChanged<int> onTap;

  /// Navigation items.
  final List<AppBottomNavItem> items;

  /// Whether to show labels.
  final bool showLabels;

  /// Creates an [AppBottomNav].
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.showLabels = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.white,
        boxShadow: AppShadows.bottomNav,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              items.length,
              (index) => _buildNavItem(index, items[index], isDark),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, AppBottomNavItem item, bool isDark) {
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  isSelected ? (item.selectedIcon ?? item.icon) : item.icon,
                  color: isSelected
                      ? AppColors.primary
                      : (isDark
                          ? AppColors.textTertiaryDark
                          : AppColors.textTertiaryLight),
                  size: 24.sp,
                ),
                if (item.badgeCount != null && item.badgeCount! > 0)
                  Positioned(
                    top: -4.h,
                    right: -8.w,
                    child: Container(
                      constraints:
                          BoxConstraints(minWidth: 16.w, minHeight: 16.w),
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Center(
                        child: Text(
                          item.badgeCount! > 99 ? '99+' : '${item.badgeCount}',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            if (showLabels) ...[
              SizedBox(height: 4.h),
              Text(
                item.label,
                style: AppTypography.caption.copyWith(
                  color: isSelected
                      ? AppColors.primary
                      : (isDark
                          ? AppColors.textTertiaryDark
                          : AppColors.textTertiaryLight),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A bottom navigation bar with a floating action button in the center.
class AppBottomNavWithFab extends StatelessWidget {
  /// Current selected index.
  final int currentIndex;

  /// Callback when an item is tapped.
  final ValueChanged<int> onTap;

  /// Left navigation items (before FAB).
  final List<AppBottomNavItem> leftItems;

  /// Right navigation items (after FAB).
  final List<AppBottomNavItem> rightItems;

  /// FAB icon.
  final IconData fabIcon;

  /// FAB callback.
  final VoidCallback onFabTap;

  /// Whether to show labels.
  final bool showLabels;

  /// Creates an [AppBottomNavWithFab].
  const AppBottomNavWithFab({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.leftItems,
    required this.rightItems,
    required this.fabIcon,
    required this.onFabTap,
    this.showLabels = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.white,
        boxShadow: AppShadows.bottomNav,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Left items
              ...List.generate(
                leftItems.length,
                (index) => _buildNavItem(index, leftItems[index], isDark),
              ),
              // Center FAB
              _buildFab(),
              // Right items
              ...List.generate(
                rightItems.length,
                (index) => _buildNavItem(
                  leftItems.length + index + 1,
                  rightItems[index],
                  isDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, AppBottomNavItem item, bool isDark) {
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? (item.selectedIcon ?? item.icon) : item.icon,
              color: isSelected
                  ? AppColors.primary
                  : (isDark
                      ? AppColors.textTertiaryDark
                      : AppColors.textTertiaryLight),
              size: 24.sp,
            ),
            if (showLabels) ...[
              SizedBox(height: 4.h),
              Text(
                item.label,
                style: AppTypography.caption.copyWith(
                  color: isSelected
                      ? AppColors.primary
                      : (isDark
                          ? AppColors.textTertiaryDark
                          : AppColors.textTertiaryLight),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFab() {
    return GestureDetector(
      onTap: onFabTap,
      child: Container(
        width: 52.w,
        height: 52.w,
        decoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
          boxShadow: AppShadows.primary,
        ),
        child: Icon(
          fabIcon,
          color: AppColors.white,
          size: 26.sp,
        ),
      ),
    );
  }
}
