import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/utils/time_format.dart';
import '../../../design_system/design_system.dart';
import '../../../domain/entities/domain_entity.dart';

/// Compact card showing weekly time summary.
///
/// Shows total hours + mini domain chips. Tappable → navigates to CounterView.
class TodayCounterSummary extends StatelessWidget {
  /// Total minutes this week.
  final int weeklyTotalMinutes;

  /// Minutes per domain today.
  final Map<String, int> todayDomainMinutes;

  /// Active domains.
  final List<DomainEntity> domains;

  /// Called when tapped.
  final VoidCallback? onTap;

  const TodayCounterSummary({
    super.key,
    required this.weeklyTotalMinutes,
    required this.todayDomainMinutes,
    required this.domains,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final totalH = weeklyTotalMinutes ~/ 60;
    final totalM = weeklyTotalMinutes % 60;
    final totalLabel = totalM > 0
        ? '${totalH}h${totalM.toString().padLeft(2, '0')}'
        : '${totalH}h';

    return AppCard.elevated(
      onTap: onTap,
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('⏱️', style: AppTypography.textLarge),
              SizedBox(width: AppSpacing.xs),
              Text(
                context.l10n.counterThisWeek,
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.textPrimary(brightness),
                ),
              ),
              const Spacer(),
              Text(
                totalLabel,
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.xs),
          // Mini domain chips
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xxs,
            children: domains.map((domain) {
              final minutes = todayDomainMinutes[domain.id] ?? 0;
              if (minutes <= 0 && weeklyTotalMinutes <= 0) {
                return const SizedBox.shrink();
              }
              return AppChip(
                label: '${domain.icon} ${formatMinutes(minutes)}',
                backgroundColor: domain.displayColor.withValues(alpha: 0.15),
                textColor: domain.displayColor,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
