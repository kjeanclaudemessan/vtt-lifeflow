import 'package:flutter/material.dart';

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
                  'Ton bilan de la semaine est prêt !',
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: AppSpacing.xxs),
                Text(
                  'Voir le bilan →',
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
