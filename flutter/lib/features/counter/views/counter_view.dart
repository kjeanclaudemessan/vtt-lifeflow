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
      appBar: AppBar(
        title: Text(l10n.counterTitle),
      ),
      body: viewModel.isBusy
          ? const AppLoadingState()
          : viewModel.hasError
              ? AppErrorState.generic(onRetry: viewModel.init)
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
          _buildTotalCard(viewModel, brightness),
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
    final dateFormat = DateFormat('d MMM', 'fr_FR');
    final weekLabel =
        '${dateFormat.format(viewModel.weekStart)} – ${dateFormat.format(viewModel.weekEnd)}';

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: viewModel.previousWeek,
        ),
        GestureDetector(
          onTap: viewModel.isCurrentWeek ? null : viewModel.goToCurrentWeek,
          child: Text(
            weekLabel,
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textPrimary(brightness),
            ),
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.chevron_right,
            color: viewModel.isCurrentWeek
                ? AppColors.textSecondary(brightness).withValues(alpha: 0.3)
                : null,
          ),
          onPressed: viewModel.isCurrentWeek ? null : viewModel.nextWeek,
        ),
      ],
    );
  }

  Widget _buildTotalCard(
    CounterViewModel viewModel,
    Brightness brightness,
  ) {
    return AppCard.elevated(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          Text(
            l10n.counterTotalWithTime(viewModel.totalHoursLabel),
            style: AppTypography.headingMedium.copyWith(
              color: AppColors.textPrimary(brightness),
            ),
          ),
          if (viewModel.deltaMinutes != 0) ...[
            SizedBox(height: AppSpacing.xxs),
            Text(
              l10n.counterDeltaVsLastWeek(viewModel.deltaLabel),
              style: AppTypography.textSmall.copyWith(
                color: viewModel.isPositiveDelta
                    ? AppColors.success
                    : AppColors.error,
              ),
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

    return AppCard.filled(
      backgroundColor: AppColors.primary.withValues(alpha: 0.08),
      onTap: () => locator<NavigationService>().navigateToBilanView(),
      padding: EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Text('📊', style: TextStyle(fontSize: 24)),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.bilanReady,
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.primary,
                  ),
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
          Icon(
            Icons.chevron_right,
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }

  @override
  CounterViewModel viewModelBuilder(BuildContext context) => CounterViewModel();

  @override
  void onViewModelReady(CounterViewModel viewModel) => viewModel.init();
}
