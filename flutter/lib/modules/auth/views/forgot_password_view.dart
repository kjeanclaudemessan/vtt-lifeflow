import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';

import '../../../core/core.dart';
import '../../../design_system/design_system.dart';
import '../viewmodels/forgot_password_viewmodel.dart';
import '../widgets/auth_form_fields.dart';
import '../widgets/auth_header.dart';

/// Forgot password view.
///
/// Allows users to request a password reset email.
class ForgotPasswordView extends StackedView<ForgotPasswordViewModel> {
  const ForgotPasswordView({super.key});

  @override
  Widget builder(
    BuildContext context,
    ForgotPasswordViewModel viewModel,
    Widget? child,
  ) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: AppAppBar(leading: AppBackButton(onPressed: viewModel.goBack)),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: viewModel.emailSent
              ? _buildSuccessState(context, viewModel, l10n)
              : _buildFormState(context, viewModel, l10n),
        ),
      ),
    );
  }

  Widget _buildFormState(
    BuildContext context,
    ForgotPasswordViewModel viewModel,
    AppLocalizations l10n,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        AuthHeader(title: l10n.resetPassword, subtitle: l10n.forgotPassword),

        SizedBox(height: AppSpacing.xxl),

        // Email field
        AuthEmailField(
          value: viewModel.email,
          onChanged: viewModel.setEmail,
          errorText: viewModel.emailError,
          hintText: l10n.emailAddress,
        ),

        SizedBox(height: AppSpacing.lg),

        // Error message
        if (viewModel.hasError) ...[
          Container(
            padding: EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1),
              borderRadius: AppRadius.md,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  color: AppColors.error,
                  size: 20.sp,
                ),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    viewModel.modelError.toString(),
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.lg),
        ],

        // Submit button
        AppButton.primary(
          label: l10n.submit,
          onPressed: viewModel.canSubmit ? viewModel.sendResetEmail : null,
          isLoading: viewModel.busy(ForgotPasswordViewModel.resetBusyKey),
        ),

        const Spacer(),

        // Back to login link
        Center(
          child: TextButton(
            onPressed: viewModel.goBack,
            child: Text(
              l10n.back,
              style: AppTypography.labelMedium.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessState(
    BuildContext context,
    ForgotPasswordViewModel viewModel,
    AppLocalizations l10n,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Success icon
        Container(
          width: 100.w,
          height: 100.w,
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.mark_email_read_rounded,
            size: 50.sp,
            color: AppColors.success,
          ),
        ),

        SizedBox(height: AppSpacing.xl),

        // Title
        Text(
          l10n.successPasswordReset,
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: AppSpacing.md),

        // Description
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Text(
            l10n.passwordResetSentMessage(viewModel.email),
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary(Theme.of(context).brightness),
            ),
            textAlign: TextAlign.center,
          ),
        ),

        SizedBox(height: AppSpacing.xxl),

        // Back to login button
        AppButton.primary(label: l10n.signIn, onPressed: viewModel.goBack),

        SizedBox(height: AppSpacing.md),

        // Resend link
        TextButton(
          onPressed: viewModel.resendEmail,
          child: Text(
            l10n.resendCode,
            style: AppTypography.labelMedium.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  @override
  ForgotPasswordViewModel viewModelBuilder(BuildContext context) =>
      ForgotPasswordViewModel();
}
