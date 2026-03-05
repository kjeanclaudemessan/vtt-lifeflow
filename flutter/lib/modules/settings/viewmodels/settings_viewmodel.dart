import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../domain/repositories/i_auth_repository.dart';
import '../../../services/analytics/analytics_service.dart';
import '../../../services/database/app_database.dart';
import '../../../services/push_notification/push_notification_service.dart';
import '../../../services/settings/app_settings_service.dart';
import '../../../services/storage/local_storage_service.dart';
import '../../../services/local_notification/local_notification_scheduler.dart';
import '../config/settings_config.dart';

/// ViewModel for the Settings view.
///
/// Handles theme, language, notifications, and account actions.
class SettingsViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();
  final IAuthRepository _authRepository = locator<IAuthRepository>();
  final LocalStorageService _localStorage = locator<LocalStorageService>();
  final AppSettingsService _appSettings = locator<AppSettingsService>();

  /// Settings configuration.
  final SettingsConfig config;

  /// Creates the ViewModel with optional config.
  SettingsViewModel({SettingsConfig? config})
    : config = config ?? SettingsConfig.defaultConfig;

  // ═══════════════════════════════════════════════════════════════════════════
  // STATE
  // ═══════════════════════════════════════════════════════════════════════════

  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('fr');
  String _appVersion = '';
  String _buildNumber = '';

  bool _pushNotificationsEnabled = true;
  bool _emailNotificationsEnabled = true;
  bool _streakFreezeEnabled = true;

  /// Current theme mode.
  ThemeMode get themeMode => _themeMode;

  /// Current locale.
  Locale get locale => _locale;

  /// App version string.
  String get appVersion => _appVersion;

  /// Build number.
  String get buildNumber => _buildNumber;

  /// Full version string (e.g., "1.0.0 (42)").
  String get fullVersion =>
      _buildNumber.isNotEmpty ? '$_appVersion ($_buildNumber)' : _appVersion;

  /// Whether push notifications are enabled.
  bool get pushNotificationsEnabled => _pushNotificationsEnabled;

  /// Whether email notifications are enabled.
  bool get emailNotificationsEnabled => _emailNotificationsEnabled;

  /// Whether streak freeze is enabled.
  bool get streakFreezeEnabled => _streakFreezeEnabled;

  /// Get theme mode display name.
  String getThemeModeLabel(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.system => 'Système',
      ThemeMode.light => 'Clair',
      ThemeMode.dark => 'Sombre',
    };
  }

  /// Get locale display name.
  String getLocaleLabel(Locale locale) {
    return switch (locale.languageCode) {
      'en' => 'English',
      'fr' => 'Français',
      _ => locale.languageCode.toUpperCase(),
    };
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BUSY KEYS
  // ═══════════════════════════════════════════════════════════════════════════

  static const String logoutBusyKey = 'logout';
  static const String deleteAccountBusyKey = 'deleteAccount';

  // ═══════════════════════════════════════════════════════════════════════════
  // LIFECYCLE
  // ═══════════════════════════════════════════════════════════════════════════

  /// Initialize the ViewModel.
  Future<void> init() async {
    await _loadSettings();
    await _loadAppInfo();
  }

  /// Load saved settings from storage.
  Future<void> _loadSettings() async {
    final themeIndex = _localStorage.getInt('theme_mode') ?? 0;
    _themeMode = ThemeMode.values[themeIndex];

    final localeCode = _localStorage.getString('locale') ?? 'fr';
    _locale = Locale(localeCode);

    _pushNotificationsEnabled =
        _localStorage.getBool('push_notifications') ?? true;
    _emailNotificationsEnabled =
        _localStorage.getBool('email_notifications') ?? true;

    _streakFreezeEnabled =
        _localStorage.getBool('streak_freeze_enabled') ?? true;

    rebuildUi();
  }

  /// Load app version info.
  Future<void> _loadAppInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      _appVersion = packageInfo.version;
      _buildNumber = packageInfo.buildNumber;
      rebuildUi();
    } catch (_) {
      _appVersion = '1.0.0';
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // THEME
  // ═══════════════════════════════════════════════════════════════════════════

  /// Set the theme mode.
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _appSettings.setThemeMode(mode);
    rebuildUi();
  }

  /// Show theme picker bottom sheet.
  void showThemePicker() {
    // This will be called from the view to show the picker
    rebuildUi();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // LANGUAGE
  // ═══════════════════════════════════════════════════════════════════════════

  /// Set the locale.
  Future<void> setLocale(Locale newLocale) async {
    _locale = newLocale;
    await _appSettings.setLocale(newLocale);
    rebuildUi();
  }

  /// Show language picker bottom sheet.
  void showLanguagePicker() {
    // This will be called from the view to show the picker
    rebuildUi();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // NOTIFICATIONS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Toggle push notifications.
  Future<void> togglePushNotifications(bool value) async {
    _pushNotificationsEnabled = value;
    await _localStorage.setBool('push_notifications', value);

    // Enable/disable local notification scheduler
    final scheduler = locator<LocalNotificationScheduler>();
    if (!value) {
      // Cancel all scheduled local notifications when disabled
      await scheduler.rescheduleAll([]);
    }
    // Note: FCM push cannot be toggled at runtime without Firebase config.
    // The local scheduler handles habit reminders and weekly bilan.

    rebuildUi();
  }

  /// Toggle email notifications.
  Future<void> toggleEmailNotifications(bool value) async {
    _emailNotificationsEnabled = value;
    await _localStorage.setBool('email_notifications', value);
    rebuildUi();
  }

  /// Toggle streak freeze feature.
  Future<void> toggleStreakFreeze(bool value) async {
    _streakFreezeEnabled = value;
    await _localStorage.setBool('streak_freeze_enabled', value);
    rebuildUi();
  }

  /// Get toggle value for a specific item.
  bool getToggleValue(String itemId) {
    return switch (itemId) {
      'push_notifications' => _pushNotificationsEnabled,
      'email_notifications' => _emailNotificationsEnabled,
      'streak_freeze' => _streakFreezeEnabled,
      _ => false,
    };
  }

  /// Set toggle value for a specific item.
  Future<void> setToggleValue(String itemId, bool value) async {
    switch (itemId) {
      case 'push_notifications':
        await togglePushNotifications(value);
      case 'email_notifications':
        await toggleEmailNotifications(value);
      case 'streak_freeze':
        await toggleStreakFreeze(value);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // LINKS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Open terms of service.
  Future<void> openTerms() async {
    final url = config.termsUrl;
    if (url != null) {
      await _launchUrl(url);
    }
  }

  /// Open privacy policy.
  Future<void> openPrivacy() async {
    final url = config.privacyUrl;
    if (url != null) {
      await _launchUrl(url);
    }
  }

  /// Launch external URL.
  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ACCOUNT ACTIONS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Change password — navigate to forgot-password flow (sends reset email).
  void changePassword() {
    _navigationService.navigateTo(Routes.forgotPasswordView);
  }

  /// Logout the user.
  Future<void> logout() async {
    final confirmed = await _dialogService.showConfirmationDialog(
      title: 'Log out',
      description: 'Are you sure you want to log out?',
      confirmationTitle: 'Log out',
      cancelTitle: 'Cancel',
    );

    if (confirmed?.confirmed != true) return;

    final result = await runBusyFuture(
      _authRepository.signOut(),
      busyObject: logoutBusyKey,
    );

    result.fold((failure) => setError(failure.message), (_) {
      locator<PushNotificationService>().removeTokenFromSupabase();
      locator<AppDatabase>().clearAll();
      locator<AnalyticsService>().capture('user_logged_out');
      locator<AnalyticsService>().reset();
      _navigationService.clearStackAndShow(Routes.loginView);
    });
  }

  /// Delete the user's account.
  Future<void> deleteAccount() async {
    final confirmed = await _dialogService.showConfirmationDialog(
      title: 'Delete Account',
      description:
          'Are you sure you want to delete your account? This action cannot be undone.',
      confirmationTitle: 'Delete',
      cancelTitle: 'Cancel',
    );

    if (confirmed?.confirmed != true) return;

    final result = await runBusyFuture(
      _authRepository.deleteAccount(),
      busyObject: deleteAccountBusyKey,
    );

    result.fold(
      (failure) => setError(failure.message),
      (_) => _navigationService.clearStackAndShow(Routes.loginView),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ABOUT ACTIONS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Rate the app.
  Future<void> rateApp() async {
    // Android Play Store URL (update with actual listing when published)
    const playStoreUrl =
        'https://play.google.com/store/apps/details?id=com.vitatech.lifeflow';
    // iOS App Store URL (update with actual listing when published)
    const appStoreUrl = 'https://apps.apple.com/app/lifeflow/id000000000';

    final url = defaultTargetPlatform == TargetPlatform.iOS
        ? appStoreUrl
        : playStoreUrl;
    await _launchUrl(url);
  }

  /// Share the app.
  Future<void> shareApp() async {
    const text =
        'D\u00e9couvre LifeFlow, l\u2019app pour construire tes habitudes et suivre ton temps ! \ud83d\ude80\nhttps://vttlife.com';
    await Share.share(text);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ITEM ACTIONS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Handle tap on a settings item.
  Future<void> onItemTap(SettingsItem item) async {
    switch (item.id) {
      // Appearance
      case 'theme':
        showThemePicker();
      case 'language':
        showLanguagePicker();

      // Legal
      case 'terms':
        await openTerms();
      case 'privacy':
        await openPrivacy();

      // Account
      case 'change_password':
        changePassword();
      case 'logout':
        await logout();
      case 'delete_account':
        await deleteAccount();

      // Profile
      case 'profile':
        _navigationService.navigateTo(Routes.profileView);
      case 'notification_channels':
        _navigationService.navigateTo(Routes.notificationsView);

      // About
      case 'rate':
        await rateApp();
      case 'share':
        await shareApp();
    }
  }

  /// Navigate back.
  void goBack() {
    _navigationService.back();
  }
}
