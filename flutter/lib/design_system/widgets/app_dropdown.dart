import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';
import '../tokens/app_typography.dart';

/// A styled dropdown/select component following Porsche Design System.
///
/// Example:
/// ```dart
/// AppDropdown<String>(
///   value: _selectedValue,
///   items: [
///     AppDropdownItem(value: 'opt1', label: 'Option 1'),
///     AppDropdownItem(value: 'opt2', label: 'Option 2'),
///     AppDropdownItem(value: 'opt3', label: 'Option 3'),
///   ],
///   onChanged: (value) => setState(() => _selectedValue = value),
///   hint: 'Select an option',
///   label: 'Options',
/// );
/// ```
class AppDropdown<T> extends StatelessWidget {
  /// Currently selected value.
  final T? value;

  /// List of dropdown items.
  final List<AppDropdownItem<T>> items;

  /// Callback when selection changes.
  final ValueChanged<T?>? onChanged;

  /// Hint text when nothing is selected.
  final String? hint;

  /// Label above the dropdown.
  final String? label;

  /// Helper text below the dropdown.
  final String? helperText;

  /// Error text (shows error state).
  final String? errorText;

  /// Whether the dropdown is disabled.
  final bool isDisabled;

  /// Whether the dropdown is required.
  final bool isRequired;

  /// Custom icon for the dropdown arrow.
  final IconData? icon;

  /// Whether to show a clear button.
  final bool showClearButton;

