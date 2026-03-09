import 'package:json_annotation/json_annotation.dart';

import '../../core/enums/lifeflow_enums.dart';
import '../../core/utils/time_parsing.dart';
import '../../domain/entities/habit_entity.dart';

part 'habit_model.g.dart';

/// Data model for the `habits` Supabase table.
///
/// Handles JSON serialization/deserialization with snake_case mapping,
/// including the new `estimated_duration_minutes` field.
@JsonSerializable()
class HabitModel {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'user_id')
  final String userId;

  @JsonKey(name: 'domain_id')
  final String? domainId;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'description')
  final String? description;

  @JsonKey(name: 'type')
  final String type;

  @JsonKey(name: 'target_value')
  final num? targetValue;

  @JsonKey(name: 'unit')
  final String? unit;

  @JsonKey(name: 'estimated_duration_minutes')
  final int estimatedDurationMinutes;

  @JsonKey(name: 'start_time')
  final String? startTime;

  @JsonKey(name: 'notifications_enabled')
  final bool notificationsEnabled;

  @JsonKey(name: 'reminder_offset_minutes')
  final int reminderOffsetMinutes;

  @JsonKey(name: 'frequency')
  final String frequency;

  @JsonKey(name: 'frequency_days')
  final List<int>? frequencyDays;

  @JsonKey(name: 'is_archived')
  final bool isArchived;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'updated_at')
  final String updatedAt;

  const HabitModel({
    required this.id,
    required this.userId,
    this.domainId,
    required this.name,
    this.description,
    this.type = 'binary',
    this.targetValue,
    this.unit,
    this.estimatedDurationMinutes = 15,
    this.startTime,
    this.notificationsEnabled = true,
    this.reminderOffsetMinutes = 5,
    this.frequency = 'daily',
    this.frequencyDays,
    this.isArchived = false,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Creates a [HabitModel] from a JSON map.
  factory HabitModel.fromJson(Map<String, dynamic> json) =>
      _$HabitModelFromJson(json);

  /// Converts this model to a JSON map.
  Map<String, dynamic> toJson() => _$HabitModelToJson(this);

  /// Converts this model to a domain [HabitEntity].
  HabitEntity toEntity() {
    return HabitEntity(
      id: id,
      userId: userId,
      domainId: domainId,
      name: name,
      description: description,
      type: HabitType.fromString(type),
      targetValue: targetValue?.toDouble(),
      unit: unit,
      estimatedDurationMinutes: estimatedDurationMinutes,
      startTime: TimeParsingUtils.parseTime(startTime),
      notificationsEnabled: notificationsEnabled,
      reminderOffsetMinutes: reminderOffsetMinutes,
      frequency: HabitFrequency.fromString(frequency),
      frequencyDays: frequencyDays ?? [],
      isArchived: isArchived,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
    );
  }

  /// Creates a [HabitModel] from a domain [HabitEntity].
  factory HabitModel.fromEntity(HabitEntity entity) {
    return HabitModel(
      id: entity.id,
      userId: entity.userId,
      domainId: entity.domainId,
      name: entity.name,
      description: entity.description,
      type: entity.type.toValue(),
      targetValue: entity.targetValue,
      unit: entity.unit,
      estimatedDurationMinutes: entity.estimatedDurationMinutes,
      startTime: TimeParsingUtils.formatTime(entity.startTime),
      notificationsEnabled: entity.notificationsEnabled,
      reminderOffsetMinutes: entity.reminderOffsetMinutes,
      frequency: entity.frequency.toValue(),
      frequencyDays: entity.frequencyDays,
      isArchived: entity.isArchived,
      createdAt: entity.createdAt.toIso8601String(),
      updatedAt: entity.updatedAt.toIso8601String(),
    );
  }

  /// Creates a JSON map for INSERT (without id, timestamps).
  static Map<String, dynamic> toInsertJson(HabitEntity entity) {
    return {
      'user_id': entity.userId,
      'domain_id': entity.domainId,
      'name': entity.name,
      'description': entity.description,
      'type': entity.type.toValue(),
      'target_value': entity.targetValue,
      'unit': entity.unit,
      'estimated_duration_minutes': entity.estimatedDurationMinutes,
      'start_time': TimeParsingUtils.formatTime(entity.startTime),
      'notifications_enabled': entity.notificationsEnabled,
      'reminder_offset_minutes': entity.reminderOffsetMinutes,
      'frequency': entity.frequency.toValue(),
      'frequency_days': entity.frequencyDays,
      'is_archived': entity.isArchived,
    };
  }

  /// Creates a JSON map for UPDATE.
  static Map<String, dynamic> toUpdateJson(HabitEntity entity) {
    return {
      'domain_id': entity.domainId,
      'name': entity.name,
      'description': entity.description,
      'type': entity.type.toValue(),
      'target_value': entity.targetValue,
      'unit': entity.unit,
      'estimated_duration_minutes': entity.estimatedDurationMinutes,
      'start_time': TimeParsingUtils.formatTime(entity.startTime),
      'notifications_enabled': entity.notificationsEnabled,
      'reminder_offset_minutes': entity.reminderOffsetMinutes,
      'frequency': entity.frequency.toValue(),
      'frequency_days': entity.frequencyDays,
      'is_archived': entity.isArchived,
    };
  }
}
