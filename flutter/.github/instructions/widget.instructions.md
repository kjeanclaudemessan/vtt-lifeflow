---
applyTo: "**/ui/widgets/**/*.dart,**/widgets/**/*.dart,**/design_system/**/*.dart"
---
# Widget Instructions

> These instructions apply to all reusable Widget files.
> Inherits from: `dart.instructions.md`

---

## Widget Principles

### Reusable & Composable

- **Single responsibility** - one widget does one thing well
- **Configurable** - expose necessary properties
- **Self-contained** - no external state dependencies
- **Follows design system** - uses design tokens

### Location

- **UI Widgets**: `lib/ui/widgets/`
- **Design System Components**: `lib/design_system/`
- **Feature-specific Widgets**: `lib/features/<feature>/widgets/`

### Naming

| Widget Type | Prefix | Example |
|-------------|--------|---------|
| App-wide widgets | `App` | `AppButton`, `AppTextField` |
| Design system | `Ds` | `DsCard`, `DsAvatar` |
| Feature widgets | None | `ProductCard`, `OrderItem` |

---

## Widget Structure

### Stateless Widget Template

```dart
import 'package:flutter/material.dart';

import '../../../design_system/design_system.dart';

/// A primary action button with loading state support.
///
/// Use this button for primary actions like "Submit", "Save", "Continue".
///
/// Example:
/// ```dart
/// AppButton(
///   label: 'Submit',
///   onPressed: () => viewModel.submit(),
///   isLoading: viewModel.isBusy,
/// )
/// ```
class AppButton extends StatelessWidget {
  /// The button label text.
  final String label;

  /// Callback when button is pressed.
  /// If null, the button will be disabled.
  final VoidCallback? onPressed;

  /// Whether to show loading indicator.
  final bool isLoading;

  /// Button variant style.
  final AppButtonVariant variant;

  /// Button size.
  final AppButtonSize size;

  /// Optional icon to show before the label.
  final IconData? prefixIcon;

  /// Optional icon to show after the label.
  final IconData? suffixIcon;

