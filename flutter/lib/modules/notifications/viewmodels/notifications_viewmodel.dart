import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../config/notifications_config.dart';

/// ViewModel for the Notifications view.
class NotificationsViewModel extends BaseViewModel {
  /// Notifications configuration.
  final NotificationsConfig? _inputConfig;

  NotificationsViewModel({NotificationsConfig? config}) : _inputConfig = config;

  /// Navigation service.
  final _navigationService = locator<NavigationService>();

  /// Current configuration.
  NotificationsConfig get config =>
      _inputConfig ?? NotificationsConfig.defaultConfig;

  /// List of notifications.
  List<NotificationItem> _notifications = [];
  List<NotificationItem> get notifications => _notifications;

  /// Unread notifications count.
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  /// Whether there are any notifications.
  bool get hasNotifications => _notifications.isNotEmpty;

  /// Whether all notifications are read.
  bool get allRead => unreadCount == 0;

  /// Selected filter.
  NotificationType? _selectedFilter;
  NotificationType? get selectedFilter => _selectedFilter;

  /// Filtered notifications.
  List<NotificationItem> get filteredNotifications {
    if (_selectedFilter == null) return _notifications;
    return _notifications.where((n) => n.type == _selectedFilter).toList();
  }

  /// Channel preferences.
  final Map<String, bool> _channelPreferences = {};

  /// Initialize the ViewModel.
  Future<void> init() async {
    setBusy(true);
    await _loadNotifications();
    await _loadChannelPreferences();
    setBusy(false);
  }

  /// Load notifications from the data source.
  Future<void> _loadNotifications() async {
    // TODO: Load from repository
    // For now, use mock data
    _notifications = _getMockNotifications();
    notifyListeners();
  }

  /// Load channel preferences.
  Future<void> _loadChannelPreferences() async {
    // TODO: Load from storage
    for (final channel in config.channels) {
      _channelPreferences[channel.id] = channel.enabledByDefault;
    }
  }

  /// Refresh notifications.
  Future<void> refresh() async {
    await _loadNotifications();
  }

  /// Set filter.
  void setFilter(NotificationType? type) {
    _selectedFilter = type;
    notifyListeners();
  }

  /// Clear filter.
  void clearFilter() {
    _selectedFilter = null;
    notifyListeners();
  }

  /// Mark a notification as read.
  Future<void> markAsRead(String notificationId) async {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      // TODO: Update in repository
      notifyListeners();
    }
  }

  /// Mark all notifications as read.
  Future<void> markAllAsRead() async {
    _notifications =
        _notifications.map((n) => n.copyWith(isRead: true)).toList();
    // TODO: Update in repository
    notifyListeners();
  }

  /// Delete a notification.
  Future<void> deleteNotification(String notificationId) async {
    _notifications.removeWhere((n) => n.id == notificationId);
    // TODO: Delete from repository
    notifyListeners();
  }

  /// Clear all notifications.
  Future<void> clearAll() async {
    _notifications.clear();
    // TODO: Clear in repository
    notifyListeners();
  }

  /// Handle notification tap.
  void onNotificationTap(NotificationItem notification) {
    // Mark as read
    markAsRead(notification.id);

    // Navigate if action URL is present
    if (notification.actionUrl != null) {
      // TODO: Handle deep linking
    }
  }

  /// Get channel preference.
  bool getChannelEnabled(String channelId) {
    return _channelPreferences[channelId] ?? true;
  }

  /// Set channel preference.
  void setChannelEnabled(String channelId, bool enabled) {
    _channelPreferences[channelId] = enabled;
    // TODO: Save to storage
    notifyListeners();
  }

  /// Navigate back.
  void goBack() {
    _navigationService.back();
  }

  /// Get notification type label.
  String getTypeLabel(NotificationType type) {
    return switch (type) {
      NotificationType.general => 'General',
      NotificationType.marketing => 'Marketing',
      NotificationType.order => 'Orders',
      NotificationType.social => 'Social',
      NotificationType.reminder => 'Reminders',
      NotificationType.alert => 'Alerts',
      NotificationType.success => 'Success',
    };
  }

  /// Get grouped notifications by date.
  Map<DateTime, List<NotificationItem>> get groupedNotifications {
    final grouped = <DateTime, List<NotificationItem>>{};
    for (final notification in filteredNotifications) {
      final date = DateTime(
        notification.createdAt.year,
        notification.createdAt.month,
        notification.createdAt.day,
      );
      grouped.putIfAbsent(date, () => []).add(notification);
    }
    return grouped;
  }

  /// Mock notifications for development.
  List<NotificationItem> _getMockNotifications() {
    final now = DateTime.now();
    return [
      NotificationItem(
        id: '1',
        title: 'Welcome!',
        body: 'Thank you for joining us. Start exploring the app!',
        type: NotificationType.general,
        createdAt: now.subtract(const Duration(minutes: 5)),
      ),
      NotificationItem(
        id: '2',
        title: 'Special Offer',
        body: 'Get 20% off on your first order. Limited time only!',
        type: NotificationType.marketing,
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
      NotificationItem(
        id: '3',
        title: 'Order Confirmed',
        body: 'Your order #12345 has been confirmed.',
        type: NotificationType.order,
        isRead: true,
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      NotificationItem(
        id: '4',
        title: 'New Follower',
        body: 'John Doe started following you.',
        type: NotificationType.social,
        createdAt: now.subtract(const Duration(days: 2)),
      ),
      NotificationItem(
        id: '5',
        title: 'Reminder',
        body: 'Don\'t forget to complete your profile.',
        type: NotificationType.reminder,
        createdAt: now.subtract(const Duration(days: 3)),
      ),
    ];
  }
}
