import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';

import '../../../core/core.dart';
import '../../../design_system/design_system.dart';
import '../viewmodels/login_viewmodel.dart';
import '../widgets/auth_form_fields.dart';
import '../widgets/auth_header.dart';
import '../widgets/social_login_buttons.dart';

/// Login view.
///
/// Allows users to sign in with email/password or social providers.
class LoginView extends StackedView<LoginViewModel> {
  const LoginView({super.key});

  @override
  Widget builder(
    BuildContext context,
    LoginViewModel viewModel,
    Widget? child,
  ) {
    final l10n = context.l10n;
    final config = viewModel.config;

    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: AppSpacing.xxl),

              // Header
              AuthHeader(
                title: l10n.welcomeBack,
                subtitle: l10n.signIn,
              ),

              SizedBox(height: AppSpacing.xxl),

              // Social login buttons
              if (config.hasSocialLogin) ...[
                SocialLoginButtons(
                  showGoogle: config.enableGoogle,
                  showApple: config.enableApple,
                  showGithub: config.enableGithub,
                  onGoogleTap: viewModel.loginWithGoogle,
                  onAppleTap: viewModel.loginWithApple,
                  onGithubTap: viewModel.loginWithGithub,
                  isGoogleLoading: viewModel.busy(LoginViewModel.googleBusyKey),
                  isAppleLoading: viewModel.busy(LoginViewModel.appleBusyKey),
                  isGithubLoading: viewModel.busy(LoginViewModel.githubBusyKey),
                ),
                OrDivider(text: l10n.or),
              ],

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
                textInputAction: TextInputAction.done,
                onSubmitted:
                    viewModel.canSubmit ? viewModel.loginWithEmail : null,
              ),

              SizedBox(height: AppSpacing.md),

              // Remember me & Forgot password row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (config.showRememberMe)
                    RememberMeCheckbox(
                      value: viewModel.rememberMe,
                      onChanged: viewModel.setRememberMe,
                      label: l10n.rememberMe,
                    )
                  else
                    const Spacer(),
                  TextButton(
                    onPressed: viewModel.goToForgotPassword,
                    child: Text(
                      l10n.forgotPassword,
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
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

              // Login button
              AppButton.primary(
                label: l10n.signIn,
                onPressed:
                    viewModel.canSubmit ? viewModel.loginWithEmail : null,
                isLoading: viewModel.busy(LoginViewModel.loginBusyKey),
              ),

              SizedBox(height: AppSpacing.xxl),

              // Register link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.dontHaveAccount,
                    style: AppTypography.bodyMedium.copyWith(
                      color:
                          AppColors.textSecondary(Theme.of(context).brightness),
                    ),
                  ),
                  TextButton(
                    onPressed: viewModel.goToRegister,
                    child: Text(
                      l10n.signUp,
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.primary,
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
  LoginViewModel viewModelBuilder(BuildContext context) => LoginViewModel();
}
