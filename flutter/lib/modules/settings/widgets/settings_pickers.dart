import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/core.dart';
import '../../../design_system/design_system.dart';

/// Theme picker content for bottom sheet.
/// Note: Use with AppBottomSheet.show() in the view.
class ThemePickerSheet extends StatelessWidget {
  /// Current theme mode.
  final ThemeMode currentTheme;

  /// Callback when theme is selected.
  final ValueChanged<ThemeMode> onThemeSelected;

  const ThemePickerSheet({
    required this.currentTheme,
    required this.onThemeSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Options using AppListSection
        AppListSection(
          showDividers: true,
          children: [
            _buildThemeOption(
              context: context,
              icon: Icons.brightness_auto_outlined,
              title: l10n.settingsThemeSystem,
              subtitle: l10n.settingsThemeSystemDesc,
              mode: ThemeMode.system,
            ),
            _buildThemeOption(
              context: context,
              icon: Icons.light_mode_outlined,
              title: l10n.settingsThemeLight,
              subtitle: l10n.settingsThemeLightDesc,
              mode: ThemeMode.light,
            ),
            _buildThemeOption(
              context: context,
              icon: Icons.dark_mode_outlined,
              title: l10n.settingsThemeDark,
              subtitle: l10n.settingsThemeDarkDesc,
              mode: ThemeMode.dark,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildThemeOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required ThemeMode mode,
  }) {
    final isSelected = currentTheme == mode;

    final primary = Theme.of(context).colorScheme.primary;

    return AppIconListTile(
      icon: icon,
      iconColor: isSelected ? primary : null,
      iconBackgroundColor: isSelected ? primary.withValues(alpha: 0.1) : null,
      title: title,
      subtitle: subtitle,
      showChevron: false,
      trailing: isSelected
          ? Icon(Icons.check_circle_rounded, size: 24.sp, color: primary)
          : null,
      onTap: () {
        onThemeSelected(mode);
        Navigator.of(context).pop();
      },
    );
  }
}

/// Language picker content for bottom sheet.
/// Note: Use with AppBottomSheet.show() in the view.
class LanguagePickerSheet extends StatelessWidget {
  /// Current locale.
  final Locale currentLocale;

  /// Supported locales.
  final List<Locale> supportedLocales;

  /// Callback when locale is selected.
  final ValueChanged<Locale> onLocaleSelected;

  const LanguagePickerSheet({
    required this.currentLocale,
    required this.onLocaleSelected,
    this.supportedLocales = const [Locale('en'), Locale('fr')],
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Options using AppListSection
        AppListSection(
          showDividers: true,
          children: [
            for (final locale in supportedLocales)
              _buildLocaleOption(context, locale),
          ],
        ),
      ],
    );
  }

  Widget _buildLocaleOption(BuildContext context, Locale locale) {
    final isSelected = currentLocale.languageCode == locale.languageCode;
    final (label, flag) = _getLocaleInfo(locale);

    return AppListTile(
      leading: Text(flag, style: TextStyle(fontSize: 28.sp)),
      title: label,
      trailing: isSelected
          ? Icon(
              Icons.check_circle_rounded,
              size: 24.sp,
              color: Theme.of(context).colorScheme.primary,
            )
          : null,
      onTap: () {
        onLocaleSelected(locale);
        Navigator.of(context).pop();
      },
    );
  }

  (String, String) _getLocaleInfo(Locale locale) {
    return switch (locale.languageCode) {
      'en' => ('English', '🇬🇧'),
      'fr' => ('Français', '🇫🇷'),
      'es' => ('Español', '🇪🇸'),
      'de' => ('Deutsch', '🇩🇪'),
      'it' => ('Italiano', '🇮🇹'),
      'pt' => ('Português', '🇵🇹'),
      'ar' => ('العربية', '🇸🇦'),
      'zh' => ('中文', '🇨🇳'),
      'ja' => ('日本語', '🇯🇵'),
      'ko' => ('한국어', '🇰🇷'),
      _ => (locale.languageCode.toUpperCase(), '🏳️'),
    };
  }
}