  /// Whether the button should take full width.
  final bool isExpanded;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.prefixIcon,
    this.suffixIcon,
    this.isExpanded = false,
  });

  // ─────────────────────────────────────────────────────────────────
  // Named Constructors for Common Variants
  // ─────────────────────────────────────────────────────────────────

  /// Creates a secondary (outlined) button.
  const AppButton.secondary({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.size = AppButtonSize.medium,
    this.prefixIcon,
    this.suffixIcon,
    this.isExpanded = false,
  }) : variant = AppButtonVariant.secondary;

  /// Creates a text-only button.
  const AppButton.text({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.size = AppButtonSize.medium,
    this.prefixIcon,
    this.suffixIcon,
    this.isExpanded = false,
  }) : variant = AppButtonVariant.text;

  /// Creates a destructive (danger) button.
  const AppButton.destructive({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.size = AppButtonSize.medium,
    this.prefixIcon,
    this.suffixIcon,
    this.isExpanded = false,
  }) : variant = AppButtonVariant.destructive;

  // ─────────────────────────────────────────────────────────────────
  // Computed Properties
  // ─────────────────────────────────────────────────────────────────

  bool get _isDisabled => onPressed == null || isLoading;

  EdgeInsets get _padding => switch (size) {
        AppButtonSize.small => const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
        AppButtonSize.medium => const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
        AppButtonSize.large => const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
      };

  double get _iconSize => switch (size) {
        AppButtonSize.small => 16,
        AppButtonSize.medium => 20,
        AppButtonSize.large => 24,
      };

  TextStyle get _textStyle => switch (size) {
        AppButtonSize.small => AppTypography.labelSmall,
        AppButtonSize.medium => AppTypography.labelMedium,
        AppButtonSize.large => AppTypography.labelLarge,
      };

  // ─────────────────────────────────────────────────────────────────
  // Build
  // ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final button = switch (variant) {
      AppButtonVariant.primary => _buildPrimaryButton(context),
      AppButtonVariant.secondary => _buildSecondaryButton(context),
      AppButtonVariant.text => _buildTextButton(context),
      AppButtonVariant.destructive => _buildDestructiveButton(context),
    };

    if (isExpanded) {
      return SizedBox(
        width: double.infinity,
        child: button,
      );
    }

    return button;
  }

  Widget _buildPrimaryButton(BuildContext context) {
    return ElevatedButton(
      onPressed: _isDisabled ? null : onPressed,
      style: ElevatedButton.styleFrom(
        padding: _padding,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
        disabledForegroundColor: AppColors.onPrimary.withOpacity(0.7),
      ),
      child: _buildContent(AppColors.onPrimary),
    );
  }

  Widget _buildSecondaryButton(BuildContext context) {
    return OutlinedButton(
      onPressed: _isDisabled ? null : onPressed,
      style: OutlinedButton.styleFrom(
        padding: _padding,
        foregroundColor: AppColors.primary,
        side: BorderSide(color: AppColors.primary),
      ),
      child: _buildContent(AppColors.primary),
    );
  }

  Widget _buildTextButton(BuildContext context) {
    return TextButton(
      onPressed: _isDisabled ? null : onPressed,
      style: TextButton.styleFrom(
        padding: _padding,
        foregroundColor: AppColors.primary,
      ),
      child: _buildContent(AppColors.primary),
    );
  }

  Widget _buildDestructiveButton(BuildContext context) {
    return ElevatedButton(
      onPressed: _isDisabled ? null : onPressed,
      style: ElevatedButton.styleFrom(
        padding: _padding,
        backgroundColor: AppColors.error,
        foregroundColor: AppColors.onError,
      ),
      child: _buildContent(AppColors.onError),
    );
  }

  Widget _buildContent(Color color) {
    if (isLoading) {
      return SizedBox(
        width: _iconSize,
        height: _iconSize,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (prefixIcon != null) ...[
          Icon(prefixIcon, size: _iconSize),
          const SizedBox(width: AppSpacing.xs),
        ],
        Text(label, style: _textStyle),
        if (suffixIcon != null) ...[
          const SizedBox(width: AppSpacing.xs),
          Icon(suffixIcon, size: _iconSize),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// Enums
// ─────────────────────────────────────────────────────────────────

enum AppButtonVariant {
  primary,
  secondary,
  text,
  destructive,
}

enum AppButtonSize {
  small,
  medium,
  large,
}
```

---

## Stateful Widget Template

```dart
import 'package:flutter/material.dart';

import '../../../design_system/design_system.dart';

/// A text input field with validation and formatting support.
class AppTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? errorText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool enabled;
  final int? maxLines;
  final int? maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;

  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.errorText,
    this.controller,
    this.onChanged,
    this.onEditingComplete,
    this.keyboardType,
    this.obscureText = false,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.focusNode,
    this.textInputAction,
    this.validator,
  });

  /// Creates a password input field.
  factory AppTextField.password({
    Key? key,
    String? label,
    String? hint,
    String? errorText,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    VoidCallback? onEditingComplete,
    bool enabled = true,
    FocusNode? focusNode,
    TextInputAction? textInputAction,
    String? Function(String?)? validator,
  }) {
    return _AppPasswordTextField(
      key: key,
      label: label,
      hint: hint,
      errorText: errorText,
      controller: controller,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      enabled: enabled,
      focusNode: focusNode,
      textInputAction: textInputAction,
      validator: validator,
    );
  }

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _focusNode.removeListener(_handleFocusChange);
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTypography.labelMedium.copyWith(
              color: widget.errorText != null
                  ? AppColors.error
                  : _isFocused
                      ? AppColors.primary
                      : AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          onChanged: widget.onChanged,
          onEditingComplete: widget.onEditingComplete,
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText,
          enabled: widget.enabled,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          textInputAction: widget.textInputAction,
          validator: widget.validator,
          decoration: InputDecoration(
            hintText: widget.hint,
            errorText: widget.errorText,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,
          ),
        ),
      ],
    );
  }
}

/// Password text field with visibility toggle.
class _AppPasswordTextField extends AppTextField {
  const _AppPasswordTextField({
    super.key,
    super.label,
    super.hint,
    super.errorText,
    super.controller,
    super.onChanged,
    super.onEditingComplete,
    super.enabled,
    super.focusNode,
    super.textInputAction,
    super.validator,
  }) : super(obscureText: true, maxLines: 1);

  @override
  State<AppTextField> createState() => _AppPasswordTextFieldState();
}

