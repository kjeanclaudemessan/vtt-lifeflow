import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';

import '../../../core/core.dart';
import '../../../design_system/design_system.dart';
import '../config/settings_config.dart';
import '../viewmodels/settings_viewmodel.dart';
import '../widgets/settings_pickers.dart';
import '../widgets/settings_section_widget.dart';

/// Settings view.
///
/// Displays app settings organized by sections.
class SettingsView extends StackedView<SettingsViewModel> {
  /// Optional custom configuration.
  final SettingsConfig? config;

  const SettingsView({
    this.config,
    super.key,
  });

  @override
  void onViewModelReady(SettingsViewModel viewModel) {
    viewModel.init();
  }

  @override
  Widget builder(
    BuildContext context,
    SettingsViewModel viewModel,
    Widget? child,
  ) {
    final l10n = context.l10n;

    return switch (viewModel.config.style) {
      SettingsStyle.grouped => _buildGroupedStyle(context, viewModel, l10n),
      SettingsStyle.material => _buildMaterialStyle(context, viewModel, l10n),
      SettingsStyle.flat => _buildFlatStyle(context, viewModel, l10n),
    };
  }

  Widget _buildGroupedStyle(
    BuildContext context,
    SettingsViewModel viewModel,
    AppLocalizations l10n,
  ) {
    return Scaffold(
      backgroundColor: context.colorScheme.surfaceContainerHighest,
      appBar: AppAppBar(
        title: l10n.settings,
        leading: AppBackButton(onPressed: viewModel.goBack),
      ),
      body: ListView(
        padding: EdgeInsets.only(top: AppSpacing.lg),
        children: [
          for (final section in viewModel.config.sections)
            SettingsSectionWidget(
              section: section,
              themeMode: viewModel.themeMode,
              locale: viewModel.locale,
              appVersion: viewModel.fullVersion,
              onItemTap: (item) => _handleItemTap(context, viewModel, item),
              getToggleValue: viewModel.getToggleValue,
              onToggleChanged: viewModel.setToggleValue,
            ),
        ],
      ),
    );
  }

