import 'package:flutter/material.dart';

/// Configuration for the Profile module.
///
/// Customizes which fields are displayed, avatar settings,
/// and visual style.
class ProfileConfig {
  /// Fields to display/edit in the profile.
  final List<ProfileField> fields;

  /// Enable avatar display and editing.
  final bool enableAvatar;

  /// Maximum avatar size in MB.
  final double maxAvatarSizeMb;

  /// Allow account deletion.
  final bool enableDeleteAccount;

  /// Allow data export (GDPR compliance).
  final bool enableDataExport;

  /// Visual style of the profile.
  final ProfileStyle style;

  /// Show email verification status.
  final bool showEmailVerification;

  /// Show profile completion indicator.
  final bool showProfileCompletion;

  const ProfileConfig({
    this.fields = defaultFields,
    this.enableAvatar = true,
    this.maxAvatarSizeMb = 5.0,
    this.enableDeleteAccount = true,
    this.enableDataExport = false,
    this.style = ProfileStyle.card,
    this.showEmailVerification = true,
    this.showProfileCompletion = false,
  });

  /// Default fields for a basic profile.
  static const defaultFields = [
    ProfileField.displayName(required: true),
    ProfileField.email(editable: false),
    ProfileField.phone(required: false),
  ];

  /// Default config instance.
  static const ProfileConfig defaultConfig = ProfileConfig();
}

/// Definition of a profile field.
class ProfileField {
  /// Unique key for the field.
  final String key;

  /// Localization key for the label.
  final String labelKey;

  /// Type of input field.
  final ProfileFieldType type;

  /// Whether the field is required.
  final bool required;

  /// Whether the field can be edited.
  final bool editable;

  /// Validation pattern (optional).
  final String? validation;

  /// Options for select/multiSelect fields.
  final List<String>? options;

  /// Icon for the field.
  final IconData? icon;

  const ProfileField({
    required this.key,
    required this.labelKey,
    this.type = ProfileFieldType.text,
    this.required = false,
    this.editable = true,
    this.validation,
    this.options,
    this.icon,
  });

  /// Factory for display name field.
  const ProfileField.displayName({bool required = true})
      : key = 'display_name',
        labelKey = 'fullName',
        type = ProfileFieldType.text,
        required = required,
        editable = true,
        validation = null,
        options = null,
        icon = Icons.person_outline_rounded;

  /// Factory for first name field.
  const ProfileField.firstName({bool required = false})
      : key = 'first_name',
        labelKey = 'firstName',
        type = ProfileFieldType.text,
        required = required,
        editable = true,
        validation = null,
        options = null,
        icon = Icons.person_outline_rounded;

  /// Factory for last name field.
  const ProfileField.lastName({bool required = false})
      : key = 'last_name',
        labelKey = 'lastName',
        type = ProfileFieldType.text,
        required = required,
        editable = true,
        validation = null,
        options = null,
        icon = null;

  /// Factory for email field.
  const ProfileField.email({bool editable = false})
      : key = 'email',
        labelKey = 'email',
        type = ProfileFieldType.email,
        required = true,
        editable = editable,
        validation = 'email',
        options = null,
        icon = Icons.email_outlined;

  /// Factory for phone field.
  const ProfileField.phone({bool required = false})
      : key = 'phone',
        labelKey = 'phoneNumber',
        type = ProfileFieldType.phone,
        required = required,
        editable = true,
        validation = 'phone',
        options = null,
        icon = Icons.phone_outlined;

  /// Factory for custom fields (stored in metadata JSONB).
  const ProfileField.custom({
    required String key,
    required String label,
    ProfileFieldType type = ProfileFieldType.text,
    bool required = false,
    List<String>? options,
    IconData? icon,
  })  : key = 'metadata.$key',
        labelKey = label,
        type = type,
        required = required,
        editable = true,
        validation = null,
        options = options,
        icon = icon;

  /// Whether this field is stored in metadata JSONB.
  bool get isMetadataField => key.startsWith('metadata.');

  /// Get the actual key for metadata fields.
  String get actualKey => isMetadataField ? key.substring(9) : key;
}

/// Types of profile fields.
enum ProfileFieldType {
  /// Single line text input.
  text,

  /// Email input with validation.
  email,

  /// Phone number input.
  phone,

  /// Numeric input.
  number,

  /// Date picker.
  date,

  /// Single selection dropdown.
  select,

  /// Multi-selection.
  multiSelect,

  /// Multi-line text area.
  textarea,
}

/// Visual styles for the profile.
enum ProfileStyle {
  /// Card-based layout.
  card,

  /// List-based layout.
  list,

  /// Hero header with avatar.
  hero,
}
