import 'package:equatable/equatable.dart';

/// Type of notification in the domain layer.
enum NotifType {
  general,
  reminder,
  alert,
  success,
  streak,
  bilan,
}

/// Channel for notification routing.
enum NotifChannel {
  reminders,
  streaks,
  bilan,
  general,
}

/// Represents a notification in the domain layer.
///
/// Maps to the `notifications` Supabase table.
/// Pure domain object — no JSON annotations.
class NotificationEntity extends Equatable {
  /// Unique identifier (UUID).
  final String id;

  /// Owner user ID.
  final String userId;

  /// Notification title.
  final String title;

  /// Notification body text.
  final String body;

  /// Type of notification.
  final NotifType type;

  /// Channel (for filtering / preferences).
  final NotifChannel channel;

  /// Whether the user has read this notification.
  final bool isRead;

  /// Deep link or action URL (nullable).
  final String? actionUrl;

  /// Additional metadata (nullable).
  final Map<String, dynamic>? metadata;

  /// When the notification was created.
  final DateTime createdAt;

  const NotificationEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    this.type = NotifType.general,
    this.channel = NotifChannel.general,
    this.isRead = false,
    this.actionUrl,
    this.metadata,
    required this.createdAt,
  });

  /// Create a copy with updated values.
  NotificationEntity copyWith({
    String? id,
    String? userId,
    String? title,
    String? body,
    NotifType? type,
    NotifChannel? channel,
    bool? isRead,
    String? actionUrl,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      channel: channel ?? this.channel,
      isRead: isRead ?? this.isRead,
      actionUrl: actionUrl ?? this.actionUrl,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        body,
        type,
        channel,
        isRead,
        actionUrl,
        metadata,
        createdAt,
      ];
}
