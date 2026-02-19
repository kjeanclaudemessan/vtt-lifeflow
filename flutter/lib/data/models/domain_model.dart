import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/domain_entity.dart';

part 'domain_model.g.dart';

/// Data model for the `domains` Supabase table.
///
/// Handles JSON serialization/deserialization with snake_case mapping.
@JsonSerializable()
class DomainModel {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'user_id')
  final String userId;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'icon')
  final String icon;

  @JsonKey(name: 'color')
  final String color;

  @JsonKey(name: 'sort_order')
  final int sortOrder;

  @JsonKey(name: 'is_archived')
  final bool isArchived;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'updated_at')
  final String updatedAt;

  const DomainModel({
    required this.id,
    required this.userId,
    required this.name,
    this.icon = '🎯',
    this.color = '#6200EE',
    this.sortOrder = 0,
    this.isArchived = false,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Creates a [DomainModel] from a JSON map.
  factory DomainModel.fromJson(Map<String, dynamic> json) =>
      _$DomainModelFromJson(json);

  /// Converts this model to a JSON map.
  Map<String, dynamic> toJson() => _$DomainModelToJson(this);

  /// Converts this model to a domain [DomainEntity].
  DomainEntity toEntity() {
    return DomainEntity(
      id: id,
      userId: userId,
      name: name,
      icon: icon,
      color: color,
      sortOrder: sortOrder,
      isArchived: isArchived,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
    );
  }

  /// Creates a [DomainModel] from a domain [DomainEntity].
  factory DomainModel.fromEntity(DomainEntity entity) {
    return DomainModel(
      id: entity.id,
      userId: entity.userId,
      name: entity.name,
      icon: entity.icon,
      color: entity.color,
      sortOrder: entity.sortOrder,
      isArchived: entity.isArchived,
      createdAt: entity.createdAt.toIso8601String(),
      updatedAt: entity.updatedAt.toIso8601String(),
    );
  }

  /// Creates a JSON map for INSERT (without id, timestamps).
  static Map<String, dynamic> toInsertJson(DomainEntity entity) {
    return {
      'user_id': entity.userId,
      'name': entity.name,
      'icon': entity.icon,
      'color': entity.color,
      'sort_order': entity.sortOrder,
      'is_archived': entity.isArchived,
    };
  }

  /// Creates a JSON map for UPDATE (without id, user_id, timestamps).
  static Map<String, dynamic> toUpdateJson(DomainEntity entity) {
    return {
      'name': entity.name,
      'icon': entity.icon,
      'color': entity.color,
      'sort_order': entity.sortOrder,
      'is_archived': entity.isArchived,
    };
  }
}
