import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/repositories/i_auth_repository.dart';
import '../../../domain/repositories/i_domain_repository.dart';
import '../../../domain/repositories/i_habit_repository.dart';
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
    final result = await runBusyFuture(
      _authRepository.deleteAccount(),
      busyObject: logoutBusyKey,
    );

    result.fold(
      (failure) => setError(failure.message),
      (_) => _navigationService.clearStackAndShow(Routes.loginView),
    );
  }

  /// Export user data (GDPR).
  ///
  /// Gathers all user data (profile, domains, habits, logs) into JSON
  /// and opens the system share sheet.
  Future<void> exportData() async {
    try {
      setBusy(true);

      final habitRepo = locator<IHabitRepository>();
      final domainRepo = locator<IDomainRepository>();

      // Gather data in parallel
      final results = await Future.wait([
        habitRepo.getHabits(),
        domainRepo.getDomains(),
      ]);

      final habits = results[0].fold((_) => [], (h) => h);
      final domains = results[1].fold((_) => [], (d) => d);

      final exportPayload = {
        'exported_at': DateTime.now().toIso8601String(),
        'user': {
          'display_name': _user?.displayName,
          'email': _user?.email,
          'first_name': _user?.firstName,
          'last_name': _user?.lastName,
          'created_at': _user?.createdAt.toIso8601String(),
          'metadata': _user?.metadata,
        },
        'domains': domains
            .map((d) => {
                  'id': d.id,
                  'name': d.name,
                  'emoji': d.emoji,
                  'color': d.color,
                  'is_archived': d.isArchived,
                })
            .toList(),
        'habits': habits
            .map((h) => {
                  'id': h.id,
                  'name': h.name,
                  'description': h.description,
                  'frequency': h.frequency.name,
                  'domain_id': h.domainId,
                  'is_archived': h.isArchived,
                  'current_streak': h.currentStreak,
                  'best_streak': h.bestStreak,
                  'created_at': h.createdAt?.toIso8601String(),
                })
            .toList(),
      };

      final jsonStr = const JsonEncoder.withIndent('  ').convert(exportPayload);

      if (kIsWeb) {
        // On web, just share text
        await Share.share(jsonStr);
      } else {
        // On mobile/desktop, write to file and share
        final dir = await getTemporaryDirectory();
        final file = File(
            '${dir.path}/lifeflow_export_${DateTime.now().millisecondsSinceEpoch}.json');
        await file.writeAsString(jsonStr);
        await Share.shareXFiles([XFile(file.path)],
            text: 'LifeFlow — Export de données');
      }
    } catch (e) {
      setError('Erreur lors de l\'export : $e');
    } finally {
      setBusy(false);
    }
  }
}
