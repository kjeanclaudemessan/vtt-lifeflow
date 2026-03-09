// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HabitModel _$HabitModelFromJson(Map<String, dynamic> json) => HabitModel(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  domainId: json['domain_id'] as String?,
  name: json['name'] as String,
  description: json['description'] as String?,
  type: json['type'] as String? ?? 'binary',
  targetValue: json['target_value'] as num?,
  unit: json['unit'] as String?,
  estimatedDurationMinutes:
      (json['estimated_duration_minutes'] as num?)?.toInt() ?? 15,
  startTime: json['start_time'] as String?,
  notificationsEnabled: json['notifications_enabled'] as bool? ?? true,
  reminderOffsetMinutes:
      (json['reminder_offset_minutes'] as num?)?.toInt() ?? 5,
  frequency: json['frequency'] as String? ?? 'daily',
  frequencyDays: (json['frequency_days'] as List<dynamic>?)
      ?.map((e) => (e as num).toInt())
      .toList(),
  isArchived: json['is_archived'] as bool? ?? false,
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
);

Map<String, dynamic> _$HabitModelToJson(HabitModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'domain_id': instance.domainId,
      'name': instance.name,
      'description': instance.description,
      'type': instance.type,
      'target_value': instance.targetValue,
      'unit': instance.unit,
      'estimated_duration_minutes': instance.estimatedDurationMinutes,
      'start_time': instance.startTime,
      'notifications_enabled': instance.notificationsEnabled,
      'reminder_offset_minutes': instance.reminderOffsetMinutes,
      'frequency': instance.frequency,
      'frequency_days': instance.frequencyDays,
      'is_archived': instance.isArchived,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
