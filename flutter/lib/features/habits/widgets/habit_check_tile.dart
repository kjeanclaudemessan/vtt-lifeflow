import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../design_system/design_system.dart';
import '../../../domain/entities/domain_entity.dart';
import '../../../domain/entities/habit_entity.dart';
import '../../../domain/entities/habit_log_entity.dart';
import '../../../domain/entities/streak_info.dart';
import 'habit_streak_badge.dart';

/// A tile for checking/unchecking a habit in daily views.
///
/// Shows checkbox (binary) or input (quantitative), domain chip,
/// streak badge, and estimated duration.
class HabitCheckTile extends StatelessWidget {
  /// The habit to display.
  final HabitEntity habit;

  /// The domain this habit belongs to.
  final DomainEntity? domain;

  /// Today's log (if any).
  final HabitLogEntity? log;

  /// Streak information.
  final StreakInfo streak;

  /// Called when the habit is toggled (check/uncheck).
  final VoidCallback? onToggle;

  /// Called when a quantitative value is submitted.
  final ValueChanged<double>? onValueSubmit;

  /// Called when the tile is tapped (navigate to detail/edit).
  final VoidCallback? onTap;

  /// Called on long-press (e.g. to edit actual time).
  final VoidCallback? onLongPress;

  const HabitCheckTile({
    super.key,
    required this.habit,
    this.domain,
    this.log,
    this.streak = StreakInfo.empty,
    this.onToggle,
    this.onValueSubmit,
    this.onTap,
    this.onLongPress,
  });

  bool get _isCompleted => log?.completed ?? false;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Semantics(
      label:
          '${habit.name}, ${_isCompleted ? context.l10n.semanticsCompleted : context.l10n.semanticsNotCompleted}',
      button: true,
      child: GestureDetector(
        onLongPress: _isCompleted ? onLongPress : null,
        child: AppCard.outlined(
          onTap: onTap,
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              // Check / input area
              _buildCheckArea(context, brightness),
              SizedBox(width: AppSpacing.sm),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Name row
                    Text(
                      _buildDisplayName(),
                      style: AppTypography.titleMedium.copyWith(
                        color: _isCompleted
                            ? AppColors.textSecondary(brightness)
                            : AppColors.textPrimary(brightness),
                        decoration: _isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    SizedBox(height: AppSpacing.xxs),
                    // Info row: domain chip + streak + duration
                    _buildInfoRow(context, brightness),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckArea(BuildContext context, Brightness brightness) {
    if (habit.isQuantitative) {
      return _buildQuantitativeCheck(context, brightness);
    }
    return AnimatedScale(
      scale: _isCompleted ? 1.0 : 0.95,
      duration: AppAnimations.fast,
      curve: AppAnimations.easeOut,
      child: Checkbox(
        value: _isCompleted,
        activeColor: AppColors.primary,
        onChanged: (_) => onToggle?.call(),
      ),
    );
  }

  Widget _buildQuantitativeCheck(BuildContext context, Brightness brightness) {
    final current = log?.value ?? 0;
    final target = habit.targetValue ?? 1;
    final percentage = (current / target).clamp(0.0, 1.0);

    return GestureDetector(
      onTap: onValueSubmit != null
          ? () => onValueSubmit?.call(current)
          : onToggle,
      child: SizedBox(
        width: 44,
        height: 44,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircularProgressIndicator(
              value: percentage,
              strokeWidth: 3,
              backgroundColor: AppColors.border(brightness),
              valueColor: AlwaysStoppedAnimation(
                _isCompleted ? AppColors.success : AppColors.primary,
              ),
            ),
            if (_isCompleted)
              Icon(
                Icons.check,
                color: AppColors.success,
                size: AppSizing.iconSm,
                semanticLabel: context.l10n.semanticsCompleted,
              ),
          ],
        ),
      ),
    );
  }

  String _buildDisplayName() {
    if (habit.isQuantitative && habit.targetValue != null) {
      final current = log?.value ?? 0;
      final target = habit.targetValue!;
      final unit = habit.unit ?? '';
      return '${habit.name} ${current.toInt()}/${target.toInt()}$unit';
    }
    return habit.name;
  }

  Widget _buildInfoRow(BuildContext context, Brightness brightness) {
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xxs,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        // Domain chip
        if (domain != null)
          AppChip(
            label: '${domain!.icon} ${domain!.name}',
            backgroundColor: domain!.displayColor.withValues(alpha: 0.15),
            textColor: domain!.displayColor,
          ),
        // Streak badge
        if (streak.currentStreak > 0)
          HabitStreakBadge(streak: streak, habitName: habit.name),
        // Duration
        Text(
          '${habit.estimatedDurationMinutes}m',
          style: AppTypography.caption.copyWith(
            color: AppColors.textSecondary(brightness),
          ),
        ),
        // Adherence indicator
        if (_isCompleted && log != null) _buildAdherenceIndicator(brightness),
      ],
    );
  }

  /// Builds a colored dot indicating time adherence.
  Widget _buildAdherenceIndicator(Brightness brightness) {
    final adherence = log!.timeAdherence(habit);
    final label = log!.adherenceLabel(habit);
    final color = adherence >= 0.85
        ? AppColors.success
        : adherence >= 0.6
        ? AppColors.warning
        : AppColors.error;

    if (label == null) return const SizedBox.shrink(); // On time, no indicator

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        SizedBox(width: AppSpacing.xxs),
        Text(label, style: AppTypography.caption.copyWith(color: color)),
      ],
    );
  }
}
