import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
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
              context.l10n.streakConsecutiveDays(streak.currentStreak),
              style: AppTypography.headingSmall.copyWith(
                color: AppColors.textPrimary(brightness),
              ),
            ),
            SizedBox(height: AppSpacing.xs),
            Text(
              context.l10n.streakBest(streak.bestStreak),
              style: AppTypography.textMedium.copyWith(
                color: AppColors.textSecondary(brightness),
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            if (streak.freezeUsedDates.isNotEmpty) ...[
              Text(
                context.l10n
                    .streakFreezeUsedCount(streak.freezeUsedDates.length),
                style: AppTypography.textSmall.copyWith(
                  color: AppColors.info,
                ),
              ),
              SizedBox(height: AppSpacing.xs),
              Text(
                context.l10n.streakFreezeRule,
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
