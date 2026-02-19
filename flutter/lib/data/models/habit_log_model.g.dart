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
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$HabitLogModelToJson(HabitLogModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'habit_id': instance.habitId,
      'log_date': instance.logDate,
      'completed': instance.completed,
      'value': instance.value,
      'created_at': instance.createdAt,
    };
