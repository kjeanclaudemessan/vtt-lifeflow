import 'package:flutter/material.dart';

import '../../../core/core.dart';
import '../../../design_system/design_system.dart';
import '../config/notifications_config.dart';

/// Bottom sheet content for notification preferences.
/// Note: Use with AppBottomSheet.show() in the view.
class NotificationPreferencesSheet extends StatefulWidget {
  /// Available channels.
  final List<NotificationChannel> channels;

  /// Current preferences.
  final Map<String, bool> preferences;

  /// Callback when preferences change.
  final void Function(String channelId, bool enabled) onPreferenceChanged;

  const NotificationPreferencesSheet({
    required this.channels,
    required this.preferences,
    required this.onPreferenceChanged,
    super.key,
  });

  @override
  State<NotificationPreferencesSheet> createState() =>
      _NotificationPreferencesSheetState();
}

class _NotificationPreferencesSheetState
    extends State<NotificationPreferencesSheet> {
  late Map<String, bool> _localPreferences;

  @override
  void initState() {
    super.initState();
    _localPreferences = Map.from(widget.preferences);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Channels list using AppListSection
        AppListSection(
          showDividers: true,
          children: [
            for (final channel in widget.channels)
              _buildChannelTile(channel, _localPreferences[channel.id] ?? true),
          ],
        ),

        // Bottom padding
        SizedBox(height: AppSpacing.md),
      ],
    );
  }

  Widget _buildChannelTile(NotificationChannel channel, bool isEnabled) {
    return AppSwitchListTile(
      icon: channel.icon,
      title: _getChannelName(channel.nameKey),
      subtitle: _getChannelDescription(channel.descriptionKey),
      value: isEnabled,
      onChanged: (value) {
        setState(() {
          _localPreferences[channel.id] = value;
        });
        widget.onPreferenceChanged(channel.id, value);
      },
    );
  }

  // TODO: Replace with actual l10n
  String _getChannelName(String key) {
    return switch (key) {
      'notificationsChannelMarketing' => 'Promotions & Offers',
      'notificationsChannelOrders' => 'Orders & Transactions',
      'notificationsChannelReminders' => 'Reminders',
      'notificationsChannelSocial' => 'Social Updates',
      _ => key,
    };
  }

  String _getChannelDescription(String key) {
    return switch (key) {
      'notificationsChannelMarketingDesc' =>
        'Receive special offers and promotions',
      'notificationsChannelOrdersDesc' =>
        'Updates about your orders and payments',
      'notificationsChannelRemindersDesc' => 'Important reminders and alerts',
      'notificationsChannelSocialDesc' => 'Activity from people you follow',
      _ => key,
    };
  }
}

/// Empty state widget for notifications.
/// Uses AppEmptyState.notifications() factory from Design System.
class EmptyNotificationsWidget extends StatelessWidget {
  /// Empty state configuration.
  final NotificationsEmptyState? config;

  const EmptyNotificationsWidget({
    this.config,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppEmptyState.notifications(
      title: l10n.notificationsEmptyTitle,
      description: l10n.notificationsEmptyDescription,
    );
  }
}

/// Filter chip for notification types.
class NotificationFilterChip extends StatelessWidget {
  /// The notification type.
  final NotificationType type;

  /// Whether this filter is selected.
  final bool isSelected;

  /// Callback when tapped.
  final VoidCallback onTap;

  /// Label for the filter.
  final String label;

  const NotificationFilterChip({
    required this.type,
    required this.isSelected,
    required this.onTap,
    required this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppChip(
      label: label,
      isSelected: isSelected,
      onTap: onTap,
    );
  }
}
