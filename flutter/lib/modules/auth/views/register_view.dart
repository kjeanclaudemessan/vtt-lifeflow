import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';

import '../../../core/core.dart';
import '../../../design_system/design_system.dart';
import '../utils/auth_error_mapper.dart';
import '../viewmodels/register_viewmodel.dart';
import '../widgets/auth_form_fields.dart';
import '../widgets/auth_header.dart';
import '../widgets/social_login_buttons.dart';

/// Register view.
///
/// Allows users to create a new account.
class RegisterView extends StackedView<RegisterViewModel> {
  const RegisterView({super.key});

  @override
  Widget builder(
    BuildContext context,
    RegisterViewModel viewModel,
    Widget? child,
  ) {
    final l10n = context.l10n;
    final config = viewModel.config;

    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: AppAppBar(leading: AppBackButton(onPressed: viewModel.goToLogin)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              AuthHeader(title: l10n.createAccount, subtitle: l10n.signUp),

              SizedBox(height: AppSpacing.xl),

              // Name fields
              Row(
                children: [
                  Expanded(
                    child: AuthNameField(
                      label: l10n.firstName,
                      hintText: l10n.firstName,
                      value: viewModel.firstName,
                      onChanged: viewModel.setFirstName,
                      errorText: viewModel.firstNameError,
                      textInputAction: TextInputAction.next,
                      prefixIcon: Icons.person_outline_rounded,
                    ),
                  ),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: AuthNameField(
                      label: l10n.lastName,
                      hintText: l10n.lastName,
                      value: viewModel.lastName,
                      onChanged: viewModel.setLastName,
                      errorText: viewModel.lastNameError,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                ],
              ),

              SizedBox(height: AppSpacing.md),

              // Email field
              AuthEmailField(
                value: viewModel.email,
                onChanged: viewModel.setEmail,
                errorText: viewModel.emailError,
                hintText: l10n.emailAddress,
              ),

              SizedBox(height: AppSpacing.md),

              // Password field
              AuthPasswordField(
                value: viewModel.password,
                onChanged: viewModel.setPassword,
                errorText: viewModel.passwordError,
                obscureText: viewModel.obscurePassword,
                onToggleVisibility: viewModel.togglePasswordVisibility,
                textInputAction: TextInputAction.next,
              ),

              // Password strength indicator
              if (config.showPasswordStrength)
                PasswordStrengthIndicator(strength: viewModel.passwordStrength),

              SizedBox(height: AppSpacing.md),

              // Confirm password field
              AuthPasswordField(
                label: l10n.confirmPassword,
                value: viewModel.confirmPassword,
                onChanged: viewModel.setConfirmPassword,
                errorText: viewModel.confirmPasswordError,
                obscureText: viewModel.obscureConfirmPassword,
                onToggleVisibility: viewModel.toggleConfirmPasswordVisibility,
                textInputAction: TextInputAction.done,
                onSubmitted: viewModel.canSubmit ? viewModel.register : null,
              ),

              SizedBox(height: AppSpacing.lg),

              // Terms checkbox
              if (config.showTermsCheckbox)
                TermsCheckbox(
                  value: viewModel.acceptedTerms,
                  onChanged: viewModel.setAcceptedTerms,
                  onTermsTap: viewModel.openTerms,
                  onPrivacyTap: viewModel.openPrivacy,
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
                          AuthErrorMapper.message(
                            context,
                            viewModel.modelError,
                          ),
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

              // Register button
              AppButton.primary(
                label: l10n.createAccount,
                onPressed: viewModel.canSubmit ? viewModel.register : null,
                isLoading: viewModel.busy(RegisterViewModel.registerBusyKey),
              ),

              // Social login buttons
              if (config.hasSocialLogin) ...[
                OrDivider(text: l10n.or),
                SocialLoginButtons(
                  showGoogle: config.enableGoogle,
                  showApple: config.enableApple,
                  showGithub: config.enableGithub,
                  onGoogleTap: viewModel.registerWithGoogle,
                  onAppleTap: viewModel.registerWithApple,
                  onGithubTap: viewModel.registerWithGithub,
                ),
              ],

              SizedBox(height: AppSpacing.xl),

              // Login link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.alreadyHaveAccount,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary(
                        Theme.of(context).brightness,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: viewModel.goToLogin,
                    child: Text(
                      l10n.signIn,
                      style: AppTypography.labelMedium.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  RegisterViewModel viewModelBuilder(BuildContext context) =>
      RegisterViewModel();
}
