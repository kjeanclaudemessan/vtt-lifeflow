import 'package:flutter/material.dart';

import '../../../core/enums/lifeflow_enums.dart';
import '../../../design_system/design_system.dart';
import '../../../domain/entities/domain_entity.dart';
import '../../../domain/entities/habit_entity.dart';
import '../../../domain/entities/habit_log_entity.dart';
import '../../../domain/entities/streak_info.dart';
import '../../habits/widgets/habit_check_tile.dart';

/// Groups habits by [TimeSlot] with section headers.
///
/// Renders HabitCheckTile for each habit within its time slot section.
class TodayHabitsSection extends StatelessWidget {
  /// Habits grouped by time slot.
  final Map<TimeSlot, List<HabitEntity>> habitsBySlot;

  /// Resolver for domain entities.
  final DomainEntity? Function(String? domainId) domainResolver;

  /// Resolver for today's log.
  final HabitLogEntity? Function(String habitId) logResolver;

  /// Resolver for streak info.
  final StreakInfo Function(String habitId) streakResolver;

  /// Called when a habit is toggled.
  final void Function(String habitId) onToggle;

  const TodayHabitsSection({
    super.key,
    required this.habitsBySlot,
    required this.domainResolver,
    required this.logResolver,
    required this.streakResolver,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: habitsBySlot.entries.map((entry) {
        final slot = entry.key;
        final habits = entry.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header
            Padding(
              padding: EdgeInsets.only(
                top: AppSpacing.md,
                bottom: AppSpacing.xs,
              ),
              child: Text(
                slot.label,
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.textSecondary(brightness),
                ),
              ),
            ),
            // Habit tiles
            ...habits.asMap().entries.map((habitEntry) {
              final index = habitEntry.key;
              final habit = habitEntry.value;
              return TweenAnimationBuilder<double>(
                key: ValueKey(habit.id),
                tween: Tween(begin: 0.0, end: 1.0),
                duration:
                    AppAnimations.medium + AppAnimations.staggeredDelay(index),
                curve: AppAnimations.easeOut,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 12 * (1 - value)),
                      child: child,
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.only(bottom: AppSpacing.xs),
                  child: HabitCheckTile(
                    habit: habit,
                    domain: domainResolver(habit.domainId),
                    log: logResolver(habit.id),
                    streak: streakResolver(habit.id),
                    onToggle: () => onToggle(habit.id),
                  ),
                ),
              );
            }),
          ],
        );
      }).toList(),
    );
  }
}
