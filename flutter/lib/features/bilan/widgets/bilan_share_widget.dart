import 'package:flutter/material.dart';

import '../../../design_system/design_system.dart';
import '../../../domain/entities/weekly_bilan.dart';
import 'bilan_domain_chart.dart';

/// Offscreen widget wrapped in RepaintBoundary for share screenshot.
class BilanShareWidget extends StatelessWidget {
  final GlobalKey repaintKey;
  final WeeklyBilan bilan;
  final String weekLabel;

  const BilanShareWidget({
    super.key,
    required this.repaintKey,
    required this.bilan,
    required this.weekLabel,
  });

  String _formatHours(int minutes) {
    final h = minutes ~/ 60;
    final m = minutes % 60;
    if (h == 0) return '${m}min';
    if (m == 0) return '${h}h';
    return '${h}h${m.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: repaintKey,
      child: Container(
        width: 360,
        padding: EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppRadius.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Text(
              '📊 Mon bilan LifeFlow',
              style: AppTypography.titleLarge.copyWith(
                color: AppColors.textPrimary(Brightness.light),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppSpacing.xxs),
            Text(
              weekLabel,
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textSecondary(Brightness.light),
              ),
            ),
            SizedBox(height: AppSpacing.lg),

            // Highlights (inline version for share)
            _ShareStatsRow(bilan: bilan, formatHours: _formatHours),
            SizedBox(height: AppSpacing.lg),

            // Domain chart
            BilanDomainChart(
              counters: bilan.domainTimes,
              totalMinutes: bilan.totalMinutes,
            ),
            SizedBox(height: AppSpacing.lg),

            // Branding
            Text(
              'LifeFlow — Habitudes & Temps',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.textTertiary(Brightness.light),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShareStatsRow extends StatelessWidget {
  final WeeklyBilan bilan;
  final String Function(int) formatHours;

  const _ShareStatsRow({required this.bilan, required this.formatHours});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _StatChip(emoji: '📈', value: bilan.completionRateLabel),
        _StatChip(emoji: '⏱️', value: formatHours(bilan.totalMinutes)),
        if (bilan.longestStreak != null &&
            bilan.longestStreak!.currentStreak > 0)
          _StatChip(
              emoji: '🔥', value: '${bilan.longestStreak!.currentStreak}j'),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final String emoji;
  final String value;

  const _StatChip({required this.emoji, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceSecondary(Brightness.light),
        borderRadius: AppRadius.md,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: TextStyle(fontSize: 16)),
          SizedBox(width: AppSpacing.xxs),
          Text(
            value,
            style: AppTypography.titleSmall.copyWith(
              color: AppColors.textPrimary(Brightness.light),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
