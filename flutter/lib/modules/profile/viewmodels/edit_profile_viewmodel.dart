import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/app.locator.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/repositories/i_auth_repository.dart';
import '../../../services/storage/storage_service.dart';
import '../config/profile_config.dart';

/// ViewModel for the Edit Profile view.
///
/// Handles editing user profile information.
class EditProfileViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final IAuthRepository _authRepository = locator<IAuthRepository>();
  final StorageService _storageService = locator<StorageService>();
  final ImagePicker _imagePicker = ImagePicker();

  /// Profile configuration.
  final ProfileConfig config;

  /// Creates the ViewModel with optional config.
  EditProfileViewModel({ProfileConfig? config})
      : config = config ?? ProfileConfig.defaultConfig;

  // ═══════════════════════════════════════════════════════════════════════════
  // STATE
  // ═══════════════════════════════════════════════════════════════════════════

  UserEntity? _user;

  /// Form field values.
  final Map<String, String> _fieldValues = {};

  /// Form field errors.
  final Map<String, String?> _fieldErrors = {};

  /// Selected avatar file (if changed).
  File? _avatarFile;

  /// Whether the avatar was changed.
  bool get hasAvatarChanged => _avatarFile != null;

  /// Get current avatar file.
  File? get avatarFile => _avatarFile;

  /// Current avatar URL (if not changed).
  String? get avatarUrl => _user?.avatarUrl;

  /// User's initials for avatar placeholder.
  String get initials {
    final first = _fieldValues['first_name']?.isNotEmpty == true
        ? _fieldValues['first_name']![0].toUpperCase()
        : '';
    final last = _fieldValues['last_name']?.isNotEmpty == true
        ? _fieldValues['last_name']![0].toUpperCase()
        : '';
    final display = _fieldValues['display_name'] ?? '';
    if (first.isEmpty && last.isEmpty && display.isNotEmpty) {
      return display[0].toUpperCase();
    }
    return '$first$last';
  }

  /// Whether the form has been modified.
  bool get isDirty {
    if (_avatarFile != null) return true;
    for (final field in config.fields) {
      if (!field.editable) continue;
      final original = _getOriginalValue(field.key);
      final current = _fieldValues[field.key] ?? '';
      if (original != current) return true;
    }
    return false;
  }

  /// Whether the form is valid.
  bool get isValid {
    for (final field in config.fields) {
      if (field.required) {
        final value = _fieldValues[field.key] ?? '';
        if (value.isEmpty) return false;
      }
      if (_fieldErrors[field.key] != null) return false;
    }
    return true;
  }

  /// Whether the form can be submitted.
  bool get canSubmit => isDirty && isValid;

  // ═══════════════════════════════════════════════════════════════════════════
  // BUSY KEYS
  // ═══════════════════════════════════════════════════════════════════════════

  static const String loadingBusyKey = 'loading';
  static const String savingBusyKey = 'saving';
  static const String uploadingBusyKey = 'uploading';

  // ═══════════════════════════════════════════════════════════════════════════
  // LIFECYCLE
  // ═══════════════════════════════════════════════════════════════════════════

  /// Initialize and load user data.
  Future<void> init() async {
    await loadProfile();
  }

  /// Load user profile from repository.
  Future<void> loadProfile() async {
    final result = await runBusyFuture(
      _authRepository.getCurrentUser(),
      busyObject: loadingBusyKey,
    );

    result.fold(
      (failure) => setError(failure.message),
      (user) {
        _user = user;
        _initializeFieldValues();
        rebuildUi();
      },
    );
  }

  /// Initialize field values from user data.
  void _initializeFieldValues() {
    for (final field in config.fields) {
      _fieldValues[field.key] = _getOriginalValue(field.key);
    }
  }

  /// Get original value from user entity.
  String _getOriginalValue(String key) {
    if (_user == null) return '';

    if (key.startsWith('metadata.')) {
      final metaKey = key.substring(9);
      return _user?.metadata[metaKey]?.toString() ?? '';
    }

    return switch (key) {
      'display_name' => _user?.displayName ?? '',
      'first_name' => _user?.firstName ?? '',
      'last_name' => _user?.lastName ?? '',
      'email' => _user?.email ?? '',
      'phone' => _user?.phone ?? _user?.metadata['phone']?.toString() ?? '',
      _ => '',
    };
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // FIELD ACCESS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Get value for a field.
  String getFieldValue(String key) {
    return _fieldValues[key] ?? '';
  }

  /// Get error for a field.
  String? getFieldError(String key) {
    return _fieldErrors[key];
  }

  /// Set value for a field.
  void setFieldValue(String key, String value) {
    _fieldValues[key] = value;
    _validateField(key);
    rebuildUi();
  }

  /// Validate a single field.
  void _validateField(String key) {
    final field = config.fields.firstWhere(
      (f) => f.key == key,
      orElse: () => ProfileField(key: key, labelKey: key),
    );

    final value = _fieldValues[key] ?? '';

    if (field.required && value.isEmpty) {
      _fieldErrors[key] = 'fieldRequired';
      return;
    }

    if (value.isNotEmpty && field.validation != null) {
      switch (field.validation) {
        case 'email':
          final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
          if (!emailRegex.hasMatch(value)) {
            _fieldErrors[key] = 'emailInvalid';
            return;
          }
        case 'phone':
          final phoneRegex = RegExp(r'^\+?[\d\s-]{10,}$');
          if (!phoneRegex.hasMatch(value)) {
            _fieldErrors[key] = 'phoneInvalid';
            return;
          }
      }
    }

    _fieldErrors[key] = null;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // AVATAR
  // ═══════════════════════════════════════════════════════════════════════════

  /// Pick a new avatar image from gallery.
  Future<void> pickAvatar() async {
    try {
      final image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );
      if (image != null) {
        _avatarFile = File(image.path);
        _avatarXFile = image;
        rebuildUi();
      }
    } catch (e) {
      setError('Impossible de charger l\'image');
    }
  }

  /// The XFile for upload.
  XFile? _avatarXFile;

  /// Remove the avatar.
  void removeAvatar() {
    _avatarFile = null;
    rebuildUi();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ACTIONS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Save the profile changes.
  Future<void> save() async {
    if (!canSubmit) return;

    // Validate all fields
    for (final field in config.fields) {
      _validateField(field.key);
    }

    if (!isValid) {
      rebuildUi();
      return;
    }

    // Build update data
    final updateData = <String, dynamic>{};
    final metadataUpdates = <String, dynamic>{};

    for (final field in config.fields) {
      if (!field.editable) continue;

      final value = _fieldValues[field.key] ?? '';
      if (field.isMetadataField) {
        metadataUpdates[field.actualKey] = value;
      } else {
        updateData[field.key] = value;
      }
    }

    // Phone is stored in metadata (profiles table has no phone column;
    // auth.users.phone requires phone-verification flow).
    final phone = updateData.remove('phone') as String?;
    if (phone != null) {
      metadataUpdates['phone'] = phone;
    }

    if (metadataUpdates.isNotEmpty) {
      updateData['metadata'] = {
        ...?_user?.metadata,
        ...metadataUpdates,
      };
    }

    // Handle avatar upload if changed
    if (_avatarXFile != null) {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId != null) {
        final uploadResult = await runBusyFuture(
          _storageService.uploadAvatar(userId: userId, file: _avatarXFile!),
          busyObject: uploadingBusyKey,
        );
        uploadResult.fold(
          (failure) => setError(failure.message),
          (url) => updateData['avatar_url'] = url,
        );
        if (hasError) return;
      }
    }

    final metadata = updateData['metadata'] as Map<String, dynamic>?;

    final result = await runBusyFuture(
      _authRepository.updateProfile(
        firstName: updateData['first_name'] as String?,
        lastName: updateData['last_name'] as String?,
        displayName: updateData['display_name'] as String?,
        avatarUrl: updateData['avatar_url'] as String?,
        metadata: metadata,
      ),
      busyObject: savingBusyKey,
    );

    result.fold(
      (failure) => setError(failure.message),
      (_) => _navigationService.back(result: true),
    );
  }

  /// Cancel editing and go back.
  void cancel() {
    _navigationService.back();
  }

  /// Go back with optional confirmation if dirty.
  Future<bool> onWillPop() async {
    if (!isDirty) return true;

    // TODO: Show confirmation dialog
    return true;
  }
}
