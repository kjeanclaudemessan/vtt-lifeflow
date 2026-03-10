import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';

import '../../../core/core.dart';
import '../../../design_system/design_system.dart';
import '../config/profile_config.dart';
import '../viewmodels/profile_viewmodel.dart';
import '../widgets/avatar_widget.dart';
import '../widgets/profile_field_widget.dart';
import '../widgets/profile_section.dart';

/// Profile view.
///
/// Displays user profile information with various visual styles.
class ProfileView extends StackedView<ProfileViewModel> {
  /// Optional custom configuration.
  final ProfileConfig? config;

  const ProfileView({this.config, super.key});

  @override
  void onViewModelReady(ProfileViewModel viewModel) {
    viewModel.init();
  }

  @override
  Widget builder(
    BuildContext context,
    ProfileViewModel viewModel,
    Widget? child,
  ) {
    if (viewModel.busy(ProfileViewModel.loadingBusyKey)) {
      return Scaffold(
        backgroundColor: context.colorScheme.surface,
        body: const Center(child: AppLoader()),
      );
    }

    return switch (viewModel.config.style) {
      ProfileStyle.card => _buildCardStyle(context, viewModel),
      ProfileStyle.list => _buildListStyle(context, viewModel),
      ProfileStyle.hero => _buildHeroStyle(context, viewModel),
    };
  }

  Widget _buildCardStyle(BuildContext context, ProfileViewModel viewModel) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: context.colorScheme.surfaceContainerLow,
      appBar: AppAppBar(
        title: l10n.profile,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: viewModel.editProfile,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            // Avatar and name section
            ProfileSection(
              children: [
                Center(
                  child: Column(
                    children: [
                      AvatarWidget(
                        url: viewModel.avatarUrl,
                        initials: viewModel.initials,
                        size: 100,
                        editable: true,
                        onEditTap: viewModel.editProfile,
                      ),
                      SizedBox(height: AppSpacing.md),
                      Text(
                        viewModel.displayName,
                        style: AppTypography.headlineSmall.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: AppSpacing.xs),
                      Text(
                        viewModel.email,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary(
                            Theme.of(context).brightness,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Profile completion indicator
            if (viewModel.config.showProfileCompletion)
              ProfileSection(
                children: [_buildProfileCompletion(context, viewModel)],
              ),

            // Profile fields
            ProfileSection(
              title: l10n.personalInfo,
              trailing: TextButton(
                onPressed: viewModel.editProfile,
                child: Text(l10n.edit),
              ),
              showDividers: true,
              children: viewModel.config.fields.map((field) {
                return ProfileFieldDisplay(
                  label: _getLocalizedLabel(l10n, field.labelKey),
                  value: viewModel.getFieldDisplayValue(field),
                  icon: field.icon,
                );
              }).toList(),
            ),

            // Account actions
            ProfileSection(
              title: l10n.accountSettings,
              showDividers: true,
              children: [
                ProfileActionButton(
                  icon: Icons.lock_outline_rounded,
                  label: l10n.changePassword,
                  onTap: viewModel.changePassword,
                ),
                if (viewModel.config.enableDataExport)
                  ProfileActionButton(
                    icon: Icons.download_outlined,
                    label: l10n.exportData,
                    onTap: viewModel.exportData,
                  ),
                ProfileActionButton(
                  icon: Icons.logout_rounded,
                  label: l10n.logout,
                  onTap: viewModel.logout,
                  isDestructive: true,
                ),
                if (viewModel.config.enableDeleteAccount)
                  ProfileActionButton(
                    icon: Icons.delete_outline_rounded,
                    label: l10n.delete,
                    onTap: viewModel.deleteAccount,
                    isDestructive: true,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListStyle(BuildContext context, ProfileViewModel viewModel) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: AppAppBar(
        title: l10n.profile,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: viewModel.editProfile,
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
        children: [
          // Avatar and name
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Row(
              children: [
                AvatarWidget(
                  url: viewModel.avatarUrl,
                  initials: viewModel.initials,
                  size: 60,
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        viewModel.displayName,
                        style: AppTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        viewModel.email,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary(
                            Theme.of(context).brightness,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: AppSpacing.lg),
          const AppDivider(),

          // Profile fields
          ...viewModel.config.fields.map((field) {
            return AppListTile(
              leading: field.icon != null ? Icon(field.icon) : null,
              title: _getLocalizedLabel(l10n, field.labelKey),
              subtitle: viewModel.getFieldDisplayValue(field).isEmpty
                  ? '-'
                  : viewModel.getFieldDisplayValue(field),
            );
          }),

          const AppDivider(),
          SizedBox(height: AppSpacing.md),

          // Actions
          AppIconListTile(
            icon: Icons.lock_outline_rounded,
            title: l10n.changePassword,
            showChevron: true,
            onTap: viewModel.changePassword,
          ),
          AppIconListTile(
            icon: Icons.logout_rounded,
            title: l10n.logout,
            isDestructive: true,
            showChevron: false,
            onTap: viewModel.logout,
          ),
        ],
      ),
    );
  }

  Widget _buildHeroStyle(BuildContext context, ProfileViewModel viewModel) {
    final l10n = context.l10n;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Hero header with avatar
          SliverAppBar(
            expandedHeight: 200.h,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.7),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: AppSpacing.xl),
                      AvatarWidget(
                        url: viewModel.avatarUrl,
                        initials: viewModel.initials,
                        size: 80,
                        backgroundColor: AppColors.white,
                      ),
                      SizedBox(height: AppSpacing.md),
                      Text(
                        viewModel.displayName,
                        style: AppTypography.titleLarge.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        viewModel.email,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: viewModel.editProfile,
              ),
            ],
          ),

          // Content
          SliverPadding(
            padding: EdgeInsets.all(AppSpacing.lg),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Profile fields
                ProfileSection(
                  title: l10n.personalInfo,
                  showDividers: true,
                  children: viewModel.config.fields.map((field) {
                    return ProfileFieldDisplay(
                      label: _getLocalizedLabel(l10n, field.labelKey),
                      value: viewModel.getFieldDisplayValue(field),
                      icon: field.icon,
                    );
                  }).toList(),
                ),

                // Account actions
                ProfileSection(
                  title: l10n.accountSettings,
                  showDividers: true,
                  children: [
                    ProfileActionButton(
                      icon: Icons.lock_outline_rounded,
                      label: l10n.changePassword,
                      onTap: viewModel.changePassword,
                    ),
                    ProfileActionButton(
                      icon: Icons.logout_rounded,
                      label: l10n.logout,
                      onTap: viewModel.logout,
                      isDestructive: true,
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCompletion(
    BuildContext context,
    ProfileViewModel viewModel,
  ) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n.profileCompletion, style: AppTypography.labelMedium),
            Text(
              '${viewModel.profileCompletion}%',
              style: AppTypography.labelMedium.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.sm),
        AppLinearProgress(value: viewModel.profileCompletion / 100),
      ],
    );
  }

  String _getLocalizedLabel(AppLocalizations l10n, String key) {
    try {
      return switch (key) {
        'fullName' => l10n.fullName,
        'firstName' => l10n.firstName,
        'lastName' => l10n.lastName,
        'email' => l10n.email,
        'phoneNumber' => l10n.phoneNumber,
        _ => key,
      };
    } catch (_) {
      return key;
    }
  }

  @override
  ProfileViewModel viewModelBuilder(BuildContext context) =>
      ProfileViewModel(config: config);
}
