import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../app/app.locator.dart';
import '../../design_system/design_system.dart';

/// Enhanced dialog service with custom styled dialogs.
///
/// Wraps [DialogService] from stacked_services and adds
/// convenience methods for common dialog patterns using
/// the app's design system.
///
/// Example:
/// ```dart
/// final dialogHelper = locator<DialogHelper>();
///
/// // Simple confirmation
/// final confirmed = await dialogHelper.showConfirmation(
///   title: 'Delete Item',
///   message: 'Are you sure you want to delete this item?',
/// );
///
/// // Loading dialog
/// dialogHelper.showLoading(message: 'Please wait...');
/// // ... do work
/// dialogHelper.hideLoading();
/// ```
class DialogHelper {
  final _dialogService = locator<DialogService>();
  final _navigationService = locator<NavigationService>();

  // Track loading dialog
  bool _isLoadingVisible = false;

  // ═══════════════════════════════════════════════════════════════════════════
  // CONFIRMATION DIALOGS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Shows a confirmation dialog.
  ///
  /// Returns `true` if confirmed, `false` if cancelled.
  Future<bool> showConfirmation({
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDestructive = false,
  }) async {
    final response = await _dialogService.showConfirmationDialog(
      title: title,
      description: message,
      confirmationTitle: confirmText,
      cancelTitle: cancelText,
      dialogPlatform: DialogPlatform.Material,
    );

    return response?.confirmed ?? false;
  }

  /// Shows a destructive confirmation dialog (e.g., delete).
  Future<bool> showDestructiveConfirmation({
    required String title,
    required String message,
    String confirmText = 'Delete',
    String cancelText = 'Cancel',
  }) async {
    return showConfirmation(
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      isDestructive: true,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ALERT DIALOGS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Shows an info alert.
  Future<void> showInfo({
    required String title,
    required String message,
    String buttonText = 'OK',
  }) async {
    await _dialogService.showDialog(
      title: title,
      description: message,
      buttonTitle: buttonText,
      dialogPlatform: DialogPlatform.Material,
    );
  }

  /// Shows a success alert.
  Future<void> showSuccess({
    required String title,
    String? message,
    String buttonText = 'OK',
  }) async {
    await _dialogService.showDialog(
      title: '✓ $title',
      description: message ?? '',
      buttonTitle: buttonText,
      dialogPlatform: DialogPlatform.Material,
    );
  }

  /// Shows an error alert.
  Future<void> showError({
    required String title,
    String? message,
    String buttonText = 'OK',
  }) async {
    await _dialogService.showDialog(
      title: '✗ $title',
      description: message ?? '',
      buttonTitle: buttonText,
      dialogPlatform: DialogPlatform.Material,
    );
  }

  /// Shows a warning alert.
  Future<void> showWarning({
    required String title,
    String? message,
    String buttonText = 'OK',
  }) async {
    await _dialogService.showDialog(
      title: '⚠ $title',
      description: message ?? '',
      buttonTitle: buttonText,
      dialogPlatform: DialogPlatform.Material,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // LOADING DIALOG
  // ═══════════════════════════════════════════════════════════════════════════

  /// Shows a loading dialog.
  ///
  /// Call [hideLoading] to dismiss.
  void showLoading({String message = 'Loading...'}) {
    if (_isLoadingVisible) return;
    _isLoadingVisible = true;

    final context = StackedService.navigatorKey?.currentContext;
    if (context == null) return;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          content: Row(
            children: [
              const AppLoader.small(),
              AppSpacing.horizontalMd,
              Expanded(child: Text(message, style: AppTypography.bodyMedium)),
            ],
          ),
        ),
      ),
    );
  }

  /// Hides the loading dialog.
  void hideLoading() {
    if (!_isLoadingVisible) return;
    _isLoadingVisible = false;

    _navigationService.back();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // INPUT DIALOGS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Shows a text input dialog.
  ///
  /// Returns the entered text or `null` if cancelled.
  Future<String?> showTextInput({
    required String title,
    String? message,
    String? initialValue,
    String? hintText,
    String confirmText = 'OK',
    String cancelText = 'Cancel',
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
  }) async {
    final context = StackedService.navigatorKey?.currentContext;
    if (context == null) return null;

    String inputValue = initialValue ?? '';

    final result = await showDialog<String?>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: AppTypography.titleLarge),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message != null) ...[
              Text(message, style: AppTypography.bodyMedium),
              AppSpacing.verticalMd,
            ],
            TextFormField(
              initialValue: initialValue,
              decoration: InputDecoration(
                hintText: hintText,
                border: const OutlineInputBorder(),
              ),
              keyboardType: keyboardType,
              maxLength: maxLength,
              onChanged: (value) => inputValue = value,
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, inputValue),
            child: Text(confirmText),
          ),
        ],
      ),
    );

    return result;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SELECTION DIALOGS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Shows a single selection dialog.
  ///
  /// Returns the selected item or `null` if cancelled.
  Future<T?> showSingleSelection<T>({
    required String title,
    required List<T> items,
    required String Function(T item) itemLabel,
    T? selectedItem,
  }) async {
    final context = StackedService.navigatorKey?.currentContext;
    if (context == null) return null;

    return showDialog<T>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: AppTypography.titleLarge),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final isSelected = item == selectedItem;
              return ListTile(
                title: Text(itemLabel(item)),
                trailing: isSelected
                    ? Icon(
                        Icons.check,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : null,
                onTap: () => Navigator.pop(context, item),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  /// Shows a multi-selection dialog.
  ///
  /// Returns the selected items or empty list if cancelled.
  Future<List<T>> showMultiSelection<T>({
    required String title,
    required List<T> items,
    required String Function(T item) itemLabel,
    List<T> selectedItems = const [],
    String confirmText = 'Confirm',
  }) async {
    final context = StackedService.navigatorKey?.currentContext;
    if (context == null) return [];

    final selected = List<T>.from(selectedItems);

    final result = await showDialog<List<T>>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(title, style: AppTypography.titleLarge),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = selected.contains(item);
                return CheckboxListTile(
                  title: Text(itemLabel(item)),
                  value: isSelected,
                  onChanged: (checked) {
                    setState(() {
                      if (checked == true) {
                        selected.add(item);
                      } else {
                        selected.remove(item);
                      }
                    });
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, selected),
              child: Text(confirmText),
            ),
          ],
        ),
      ),
    );

    return result ?? [];
  }
}
