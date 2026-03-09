import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../core/utils/time_parsing.dart';
import '../../domain/entities/habit_log_entity.dart';

part 'habit_log_model.g.dart';

/// Data model for the `habit_logs` Supabase table.
///
/// Handles JSON serialization/deserialization with snake_case mapping.
@JsonSerializable()
class HabitLogModel {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'habit_id')
  final String habitId;

  @JsonKey(name: 'log_date')
  final String logDate;

  @JsonKey(name: 'completed')
  final bool completed;

  @JsonKey(name: 'value')
  final num? value;

  @JsonKey(name: 'actual_start_time')
  final String? actualStartTime;

  @JsonKey(name: 'actual_end_time')
  final String? actualEndTime;

  @JsonKey(name: 'created_at')
  final String createdAt;

  const HabitLogModel({
    required this.id,
    required this.habitId,
    required this.logDate,
    this.completed = false,
    this.value,
    this.actualStartTime,
    this.actualEndTime,
    required this.createdAt,
  });

  /// Creates a [HabitLogModel] from a JSON map.
  factory HabitLogModel.fromJson(Map<String, dynamic> json) =>
      _$HabitLogModelFromJson(json);

  /// Converts this model to a JSON map.
  Map<String, dynamic> toJson() => _$HabitLogModelToJson(this);

  /// Converts this model to a domain [HabitLogEntity].
  HabitLogEntity toEntity() {
    return HabitLogEntity(
      id: id,
      habitId: habitId,
      logDate: DateTime.parse(logDate),
      completed: completed,
      value: value?.toDouble(),
      actualStartTime: TimeParsingUtils.parseTime(actualStartTime),
      actualEndTime: TimeParsingUtils.parseTime(actualEndTime),
      createdAt: DateTime.parse(createdAt),
    );
  }

  /// Creates a [HabitLogModel] from a domain [HabitLogEntity].
  factory HabitLogModel.fromEntity(HabitLogEntity entity) {
    return HabitLogModel(
      id: entity.id,
      habitId: entity.habitId,
      logDate: entity.logDate.toIso8601String().split('T').first,
      completed: entity.completed,
      value: entity.value,
      actualStartTime: TimeParsingUtils.formatTime(entity.actualStartTime),
      actualEndTime: TimeParsingUtils.formatTime(entity.actualEndTime),
      createdAt: entity.createdAt.toIso8601String(),
    );
  }

  /// Creates a JSON map for UPSERT (log a habit).
  static Map<String, dynamic> toUpsertJson({
    required String habitId,
    required DateTime date,
    required bool completed,
    double? value,
    TimeOfDay? actualStartTime,
    TimeOfDay? actualEndTime,
  }) {
    return {
      'habit_id': habitId,
      'log_date': date.toIso8601String().split('T').first,
      'completed': completed,
      'value': value,
      'actual_start_time': TimeParsingUtils.formatTime(actualStartTime),
      'actual_end_time': TimeParsingUtils.formatTime(actualEndTime),
    };
  }
}
