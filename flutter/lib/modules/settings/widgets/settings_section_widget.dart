import 'package:flutter/material.dart';

import '../../../core/core.dart';
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
    final l10n = context.l10n;
    final currentLabel = switch (themeMode) {
      ThemeMode.system => l10n.settingsThemeSystem,
      ThemeMode.light => l10n.settingsThemeLight,
      ThemeMode.dark => l10n.settingsThemeDark,
      null => l10n.settingsThemeSystem,
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
    final l10n = context.l10n;
    return switch (key) {
      'settingsAppearance' => l10n.settingsAppearance,
      'settingsNotifications' => l10n.settingsNotifications,
      'settingsLegal' => l10n.settingsLegal,
      'settingsAccount' => l10n.settingsAccount,
      'settingsAbout' => l10n.settingsAbout,
      'settingsTheme' => l10n.settingsTheme,
      'settingsLanguage' => l10n.settingsLanguage,
      'settingsPushNotifications' => l10n.settingsPushNotifications,
      'settingsEmailNotifications' => l10n.settingsEmailNotifications,
      'notificationPreferences' => l10n.notificationPreferences,
      'settingsTerms' => l10n.settingsTerms,
      'settingsPrivacy' => l10n.settingsPrivacy,
      'profile' => l10n.profile,
      'settingsChangePassword' => l10n.settingsChangePassword,
      'settingsLogout' => l10n.settingsLogout,
      'settingsDeleteAccount' => l10n.settingsDeleteAccount,
      'settingsVersion' => l10n.settingsVersion,
      'settingsRateApp' => l10n.settingsRateApp,
      'settingsShareApp' => l10n.settingsShareApp,
      'habitsTitle' => l10n.habitsTitle,
      'streakFreeze' => l10n.streakFreeze,
      _ => key,
    };
  }
}
