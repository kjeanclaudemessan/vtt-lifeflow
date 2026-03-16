import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';

import '../../../core/core.dart';
import '../../../design_system/design_system.dart';
import '../config/auth_config.dart';
import '../viewmodels/forgot_password_viewmodel.dart';
import '../widgets/auth_form_fields.dart';
import '../widgets/auth_header.dart';

/// Forgot password view.
///
/// Allows users to request a password reset email.
/// Supports 3 visual styles: modern, classic, minimal.
class ForgotPasswordView extends StackedView<ForgotPasswordViewModel> {
  const ForgotPasswordView({super.key});

  @override
  Widget builder(
    BuildContext context,
    ForgotPasswordViewModel viewModel,
    Widget? child,
  ) {
    final l10n = context.l10n;

    // Success state is shared across styles — same celebratory moment
    if (viewModel.emailSent) {
      return _buildSuccessState(context, viewModel, l10n);
    }

    return switch (viewModel.config.style) {
      AuthStyle.modern => _buildModernForm(context, viewModel, l10n),
      AuthStyle.classic => _buildClassicForm(context, viewModel, l10n),
      AuthStyle.minimal => _buildMinimalForm(context, viewModel, l10n),
    };
  }

  // ═══════════════════════════════════════════════════════════════════
  // MODERN — Gradient top, centered, warm
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildModernForm(
    BuildContext context,
    ForgotPasswordViewModel viewModel,
    AppLocalizations l10n,
  ) {
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
          child: Column(
            children: [
              // AppBar row
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                child: Row(
                  children: [AppBackButton(onPressed: viewModel.goBack)],
                ),
              ),

              // Content
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: AppSpacing.xl),

                      // Header
                      AppStaggeredFadeIn(
                        index: 0,
                        child: AuthHeader(
                          title: l10n.resetPassword,
                          subtitle: l10n.authForgotSubtitle,
                          alignment: CrossAxisAlignment.center,
                        ),
                      ),

                      SizedBox(height: AppSpacing.xxl),

                      // Email + Error + Button
                      AppStaggeredFadeIn(
                        index: 1,
                        child: _buildFormContent(context, viewModel, l10n),
                      ),

                      const Spacer(),

                      // Back link
                      AppStaggeredFadeIn(
                        index: 2,
                        child: _buildBackLink(context, viewModel, l10n),
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
  // CLASSIC — Card layout, centered
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildClassicForm(
    BuildContext context,
    ForgotPasswordViewModel viewModel,
    AppLocalizations l10n,
  ) {
    return Scaffold(
      backgroundColor: context.colorScheme.surfaceContainerLow,
      appBar: AppAppBar(leading: AppBackButton(onPressed: viewModel.goBack)),
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
                      title: l10n.resetPassword,
                      subtitle: l10n.authForgotSubtitle,
                      alignment: CrossAxisAlignment.center,
                    ),

                    SizedBox(height: AppSpacing.xxl),

                    // Form content
                    _buildFormContent(context, viewModel, l10n),

                    SizedBox(height: AppSpacing.xl),

                    // Back link
                    _buildBackLink(context, viewModel, l10n),
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
  // MINIMAL — Left-aligned, no card, clean
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildMinimalForm(
    BuildContext context,
    ForgotPasswordViewModel viewModel,
    AppLocalizations l10n,
  ) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: AppAppBar(leading: AppBackButton(onPressed: viewModel.goBack)),
      body: SafeArea(
        child: Padding(
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
                  title: l10n.resetPassword,
                  subtitle: l10n.authForgotSubtitle,
                  alignment: CrossAxisAlignment.start,
                ),
              ),

              SizedBox(height: AppSpacing.xxl),

              // Form
              AppStaggeredFadeIn(
                index: 1,
                child: _buildFormContent(context, viewModel, l10n),
              ),

              const Spacer(),

              // Back link
              AppStaggeredFadeIn(
                index: 2,
                child: _buildBackLink(context, viewModel, l10n),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // SUCCESS STATE — Shared across styles (Celebration archetype)
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildSuccessState(
    BuildContext context,
    ForgotPasswordViewModel viewModel,
    AppLocalizations l10n,
  ) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: AppAppBar(leading: AppBackButton(onPressed: viewModel.goBack)),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success icon — elasticOut scale entrance
              AppStaggeredFadeIn(
                index: 0,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: AppAnimations.extraSlow,
                  curve: Curves.elasticOut,
                  builder: (context, value, child) =>
                      Transform.scale(scale: value, child: child),
                  child: Container(
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
                ),
              ),

              SizedBox(height: AppSpacing.xl),

              // Title
              AppStaggeredFadeIn(
                index: 1,
                child: Text(
                  l10n.successPasswordReset,
                  style: AppTypography.headlineMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: AppSpacing.md),

              // Description — warm, personal
              AppStaggeredFadeIn(
                index: 2,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Text(
                    l10n.passwordResetSentMessage(viewModel.email),
                    style: AppTypography.bodyMedium.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              SizedBox(height: AppSpacing.xxl),

              // Back to login button
              AppStaggeredFadeIn(
                index: 3,
                child: AppButton.primary(
                  label: l10n.signIn,
                  onPressed: viewModel.goBack,
                ),
              ),

              SizedBox(height: AppSpacing.md),

              // Resend link
              AppStaggeredFadeIn(
                index: 4,
                child: TextButton(
                  onPressed: viewModel.resendEmail,
                  child: Text(
                    l10n.resendCode,
                    style: AppTypography.labelMedium.copyWith(
                      color: context.colorScheme.primary,
                    ),
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
  // SHARED BUILDERS
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildFormContent(
    BuildContext context,
    ForgotPasswordViewModel viewModel,
    AppLocalizations l10n,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Email field
        AuthEmailField(
          value: viewModel.email,
          onChanged: viewModel.setEmail,
          errorText: viewModel.emailError,
          hintText: l10n.emailAddress,
        ),

        SizedBox(height: AppSpacing.lg),

        // Error banner
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
                  size: 20.sp,
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

        // Submit button
        AppButton.primary(
          label: l10n.submit,
          onPressed: viewModel.canSubmit ? viewModel.sendResetEmail : null,
          isLoading: viewModel.busy(ForgotPasswordViewModel.resetBusyKey),
        ),
      ],
    );
  }

  Widget _buildBackLink(
    BuildContext context,
    ForgotPasswordViewModel viewModel,
    AppLocalizations l10n,
  ) {
    return Center(
      child: TextButton(
        onPressed: viewModel.goBack,
        child: Text(
          l10n.back,
          style: AppTypography.labelMedium.copyWith(
            color: context.colorScheme.primary,
          ),
        ),
      ),
    );
  }

  @override
  ForgotPasswordViewModel viewModelBuilder(BuildContext context) =>
      ForgotPasswordViewModel();
}
