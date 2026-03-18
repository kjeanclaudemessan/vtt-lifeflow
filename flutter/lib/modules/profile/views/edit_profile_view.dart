import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../core/core.dart';
import '../../../design_system/design_system.dart';
import '../config/profile_config.dart';
import '../viewmodels/edit_profile_viewmodel.dart';
import '../widgets/avatar_widget.dart';
import '../widgets/profile_field_widget.dart';

/// Edit profile view.
///
/// Allows users to edit their profile information.
///
/// Supports three visual styles via [ProfileStyle]:
/// - [ProfileStyle.card]: Fields grouped inside cards.
/// - [ProfileStyle.list]: Simple vertical list of fields (default).
/// - [ProfileStyle.hero]: Large avatar header with fields in a scrollable sheet.
class EditProfileView extends StackedView<EditProfileViewModel> {
  /// Optional custom configuration.
  final ProfileConfig? config;

  const EditProfileView({this.config, super.key});

  @override
  void onViewModelReady(EditProfileViewModel viewModel) {
    viewModel.init();
  }

  @override
  Widget builder(
    BuildContext context,
    EditProfileViewModel viewModel,
    Widget? child,
  ) {
    final l10n = context.l10n;

    if (viewModel.isBusy ||
        viewModel.busy(EditProfileViewModel.loadingBusyKey)) {
      return Scaffold(
        backgroundColor: context.colorScheme.surface,
        appBar: AppAppBar(title: l10n.editProfile),
        body: const Center(child: AppLoader()),
      );
    }

    return PopScope(
      canPop: !viewModel.isDirty,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          final shouldPop = await viewModel.onWillPop();
          if (shouldPop && context.mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        backgroundColor: context.colorScheme.surface,
        appBar: AppAppBar(
          title: l10n.editProfile,
          leading: AppBackButton(
            icon: Icons.close_rounded,
            onPressed: viewModel.cancel,
          ),
          actions: [
            TextButton(
              onPressed: viewModel.canSubmit ? viewModel.save : null,
              child: viewModel.busy(EditProfileViewModel.savingBusyKey)
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: AppLoader.small(),
                    )
                  : Text(
                      l10n.save,
                      style: TextStyle(
                        color: viewModel.canSubmit
                            ? context.colorScheme.primary
                            : context.colorScheme.onSurfaceVariant,
                      ),
                    ),
            ),
          ],
        ),
        body: switch (viewModel.config.style) {
          ProfileStyle.card => _buildCardStyle(context, viewModel),
          ProfileStyle.list => _buildListStyle(context, viewModel),
          ProfileStyle.hero => _buildHeroStyle(context, viewModel),
        },
      ),
    );
  }

  // ── Card style ──────────────────────────────────────────────────────

  Widget _buildCardStyle(BuildContext context, EditProfileViewModel viewModel) {
    final l10n = context.l10n;

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (viewModel.config.enableAvatar) ...[
            Center(
              child: AvatarWidget(
                url: viewModel.avatarUrl,
                file: viewModel.avatarFile,
                initials: viewModel.initials,
                size: 100,
                editable: true,
                onEditTap: viewModel.pickAvatar,
              ),
            ),
            SizedBox(height: AppSpacing.xl),
          ],

          _buildErrorBanner(context, viewModel),

          // Fields grouped inside a card
          AppCard.outlined(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                ...viewModel.config.fields.map((field) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: AppSpacing.md),
                    child: ProfileFieldWidget(
                      field: field,
                      value: viewModel.getFieldValue(field.key),
                      error: viewModel.getFieldError(field.key),
                      onChanged: (value) =>
                          viewModel.setFieldValue(field.key, value),
                      readOnly: !field.editable,
                    ),
                  );
                }),
              ],
            ),
          ),

          SizedBox(height: AppSpacing.xl),

          AppButton.primary(
            label: l10n.save,
            onPressed: viewModel.canSubmit ? viewModel.save : null,
            isLoading: viewModel.busy(EditProfileViewModel.savingBusyKey),
          ),
        ],
      ),
    );
  }

  // ── List style ──────────────────────────────────────────────────────

  Widget _buildListStyle(BuildContext context, EditProfileViewModel viewModel) {
    final l10n = context.l10n;

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (viewModel.config.enableAvatar) ...[
            Center(
              child: AvatarWidget(
                url: viewModel.avatarUrl,
                file: viewModel.avatarFile,
                initials: viewModel.initials,
                size: 100,
                editable: true,
                onEditTap: viewModel.pickAvatar,
              ),
            ),
            SizedBox(height: AppSpacing.xl),
          ],

          _buildErrorBanner(context, viewModel),

          ...viewModel.config.fields.map((field) {
            return Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.md),
              child: ProfileFieldWidget(
                field: field,
                value: viewModel.getFieldValue(field.key),
                error: viewModel.getFieldError(field.key),
                onChanged: (value) => viewModel.setFieldValue(field.key, value),
                readOnly: !field.editable,
              ),
            );
          }),

          SizedBox(height: AppSpacing.xl),

          AppButton.primary(
            label: l10n.save,
            onPressed: viewModel.canSubmit ? viewModel.save : null,
            isLoading: viewModel.busy(EditProfileViewModel.savingBusyKey),
          ),
        ],
      ),
    );
  }

  // ── Hero style ──────────────────────────────────────────────────────

  Widget _buildHeroStyle(BuildContext context, EditProfileViewModel viewModel) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;

    return Column(
      children: [
        // Hero header with large avatar
        if (viewModel.config.enableAvatar)
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colorScheme.primary.withValues(alpha: 0.1),
                  colorScheme.surface,
                ],
              ),
            ),
            child: Center(
              child: AvatarWidget(
                url: viewModel.avatarUrl,
                file: viewModel.avatarFile,
                initials: viewModel.initials,
                size: 120,
                editable: true,
                onEditTap: viewModel.pickAvatar,
              ),
            ),
          ),

        // Scrollable fields
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildErrorBanner(context, viewModel),

                ...viewModel.config.fields.map((field) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: AppSpacing.md),
                    child: ProfileFieldWidget(
                      field: field,
                      value: viewModel.getFieldValue(field.key),
                      error: viewModel.getFieldError(field.key),
                      onChanged: (value) =>
                          viewModel.setFieldValue(field.key, value),
                      readOnly: !field.editable,
                    ),
                  );
                }),

                SizedBox(height: AppSpacing.xl),

                AppButton.primary(
                  label: l10n.save,
                  onPressed: viewModel.canSubmit ? viewModel.save : null,
                  isLoading: viewModel.busy(EditProfileViewModel.savingBusyKey),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Shared error banner ─────────────────────────────────────────────

  Widget _buildErrorBanner(
    BuildContext context,
    EditProfileViewModel viewModel,
  ) {
    if (!viewModel.hasError) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.lg),
      child: Container(
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: context.colorScheme.error.withValues(alpha: 0.1),
          borderRadius: AppRadius.md,
        ),
        child: Row(
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: context.colorScheme.error,
              size: 20,
            ),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                viewModel.modelError.toString(),
                style: AppTypography.bodySmall.copyWith(
                  color: context.colorScheme.error,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  EditProfileViewModel viewModelBuilder(BuildContext context) =>
      EditProfileViewModel(config: config);
}
