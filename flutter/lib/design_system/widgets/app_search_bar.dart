import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_spacing.dart';
import 'app_input.dart';

/// Themed search bar wrapping [AppTextField] with search icon and
/// optional clear button.
///
/// Reusable for: habits search, tasks search, contacts search,
/// inbox filtering, OKR search, etc.
///
/// Usage:
/// ```dart
/// AppSearchBar(
///   hint: l10n.searchHabits,
///   onChanged: viewModel.setSearchQuery,
/// )
/// ```
class AppSearchBar extends StatefulWidget {
  /// Placeholder text.
  final String hint;

  /// Called on every text change.
  final ValueChanged<String>? onChanged;

  /// Called when the user submits (keyboard done).
  final ValueChanged<String>? onSubmitted;

  /// Whether to show a clear button when text is non-empty.
  final bool showClearButton;

  /// External controller (optional). If null, an internal one is created.
  final TextEditingController? controller;

  /// Whether the field should autofocus.
  final bool autofocus;

  /// Custom prefix icon. Defaults to search icon.
  final IconData prefixIcon;

  const AppSearchBar({
    super.key,
    required this.hint,
    this.onChanged,
    this.onSubmitted,
    this.showClearButton = true,
    this.controller,
    this.autofocus = false,
    this.prefixIcon = Icons.search,
  });

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  late final TextEditingController _controller;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _hasText = _controller.text.isNotEmpty;
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _controller.clear();
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      child: AppTextField(
        controller: _controller,
        hint: widget.hint,
        prefixIcon: Icon(widget.prefixIcon, size: 20.sp),
        suffixIcon: widget.showClearButton && _hasText
            ? GestureDetector(
                onTap: _clearSearch,
                child: Icon(
                  Icons.close,
                  size: 18.sp,
                  color: AppColors.textSecondary(
                    Theme.of(context).brightness,
                  ),
                ),
              )
            : null,
        onChanged: widget.onChanged,
        autofocus: widget.autofocus,
      ),
    );
  }
}
