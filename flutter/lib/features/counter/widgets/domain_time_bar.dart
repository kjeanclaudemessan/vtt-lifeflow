import 'package:flutter/material.dart';

import '../../../design_system/design_system.dart';
import '../../../domain/entities/time_counter.dart';

/// Horizontal bar showing time spent on a domain.
///
/// Shows domain icon + name, progress bar (domain color), hours, delta badge.
class DomainTimeBar extends StatelessWidget {
  /// The time counter data for this domain.
  final TimeCounter counter;

  /// Maximum minutes among all domains (for relative bar width).
  final int maxMinutes;

  /// Whether this bar is expanded to show detail.
  final bool isExpanded;

  /// Called when tapped (to toggle expansion).
  final VoidCallback? onTap;

  const DomainTimeBar({
    super.key,
    required this.counter,
    required this.maxMinutes,
    this.isExpanded = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final color = counter.domainColor;
    final progress =
        maxMinutes > 0 ? counter.totalMinutesThisWeek / maxMinutes : 0.0;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Domain name row
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
                _formatMinutes(counter.totalMinutesThisWeek),
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.textPrimary(brightness),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.xxs),
          // Progress bar
          AppLinearProgress(
            value: progress.clamp(0.0, 1.0),
            height: 8,
            backgroundColor: color.withValues(alpha: 0.15),
          ),
          SizedBox(height: AppSpacing.xxs),
          // Delta
          _buildDelta(brightness),
          // Expanded detail
          if (isExpanded) _buildDetail(brightness),
        ],
      ),
    );
  }

  Widget _buildDelta(Brightness brightness) {
    final delta = counter.deltaMinutes;
    if (delta == 0) return const SizedBox.shrink();

    final abs = delta.abs();
    final h = abs ~/ 60;
    final m = abs % 60;
    final sign = delta >= 0 ? '▲ +' : '▼ -';
    final label =
        m > 0 ? '$sign${h}h${m.toString().padLeft(2, '0')}' : '$sign${h}h';

    return Text(
      label,
      style: AppTypography.caption.copyWith(
        color: counter.isPositiveDelta ? AppColors.success : AppColors.error,
      ),
    );
  }

  Widget _buildDetail(Brightness brightness) {
    if (counter.habitBreakdown.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        top: AppSpacing.xs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: counter.habitBreakdown.entries.map((entry) {
          return Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.xxs),
            child: Text(
              '${entry.key.name}: ${_formatMinutes(entry.value)}',
              style: AppTypography.textSmall.copyWith(
                color: AppColors.textSecondary(brightness),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _formatMinutes(int minutes) {
    if (minutes >= 60) {
      final h = minutes ~/ 60;
      final m = minutes % 60;
      return m > 0 ? '${h}h${m.toString().padLeft(2, '0')}' : '${h}h';
    }
    return '${minutes}min';
  }
}
