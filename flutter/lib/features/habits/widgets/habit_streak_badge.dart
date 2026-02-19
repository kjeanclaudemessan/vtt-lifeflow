import 'package:flutter/material.dart';

import '../../../design_system/design_system.dart';
import '../../../domain/entities/streak_info.dart';

/// Displays a streak badge: 🔥 Xj (normal) or ❄️ Xj (freeze active).
///
/// Tappable → opens streak detail bottom sheet.
class HabitStreakBadge extends StatelessWidget {
  /// Streak information to display.
  final StreakInfo streak;

  /// Habit name for the detail sheet title.
  final String habitName;

  const HabitStreakBadge({
    super.key,
    required this.streak,
    required this.habitName,
  });

  @override
  Widget build(BuildContext context) {
    if (streak.currentStreak <= 0) return const SizedBox.shrink();

    final label = streak.isFreezeActive
        ? '❄️ ${streak.currentStreak}j'
        : '🔥 ${streak.currentStreak}j';

    return GestureDetector(
      onTap: () => _showDetail(context),
      child: AppBadge(
        label: label,
        variant: streak.isFreezeActive
            ? AppBadgeVariant.info
            : AppBadgeVariant.warning,
      ),
    );
  }

  Future<void> _showDetail(BuildContext context) async {
    final brightness = Theme.of(context).brightness;

    await AppBottomSheet.show(
      context: context,
      title: streak.isFreezeActive
          ? '❄️ Streak: $habitName'
          : '🔥 Streak: $habitName',
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${streak.currentStreak} jours consécutifs',
              style: AppTypography.headingSmall.copyWith(
                color: AppColors.textPrimary(brightness),
              ),
            ),
            SizedBox(height: AppSpacing.xs),
            Text(
              'Record: ${streak.bestStreak} jours',
              style: AppTypography.textMedium.copyWith(
                color: AppColors.textSecondary(brightness),
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            if (streak.freezeUsedDates.isNotEmpty) ...[
              Text(
                'Freeze utilisé ${streak.freezeUsedDates.length} fois',
                style: AppTypography.textSmall.copyWith(
                  color: AppColors.info,
                ),
              ),
              SizedBox(height: AppSpacing.xs),
              Text(
                'Règle: 1 freeze max par période de 7 jours',
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary(brightness),
                ),
              ),
            ],
            SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}
