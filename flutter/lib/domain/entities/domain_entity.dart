import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Default domain names seeded at onboarding.
const kDefaultDomainNames = [
  'Santé',
  'Travail',
  'Relations',
  'Finances',
  'Développement personnel',
];

/// Represents a life domain in the domain layer.
///
/// Domains categorize habits into areas of life (e.g., Health, Work, etc.).
/// Used for grouping habits and calculating time per domain.
class DomainEntity extends Equatable {
  /// Unique identifier.
  final String id;

  /// Owner user ID.
  final String userId;

  /// Domain name (e.g., "Santé", "Travail").
  final String name;

  /// Emoji icon for display.
  final String icon;

  /// Hex color string (e.g., "#4CAF50").
  final String color;

  /// Sort order for drag-and-drop reordering.
  final int sortOrder;

  /// Whether the domain is archived (soft delete).
  final bool isArchived;

  /// When the domain was created.
  final DateTime createdAt;

  /// When the domain was last updated.
  final DateTime updatedAt;

  const DomainEntity({
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

  // ─────────────────────────────────────────────────────────────────
  // Computed Properties
  // ─────────────────────────────────────────────────────────────────

  /// Whether this domain is one of the 5 default domains.
  bool get isDefault => kDefaultDomainNames.contains(name);

  /// Parses [color] hex string to a Flutter [Color].
  Color get displayColor {
    try {
      final hex = color.replaceFirst('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      return const Color(0xFF6200EE);
    }
  }

  // ─────────────────────────────────────────────────────────────────
  // Copy
  // ─────────────────────────────────────────────────────────────────

  /// Creates a copy with the given fields replaced.
  DomainEntity copyWith({
    String? id,
    String? userId,
    String? name,
    String? icon,
    String? color,
    int? sortOrder,
    bool? isArchived,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DomainEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      sortOrder: sortOrder ?? this.sortOrder,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // ─────────────────────────────────────────────────────────────────
  // Factories
  // ─────────────────────────────────────────────────────────────────

  /// Creates an empty domain for form initialization.
  factory DomainEntity.empty() {
    final now = DateTime.now();
    return DomainEntity(
      id: '',
      userId: '',
      name: '',
      icon: '🎯',
      color: '#6200EE',
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Creates a mock domain for testing.
  factory DomainEntity.mock({
    String id = 'mock-domain-id',
    String name = 'Santé',
    String icon = '💪',
    String color = '#4CAF50',
    int sortOrder = 0,
    bool isArchived = false,
  }) {
    final now = DateTime.now();
    return DomainEntity(
      id: id,
      userId: 'mock-user-id',
      name: name,
      icon: icon,
      color: color,
      sortOrder: sortOrder,
      isArchived: isArchived,
      createdAt: now,
      updatedAt: now,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        icon,
        color,
        sortOrder,
        isArchived,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() => 'DomainEntity(id: $id, name: $name, icon: $icon)';
}
