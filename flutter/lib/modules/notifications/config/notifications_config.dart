import 'package:flutter/material.dart';

/// Configuration for the Notifications module.
class NotificationsConfig {
  /// Enable push notifications.
  final bool enablePush;

  /// Enable in-app notifications.
  final bool enableInApp;

  /// Show badge count on app icon.
  final bool showBadge;

  /// Play sound for notifications.
  final bool playSound;

  /// Notification channels for user preferences.
  final List<NotificationChannel> channels;

  /// Visual style for notifications list.
  final NotificationsStyle style;

  /// Empty state configuration.
  final NotificationsEmptyState emptyState;

  const NotificationsConfig({
    this.enablePush = true,
    this.enableInApp = true,
    this.showBadge = true,
    this.playSound = true,
    this.channels = const [],
    this.style = NotificationsStyle.card,
    this.emptyState = const NotificationsEmptyState(),
  });

  /// Default configuration with standard channels.
  static const defaultConfig = NotificationsConfig(
    channels: [
      NotificationChannel.marketing(),
      NotificationChannel.orders(),
      NotificationChannel.reminders(),
      NotificationChannel.social(),
    ],
  );
}

/// Notification channel for user preferences.
class NotificationChannel {
  /// Unique identifier for the channel.
  final String id;

  /// Localization key for the channel name.
  final String nameKey;

  /// Localization key for the channel description.
  final String descriptionKey;

  /// Icon for the channel.
  final IconData icon;

  /// Whether enabled by default.
  final bool enabledByDefault;

  const NotificationChannel({
    required this.id,
    required this.nameKey,
    required this.descriptionKey,
    required this.icon,
    this.enabledByDefault = true,
  });

  /// Marketing notifications channel.
  const NotificationChannel.marketing()
      : id = 'marketing',
        nameKey = 'notificationsChannelMarketing',
        descriptionKey = 'notificationsChannelMarketingDesc',
        icon = Icons.campaign_outlined,
        enabledByDefault = true;

  /// Orders/transactions notifications channel.
  const NotificationChannel.orders()
      : id = 'orders',
        nameKey = 'notificationsChannelOrders',
        descriptionKey = 'notificationsChannelOrdersDesc',
        icon = Icons.receipt_long_outlined,
        enabledByDefault = true;

  /// Reminders notifications channel.
  const NotificationChannel.reminders()
      : id = 'reminders',
        nameKey = 'notificationsChannelReminders',
        descriptionKey = 'notificationsChannelRemindersDesc',
        icon = Icons.alarm_outlined,
        enabledByDefault = true;

  /// Social notifications channel.
  const NotificationChannel.social()
      : id = 'social',
        nameKey = 'notificationsChannelSocial',
        descriptionKey = 'notificationsChannelSocialDesc',
        icon = Icons.people_outline,
        enabledByDefault = true;
}

/// Notification item model for UI.
class NotificationItem {
  /// Unique identifier.
  final String id;

  /// Notification title.
  final String title;

  /// Notification body/description.
  final String body;

  /// Type/category of notification.
  final NotificationType type;

  /// Icon for the notification.
  final IconData? icon;

  /// Image URL for the notification.
  final String? imageUrl;

  /// Deep link or action URL.
  final String? actionUrl;

  /// Whether the notification has been read.
  final bool isRead;

  /// When the notification was received.
  final DateTime createdAt;

  /// Additional metadata.
  final Map<String, dynamic>? metadata;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.icon,
    this.imageUrl,
    this.actionUrl,
    this.isRead = false,
    required this.createdAt,
    this.metadata,
  });

  /// Create a copy with updated values.
  NotificationItem copyWith({
    String? id,
    String? title,
    String? body,
    NotificationType? type,
    IconData? icon,
    String? imageUrl,
    String? actionUrl,
    bool? isRead,
    DateTime? createdAt,
    Map<String, dynamic>? metadata,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      icon: icon ?? this.icon,
      imageUrl: imageUrl ?? this.imageUrl,
      actionUrl: actionUrl ?? this.actionUrl,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      metadata: metadata ?? this.metadata,
    );
  }
}

/// Type of notification.
enum NotificationType {
  /// General/info notification.
  general,

  /// Marketing/promotional notification.
  marketing,

  /// Order/transaction notification.
  order,

  /// Social/interaction notification.
  social,

  /// Reminder notification.
  reminder,

  /// Alert/warning notification.
  alert,

  /// Success notification.
  success,
}

/// Visual style for notifications list.
enum NotificationsStyle {
  /// Card-based layout with shadows.
  card,

  /// Simple list with separators.
  list,

  /// Grouped by date.
  grouped,
}

/// Empty state configuration.
class NotificationsEmptyState {
  /// Icon to display.
  final IconData icon;

  /// Localization key for title.
  final String titleKey;

  /// Localization key for description.
  final String descriptionKey;

  const NotificationsEmptyState({
    this.icon = Icons.notifications_off_outlined,
    this.titleKey = 'notificationsEmptyTitle',
    this.descriptionKey = 'notificationsEmptyDescription',
  });
}
