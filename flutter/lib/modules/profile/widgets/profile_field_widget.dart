import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/core.dart';
import '../../../design_system/design_system.dart';
import '../config/profile_config.dart';

/// Generic profile field widget.
///
/// Renders different input types based on field configuration.
class ProfileFieldWidget extends StatefulWidget {
  /// Field configuration.
  final ProfileField field;

  /// Current value.
  final String value;

  /// Error message.
  final String? error;

  /// Callback when value changes.
  final ValueChanged<String>? onChanged;

  /// Whether the field is read-only.
  final bool readOnly;

  const ProfileFieldWidget({
    required this.field,
    required this.value,
    this.error,
    this.onChanged,
    this.readOnly = false,
    super.key,
  });

  @override
  State<ProfileFieldWidget> createState() => _ProfileFieldWidgetState();
}

class _ProfileFieldWidgetState extends State<ProfileFieldWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(ProfileFieldWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && widget.value != _controller.text) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isEditable = widget.field.editable && !widget.readOnly;

    // Get localized label
    final label = _getLocalizedLabel(l10n, widget.field.labelKey);
    final errorText =
        widget.error != null ? _getLocalizedLabel(l10n, widget.error!) : null;

    return switch (widget.field.type) {
      ProfileFieldType.text => _buildTextField(label, errorText, isEditable),
      ProfileFieldType.email => _buildEmailField(label, errorText, isEditable),
      ProfileFieldType.phone => _buildPhoneField(label, errorText, isEditable),
      ProfileFieldType.number =>
        _buildNumberField(label, errorText, isEditable),
      ProfileFieldType.date =>
        _buildDateField(context, label, errorText, isEditable),
      ProfileFieldType.select =>
        _buildSelectField(context, label, errorText, isEditable),
      ProfileFieldType.multiSelect =>
        _buildMultiSelectField(context, label, errorText, isEditable),
      ProfileFieldType.textarea =>
        _buildTextareaField(label, errorText, isEditable),
    };
  }

  Widget _buildTextField(String label, String? errorText, bool isEditable) {
    return AppTextField(
      label: label,
      controller: _controller,
      onChanged: widget.onChanged,
      errorText: errorText,
      enabled: isEditable,
      prefixIcon: widget.field.icon != null ? Icon(widget.field.icon) : null,
    );
  }

  Widget _buildEmailField(String label, String? errorText, bool isEditable) {
    return AppTextField(
      label: label,
      controller: _controller,
      onChanged: widget.onChanged,
      errorText: errorText,
      enabled: isEditable,
      keyboardType: TextInputType.emailAddress,
      prefixIcon: Icon(widget.field.icon ?? Icons.email_outlined),
    );
  }

  Widget _buildPhoneField(String label, String? errorText, bool isEditable) {
    return AppTextField(
      label: label,
      controller: _controller,
      onChanged: widget.onChanged,
      errorText: errorText,
      enabled: isEditable,
      keyboardType: TextInputType.phone,
      prefixIcon: Icon(widget.field.icon ?? Icons.phone_outlined),
    );
  }

  Widget _buildNumberField(String label, String? errorText, bool isEditable) {
    return AppTextField(
      label: label,
      controller: _controller,
      onChanged: widget.onChanged,
      errorText: errorText,
      enabled: isEditable,
      keyboardType: TextInputType.number,
      prefixIcon: widget.field.icon != null ? Icon(widget.field.icon) : null,
    );
  }

  Widget _buildDateField(
      BuildContext context, String label, String? errorText, bool isEditable) {
    return GestureDetector(
      onTap: isEditable
          ? () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.tryParse(widget.value) ?? DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (date != null) {
                widget.onChanged?.call(date.toIso8601String().split('T').first);
              }
            }
          : null,
      child: AbsorbPointer(
        child: AppTextField(
          label: label,
          controller: _controller,
          errorText: errorText,
          enabled: isEditable,
          prefixIcon: Icon(widget.field.icon ?? Icons.calendar_today_outlined),
          suffixIcon: const Icon(Icons.arrow_drop_down),
        ),
      ),
    );
  }

  Widget _buildSelectField(
      BuildContext context, String label, String? errorText, bool isEditable) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.textSecondary(Theme.of(context).brightness),
          ),
        ),
        SizedBox(height: AppSpacing.xs),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: errorText != null ? AppColors.error : AppColors.neutral300,
            ),
            borderRadius: AppRadius.md,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: widget.value.isEmpty ? null : widget.value,
              isExpanded: true,
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              hint: Text(
                label,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.neutral400,
                ),
              ),
              items: widget.field.options?.map((option) {
                return DropdownMenuItem(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
              onChanged: isEditable
                  ? (newValue) {
                      if (newValue != null) widget.onChanged?.call(newValue);
                    }
                  : null,
            ),
          ),
        ),
        if (errorText != null) ...[
          SizedBox(height: AppSpacing.xs),
          Text(
            errorText,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.error,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildMultiSelectField(
      BuildContext context, String label, String? errorText, bool isEditable) {
    // For now, render as a simple text field
    // In a real app, this would open a multi-select dialog
    return _buildTextField(label, errorText, isEditable);
  }

  Widget _buildTextareaField(String label, String? errorText, bool isEditable) {
    return AppTextField(
      label: label,
      controller: _controller,
      onChanged: widget.onChanged,
      errorText: errorText,
      enabled: isEditable,
      maxLines: 4,
      prefixIcon: widget.field.icon != null ? Icon(widget.field.icon) : null,
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
        'fieldRequired' => l10n.fieldRequired,
        'emailInvalid' => l10n.emailInvalid,
        'phoneInvalid' => l10n.phoneInvalid,
        _ => key,
      };
    } catch (_) {
      return key;
    }
  }
}

/// Read-only profile field display.
///
/// Shows a field value without editing capability.
class ProfileFieldDisplay extends StatelessWidget {
  /// Label text.
  final String label;

  /// Value text.
  final String value;

  /// Optional icon.
  final IconData? icon;

  /// Callback when tapped.
  final VoidCallback? onTap;

  const ProfileFieldDisplay({
    required this.label,
    required this.value,
    this.icon,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.md,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.sm,
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 20.sp,
                color: AppColors.neutral500,
              ),
              SizedBox(width: AppSpacing.md),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTypography.bodySmall.copyWith(
                      color:
                          AppColors.textSecondary(Theme.of(context).brightness),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    value.isEmpty ? '-' : value,
                    style: AppTypography.bodyMedium.copyWith(
                      color: value.isEmpty
                          ? AppColors.neutral400
                          : context.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.chevron_right_rounded,
                size: 20.sp,
                color: AppColors.neutral400,
              ),
          ],
        ),
      ),
    );
  }
}
