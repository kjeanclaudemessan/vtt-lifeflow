import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../design_system/design_system.dart';
import '../viewmodels/counter_viewmodel.dart';
import '../widgets/domain_time_bar.dart';

/// Weekly time-counter view with domain breakdown.
class CounterView extends StackedView<CounterViewModel> {
  const CounterView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    CounterViewModel viewModel,
    Widget? child,
  ) {
    final brightness = Theme.of(context).brightness;
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.counterTitle)),
      body: viewModel.isBusy
          ? const AppLoadingState()
          : viewModel.hasError
          ? AppErrorState.generic(
              title: l10n.errorOccurred,
              description: l10n.errorUnknown,
              onRetry: viewModel.init,
            )
          : _buildContent(context, viewModel, brightness),
    );
  }

  Widget _buildContent(
    BuildContext context,
    CounterViewModel viewModel,
    Brightness brightness,
  ) {
    final l10n = context.l10n;

    if (viewModel.counters.isEmpty) {
      return AppEmptyState(
        icon: Icons.timer_outlined,
        title: l10n.counterEmptyTitle,
        description: l10n.counterEmptyDescription,
        actionLabel: l10n.habitAdd,
        onAction: () => locator<NavigationService>().navigateToHabitFormView(),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Week navigator
          _buildWeekNavigator(context, viewModel, brightness),
          SizedBox(height: AppSpacing.lg),

          // Total card
          _buildTotalCard(context, viewModel, brightness),
          SizedBox(height: AppSpacing.lg),

          // Domain bars
          ...viewModel.counters.asMap().entries.map((entry) {
            final index = entry.key;
            final counter = entry.value;
            final maxMinutes = viewModel.counters
                .map((c) => c.totalMinutesThisWeek)
                .reduce((a, b) => a > b ? a : b);

            return Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.md),
              child: DomainTimeBar(
                counter: counter,
                maxMinutes: maxMinutes,
                isExpanded: viewModel.expandedIndex == index,
                onTap: () => viewModel.toggleExpanded(index),
              ),
            );
          }),

          SizedBox(height: AppSpacing.lg),

          // Bilan card
          _buildBilanCard(context, viewModel, brightness),
        ],
      ),
    );
  }

  Widget _buildWeekNavigator(
    BuildContext context,
    CounterViewModel viewModel,
    Brightness brightness,
  ) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    final dateFormat = DateFormat('d MMM', locale);
    final weekLabel =
        '${dateFormat.format(viewModel.weekStart)} – ${dateFormat.format(viewModel.weekEnd)}';

    return AppWeekNavigator(
      label: weekLabel,
      isLast: viewModel.isCurrentWeek,
      onPrevious: viewModel.previousWeek,
      onNext: viewModel.nextWeek,
      onLabelTap: viewModel.isCurrentWeek ? null : viewModel.goToCurrentWeek,
      previousTooltip: l10n.counterPreviousWeek,
      nextTooltip: l10n.counterNextWeek,
    );
  }

  Widget _buildTotalCard(
    BuildContext context,
    CounterViewModel viewModel,
    Brightness brightness,
  ) {
    final l10n = context.l10n;
    // Weekly goal computed from active habits
    final progress =
        (viewModel.totalMinutesThisWeek / viewModel.weeklyGoalMinutes).clamp(
          0.0,
          1.0,
        );

    return AppCard.elevated(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          // Animated progress ring with animated counter
          AppAnimatedDouble(
            value: progress,
            duration: AppAnimations.slow,
            builder: (animatedProgress) {
              return AppProgressRing.large(
                value: animatedProgress,
                label: viewModel.totalHoursLabel,
                sublabel: l10n.counterTitle,
                color: Theme.of(context).colorScheme.primary,
              );
            },
          ),
          SizedBox(height: AppSpacing.sm),
          // Animated total text
          AppAnimatedNumber(
            value: viewModel.totalMinutesThisWeek,
            duration: AppAnimations.slow,
            builder: (animatedMinutes) {
              final h = animatedMinutes ~/ 60;
              final m = animatedMinutes % 60;
              final label = m > 0
                  ? '${h}h${m.toString().padLeft(2, '0')}'
                  : '${h}h';
              return Text(
                l10n.counterTotalWithTime(label),
                style: AppTypography.headingMedium.copyWith(
                  color: AppColors.textPrimary(brightness),
                ),
              );
            },
          ),
          if (viewModel.deltaMinutes != 0) ...[
            SizedBox(height: AppSpacing.xxs),
            AppAnimatedDouble(
              value: 1,
              duration: AppAnimations.medium,
              builder: (opacity) {
                return Opacity(
                  opacity: opacity,
                  child: Text(
                    l10n.counterDeltaVsLastWeek(viewModel.deltaLabel),
                    style: AppTypography.textSmall.copyWith(
                      color: viewModel.isPositiveDelta
                          ? AppColors.success
                          : AppColors.error,
                    ),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBilanCard(
    BuildContext context,
    CounterViewModel viewModel,
    Brightness brightness,
  ) {
    final l10n = context.l10n;

    final primary = Theme.of(context).colorScheme.primary;

    return AppCard.filled(
      backgroundColor: primary.withValues(alpha: 0.08),
      onTap: () => locator<NavigationService>().navigateToBilanView(),
      padding: EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Text('📊', style: AppTypography.headingMedium),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.bilanReady,
                  style: AppTypography.titleSmall.copyWith(color: primary),
                ),
                Text(
                  l10n.bilanTitle,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary(brightness),
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: primary),
        ],
      ),
    );
  }

  @override
  CounterViewModel viewModelBuilder(BuildContext context) => CounterViewModel();

  @override
  void onViewModelReady(CounterViewModel viewModel) => viewModel.init();
}
