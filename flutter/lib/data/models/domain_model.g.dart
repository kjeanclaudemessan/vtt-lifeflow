// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'domain_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DomainModel _$DomainModelFromJson(Map<String, dynamic> json) => DomainModel(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  name: json['name'] as String,
  icon: json['icon'] as String? ?? '🎯',
  color: json['color'] as String? ?? '#6200EE',
  sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
  isArchived: json['is_archived'] as bool? ?? false,
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
);

Map<String, dynamic> _$DomainModelToJson(DomainModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'name': instance.name,
      'icon': instance.icon,
      'color': instance.color,
      'sort_order': instance.sortOrder,
      'is_archived': instance.isArchived,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
