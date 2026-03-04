import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../domain/entities/notification_entity.dart';
import '../../../domain/repositories/i_notification_repository.dart';
import '../../../services/storage/local_storage_service.dart';
import '../config/notifications_config.dart';

/// ViewModel for the Notifications view.
///
/// Loads notifications from Supabase via [INotificationRepository],
/// converts [NotificationEntity] → [NotificationItem] for the UI,
/// and persists channel preferences in local storage.
class NotificationsViewModel extends BaseViewModel {
  /// Notifications configuration.
  final NotificationsConfig? _inputConfig;

  NotificationsViewModel({NotificationsConfig? config}) : _inputConfig = config;

  /// Services & repositories.
  final _navigationService = locator<NavigationService>();
  final _repository = locator<INotificationRepository>();
  final _localStorage = locator<LocalStorageService>();

  /// Current configuration.
  NotificationsConfig get config =>
      _inputConfig ?? NotificationsConfig.defaultConfig;

  /// List of notifications (UI model).
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
    _loadChannelPreferences();
    setBusy(false);
  }

  /// Load notifications from Supabase.
  Future<void> _loadNotifications() async {
    final result = await _repository.getNotifications();

    result.fold(
      (failure) {
        setError(failure.message);
      },
      (entities) {
        _notifications = entities.map(_toNotificationItem).toList();
        notifyListeners();
      },
    );
  }

  /// Convert domain entity to UI model.
  NotificationItem _toNotificationItem(NotificationEntity entity) {
    return NotificationItem(
      id: entity.id,
      title: entity.title,
      body: entity.body,
      type: _mapType(entity.type),
      isRead: entity.isRead,
      actionUrl: entity.actionUrl,
      createdAt: entity.createdAt,
      metadata: entity.metadata,
    );
  }

  /// Map domain [NotifType] to UI [NotificationType].
  NotificationType _mapType(NotifType type) {
    return switch (type) {
      NotifType.general => NotificationType.general,
      NotifType.reminder => NotificationType.reminder,
      NotifType.alert => NotificationType.alert,
      NotifType.success => NotificationType.success,
      NotifType.streak => NotificationType.success,
      NotifType.bilan => NotificationType.general,
    };
  }

  /// Load channel preferences from local storage.
  void _loadChannelPreferences() {
    for (final channel in config.channels) {
      _channelPreferences[channel.id] = _localStorage.getBoolOrDefault(
        'notif_channel_${channel.id}',
        defaultValue: channel.enabledByDefault,
      );
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
    // Optimistic UI update
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();
    }

    // Persist to Supabase
    final result = await _repository.markAsRead(notificationId);
    result.fold(
      (failure) {
        // Revert on error
        if (index != -1) {
          _notifications[index] = _notifications[index].copyWith(isRead: false);
          notifyListeners();
        }
      },
      (_) {},
    );
  }

  /// Mark all notifications as read.
  Future<void> markAllAsRead() async {
    // Optimistic UI update
    final oldNotifications = List<NotificationItem>.from(_notifications);
    _notifications =
        _notifications.map((n) => n.copyWith(isRead: true)).toList();
    notifyListeners();

    // Persist to Supabase
    final result = await _repository.markAllAsRead();
    result.fold(
      (failure) {
        // Revert on error
        _notifications = oldNotifications;
        notifyListeners();
      },
      (_) {},
    );
  }

  /// Delete a notification.
  Future<void> deleteNotification(String notificationId) async {
    // Optimistic UI update
    final removed =
        _notifications.where((n) => n.id == notificationId).firstOrNull;
    final removedIndex =
        _notifications.indexWhere((n) => n.id == notificationId);
    _notifications.removeWhere((n) => n.id == notificationId);
    notifyListeners();

    // Persist to Supabase
    final result = await _repository.deleteNotification(notificationId);
    result.fold(
      (failure) {
        // Revert on error
        if (removed != null && removedIndex >= 0) {
          _notifications.insert(removedIndex, removed);
          notifyListeners();
        }
      },
      (_) {},
    );
  }

  /// Clear all notifications.
  Future<void> clearAll() async {
    final oldNotifications = List<NotificationItem>.from(_notifications);
    _notifications.clear();
    notifyListeners();

    final result = await _repository.clearAll();
    result.fold(
      (failure) {
        _notifications = oldNotifications;
        notifyListeners();
      },
      (_) {},
    );
  }

  /// Handle notification tap.
  void onNotificationTap(NotificationItem notification) {
    markAsRead(notification.id);

    if (notification.actionUrl != null) {
      // Deep link navigation — handled by router
    }
  }

  /// Get channel preference.
  bool getChannelEnabled(String channelId) {
    return _channelPreferences[channelId] ?? true;
  }

  /// Set channel preference.
  void setChannelEnabled(String channelId, bool enabled) {
    _channelPreferences[channelId] = enabled;
    _localStorage.setBool('notif_channel_$channelId', enabled);
    notifyListeners();
  }

  /// Navigate back.
  void goBack() {
    _navigationService.back();
  }

  /// Get notification type label.
  String getTypeLabel(NotificationType type) {
    return switch (type) {
      NotificationType.general => 'Général',
      NotificationType.marketing => 'Marketing',
      NotificationType.order => 'Transactions',
      NotificationType.social => 'Social',
      NotificationType.reminder => 'Rappels',
      NotificationType.alert => 'Alertes',
      NotificationType.success => 'Succès',
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
}
