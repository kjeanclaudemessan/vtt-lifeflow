import 'package:flutter/material.dart';

/// Configuration for the Settings module.
class SettingsConfig {
  /// Sections to display.
  final List<SettingsSection> sections;

  /// Visual style.
  final SettingsStyle style;

  /// Show version info at bottom.
  final bool showVersion;

  /// Terms of service URL.
  final String? termsUrl;

  /// Privacy policy URL.
  final String? privacyUrl;

  /// Rate app store URL (iOS).
  final String? appStoreUrl;

  /// Rate app store URL (Android).
  final String? playStoreUrl;

  const SettingsConfig({
    this.sections = const [],
    this.style = SettingsStyle.grouped,
    this.showVersion = true,
    this.termsUrl,
    this.privacyUrl,
    this.appStoreUrl,
    this.playStoreUrl,
  });

  /// Default configuration with all sections.
  static SettingsConfig get defaultConfig => SettingsConfig(
        sections: [
          SettingsSection.appearance(),
          SettingsSection.notifications(),
          SettingsSection.legal(),
          SettingsSection.account(),
          SettingsSection.about(),
        ],
      );

  /// Minimal configuration (appearance + account only).
  static SettingsConfig get minimalConfig => SettingsConfig(
        sections: [
          SettingsSection.appearance(),
          SettingsSection.account(),
        ],
      );
}

/// Section of settings.
class SettingsSection {
  /// Unique identifier.
  final String id;

  /// Title key for i18n.
  final String titleKey;

  /// Items in this section.
  final List<SettingsItem> items;

  /// Optional icon.
  final IconData? icon;

  const SettingsSection({
    required this.id,
    required this.titleKey,
    required this.items,
    this.icon,
  });

  /// Appearance section (theme, language).
  factory SettingsSection.appearance() => const SettingsSection(
        id: 'appearance',
        titleKey: 'settingsAppearance',
        icon: Icons.palette_outlined,
        items: [
          SettingsItem.themeSelector(),
          SettingsItem.languageSelector(),
        ],
      );

  /// Notifications section.
  factory SettingsSection.notifications() => const SettingsSection(
        id: 'notifications',
        titleKey: 'settingsNotifications',
        icon: Icons.notifications_outlined,
        items: [
          SettingsItem.pushNotifications(),
          SettingsItem.emailNotifications(),
        ],
      );

  /// Legal section (terms, privacy).
  factory SettingsSection.legal() => const SettingsSection(
        id: 'legal',
        titleKey: 'settingsLegal',
        icon: Icons.description_outlined,
        items: [
          SettingsItem.termsOfService(),
          SettingsItem.privacyPolicy(),
        ],
      );

  /// Account section (logout, delete).
  factory SettingsSection.account() => const SettingsSection(
        id: 'account',
        titleKey: 'settingsAccount',
        icon: Icons.person_outlined,
        items: [
          SettingsItem.changePassword(),
          SettingsItem.logout(),
          SettingsItem.deleteAccount(),
        ],
      );

  /// About section (version, rate).
  factory SettingsSection.about() => const SettingsSection(
        id: 'about',
        titleKey: 'settingsAbout',
        icon: Icons.info_outlined,
        items: [
          SettingsItem.appVersion(),
          SettingsItem.rateApp(),
          SettingsItem.shareApp(),
        ],
      );
}

/// Individual settings item.
class SettingsItem {
  /// Unique identifier.
  final String id;

  /// Title key for i18n.
  final String titleKey;

  /// Subtitle key for i18n (optional).
  final String? subtitleKey;

  /// Item type.
  final SettingsItemType type;

  /// Icon.
  final IconData? icon;

  /// URL for link items.
  final String? url;

  /// Whether this is a destructive action (shows in red).
  final bool destructive;

  /// Whether this requires confirmation.
  final bool requiresConfirmation;

