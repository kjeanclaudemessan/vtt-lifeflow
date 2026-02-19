import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';

import '../../../core/core.dart';
import '../../../design_system/design_system.dart';
import '../config/notifications_config.dart';
import '../viewmodels/notifications_viewmodel.dart';
import '../widgets/notification_card.dart';
import '../widgets/notification_widgets.dart';

/// Notifications view.
///
/// Displays a list of notifications with filtering and actions.
class NotificationsView extends StackedView<NotificationsViewModel> {
  /// Optional custom configuration.
  final NotificationsConfig? config;

  const NotificationsView({
    this.config,
    super.key,
  });

  @override
  void onViewModelReady(NotificationsViewModel viewModel) {
    viewModel.init();
  }

  @override
  Widget builder(
    BuildContext context,
    NotificationsViewModel viewModel,
    Widget? child,
  ) {
    final l10n = context.l10n;

    return switch (viewModel.config.style) {
      NotificationsStyle.card => _buildCardStyle(context, viewModel, l10n),
      NotificationsStyle.list => _buildListStyle(context, viewModel, l10n),
      NotificationsStyle.grouped =>
        _buildGroupedStyle(context, viewModel, l10n),
    };
  }

  Widget _buildCardStyle(
    BuildContext context,
    NotificationsViewModel viewModel,
    AppLocalizations l10n,
  ) {
    final isDark = context.isDarkMode;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: _buildAppBar(context, viewModel, l10n),
      body: viewModel.isBusy
          ? const Center(child: AppLoader())
          : viewModel.hasNotifications
              ? RefreshIndicator(
                  onRefresh: viewModel.refresh,
                  child: Column(
                    children: [
                      // Filters
                      _buildFilters(context, viewModel),

                      // Notifications list
                      Expanded(
                        child: ListView.separated(
                          padding: EdgeInsets.all(AppSpacing.md),
                          itemCount: viewModel.filteredNotifications.length,
                          separatorBuilder: (_, __) =>
                              SizedBox(height: AppSpacing.sm),
                          itemBuilder: (context, index) {
                            final notification =
                                viewModel.filteredNotifications[index];
                            return NotificationCard(
                              notification: notification,
                              onTap: () =>
                                  viewModel.onNotificationTap(notification),
                              onDismiss: () =>
                                  viewModel.deleteNotification(notification.id),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )
              : AppEmptyState.notifications(
                  title: l10n.notificationsEmptyTitle,
                  description: l10n.notificationsEmptyDescription,
                ),
    );
  }

  Widget _buildListStyle(
    BuildContext context,
    NotificationsViewModel viewModel,
    AppLocalizations l10n,
  ) {
    final isDark = context.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      appBar: _buildAppBar(context, viewModel, l10n),
      body: viewModel.isBusy
          ? const Center(child: AppLoader())
          : viewModel.hasNotifications
              ? RefreshIndicator(
                  onRefresh: viewModel.refresh,
                  child: ListView.separated(
                    itemCount: viewModel.filteredNotifications.length,
                    separatorBuilder: (_, __) => const AppDivider(
                      indent: 72,
                    ),
                    itemBuilder: (context, index) {
                      final notification =
                          viewModel.filteredNotifications[index];
                      return _buildListItem(
                          context, viewModel, notification, isDark);
                    },
                  ),
                )
              : AppEmptyState.notifications(
                  title: l10n.notificationsEmptyTitle,
                  description: l10n.notificationsEmptyDescription,
                ),
    );
  }

  Widget _buildGroupedStyle(
    BuildContext context,
    NotificationsViewModel viewModel,
    AppLocalizations l10n,
  ) {
    final isDark = context.isDarkMode;
    final grouped = viewModel.groupedNotifications;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: _buildAppBar(context, viewModel, l10n),
      body: viewModel.isBusy
          ? const Center(child: AppLoader())
          : viewModel.hasNotifications
              ? RefreshIndicator(
                  onRefresh: viewModel.refresh,
                  child: ListView.builder(
                    padding: EdgeInsets.all(AppSpacing.md),
                    itemCount: grouped.length,
                    itemBuilder: (context, index) {
                      final date = grouped.keys.elementAt(index);
                      final notifications = grouped[date]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Date header
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: AppSpacing.md,
                            ),
                            child: Text(
                              _formatDate(date),
                              style: AppTypography.labelLarge.copyWith(
                                color: AppColors.neutral500,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          // Notifications
                          ...notifications.map(
                            (notification) => Padding(
                              padding: EdgeInsets.only(bottom: AppSpacing.sm),
                              child: NotificationCard(
                                notification: notification,
                                onTap: () =>
                                    viewModel.onNotificationTap(notification),
                                onDismiss: () => viewModel
                                    .deleteNotification(notification.id),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                )
              : AppEmptyState.notifications(
                  title: l10n.notificationsEmptyTitle,
                  description: l10n.notificationsEmptyDescription,
                ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    NotificationsViewModel viewModel,
    AppLocalizations l10n,
  ) {
    return AppAppBar(
      title: l10n.notifications,
      leading: AppBackButton(onPressed: viewModel.goBack),
      actions: [
        if (viewModel.hasNotifications && !viewModel.allRead)
          TextButton(
            onPressed: viewModel.markAllAsRead,
            child: Text(
              l10n.markAllRead,
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        PopupMenuButton(
          icon: const Icon(Icons.more_vert),
          itemBuilder: (context) => [
            PopupMenuItem(
              onTap: () => _showPreferences(context, viewModel),
              child: Row(
                children: [
                  const Icon(Icons.settings_outlined, size: 20),
                  SizedBox(width: AppSpacing.sm),
                  Text(l10n.notificationPreferences),
                ],
              ),
            ),
            if (viewModel.hasNotifications)
              PopupMenuItem(
                onTap: viewModel.clearAll,
                child: Row(
                  children: [
                    const Icon(Icons.delete_outline,
                        size: 20, color: AppColors.error),
                    SizedBox(width: AppSpacing.sm),
                    Text(
                      l10n.clearAll,
                      style: const TextStyle(color: AppColors.error),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildFilters(
    BuildContext context,
    NotificationsViewModel viewModel,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          // All filter
          NotificationFilterChip(
            type: NotificationType.general,
            isSelected: viewModel.selectedFilter == null,
            onTap: viewModel.clearFilter,
            label: 'All',
          ),
          SizedBox(width: AppSpacing.sm),

          // Type filters
          ...NotificationType.values.map(
            (type) => Padding(
              padding: EdgeInsets.only(right: AppSpacing.sm),
              child: NotificationFilterChip(
                type: type,
                isSelected: viewModel.selectedFilter == type,
                onTap: () => viewModel.setFilter(type),
                label: viewModel.getTypeLabel(type),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(
    BuildContext context,
    NotificationsViewModel viewModel,
    NotificationItem notification,
    bool isDark,
  ) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => viewModel.deleteNotification(notification.id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: AppSpacing.lg),
        color: AppColors.error.withValues(alpha: 0.1),
        child: Icon(
          Icons.delete_outline,
          color: AppColors.error,
          size: 24.sp,
        ),
      ),
      child: AppListTile(
        onTap: () => viewModel.onNotificationTap(notification),
        leading: _buildTypeIcon(notification.type),
        title: Text(
          notification.title,
          style: AppTypography.labelLarge.copyWith(
            fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.w600,
          ),
        ),
        subtitle: Text(
          notification.body,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.neutral500,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _formatTime(notification.createdAt),
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.neutral400,
              ),
            ),
            if (!notification.isRead) ...[
              SizedBox(height: 4.h),
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
    );
  }

  Widget _buildTypeIcon(NotificationType type) {
    final color = _getTypeColor(type);
    final icon = _getTypeIcon(type);

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
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${dateTime.day}/${dateTime.month}';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    if (date == today) {
      return 'Today';
    } else if (date == yesterday) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _showPreferences(
    BuildContext context,
    NotificationsViewModel viewModel,
  ) {
    AppBottomSheet.show(
      context: context,
      title: context.l10n.notificationPreferences,
      isScrollControlled: true,
      child: NotificationPreferencesSheet(
        channels: viewModel.config.channels,
        preferences: {
          for (final channel in viewModel.config.channels)
            channel.id: viewModel.getChannelEnabled(channel.id),
        },
        onPreferenceChanged: viewModel.setChannelEnabled,
      ),
    );
  }

  @override
  NotificationsViewModel viewModelBuilder(BuildContext context) =>
      NotificationsViewModel(config: config);
}
