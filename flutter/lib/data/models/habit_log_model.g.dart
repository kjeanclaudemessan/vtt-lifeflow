// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HabitLogModel _$HabitLogModelFromJson(Map<String, dynamic> json) =>
    HabitLogModel(
      id: json['id'] as String,
      habitId: json['habit_id'] as String,
      logDate: json['log_date'] as String,
      completed: json['completed'] as bool? ?? false,
      value: json['value'] as num?,
      actualStartTime: json['actual_start_time'] as String?,
      actualEndTime: json['actual_end_time'] as String?,
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$HabitLogModelToJson(HabitLogModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'habit_id': instance.habitId,
      'log_date': instance.logDate,
      'completed': instance.completed,
      'value': instance.value,
      'actual_start_time': instance.actualStartTime,
      'actual_end_time': instance.actualEndTime,
      'created_at': instance.createdAt,
    };
