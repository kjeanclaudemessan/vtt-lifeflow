import '../../core/typedefs/typedefs.dart';
import '../entities/notification_entity.dart';

/// Contract for notification operations.
///
/// Implementations: [NotificationRepositoryImpl]
abstract class INotificationRepository {
  // ─────────────────────────────────────────────────────────────────
  // Read
  // ─────────────────────────────────────────────────────────────────

  /// Gets all notifications for the current user, newest first.
  FutureResult<List<NotificationEntity>> getNotifications();

  /// Gets the count of unread notifications.
  FutureResult<int> getUnreadCount();

  // ─────────────────────────────────────────────────────────────────
  // Update
  // ─────────────────────────────────────────────────────────────────

  /// Marks a single notification as read.
  FutureResult<void> markAsRead(String notificationId);

  /// Marks all notifications as read for the current user.
  FutureResult<void> markAllAsRead();

  // ─────────────────────────────────────────────────────────────────
  // Delete
  // ─────────────────────────────────────────────────────────────────

  /// Deletes a single notification.
  FutureResult<void> deleteNotification(String notificationId);

  /// Deletes all notifications for the current user.
  FutureResult<void> clearAll();
}
