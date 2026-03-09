import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../design_system/design_system.dart';
import '../../../domain/entities/domain_entity.dart';

/// A bottom sheet for picking a domain from the active list.
///
/// Returns the selected [DomainEntity] or `null` if dismissed.
/// Shows a "+ Nouveau domaine" button for inline creation.
class DomainPickerSheet extends StatelessWidget {
  /// List of active (non-archived) domains to choose from.
  final List<DomainEntity> domains;

  /// Currently selected domain ID (optional).
  final String? selectedDomainId;

  /// Called when "+ Nouveau domaine" is tapped.
  final VoidCallback? onCreateNew;

  const DomainPickerSheet({
    super.key,
    required this.domains,
    this.selectedDomainId,
    this.onCreateNew,
  });

  /// Shows this picker as a modal bottom sheet and returns the selected domain.
  static Future<DomainEntity?> show({
    required BuildContext context,
    required List<DomainEntity> domains,
    String? selectedDomainId,
    VoidCallback? onCreateNew,
  }) {
    return AppBottomSheet.show<DomainEntity>(
      context: context,
      title: context.l10n.habitSelectDomain,
      child: DomainPickerSheet(
        domains: domains,
        selectedDomainId: selectedDomainId,
        onCreateNew: onCreateNew,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...domains.map((domain) {
          final isSelected = domain.id == selectedDomainId;
          return AppListTile(
            leading: Text(domain.icon, style: AppTypography.headingMedium),
            title: Text(
              domain.name,
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.textPrimary(brightness),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              ),
            ),
            trailing: isSelected
                ? Icon(Icons.check_circle, color: AppColors.primary)
                : null,
            isSelected: isSelected,
            onTap: () => Navigator.of(context).pop(domain),
          );
        }),
        SizedBox(height: AppSpacing.sm),
        AppButton.ghost(
          label: '+ Nouveau domaine',
          leftIcon: Icons.add,
          onPressed: () {
            Navigator.of(context).pop();
            onCreateNew?.call();
          },
        ),
        SizedBox(height: AppSpacing.md),
      ],
    );
  }
}