  const SettingsItem({
    required this.id,
    required this.titleKey,
    this.subtitleKey,
    required this.type,
    this.icon,
    this.url,
    this.destructive = false,
    this.requiresConfirmation = false,
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // APPEARANCE
  // ═══════════════════════════════════════════════════════════════════════════

  /// Theme selector item.
  const SettingsItem.themeSelector()
      : this(
          id: 'theme',
          titleKey: 'settingsTheme',
          subtitleKey: 'settingsThemeSubtitle',
          type: SettingsItemType.themeSelector,
          icon: Icons.dark_mode_outlined,
        );

  /// Language selector item.
  const SettingsItem.languageSelector()
      : this(
          id: 'language',
          titleKey: 'settingsLanguage',
          subtitleKey: 'settingsLanguageSubtitle',
          type: SettingsItemType.languageSelector,
          icon: Icons.language_outlined,
        );

  // ═══════════════════════════════════════════════════════════════════════════
  // NOTIFICATIONS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Push notifications toggle.
  const SettingsItem.pushNotifications()
      : this(
          id: 'push_notifications',
          titleKey: 'settingsPushNotifications',
          type: SettingsItemType.toggle,
          icon: Icons.notifications_active_outlined,
        );

  /// Email notifications toggle.
  const SettingsItem.emailNotifications()
      : this(
          id: 'email_notifications',
          titleKey: 'settingsEmailNotifications',
          type: SettingsItemType.toggle,
          icon: Icons.email_outlined,
        );

  // ═══════════════════════════════════════════════════════════════════════════
  // LEGAL
  // ═══════════════════════════════════════════════════════════════════════════

  /// Terms of service link.
  const SettingsItem.termsOfService()
      : this(
          id: 'terms',
          titleKey: 'settingsTerms',
          type: SettingsItemType.link,
          icon: Icons.article_outlined,
        );

  /// Privacy policy link.
  const SettingsItem.privacyPolicy()
      : this(
          id: 'privacy',
          titleKey: 'settingsPrivacy',
          type: SettingsItemType.link,
          icon: Icons.privacy_tip_outlined,
        );

  // ═══════════════════════════════════════════════════════════════════════════
  // ACCOUNT
  // ═══════════════════════════════════════════════════════════════════════════

  /// Change password item.
  const SettingsItem.changePassword()
      : this(
          id: 'change_password',
          titleKey: 'settingsChangePassword',
          type: SettingsItemType.navigation,
          icon: Icons.lock_outlined,
        );

  /// Logout item.
  const SettingsItem.logout()
      : this(
          id: 'logout',
          titleKey: 'settingsLogout',
          type: SettingsItemType.action,
          icon: Icons.logout_outlined,
          requiresConfirmation: true,
        );

  /// Delete account item.
  const SettingsItem.deleteAccount()
      : this(
          id: 'delete_account',
          titleKey: 'settingsDeleteAccount',
          type: SettingsItemType.action,
          icon: Icons.delete_forever_outlined,
          destructive: true,
          requiresConfirmation: true,
        );

  // ═══════════════════════════════════════════════════════════════════════════
  // ABOUT
  // ═══════════════════════════════════════════════════════════════════════════

  /// App version info.
  const SettingsItem.appVersion()
      : this(
          id: 'version',
          titleKey: 'settingsVersion',
          type: SettingsItemType.info,
          icon: Icons.info_outlined,
        );

  /// Rate app item.
  const SettingsItem.rateApp()
      : this(
          id: 'rate',
          titleKey: 'settingsRateApp',
          type: SettingsItemType.action,
          icon: Icons.star_outlined,
        );

  /// Share app item.
  const SettingsItem.shareApp()
      : this(
          id: 'share',
          titleKey: 'settingsShareApp',
          type: SettingsItemType.action,
          icon: Icons.share_outlined,
        );
}

/// Types of settings items.
enum SettingsItemType {
  /// Theme picker (light/dark/system).
  themeSelector,

  /// Language picker.
  languageSelector,

  /// Toggle switch.
  toggle,

  /// External link.
  link,

  /// Action button.
  action,

  /// Information display.
  info,

  /// Navigate to another screen.
  navigation,
}

/// Visual styles for settings.
enum SettingsStyle {
  /// iOS-style grouped settings.
  grouped,

  /// Material Design style.
  material,

  /// Flat list style.
  flat,
}
