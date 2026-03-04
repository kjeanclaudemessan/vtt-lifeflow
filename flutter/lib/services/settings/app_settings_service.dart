import 'package:flutter/material.dart';

import '../../app/app.locator.dart';
import '../storage/local_storage_service.dart';

/// Global reactive service for app-wide settings (theme, locale).
///
/// Exposes [ValueNotifier]s that [main.dart] listens to so changes
/// in Settings propagate instantly without restart.
class AppSettingsService {
  final LocalStorageService _storage = locator<LocalStorageService>();

  // ═══════════════════════════════════════════════════════════════════════════
  // THEME
  // ═══════════════════════════════════════════════════════════════════════════

  late final ValueNotifier<ThemeMode> themeMode;

  // ═══════════════════════════════════════════════════════════════════════════
  // LOCALE
  // ═══════════════════════════════════════════════════════════════════════════

  late final ValueNotifier<Locale> locale;

  // ═══════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════

  /// Loads persisted values from local storage.
  /// Must be called after [LocalStorageService.init].
  void init() {
    final themeIndex = _storage.getInt('theme_mode') ?? 0;
    themeMode = ValueNotifier(ThemeMode.values[themeIndex]);

    final localeCode = _storage.getString('locale') ?? 'fr';
    locale = ValueNotifier(Locale(localeCode));
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SETTERS (with persistence)
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode.value = mode;
    await _storage.setInt('theme_mode', mode.index);
  }

  Future<void> setLocale(Locale newLocale) async {
    locale.value = newLocale;
    await _storage.setString('locale', newLocale.languageCode);
  }
}
