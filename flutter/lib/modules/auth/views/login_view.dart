import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';

import '../../../core/core.dart';
import '../../../design_system/design_system.dart';
import '../config/auth_config.dart';
import '../viewmodels/login_viewmodel.dart';
import '../utils/auth_error_mapper.dart';
import '../widgets/auth_form_fields.dart';
import '../widgets/auth_header.dart';
import '../widgets/social_login_buttons.dart';

/// Login view.
///
/// Allows users to sign in with email/password or social providers.
/// Supports 3 visual styles: modern, classic, minimal.
class LoginView extends StackedView<LoginViewModel> {
  const LoginView({super.key});

  @override
  Widget builder(
    BuildContext context,
    LoginViewModel viewModel,
    Widget? child,
  ) {
    return switch (viewModel.config.style) {
      AuthStyle.modern => _buildModernStyle(context, viewModel),
      AuthStyle.classic => _buildClassicStyle(context, viewModel),
      AuthStyle.minimal => _buildMinimalStyle(context, viewModel),
    };
  }

  // ═══════════════════════════════════════════════════════════════════
  // MODERN — Gradient top, centered, expressive entrance
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildModernStyle(BuildContext context, LoginViewModel viewModel) {
    final l10n = context.l10n;
    final config = viewModel.config;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.35],
            colors: [
              context.colorScheme.primary.withValues(alpha: 0.08),
              context.colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: AppSpacing.xxl),

                // Header — centered with breathing logo
                AppStaggeredFadeIn(
                  index: 0,
                  child: AuthHeader(
                    title: l10n.welcomeBack,
                    subtitle: l10n.authLoginSubtitle,
                    alignment: CrossAxisAlignment.center,
                  ),
                ),

                SizedBox(height: AppSpacing.xxl),

                // Form fields
                AppStaggeredFadeIn(
                  index: 1,
                  child: _buildFormFields(context, viewModel, l10n, config),
                ),

                SizedBox(height: AppSpacing.lg),

