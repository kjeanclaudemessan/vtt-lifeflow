import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';

import '../../../core/core.dart';
import '../../../design_system/design_system.dart';
import '../config/auth_config.dart';
import '../utils/auth_error_mapper.dart';
import '../viewmodels/register_viewmodel.dart';
import '../widgets/auth_form_fields.dart';
import '../widgets/auth_header.dart';
import '../widgets/social_login_buttons.dart';

/// Register view.
///
/// Allows users to create a new account.
/// Supports 3 visual styles: modern, classic, minimal.
class RegisterView extends StackedView<RegisterViewModel> {
  const RegisterView({super.key});

  @override
  Widget builder(
    BuildContext context,
    RegisterViewModel viewModel,
    Widget? child,
  ) {
    return switch (viewModel.config.style) {
      AuthStyle.modern => _buildModernStyle(context, viewModel),
      AuthStyle.classic => _buildClassicStyle(context, viewModel),
      AuthStyle.minimal => _buildMinimalStyle(context, viewModel),
    };
  }

  // ═══════════════════════════════════════════════════════════════════
  // MODERN — Subtle gradient, centered header, staggered sections
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildModernStyle(BuildContext context, RegisterViewModel viewModel) {
    final l10n = context.l10n;
    final config = viewModel.config;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.25],
            colors: [
              context.colorScheme.primary.withValues(alpha: 0.06),
              context.colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // AppBar row
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                child: Row(
                  children: [AppBackButton(onPressed: viewModel.goToLogin)],
                ),
              ),

              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header
                      AppStaggeredFadeIn(
                        index: 0,
                        child: AuthHeader(
                          title: l10n.createAccount,
                          subtitle: l10n.authRegisterSubtitle,
                          alignment: CrossAxisAlignment.center,
                        ),
                      ),

                      SizedBox(height: AppSpacing.xl),

                      // Form
                      AppStaggeredFadeIn(
                        index: 1,
                        child: _buildFormFields(
                          context,
                          viewModel,
                          l10n,
                          config,
                        ),
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
                              label: l10n.createAccountAction,
                              onPressed: viewModel.canSubmit
                                  ? viewModel.register
                                  : null,
                              isLoading: viewModel.busy(
                                RegisterViewModel.registerBusyKey,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Social
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

                      SizedBox(height: AppSpacing.xl),

                      // Login link
                      AppStaggeredFadeIn(
                        index: 4,
                        child: _buildLoginLink(context, viewModel, l10n),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // CLASSIC — Card layout, centered, clean
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildClassicStyle(BuildContext context, RegisterViewModel viewModel) {
    final l10n = context.l10n;
    final config = viewModel.config;

    return Scaffold(
      backgroundColor: context.colorScheme.surfaceContainerLow,
      appBar: AppAppBar(leading: AppBackButton(onPressed: viewModel.goToLogin)),
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
                    // Header
                    AuthHeader(
                      title: l10n.createAccount,
                      subtitle: l10n.authRegisterSubtitle,
                      alignment: CrossAxisAlignment.center,
                    ),

                    SizedBox(height: AppSpacing.xl),

                    // Form
                    _buildFormFields(context, viewModel, l10n, config),

                    SizedBox(height: AppSpacing.lg),

                    // Error + Button
                    _buildErrorBanner(context, viewModel),
                    AppButton.primary(
                      label: l10n.createAccountAction,
                      onPressed: viewModel.canSubmit
                          ? viewModel.register
                          : null,
                      isLoading: viewModel.busy(
                        RegisterViewModel.registerBusyKey,
                      ),
                    ),

                    // Social
                    if (config.hasSocialLogin) ...[
                      OrDivider(text: l10n.or),
                      _buildSocialButtons(context, viewModel, config),
                    ],

                    SizedBox(height: AppSpacing.lg),

                    // Login link
                    _buildLoginLink(context, viewModel, l10n),
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
  // MINIMAL — Left-aligned, no card, essentials only
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildMinimalStyle(BuildContext context, RegisterViewModel viewModel) {
    final l10n = context.l10n;
    final config = viewModel.config;

    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: AppAppBar(leading: AppBackButton(onPressed: viewModel.goToLogin)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: AppSpacing.xl),

              // Header — left-aligned
              AppStaggeredFadeIn(
                index: 0,
                child: AuthHeader(
                  title: l10n.createAccount,
                  subtitle: l10n.authRegisterSubtitle,
                  alignment: CrossAxisAlignment.start,
                ),
              ),

              SizedBox(height: AppSpacing.xxl),

              // Form
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
                      label: l10n.createAccountAction,
                      onPressed: viewModel.canSubmit
                          ? viewModel.register
                          : null,
                      isLoading: viewModel.busy(
                        RegisterViewModel.registerBusyKey,
                      ),
                    ),
                  ],
                ),
              ),

              // Social
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

              SizedBox(height: AppSpacing.xl),

              // Login link
              AppStaggeredFadeIn(
                index: 4,
                child: _buildLoginLink(context, viewModel, l10n),
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
    RegisterViewModel viewModel,
    AppLocalizations l10n,
    AuthConfig config,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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

        // Email
        AuthEmailField(
          value: viewModel.email,
          onChanged: viewModel.setEmail,
          errorText: viewModel.emailError,
          hintText: l10n.emailAddress,
        ),

        SizedBox(height: AppSpacing.md),

        // Password
        AuthPasswordField(
          value: viewModel.password,
          onChanged: viewModel.setPassword,
          errorText: viewModel.passwordError,
          obscureText: viewModel.obscurePassword,
          onToggleVisibility: viewModel.togglePasswordVisibility,
          textInputAction: TextInputAction.next,
        ),

        // Password strength
        if (config.showPasswordStrength)
          PasswordStrengthIndicator(strength: viewModel.passwordStrength),

        SizedBox(height: AppSpacing.md),

        // Confirm password
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

        // Terms
        if (config.showTermsCheckbox)
          TermsCheckbox(
            value: viewModel.acceptedTerms,
            onChanged: viewModel.setAcceptedTerms,
            onTermsTap: viewModel.openTerms,
            onPrivacyTap: viewModel.openPrivacy,
          ),
      ],
    );
  }

  Widget _buildErrorBanner(BuildContext context, RegisterViewModel viewModel) {
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
    RegisterViewModel viewModel,
    AuthConfig config,
  ) {
    return SocialLoginButtons(
      showGoogle: config.enableGoogle,
      showApple: config.enableApple,
      showGithub: config.enableGithub,
      onGoogleTap: viewModel.registerWithGoogle,
      onAppleTap: viewModel.registerWithApple,
      onGithubTap: viewModel.registerWithGithub,
    );
  }

  Widget _buildLoginLink(
    BuildContext context,
    RegisterViewModel viewModel,
    AppLocalizations l10n,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l10n.alreadyHaveAccount,
          style: AppTypography.bodyMedium.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
        TextButton(
          onPressed: viewModel.goToLogin,
          child: Text(
            l10n.signIn,
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
  RegisterViewModel viewModelBuilder(BuildContext context) =>
      RegisterViewModel();
}
