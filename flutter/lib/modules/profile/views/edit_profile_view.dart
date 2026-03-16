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

    if (viewModel.busy(EditProfileViewModel.loadingBusyKey)) {
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
        body: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Avatar section
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

              // Error message
              if (viewModel.hasError) ...[
                Container(
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
                SizedBox(height: AppSpacing.lg),
              ],

              // Profile fields
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

              // Save button
              AppButton.primary(
                label: l10n.save,
                onPressed: viewModel.canSubmit ? viewModel.save : null,
                isLoading: viewModel.busy(EditProfileViewModel.savingBusyKey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  EditProfileViewModel viewModelBuilder(BuildContext context) =>
      EditProfileViewModel(config: config);
}
