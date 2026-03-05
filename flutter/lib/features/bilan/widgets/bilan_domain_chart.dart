import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../design_system/design_system.dart';
import '../../../domain/entities/time_counter.dart';

/// Horizontal bars chart showing time per domain with percentages.
class BilanDomainChart extends StatelessWidget {
  /// Time counters sorted by total minutes (descending).
  final List<TimeCounter> counters;

  /// Total minutes across all domains.
  final int totalMinutes;

  const BilanDomainChart({
    super.key,
    required this.counters,
    required this.totalMinutes,
  });

  String _formatHours(double hours) {
    final h = hours.floor();
    final m = ((hours - h) * 60).round();
    if (h == 0) return '${m}min';
    if (m == 0) return '${h}h';
    return '${h}h${m.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    if (counters.isEmpty) {
      return Text(
        context.l10n.bilanNoDataThisWeek,
        style: AppTypography.textSmall.copyWith(
          color: AppColors.textSecondary(brightness),
        ),
      );
    }

    final maxMinutes = counters
        .map((c) => c.totalMinutesThisWeek)
        .reduce((a, b) => a > b ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: counters.map((counter) {
        final percentage = totalMinutes > 0
            ? (counter.totalMinutesThisWeek / totalMinutes * 100).round()
            : 0;
        final barValue =
            maxMinutes > 0 ? counter.totalMinutesThisWeek / maxMinutes : 0.0;

        return Padding(
          padding: EdgeInsets.only(bottom: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    counter.domainIcon,
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      counter.domainName,
                      style: AppTypography.titleSmall.copyWith(
                        color: AppColors.textPrimary(brightness),
                      ),
                    ),
                  ),
                  Text(
                    '${_formatHours(counter.hoursThisWeek)}  $percentage%',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.textSecondary(brightness),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.xxs),
              AppLinearProgress(
                value: barValue.clamp(0.0, 1.0),
                height: 10,
                backgroundColor: counter.domainColor.withValues(alpha: 0.15),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
