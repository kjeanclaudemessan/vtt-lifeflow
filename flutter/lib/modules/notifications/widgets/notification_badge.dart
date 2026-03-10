import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../design_system/design_system.dart';

/// Badge widget for displaying notification count.
class NotificationBadge extends StatelessWidget {
  /// Number of unread notifications.
  final int count;

  /// Callback when badge is tapped.
  final VoidCallback? onTap;

  /// Icon to display.
  final IconData icon;

  /// Size of the icon.
  final double? iconSize;

  /// Color of the icon.
  final Color? iconColor;

  /// Background color of the badge.
  final Color? badgeColor;

  /// Text color of the badge.
  final Color? badgeTextColor;

  /// Show badge even when count is 0.
  final bool showZero;

  /// Maximum number to display (shows "9+" if exceeded).
  final int maxCount;

  const NotificationBadge({
    required this.count,
    this.onTap,
    this.icon = Icons.notifications_outlined,
    this.iconSize,
    this.iconColor,
    this.badgeColor,
    this.badgeTextColor,
    this.showZero = false,
    this.maxCount = 99,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveIconColor =
        iconColor ??
        (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight);
    final effectiveBadgeColor = badgeColor ?? AppColors.error;
    final effectiveBadgeTextColor = badgeTextColor ?? AppColors.white;
    final effectiveIconSize = iconSize ?? 24.sp;

    final showBadge = count > 0 || showZero;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: effectiveIconSize + 12.w,
        height: effectiveIconSize + 8.h,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Icon
            Positioned(
              left: 0,
              top: 4.h,
              child: Icon(
                icon,
                size: effectiveIconSize,
                color: effectiveIconColor,
              ),
            ),

            // Badge
            if (showBadge)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: count > 9 ? 4.w : 0,
                  ),
                  constraints: BoxConstraints(minWidth: 18.w, minHeight: 18.h),
                  decoration: BoxDecoration(
                    color: effectiveBadgeColor,
                    borderRadius: BorderRadius.circular(9.r),
                    border: Border.all(
                      color: isDark
                          ? AppColors.backgroundDark
                          : AppColors.backgroundLight,
                      width: 2.w,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _formatCount(count),
                      style: AppTypography.labelSmall.copyWith(
                        color: effectiveBadgeTextColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 10.sp,
                        height: 1,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count <= 0) return '0';
    if (count > maxCount) return '$maxCount+';
    return count.toString();
  }
}

/// Animated notification badge with pulse effect.
class AnimatedNotificationBadge extends StatefulWidget {
  /// Number of unread notifications.
  final int count;

  /// Callback when badge is tapped.
  final VoidCallback? onTap;

  /// Icon to display.
  final IconData icon;

  /// Whether to show pulse animation.
  final bool showPulse;

  const AnimatedNotificationBadge({
    required this.count,
    this.onTap,
    this.icon = Icons.notifications_outlined,
    this.showPulse = true,
    super.key,
  });

  @override
  State<AnimatedNotificationBadge> createState() =>
      _AnimatedNotificationBadgeState();
}

class _AnimatedNotificationBadgeState extends State<AnimatedNotificationBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppAnimations.slow,
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (widget.showPulse && widget.count > 0) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(AnimatedNotificationBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.count > 0 && widget.showPulse) {
      if (!_controller.isAnimating) {
        _controller.repeat(reverse: true);
      }
    } else {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;

    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 36.w,
        height: 32.h,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Icon
            Positioned(
              left: 0,
              top: 4.h,
              child: Icon(widget.icon, size: 24.sp, color: iconColor),
            ),

            // Animated Badge
            if (widget.count > 0)
              Positioned(
                right: 0,
                top: 0,
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: widget.showPulse ? _animation.value : 1.0,
                      child: child,
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: widget.count > 9 ? 4.w : 0,
                    ),
                    constraints: BoxConstraints(
                      minWidth: 18.w,
                      minHeight: 18.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(9.r),
                      border: Border.all(
                        color: isDark
                            ? AppColors.backgroundDark
                            : AppColors.backgroundLight,
                        width: 2.w,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        widget.count > 99 ? '99+' : widget.count.toString(),
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 10.sp,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
