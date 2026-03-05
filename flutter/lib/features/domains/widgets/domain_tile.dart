import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../design_system/design_system.dart';
import '../../../domain/entities/domain_entity.dart';

/// A tile representing a single domain in the reorderable list.
///
/// Shows drag handle, emoji icon, name, habit count, and swipe-to-archive.
class DomainTile extends StatelessWidget {
  /// The domain to display.
  final DomainEntity domain;

  /// Number of habits linked to this domain.
  final int habitCount;

  /// Called when the user taps the tile (edit).
  final VoidCallback? onTap;

  /// Called when the user swipes to archive.
  final VoidCallback? onArchive;

  /// Called when the user taps restore (archived domains).
  final VoidCallback? onRestore;

  /// Whether this domain is archived (greyed-out styling).
  final bool isArchived;

  const DomainTile({
    super.key,
    required this.domain,
    this.habitCount = 0,
    this.onTap,
    this.onArchive,
    this.onRestore,
    this.isArchived = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isArchived) {
      return _buildArchivedTile(context);
    }
    return _buildActiveTile(context);
  }

  Widget _buildActiveTile(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return AppSwipeToAction(
      itemKey: ValueKey(domain.id),
      onAction: () async {
        onArchive?.call();
        return false; // Let the viewmodel handle the removal
      },
      backgroundColor: AppColors.warning,
      iconColor: Colors.white,
      child: AppListTile(
        leading: Text(
          domain.icon,
          style: TextStyle(fontSize: 28),
        ),
        title: Text(
          domain.name,
          style: AppTypography.titleMedium.copyWith(
            color: AppColors.textPrimary(brightness),
          ),
        ),
        subtitle: Text(
          context.l10n.domainHabitCount(habitCount),
          style: AppTypography.textSmall.copyWith(
            color: AppColors.textSecondary(brightness),
          ),
        ),
        trailing: Icon(
          Icons.drag_handle,
          color: AppColors.textSecondary(brightness),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildArchivedTile(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return AppListTile(
      leading: Opacity(
        opacity: 0.5,
        child: Text(
          domain.icon,
          style: TextStyle(fontSize: 28),
        ),
      ),
      title: Text(
        context.l10n.archivedLabel(domain.name),
        style: AppTypography.titleMedium.copyWith(
          color: AppColors.textSecondary(brightness),
        ),
      ),
      trailing: TextButton(
        onPressed: onRestore,
        child: Text(
          context.l10n.restore,
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
