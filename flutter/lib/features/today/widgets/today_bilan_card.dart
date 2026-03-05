import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../design_system/design_system.dart';

/// Card prompting the user to view their weekly bilan.
///
/// Visible only on Sunday evening / Monday morning.
class TodayBilanCard extends StatelessWidget {
  /// Called when the card is tapped.
  final VoidCallback? onTap;

  const TodayBilanCard({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard.filled(
      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
      onTap: onTap,
      padding: EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Text('📊', style: TextStyle(fontSize: 28)),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.bilanWeeklyReady,
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: AppSpacing.xxs),
                Text(
                  context.l10n.bilanViewSummary,
                  style: AppTypography.textSmall.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
