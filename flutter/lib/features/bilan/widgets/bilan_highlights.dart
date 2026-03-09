import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../design_system/design_system.dart';
import '../../../domain/entities/weekly_bilan.dart';

/// Highlights card with top habit, longest streak, and completion rate.
class BilanHighlights extends StatelessWidget {
  final WeeklyBilan bilan;

  const BilanHighlights({super.key, required this.bilan});

  String _formatHours(int minutes) {
    final h = minutes ~/ 60;
    final m = minutes % 60;
    if (h == 0) return '${m}min';
    if (m == 0) return '${h}h';
    return '${h}h${m.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return AppCard.elevated(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.bilanHighlights,
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textPrimary(brightness),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          if (bilan.topHabit != null)
            _HighlightRow(
              emoji: '🏆',
              label: context.l10n.bilanTopHabit,
              value: bilan.topHabit!.name,
            ),
          if (bilan.longestStreak != null) ...[
            SizedBox(height: AppSpacing.sm),
            _HighlightRow(
              emoji: '🔥',
              label: context.l10n.bilanLongestStreak,
              value: '${bilan.longestStreak!.currentStreak}j',
            ),
          ],
          SizedBox(height: AppSpacing.sm),
          _HighlightRow(
            emoji: '📈',
            label: context.l10n.bilanCompletionRate,
            value: bilan.completionRateLabel,
          ),
          SizedBox(height: AppSpacing.sm),
          _HighlightRow(
            emoji: '⏱️',
            label: context.l10n.bilanTotalTime,
            value: _formatHours(bilan.totalMinutes),
          ),
        ],
      ),
    );
  }
}

class _HighlightRow extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;

  const _HighlightRow({
    required this.emoji,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Row(
      children: [
        Text(emoji, style: AppTypography.headingSmall),
        SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.textSecondary(brightness),
                ),
              ),
              Text(
                value,
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.textPrimary(brightness),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
