import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../design_system/design_system.dart';
import '../viewmodels/register_viewmodel.dart';

/// Email input field for auth forms.
class AuthEmailField extends StatefulWidget {
  final String? value;
  final ValueChanged<String>? onChanged;
  final String? errorText;
  final String? hintText;
  final bool enabled;

  const AuthEmailField({
    super.key,
    this.value,
    this.onChanged,
    this.errorText,
    this.hintText,
    this.enabled = true,
  });

  @override
  State<AuthEmailField> createState() => _AuthEmailFieldState();
}

class _AuthEmailFieldState extends State<AuthEmailField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(AuthEmailField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && widget.value != _controller.text) {
      _controller.text = widget.value ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: context.l10n.email,
      hint: widget.hintText ?? context.l10n.emailHint,
      controller: _controller,
      onChanged: widget.onChanged,
      errorText: widget.errorText,
      enabled: widget.enabled,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      prefixIcon: const Icon(Icons.email_outlined),
    );
  }
}

/// Password input field for auth forms.
class AuthPasswordField extends StatefulWidget {
  final String? value;
  final ValueChanged<String>? onChanged;
  final String? errorText;
  final String? hintText;
  final String? label;
  final bool enabled;
  final bool obscureText;
  final VoidCallback? onToggleVisibility;
  final TextInputAction? textInputAction;
  final VoidCallback? onSubmitted;

  const AuthPasswordField({
    super.key,
    this.value,
    this.onChanged,
    this.errorText,
    this.hintText,
    this.label,
    this.enabled = true,
    this.obscureText = true,
    this.onToggleVisibility,
    this.textInputAction,
    this.onSubmitted,
  });

  @override
  State<AuthPasswordField> createState() => _AuthPasswordFieldState();
}

class _AuthPasswordFieldState extends State<AuthPasswordField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(AuthPasswordField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && widget.value != _controller.text) {
      _controller.text = widget.value ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: widget.label ?? context.l10n.password,
      hint: widget.hintText ?? context.l10n.passwordHint,
      controller: _controller,
      onChanged: widget.onChanged,
      errorText: widget.errorText,
      enabled: widget.enabled,
      obscureText: widget.obscureText,
      textInputAction: widget.textInputAction ?? TextInputAction.done,
      prefixIcon: const Icon(Icons.lock_outlined),
      suffixIcon: IconButton(
        icon: Icon(
          widget.obscureText
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          color: AppColors.textTertiary(Theme.of(context).brightness),
        ),
        onPressed: widget.onToggleVisibility,
      ),
      onSubmitted:
          widget.onSubmitted != null ? (_) => widget.onSubmitted!() : null,
    );
  }
}

/// Password strength indicator.
class PasswordStrengthIndicator extends StatelessWidget {
  final PasswordStrength strength;

  const PasswordStrengthIndicator({
    super.key,
    required this.strength,
  });

  @override
  Widget build(BuildContext context) {
    if (strength == PasswordStrength.none) {
      return const SizedBox.shrink();
    }

    final (color, label, progress) = switch (strength) {
      PasswordStrength.none => (Colors.transparent, '', 0.0),
      PasswordStrength.weak => (
          AppColors.error,
          context.l10n.passwordStrengthWeak,
          0.33
        ),
      PasswordStrength.medium => (
          AppColors.warning,
          context.l10n.passwordStrengthMedium,
          0.66
        ),
      PasswordStrength.strong => (
          AppColors.success,
          context.l10n.passwordStrengthStrong,
          1.0
        ),
    };

    return Padding(
      padding: EdgeInsets.only(top: AppSpacing.xs),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: AppRadius.xs,
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: AppColors.contrastLowLight,
                valueColor: AlwaysStoppedAnimation(color),
                minHeight: 4.h,
              ),
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

/// Terms and conditions checkbox.
class TermsCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final String? termsText;
  final VoidCallback? onTermsTap;
  final VoidCallback? onPrivacyTap;

  const TermsCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.termsText,
    this.onTermsTap,
    this.onPrivacyTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24.w,
          height: 24.w,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Expanded(
          child: GestureDetector(
            onTap: () => onChanged?.call(!value),
            child: Text.rich(
              TextSpan(
                text: termsText ?? context.l10n.agreeToTermsPrefix,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary(Theme.of(context).brightness),
                ),
                children: [
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: onTermsTap,
                      child: Text(
                        context.l10n.termsAndConditions,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.primary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  const TextSpan(text: ' & '),
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: onPrivacyTap,
                      child: Text(
                        context.l10n.privacyPolicy,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.primary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Remember me checkbox.
class RememberMeCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final String? label;

  const RememberMeCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 24.w,
          height: 24.w,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
        ),
        SizedBox(width: AppSpacing.xs),
        Flexible(
          child: GestureDetector(
            onTap: () => onChanged?.call(!value),
            child: Text(
              label ?? context.l10n.rememberMe,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary(Theme.of(context).brightness),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}

/// Name input field for auth forms.
class AuthNameField extends StatefulWidget {
  final String? value;
  final ValueChanged<String>? onChanged;
  final String? errorText;
  final String? label;
  final String? hintText;
  final bool enabled;
  final IconData? prefixIcon;
  final TextInputAction? textInputAction;

  const AuthNameField({
    super.key,
    this.value,
    this.onChanged,
    this.errorText,
    this.label,
    this.hintText,
    this.enabled = true,
    this.prefixIcon,
    this.textInputAction,
  });

  @override
  State<AuthNameField> createState() => _AuthNameFieldState();
}

class _AuthNameFieldState extends State<AuthNameField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(AuthNameField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && widget.value != _controller.text) {
      _controller.text = widget.value ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: widget.label,
      hint: widget.hintText,
      controller: _controller,
      onChanged: widget.onChanged,
      errorText: widget.errorText,
      enabled: widget.enabled,
      textInputAction: widget.textInputAction ?? TextInputAction.next,
      prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
    );
  }
}