  Widget _buildMaterialStyle(
    BuildContext context,
    SettingsViewModel viewModel,
    AppLocalizations l10n,
  ) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: AppAppBar(
        title: l10n.settings,
        leading: AppBackButton(onPressed: viewModel.goBack),
      ),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
        itemCount: _getAllItems(viewModel).length,
        separatorBuilder: (_, __) => const AppDivider(),
        itemBuilder: (context, index) {
          final (section, item) = _getAllItems(viewModel)[index];
          return _buildMaterialItem(context, viewModel, section, item);
        },
      ),
    );
  }

  Widget _buildFlatStyle(
    BuildContext context,
    SettingsViewModel viewModel,
    AppLocalizations l10n,
  ) {
    final isDark = context.isDarkMode;

    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: AppAppBar(
        title: l10n.settings,
        leading: AppBackButton(
          icon: Icons.close,
          onPressed: viewModel.goBack,
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(AppSpacing.lg),
        children: [
          for (final section in viewModel.config.sections) ...[
            // Section header
            Padding(
              padding: EdgeInsets.only(
                top: AppSpacing.lg,
                bottom: AppSpacing.sm,
              ),
              child: Text(
                _getSectionTitle(context, section.titleKey),
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            // Items
            for (final item in section.items)
              _buildFlatItem(context, viewModel, item, isDark),
          ],
        ],
      ),
    );
  }

  List<(SettingsSection, SettingsItem)> _getAllItems(
      SettingsViewModel viewModel) {
    final items = <(SettingsSection, SettingsItem)>[];
    for (final section in viewModel.config.sections) {
      for (final item in section.items) {
        items.add((section, item));
      }
    }
    return items;
  }

  Widget _buildMaterialItem(
    BuildContext context,
    SettingsViewModel viewModel,
    SettingsSection section,
    SettingsItem item,
  ) {
    // For toggle items, use AppSwitchListTile
    if (item.type == SettingsItemType.toggle) {
      return AppSwitchListTile(
        icon: item.icon,
        title: _getItemTitle(context, item.titleKey),
        value: viewModel.getToggleValue(item.id),
        onChanged: (value) => viewModel.setToggleValue(item.id, value),
      );
    }

    // For destructive items
    if (item.destructive) {
      return AppIconListTile(
        icon: item.icon ?? Icons.warning_outlined,
        title: _getItemTitle(context, item.titleKey),
        isDestructive: true,
        showChevron: item.type == SettingsItemType.navigation ||
            item.type == SettingsItemType.link,
        trailing: _buildTrailing(context, viewModel, item),
        onTap: () => _handleItemTap(context, viewModel, item),
      );
    }

    // For other items
    return AppIconListTile(
      icon: item.icon ?? Icons.settings_outlined,
      title: _getItemTitle(context, item.titleKey),
      showChevron: false,
      trailing: _buildTrailing(context, viewModel, item),
      onTap: () => _handleItemTap(context, viewModel, item),
    );
  }

  Widget _buildFlatItem(
    BuildContext context,
    SettingsViewModel viewModel,
    SettingsItem item,
    bool isDark,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: InkWell(
        onTap: item.type == SettingsItemType.toggle
            ? null
            : () => _handleItemTap(context, viewModel, item),
        borderRadius: AppRadius.sm,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: AppSpacing.md,
            horizontal: AppSpacing.sm,
          ),
          child: Row(
            children: [
              if (item.icon != null) ...[
                Icon(
                  item.icon,
                  size: 22.sp,
                  color:
                      item.destructive ? AppColors.error : AppColors.neutral500,
                ),
                SizedBox(width: AppSpacing.md),
              ],
              Expanded(
                child: Text(
                  _getItemTitle(context, item.titleKey),
                  style: AppTypography.bodyMedium.copyWith(
                    color: item.destructive
                        ? AppColors.error
                        : context.colorScheme.onSurface,
                  ),
                ),
              ),
              _buildTrailing(context, viewModel, item),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrailing(
    BuildContext context,
    SettingsViewModel viewModel,
    SettingsItem item,
  ) {
    return switch (item.type) {
      SettingsItemType.toggle => AppSwitch(
          value: viewModel.getToggleValue(item.id),
          onChanged: (value) => viewModel.setToggleValue(item.id, value),
        ),
      SettingsItemType.themeSelector => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _getThemeModeLabel(context, viewModel.themeMode),
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.neutral500,
              ),
            ),
            SizedBox(width: AppSpacing.xs),
            Icon(
              Icons.chevron_right_rounded,
              size: 20.sp,
              color: AppColors.neutral400,
            ),
          ],
        ),
      SettingsItemType.languageSelector => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              viewModel.getLocaleLabel(viewModel.locale),
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.neutral500,
              ),
            ),
            SizedBox(width: AppSpacing.xs),
            Icon(
              Icons.chevron_right_rounded,
              size: 20.sp,
              color: AppColors.neutral400,
            ),
          ],
        ),
      SettingsItemType.info => Text(
          item.id == 'version' ? viewModel.fullVersion : '',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.neutral500,
          ),
        ),
      SettingsItemType.navigation || SettingsItemType.link => Icon(
          Icons.chevron_right_rounded,
          size: 20.sp,
          color: AppColors.neutral400,
        ),
      _ => const SizedBox.shrink(),
    };
  }

  void _handleItemTap(
    BuildContext context,
    SettingsViewModel viewModel,
    SettingsItem item,
  ) {
    switch (item.type) {
      case SettingsItemType.themeSelector:
        _showThemePicker(context, viewModel);
      case SettingsItemType.languageSelector:
        _showLanguagePicker(context, viewModel);
      default:
        viewModel.onItemTap(item);
    }
  }

  void _showThemePicker(BuildContext context, SettingsViewModel viewModel) {
    AppBottomSheet.show(
      context: context,
      title: context.l10n.settingsSelectTheme,
      child: ThemePickerSheet(
        currentTheme: viewModel.themeMode,
        onThemeSelected: viewModel.setThemeMode,
      ),
    );
  }

  void _showLanguagePicker(BuildContext context, SettingsViewModel viewModel) {
    AppBottomSheet.show(
      context: context,
      title: context.l10n.settingsSelectLanguage,
      child: LanguagePickerSheet(
        currentLocale: viewModel.locale,
        onLocaleSelected: viewModel.setLocale,
      ),
    );
  }

  String _getSectionTitle(BuildContext context, String key) {
    final l10n = context.l10n;
    return switch (key) {
      'settingsAppearance' => l10n.settingsAppearance,
      'settingsNotifications' => l10n.settingsNotifications,
      'settingsLegal' => l10n.settingsLegal,
      'settingsAccount' => l10n.settingsAccount,
      'settingsAbout' => l10n.settingsAbout,
      'habitsTitle' => l10n.habitsTitle,
      _ => key,
    };
  }

  String _getItemTitle(BuildContext context, String key) {
    final l10n = context.l10n;
    return switch (key) {
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
      'streakFreeze' => l10n.streakFreeze,
      _ => key,
    };
  }

  String _getThemeModeLabel(BuildContext context, ThemeMode mode) {
    final l10n = context.l10n;
    return switch (mode) {
      ThemeMode.system => l10n.settingsThemeSystem,
      ThemeMode.light => l10n.settingsThemeLight,
      ThemeMode.dark => l10n.settingsThemeDark,
    };
  }

  @override
  SettingsViewModel viewModelBuilder(BuildContext context) =>
      SettingsViewModel(config: config);
}
