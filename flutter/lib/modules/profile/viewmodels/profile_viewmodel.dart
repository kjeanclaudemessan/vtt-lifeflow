import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/repositories/i_auth_repository.dart';
import '../config/profile_config.dart';

/// ViewModel for the Profile view.
///
/// Handles displaying user profile information.
class ProfileViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final IAuthRepository _authRepository = locator<IAuthRepository>();

  /// Profile configuration.
  final ProfileConfig config;

  /// Creates the ViewModel with optional config.
  ProfileViewModel({ProfileConfig? config})
      : config = config ?? ProfileConfig.defaultConfig;

  // ═══════════════════════════════════════════════════════════════════════════
  // STATE
  // ═══════════════════════════════════════════════════════════════════════════

  UserEntity? _user;

  /// Current user.
  UserEntity? get user => _user;

  /// User's display name.
  String get displayName => _user?.displayName ?? '';

  /// User's email.
  String get email => _user?.email ?? '';

  /// User's avatar URL.
  String? get avatarUrl => _user?.avatarUrl;

  /// User's initials for avatar placeholder.
  String get initials {
    final first = _user?.firstName?.isNotEmpty == true
        ? _user!.firstName![0].toUpperCase()
        : '';
    final last = _user?.lastName?.isNotEmpty == true
        ? _user!.lastName![0].toUpperCase()
        : '';
    if (first.isEmpty && last.isEmpty && displayName.isNotEmpty) {
      return displayName[0].toUpperCase();
    }
    return '$first$last';
  }

  /// Profile completion percentage (0-100).
  int get profileCompletion {
    if (_user == null) return 0;

    int total = 0;
    int completed = 0;

    for (final field in config.fields) {
      total++;
      final value = _getFieldValue(field.key);
      if (value != null && value.isNotEmpty) {
        completed++;
      }
    }

    if (config.enableAvatar) {
      total++;
      if (_user?.avatarUrl != null) completed++;
    }

    return total > 0 ? ((completed / total) * 100).round() : 0;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BUSY KEYS
  // ═══════════════════════════════════════════════════════════════════════════

  static const String loadingBusyKey = 'loading';
  static const String logoutBusyKey = 'logout';

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
        rebuildUi();
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // FIELD ACCESS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Get value for a field key.
  String? _getFieldValue(String key) {
    if (_user == null) return null;

    if (key.startsWith('metadata.')) {
      final metaKey = key.substring(9);
      return _user?.metadata[metaKey]?.toString();
    }

    return switch (key) {
      'display_name' => _user?.displayName,
      'first_name' => _user?.firstName,
      'last_name' => _user?.lastName,
      'email' => _user?.email,
      'phone' => _user?.phone ?? _user?.metadata['phone']?.toString(),
      'avatar_url' => _user?.avatarUrl,
      _ => null,
    };
  }

  /// Get display value for a profile field.
  String getFieldDisplayValue(ProfileField field) {
    return _getFieldValue(field.key) ?? '';
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ACTIONS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Navigate to edit profile and reload on return.
  Future<void> editProfile() async {
    final result = await _navigationService.navigateTo(Routes.editProfileView);
    if (result == true) {
      await loadProfile();
    }
  }

  /// Logout the user.
  Future<void> logout() async {
    final result = await runBusyFuture(
      _authRepository.signOut(),
      busyObject: logoutBusyKey,
    );

    result.fold(
      (failure) => setError(failure.message),
      (_) => _navigationService.clearStackAndShow(Routes.loginView),
    );
  }

  /// Change password — navigate to forgot-password flow (sends reset email).
  void changePassword() {
    _navigationService.navigateTo(Routes.forgotPasswordView);
  }

  /// Delete account.
  Future<void> deleteAccount() async {
    // TODO: Implement account deletion
  }

  /// Export user data (GDPR).
  Future<void> exportData() async {
    // TODO: Implement data export
  }
}