  /// Creates an [AppDropdown].
  const AppDropdown({
    super.key,
    required this.value,
    required this.items,
    this.onChanged,
    this.hint,
    this.label,
    this.helperText,
    this.errorText,
    this.isDisabled = false,
    this.isRequired = false,
    this.icon,
    this.showClearButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasError = errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        if (label != null) ...[
          Row(
            children: [
              Text(
                label!,
                style: AppTypography.labelMedium.copyWith(
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
              ),
              if (isRequired) ...[
                SizedBox(width: 4.w),
                Text(
                  '*',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 8.h),
        ],

        // Dropdown
        Container(
          decoration: BoxDecoration(
            borderRadius: AppRadius.input,
            border: Border.all(
              color: hasError
                  ? AppColors.error
                  : (isDark ? AppColors.borderDark : AppColors.borderLight),
              width: hasError ? 2 : 1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              hint: hint != null
                  ? Text(
                      hint!,
                      style: AppTypography.bodyMedium.copyWith(
                        color: isDark
                            ? AppColors.textDisabledDark
                            : AppColors.textDisabledLight,
                      ),
                    )
                  : null,
              onChanged: isDisabled ? null : onChanged,
              isExpanded: true,
              icon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showClearButton && value != null)
                    GestureDetector(
                      onTap: () => onChanged?.call(null),
                      child: Padding(
                        padding: EdgeInsets.all(4.w),
                        child: Icon(
                          Icons.close_rounded,
                          size: 18.sp,
                          color: isDark
                              ? AppColors.contrastMediumDark
                              : AppColors.contrastMediumLight,
                        ),
                      ),
                    ),
                  Icon(
                    icon ?? Icons.keyboard_arrow_down_rounded,
                    color: isDisabled
                        ? (isDark
                            ? AppColors.textDisabledDark
                            : AppColors.textDisabledLight)
                        : (isDark
                            ? AppColors.contrastHighDark
                            : AppColors.contrastHighLight),
                  ),
                ],
              ),
              padding: AppSpacing.inputPadding,
              borderRadius: AppRadius.input,
              dropdownColor:
                  isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              style: AppTypography.bodyMedium.copyWith(
                color: isDisabled
                    ? (isDark
                        ? AppColors.textDisabledDark
                        : AppColors.textDisabledLight)
                    : (isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight),
              ),
              items: items
                  .map(
                    (item) => DropdownMenuItem<T>(
                      value: item.value,
                      enabled: !item.isDisabled,
                      child: _DropdownItemContent(
                        item: item,
                        isDark: isDark,
                        isSelected: item.value == value,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),

        // Helper/Error text
        if (helperText != null || errorText != null) ...[
          SizedBox(height: 4.h),
          Text(
            errorText ?? helperText!,
            style: AppTypography.bodySmall.copyWith(
              color: hasError
                  ? AppColors.error
                  : (isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight),
            ),
          ),
        ],
      ],
    );
  }
}

/// Content widget for dropdown items.
class _DropdownItemContent<T> extends StatelessWidget {
  final AppDropdownItem<T> item;
  final bool isDark;
  final bool isSelected;

  const _DropdownItemContent({
    required this.item,
    required this.isDark,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = item.isDisabled
        ? (isDark ? AppColors.textDisabledDark : AppColors.textDisabledLight)
        : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight);

    return Row(
      children: [
        if (item.icon != null) ...[
          Icon(
            item.icon,
            size: 20.sp,
            color: textColor,
          ),
          SizedBox(width: 12.w),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item.label,
                style: AppTypography.bodyMedium.copyWith(
                  color: textColor,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
              if (item.subtitle != null) ...[
                SizedBox(height: 2.h),
                Text(
                  item.subtitle!,
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (isSelected)
          Icon(
            Icons.check_rounded,
            size: 20.sp,
            color: AppColors.primary,
          ),
      ],
    );
  }
}

/// Item for dropdown.
class AppDropdownItem<T> {
  /// Item value.
  final T value;

  /// Item label.
  final String label;

  /// Optional subtitle.
  final String? subtitle;

  /// Optional leading icon.
  final IconData? icon;

  /// Whether this item is disabled.
  final bool isDisabled;

  /// Creates an [AppDropdownItem].
  const AppDropdownItem({
    required this.value,
    required this.label,
    this.subtitle,
    this.icon,
    this.isDisabled = false,
  });
}

/// A searchable dropdown variant.
///
/// Example:
/// ```dart
/// AppSearchableDropdown<String>(
///   value: _selectedValue,
///   items: _countries,
///   onChanged: (value) => setState(() => _selectedValue = value),
///   hint: 'Search countries...',
///   label: 'Country',
/// );
/// ```
class AppSearchableDropdown<T> extends StatefulWidget {
  /// Currently selected value.
  final T? value;

  /// List of dropdown items.
  final List<AppDropdownItem<T>> items;

  /// Callback when selection changes.
  final ValueChanged<T?>? onChanged;

  /// Search hint text.
  final String? hint;

  /// Label above the dropdown.
  final String? label;

  /// Helper text below the dropdown.
  final String? helperText;

  /// Error text (shows error state).
  final String? errorText;

  /// Whether the dropdown is disabled.
  final bool isDisabled;

  /// Whether the dropdown is required.
  final bool isRequired;

  /// Custom search filter function.
  final bool Function(AppDropdownItem<T> item, String query)? searchFilter;

  /// Creates an [AppSearchableDropdown].
  const AppSearchableDropdown({
    super.key,
    required this.value,
    required this.items,
    this.onChanged,
    this.hint,
    this.label,
    this.helperText,
    this.errorText,
    this.isDisabled = false,
    this.isRequired = false,
    this.searchFilter,
  });

  @override
  State<AppSearchableDropdown<T>> createState() =>
      _AppSearchableDropdownState<T>();
}

class _AppSearchableDropdownState<T> extends State<AppSearchableDropdown<T>> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _isOpen = false;
  List<AppDropdownItem<T>> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    _updateDisplayText();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(covariant AppSearchableDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _updateDisplayText();
    }
    if (widget.items != oldWidget.items) {
      _filteredItems = widget.items;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _updateDisplayText() {
    if (widget.value != null) {
      final selected = widget.items.firstWhere(
        (item) => item.value == widget.value,
        orElse: () => widget.items.first,
      );
      _controller.text = selected.label;
    } else {
      _controller.clear();
    }
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      setState(() {
        _isOpen = true;
        _controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _controller.text.length,
        );
      });
    } else {
      setState(() {
        _isOpen = false;
        _updateDisplayText();
      });
    }
  }

  void _onSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = widget.items;
      } else {
        _filteredItems = widget.items.where((item) {
          if (widget.searchFilter != null) {
            return widget.searchFilter!(item, query);
          }
          return item.label.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void _onSelect(AppDropdownItem<T> item) {
    widget.onChanged?.call(item.value);
    _controller.text = item.label;
    _focusNode.unfocus();
    setState(() => _isOpen = false);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasError = widget.errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        if (widget.label != null) ...[
          Row(
            children: [
              Text(
                widget.label!,
                style: AppTypography.labelMedium.copyWith(
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
              ),
              if (widget.isRequired) ...[
                SizedBox(width: 4.w),
                Text(
                  '*',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 8.h),
        ],

        // Search field
        TextField(
          controller: _controller,
          focusNode: _focusNode,
          enabled: !widget.isDisabled,
          onChanged: _onSearch,
          decoration: InputDecoration(
            hintText: widget.hint,
            suffixIcon: Icon(
              _isOpen
                  ? Icons.keyboard_arrow_up_rounded
                  : Icons.keyboard_arrow_down_rounded,
            ),
            errorText: hasError ? '' : null,
            errorStyle: const TextStyle(height: 0),
          ),
        ),

        // Dropdown list
        if (_isOpen)
          Container(
            constraints: BoxConstraints(maxHeight: 200.h),
            margin: EdgeInsets.only(top: 4.h),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              borderRadius: AppRadius.sm,
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: _filteredItems.isEmpty
                ? Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Text(
                      'No results found',
                      style: AppTypography.bodyMedium.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    itemCount: _filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = _filteredItems[index];
                      final isSelected = item.value == widget.value;

                      return InkWell(
                        onTap: item.isDisabled ? null : () => _onSelect(item),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 12.h,
                          ),
                          color: isSelected
                              ? AppColors.primary.withValues(alpha: 0.1)
                              : null,
                          child: _DropdownItemContent(
                            item: item,
                            isDark: isDark,
                            isSelected: isSelected,
                          ),
                        ),
                      );
                    },
                  ),
          ),

        // Helper/Error text
        if (widget.helperText != null || widget.errorText != null) ...[
          SizedBox(height: 4.h),
          Text(
            widget.errorText ?? widget.helperText!,
            style: AppTypography.bodySmall.copyWith(
              color: hasError
                  ? AppColors.error
                  : (isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight),
            ),
          ),
        ],
      ],
    );
  }
}
