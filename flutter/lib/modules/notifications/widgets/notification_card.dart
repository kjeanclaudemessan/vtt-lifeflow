import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../design_system/design_system.dart';
import '../config/notifications_config.dart';

/// Card widget for displaying a notification.
class NotificationCard extends StatelessWidget {
  /// The notification to display.
  final NotificationItem notification;

  /// Callback when the card is tapped.
  final VoidCallback? onTap;

  /// Callback when the card is dismissed.
  final VoidCallback? onDismiss;

  /// Callback when delete is pressed.
  final VoidCallback? onDelete;

  const NotificationCard({
    required this.notification,
    this.onTap,
    this.onDismiss,
    this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss?.call(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.1),
          borderRadius: AppRadius.md,
        ),
        child: Icon(
          Icons.delete_outline,
          color: AppColors.error,
          size: 24.sp,
        ),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: notification.isRead
                ? (isDark ? AppColors.surfaceDark : AppColors.surfaceLight)
                : (isDark
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : AppColors.primary.withValues(alpha: 0.05)),
            borderRadius: AppRadius.md,
            border: notification.isRead
                ? null
                : Border.all(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    width: 1,
                  ),
            boxShadow: notification.isRead ? null : AppShadows.xs,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              _buildIcon(isDark),
              SizedBox(width: AppSpacing.md),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and time
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: AppTypography.labelLarge.copyWith(
                              fontWeight: notification.isRead
                                  ? FontWeight.w500
                                  : FontWeight.w600,
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: AppSpacing.sm),
                        Text(
                          _formatTime(notification.createdAt),
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.neutral500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.xs),

                    // Body
                    Text(
                      notification.body,
                      style: AppTypography.bodyMedium.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Image if present
                    if (notification.imageUrl != null) ...[
                      SizedBox(height: AppSpacing.sm),
                      ClipRRect(
                        borderRadius: AppRadius.sm,
                        child: Image.network(
                          notification.imageUrl!,
                          height: 120.h,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Unread indicator
              if (!notification.isRead) ...[
                SizedBox(width: AppSpacing.sm),
                Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(bool isDark) {
    final color = _getTypeColor(notification.type);
    final icon = notification.icon ?? _getTypeIcon(notification.type);

    return Container(
      width: 44.w,
      height: 44.w,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: color,
        size: 22.sp,
      ),
    );
  }

  Color _getTypeColor(NotificationType type) {
    return switch (type) {
      NotificationType.general => AppColors.neutral500,
      NotificationType.marketing => AppColors.warning,
      NotificationType.order => AppColors.primary,
      NotificationType.social => AppColors.info,
      NotificationType.reminder => AppColors.warning,
      NotificationType.alert => AppColors.error,
      NotificationType.success => AppColors.success,
    };
  }

  IconData _getTypeIcon(NotificationType type) {
    return switch (type) {
      NotificationType.general => Icons.notifications_outlined,
      NotificationType.marketing => Icons.campaign_outlined,
      NotificationType.order => Icons.receipt_long_outlined,
      NotificationType.social => Icons.people_outline,
      NotificationType.reminder => Icons.alarm_outlined,
      NotificationType.alert => Icons.warning_amber_outlined,
      NotificationType.success => Icons.check_circle_outline,
    };
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'À l\'instant';
    } else if (difference.inMinutes < 60) {
      return 'il y a ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'il y a ${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return 'il y a ${difference.inDays}j';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}
