import 'package:flutter/material.dart';

import '../../../design_system/design_system.dart';
import '../config/settings_config.dart';

/// A section widget for grouped settings.
class SettingsSectionWidget extends StatelessWidget {
  /// Section configuration.
  final SettingsSection section;

  /// Current theme mode (for theme selector).
  final ThemeMode? themeMode;

  /// Current locale (for language selector).
  final Locale? locale;

  /// Callback for theme change.
  final ValueChanged<ThemeMode>? onThemeChanged;

  /// Callback for locale change.
  final ValueChanged<Locale>? onLocaleChanged;

  /// Callback when item is tapped.
  final void Function(SettingsItem item)? onItemTap;

  /// Callback to get toggle value.
  final bool Function(String itemId)? getToggleValue;

  /// Callback when toggle changes.
  final void Function(String itemId, bool value)? onToggleChanged;

  /// App version (for version info).
  final String? appVersion;

  const SettingsSectionWidget({
    required this.section,
    this.themeMode,
    this.locale,
    this.onThemeChanged,
    this.onLocaleChanged,
    this.onItemTap,
    this.getToggleValue,
    this.onToggleChanged,
    this.appVersion,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppListSection(
      title: _getLocalizedTitle(context, section.titleKey),
      showDividers: true,
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      children: [
        for (final item in section.items) _buildItem(context, item),
      ],
    );
  }

  Widget _buildItem(BuildContext context, SettingsItem item) {
    return switch (item.type) {
      SettingsItemType.themeSelector => _buildThemeSelector(context, item),
      SettingsItemType.languageSelector =>
        _buildLanguageSelector(context, item),
      SettingsItemType.toggle => _buildToggle(context, item),
      SettingsItemType.info => _buildInfo(context, item),
      _ => _buildTappableItem(context, item),
    };
  }

  Widget _buildTappableItem(BuildContext context, SettingsItem item) {
    if (item.destructive) {
      return AppIconListTile(
        icon: item.icon ?? Icons.warning_outlined,
        title: _getLocalizedTitle(context, item.titleKey),
        isDestructive: true,
        showChevron: item.type == SettingsItemType.navigation ||
            item.type == SettingsItemType.link,
        onTap: () => onItemTap?.call(item),
      );
    }

    return AppIconListTile(
      icon: item.icon ?? Icons.settings_outlined,
      title: _getLocalizedTitle(context, item.titleKey),
      showChevron: item.type == SettingsItemType.navigation ||
          item.type == SettingsItemType.link,
      onTap: () => onItemTap?.call(item),
    );
  }

  Widget _buildThemeSelector(BuildContext context, SettingsItem item) {
    final currentLabel = switch (themeMode) {
      ThemeMode.system => 'System',
      ThemeMode.light => 'Light',
      ThemeMode.dark => 'Dark',
      null => 'System',
    };

    return AppIconListTile(
      icon: item.icon ?? Icons.palette_outlined,
      title: _getLocalizedTitle(context, item.titleKey),
      showChevron: true,
      trailing: Text(
        currentLabel,
        style: AppTypography.bodyMedium.copyWith(
          color: AppColors.neutral500,
        ),
      ),
      onTap: () => onItemTap?.call(item),
    );
  }

  Widget _buildLanguageSelector(BuildContext context, SettingsItem item) {
    final currentLabel = switch (locale?.languageCode) {
      'en' => 'English',
      'fr' => 'Français',
      _ => locale?.languageCode.toUpperCase() ?? 'FR',
    };

    return AppIconListTile(
      icon: item.icon ?? Icons.language_outlined,
      title: _getLocalizedTitle(context, item.titleKey),
      showChevron: true,
      trailing: Text(
        currentLabel,
        style: AppTypography.bodyMedium.copyWith(
          color: AppColors.neutral500,
        ),
      ),
      onTap: () => onItemTap?.call(item),
    );
  }

  Widget _buildToggle(BuildContext context, SettingsItem item) {
    final value = getToggleValue?.call(item.id) ?? false;

    return AppSwitchListTile(
      icon: item.icon,
      title: _getLocalizedTitle(context, item.titleKey),
      value: value,
      onChanged: (newValue) => onToggleChanged?.call(item.id, newValue),
    );
  }

  Widget _buildInfo(BuildContext context, SettingsItem item) {
    final value = item.id == 'version' ? (appVersion ?? '') : '';

    return AppIconListTile(
      icon: item.icon ?? Icons.info_outline,
      title: _getLocalizedTitle(context, item.titleKey),
      showChevron: false,
      trailing: Text(
        value,
        style: AppTypography.bodyMedium.copyWith(
          color: AppColors.neutral500,
        ),
      ),
    );
  }

  String _getLocalizedTitle(BuildContext context, String key) {
    // In a real app, use context.l10n to get localized strings
    // For now, return formatted key as fallback
    return switch (key) {
      'settingsAppearance' => 'Appearance',
      'settingsNotifications' => 'Notifications',
      'settingsLegal' => 'Legal',
      'settingsAccount' => 'Account',
      'settingsAbout' => 'About',
      'settingsTheme' => 'Theme',
      'settingsLanguage' => 'Language',
      'settingsPushNotifications' => 'Push Notifications',
      'settingsEmailNotifications' => 'Email Notifications',
      'settingsTerms' => 'Terms of Service',
      'settingsPrivacy' => 'Privacy Policy',
      'settingsChangePassword' => 'Change Password',
      'settingsLogout' => 'Logout',
      'settingsDeleteAccount' => 'Delete Account',
      'settingsVersion' => 'Version',
      'settingsRateApp' => 'Rate App',
      'settingsShareApp' => 'Share App',
      _ => key,
    };
  }
}