class _AppPasswordTextFieldState extends _AppTextFieldState {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(widget.label!, style: AppTypography.labelMedium),
          const SizedBox(height: AppSpacing.xs),
        ],
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          onChanged: widget.onChanged,
          onEditingComplete: widget.onEditingComplete,
          keyboardType: TextInputType.visiblePassword,
          obscureText: _obscureText,
          enabled: widget.enabled,
          textInputAction: widget.textInputAction,
          validator: widget.validator,
          decoration: InputDecoration(
            hintText: widget.hint,
            errorText: widget.errorText,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
```

---

## List Item Widget

```dart
/// A reusable list item with leading icon, title, subtitle, and trailing action.
class AppListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showDivider;
  final EdgeInsets? padding;

  const AppListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.showDivider = false,
    this.padding,
  });

  /// Creates a list tile with an icon leading.
  factory AppListTile.icon({
    Key? key,
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    bool showDivider = false,
    Color? iconColor,
    Color? iconBackgroundColor,
  }) {
    return AppListTile(
      key: key,
      title: title,
      subtitle: subtitle,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: iconBackgroundColor ?? AppColors.primaryContainer,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Icon(
          icon,
          color: iconColor ?? AppColors.primary,
          size: 20,
        ),
      ),
      trailing: trailing,
      onTap: onTap,
      showDivider: showDivider,
    );
  }

  /// Creates a navigation list tile with chevron.
  factory AppListTile.navigation({
    Key? key,
    required String title,
    String? subtitle,
    Widget? leading,
    required VoidCallback onTap,
    bool showDivider = false,
  }) {
    return AppListTile(
      key: key,
      title: title,
      subtitle: subtitle,
      leading: leading,
      trailing: const Icon(
        Icons.chevron_right,
        color: AppColors.onSurfaceVariant,
      ),
      onTap: onTap,
      showDivider: showDivider,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: padding ??
                const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
            child: Row(
              children: [
                if (leading != null) ...[
                  leading!,
                  const SizedBox(width: AppSpacing.md),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTypography.bodyLarge,
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),
        ),
        if (showDivider) const Divider(height: 1),
      ],
    );
  }
}
```

---

## File Organization

```
lib/
├── ui/
│   └── widgets/
│       ├── app_button.dart
│       ├── app_text_field.dart
│       ├── app_list_tile.dart
│       ├── app_avatar.dart
│       ├── app_card.dart
│       ├── app_loading.dart
│       ├── app_error.dart
│       ├── app_empty_state.dart
│       └── widgets.dart          # Barrel file
│
└── design_system/
    ├── design_system.dart        # Barrel file
    ├── theme/
    │   ├── app_theme.dart
    │   └── app_theme_data.dart
    ├── colors/
    │   └── app_colors.dart
    ├── typography/
    │   └── app_typography.dart
    ├── spacing/
    │   └── app_spacing.dart
    └── showcase/                  # Design system showcase
        ├── showcase_view.dart
        ├── buttons_showcase.dart
        ├── inputs_showcase.dart
        └── typography_showcase.dart
```

---

## Widget Documentation

Always document widgets with:

```dart
/// Brief description of the widget.
///
/// Longer description if needed, explaining:
/// - When to use this widget
/// - Key features
/// - Related widgets
///
/// Example:
/// ```dart
/// AppButton(
///   label: 'Click me',
///   onPressed: () {},
/// )
/// ```
///
/// See also:
/// - [AppButton.secondary] for outlined buttons
/// - [AppIconButton] for icon-only buttons
class AppButton extends StatelessWidget {
```

---

## Don'ts

```dart
// ❌ Don't access services directly
final authService = locator<AuthService>(); // Widgets are pure UI

// ❌ Don't use hard-coded colors
color: Color(0xFF123456) // Use AppColors

// ❌ Don't use hard-coded dimensions
padding: EdgeInsets.all(16) // Use AppSpacing

// ❌ Don't use hard-coded text styles
style: TextStyle(fontSize: 14) // Use AppTypography

// ❌ Don't make network calls
await api.get('/users') // That's ViewModel's job

// ❌ Don't manage complex state internally
// Use callbacks to report state changes to parent

// ❌ Don't have too many parameters
// Split into multiple widgets or use a config object
```