                // Error + Button
                AppStaggeredFadeIn(
                  index: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildErrorBanner(context, viewModel),
                      AppButton.primary(
                        label: l10n.signIn,
                        onPressed: viewModel.canSubmit
                            ? viewModel.loginWithEmail
                            : null,
                        isLoading: viewModel.busy(LoginViewModel.loginBusyKey),
                      ),
                    ],
                  ),
                ),

                // Social login
                if (config.hasSocialLogin)
                  AppStaggeredFadeIn(
                    index: 3,
                    child: Column(
                      children: [
                        OrDivider(text: l10n.or),
                        _buildSocialButtons(context, viewModel, config),
                      ],
                    ),
                  ),

                SizedBox(height: AppSpacing.xxl),

                // Register link
                AppStaggeredFadeIn(
                  index: 4,
                  child: _buildRegisterLink(context, viewModel, l10n),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // CLASSIC — Card layout, centered, clean and traditional
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildClassicStyle(BuildContext context, LoginViewModel viewModel) {
    final l10n = context.l10n;
    final config = viewModel.config;

    return Scaffold(
      backgroundColor: context.colorScheme.surfaceContainerLow,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: AppStaggeredFadeIn(
              index: 0,
              child: AppCard(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header — centered
                    AuthHeader(
                      title: l10n.welcomeBack,
                      subtitle: l10n.authLoginSubtitle,
                      alignment: CrossAxisAlignment.center,
                    ),

                    SizedBox(height: AppSpacing.xl),

                    // Form
                    _buildFormFields(context, viewModel, l10n, config),

                    SizedBox(height: AppSpacing.lg),

                    // Error + Button
                    _buildErrorBanner(context, viewModel),
                    AppButton.primary(
                      label: l10n.signIn,
                      onPressed: viewModel.canSubmit
                          ? viewModel.loginWithEmail
                          : null,
                      isLoading: viewModel.busy(LoginViewModel.loginBusyKey),
                    ),

                    // Social
                    if (config.hasSocialLogin) ...[
                      OrDivider(text: l10n.or),
                      _buildSocialButtons(context, viewModel, config),
                    ],

                    SizedBox(height: AppSpacing.lg),

                    // Register link
                    _buildRegisterLink(context, viewModel, l10n),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // MINIMAL — Clean lines, left-aligned, no card, essentials only
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildMinimalStyle(BuildContext context, LoginViewModel viewModel) {
    final l10n = context.l10n;
    final config = viewModel.config;

    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: AppSpacing.xxl + AppSpacing.xl),

              // Header — left-aligned, no logo
              AppStaggeredFadeIn(
                index: 0,
                child: AuthHeader(
                  title: l10n.welcomeBack,
                  subtitle: l10n.authLoginSubtitle,
                  alignment: CrossAxisAlignment.start,
                ),
              ),

              SizedBox(height: AppSpacing.xxl),

              // Form — clean, staggered
              AppStaggeredFadeIn(
                index: 1,
                child: _buildFormFields(context, viewModel, l10n, config),
              ),

              SizedBox(height: AppSpacing.lg),

              // Error + Button
              AppStaggeredFadeIn(
                index: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildErrorBanner(context, viewModel),
                    AppButton.primary(
                      label: l10n.signIn,
                      onPressed: viewModel.canSubmit
                          ? viewModel.loginWithEmail
                          : null,
                      isLoading: viewModel.busy(LoginViewModel.loginBusyKey),
                    ),
                  ],
                ),
              ),

              // Social — horizontal compact in minimal
              if (config.hasSocialLogin)
                AppStaggeredFadeIn(
                  index: 3,
                  child: Column(
                    children: [
                      OrDivider(text: l10n.or),
                      _buildSocialButtons(context, viewModel, config),
                    ],
                  ),
                ),

              SizedBox(height: AppSpacing.xxl),

              // Register link
              AppStaggeredFadeIn(
                index: 4,
                child: _buildRegisterLink(context, viewModel, l10n),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // SHARED BUILDERS
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildFormFields(
    BuildContext context,
    LoginViewModel viewModel,
    AppLocalizations l10n,
    AuthConfig config,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthEmailField(
          value: viewModel.email,
          onChanged: viewModel.setEmail,
          errorText: viewModel.emailError,
          hintText: l10n.emailAddress,
        ),

        SizedBox(height: AppSpacing.md),

        AuthPasswordField(
          value: viewModel.password,
          onChanged: viewModel.setPassword,
          errorText: viewModel.passwordError,
          obscureText: viewModel.obscurePassword,
          onToggleVisibility: viewModel.togglePasswordVisibility,
          textInputAction: TextInputAction.done,
          onSubmitted: viewModel.canSubmit ? viewModel.loginWithEmail : null,
        ),

        SizedBox(height: AppSpacing.md),

        // Remember me & Forgot password
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (config.showRememberMe)
              Flexible(
                child: RememberMeCheckbox(
                  value: viewModel.rememberMe,
                  onChanged: viewModel.setRememberMe,
                  label: l10n.rememberMe,
                ),
              )
            else
              const Spacer(),
            Flexible(
              child: TextButton(
                onPressed: viewModel.goToForgotPassword,
                child: Text(
                  l10n.forgotPassword,
                  style: AppTypography.labelMedium.copyWith(
                    color: context.colorScheme.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildErrorBanner(BuildContext context, LoginViewModel viewModel) {
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
              size: 20.sp,
            ),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                AuthErrorMapper.message(context, viewModel.modelError),
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

  Widget _buildSocialButtons(
    BuildContext context,
    LoginViewModel viewModel,
    AuthConfig config,
  ) {
    return SocialLoginButtons(
      showGoogle: config.enableGoogle,
      showApple: config.enableApple,
      showGithub: config.enableGithub,
      onGoogleTap: viewModel.loginWithGoogle,
      onAppleTap: viewModel.loginWithApple,
      onGithubTap: viewModel.loginWithGithub,
      isGoogleLoading: viewModel.busy(LoginViewModel.googleBusyKey),
      isAppleLoading: viewModel.busy(LoginViewModel.appleBusyKey),
      isGithubLoading: viewModel.busy(LoginViewModel.githubBusyKey),
    );
  }

  Widget _buildRegisterLink(
    BuildContext context,
    LoginViewModel viewModel,
    AppLocalizations l10n,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            l10n.dontHaveAccount,
            style: AppTypography.bodyMedium.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        TextButton(
          onPressed: viewModel.goToRegister,
          child: Text(
            l10n.signUp,
            style: AppTypography.labelMedium.copyWith(
              color: context.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  @override
  LoginViewModel viewModelBuilder(BuildContext context) => LoginViewModel();
}
