import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/notification_entity.dart';

part 'notification_model.g.dart';

/// Data model for the `notifications` Supabase table.
///
/// Handles JSON serialization/deserialization with snake_case mapping.
@JsonSerializable()
class NotificationModel {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'user_id')
  final String userId;

  @JsonKey(name: 'title')
  final String title;

  @JsonKey(name: 'body')
  final String body;

  @JsonKey(name: 'type')
  final String type;

  @JsonKey(name: 'channel')
  final String channel;

  @JsonKey(name: 'is_read')
  final bool isRead;

  @JsonKey(name: 'action_url')
  final String? actionUrl;

  @JsonKey(name: 'metadata')
  final Map<String, dynamic>? metadata;

  @JsonKey(name: 'created_at')
  final String createdAt;

  const NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    this.type = 'general',
    this.channel = 'general',
    this.isRead = false,
    this.actionUrl,
    this.metadata,
    required this.createdAt,
  });

  /// JSON deserialization.
  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  /// JSON serialization.
  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);

  /// Convert to domain entity.
  NotificationEntity toEntity() {
    return NotificationEntity(
      id: id,
      userId: userId,
      title: title,
      body: body,
      type: _parseType(type),
      channel: _parseChannel(channel),
      isRead: isRead,
      actionUrl: actionUrl,
      metadata: metadata,
      createdAt: DateTime.parse(createdAt),
    );
  }

  /// Parse string to [NotifType].
  static NotifType _parseType(String value) {
    return switch (value) {
      'reminder' => NotifType.reminder,
      'alert' => NotifType.alert,
      'success' => NotifType.success,
      'streak' => NotifType.streak,
      'bilan' => NotifType.bilan,
      _ => NotifType.general,
    };
  }

  /// Parse string to [NotifChannel].
  static NotifChannel _parseChannel(String value) {
    return switch (value) {
      'reminders' => NotifChannel.reminders,
      'streaks' => NotifChannel.streaks,
      'bilan' => NotifChannel.bilan,
      _ => NotifChannel.general,
    };
  }
}
