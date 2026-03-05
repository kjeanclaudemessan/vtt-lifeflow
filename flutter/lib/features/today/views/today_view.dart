import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../core/enums/lifeflow_enums.dart';
import '../../../core/utils/time_format.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../design_system/design_system.dart';
import '../../../domain/entities/habit_entity.dart';
import '../../../modules/notifications/widgets/notification_badge.dart';
import '../viewmodels/today_viewmodel.dart';
import '../widgets/today_bilan_card.dart';
import '../widgets/today_counter_summary.dart';
import '../widgets/today_habits_section.dart';

/// Today dashboard view — contextual by time of day.
///
/// Morning: greeting + habits by slot + mini counter.
/// Progress: done/remaining + progress bar.
/// Bilan: day summary + time recap.
class TodayView extends StackedView<TodayViewModel> {
  const TodayView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    TodayViewModel viewModel,
    Widget? child,
  ) {
    final brightness = Theme.of(context).brightness;
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.today),
        actions: [
          NotificationBadge(
            count: viewModel.unreadNotificationCount,
            onTap: () =>
                locator<NavigationService>().navigateToNotificationsView(),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            tooltip: l10n.profile,
            onPressed: () =>
                locator<NavigationService>().navigateToProfileView(),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: l10n.settings,
            onPressed: () =>
                locator<NavigationService>().navigateToSettingsView(),
          ),
        ],
      ),
      body: Stack(
        children: [
          viewModel.isBusy
              ? const AppLoadingState()
              : viewModel.hasError
                  ? AppErrorState.generic(onRetry: viewModel.init)
                  : viewModel.todayHabits.isEmpty
                      ? _buildEmptyState(context, l10n)
                      : AppRefreshIndicator(
                          onRefresh: viewModel.refresh,
                          child: _buildContent(context, viewModel, brightness),
                        ),
          // Confetti celebration overlay
          AppCelebrationOverlay(
            shouldCelebrate: viewModel.justCompletedAll,
            onComplete: viewModel.clearCelebration,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, dynamic l10n) {
    return AppEmptyState(
      icon: Icons.wb_sunny_outlined,
      title: l10n.todayEmptyTitle,
      description: l10n.todayEmptySubtitle,
      actionLabel: l10n.habitAdd,
      onAction: () async {
        await locator<NavigationService>().navigateToHabitFormView();
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    TodayViewModel viewModel,
    Brightness brightness,
  ) {
    return ListView(
      padding: EdgeInsets.all(AppSpacing.md),
      children: [
        // Greeting / status header
        AnimatedSwitcher(
          duration: AppAnimations.medium,
          switchInCurve: AppAnimations.easeOut,
          switchOutCurve: AppAnimations.easeIn,
          child: _buildHeader(context, viewModel, brightness),
        ),
        SizedBox(height: AppSpacing.md),

        // Counter summary
        TodayCounterSummary(
          weeklyTotalMinutes: viewModel.weeklyTotalMinutes,
          todayDomainMinutes: viewModel.todayDomainMinutes,
          domains: viewModel.domains,
          onTap: () => locator<NavigationService>().navigateToCounterView(),
        ),
        SizedBox(height: AppSpacing.md),

        // Bilan card (conditional)
        if (viewModel.showBilanCard) ...[
          TodayBilanCard(
            onTap: () => locator<NavigationService>().navigateToBilanView(),
          ),
          SizedBox(height: AppSpacing.md),
        ],

        // Content based on mode
        AnimatedSwitcher(
          duration: AppAnimations.medium,
          switchInCurve: AppAnimations.easeOut,
          switchOutCurve: AppAnimations.easeIn,
          child: _buildModeContent(context, viewModel, brightness),
        ),
      ],
    );
  }

  Widget _buildHeader(
    BuildContext context,
    TodayViewModel viewModel,
    Brightness brightness,
  ) {
    final l10n = context.l10n;
    final now = DateTime.now();
    final locale = Localizations.localeOf(context).toString();
    final dateLabel = DateFormat('EEEE d MMMM', locale).format(now);

    switch (viewModel.mode) {
      case TodayMode.morning:
        return Column(
          key: const ValueKey('header-morning'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '👋 ${l10n.todayGreetingMorning}',
              style: AppTypography.headingSmall.copyWith(
                color: AppColors.textPrimary(brightness),
              ),
            ),
            Text(
              dateLabel,
              style: AppTypography.textMedium.copyWith(
                color: AppColors.textSecondary(brightness),
              ),
            ),
          ],
        );
      case TodayMode.progress:
        final completed = viewModel.completedHabits.length;
        final total = viewModel.todayHabits.length;
        return Column(
          key: const ValueKey('header-progress'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🎯 ${l10n.todayProgress(completed, total)}',
              style: AppTypography.headingSmall.copyWith(
                color: AppColors.textPrimary(brightness),
              ),
            ),
            SizedBox(height: AppSpacing.xs),
            AppLinearProgress(
              value: viewModel.completionRate,
              showPercentage: true,
            ),
          ],
        );
      case TodayMode.bilan:
        return Column(
          key: const ValueKey('header-bilan'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🌙 ${l10n.todayGreetingEvening}',
              style: AppTypography.headingSmall.copyWith(
                color: AppColors.textPrimary(brightness),
              ),
            ),
            Text(
              l10n.todayProgress(
                viewModel.completedHabits.length,
                viewModel.todayHabits.length,
              ),
              style: AppTypography.textMedium.copyWith(
                color: AppColors.textSecondary(brightness),
              ),
            ),
          ],
        );
    }
  }

  Widget _buildModeContent(
    BuildContext context,
    TodayViewModel viewModel,
    Brightness brightness,
  ) {
    final l10n = context.l10n;
    switch (viewModel.mode) {
      case TodayMode.morning:
        // All habits grouped by time slot
        return TodayHabitsSection(
          key: const ValueKey('mode-morning'),
          habitsBySlot: viewModel.habitsByTimeSlot,
          domainResolver: viewModel.domainFor,
          logResolver: viewModel.todayLogFor,
          streakResolver: viewModel.streakFor,
          onToggle: (id) => viewModel.toggleHabit(id),
        );

      case TodayMode.progress:
        // Done (collapsed) + Remaining (expanded)
        return Column(
          key: const ValueKey('mode-progress'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Completed section
            if (viewModel.completedHabits.isNotEmpty) ...[
              Text(
                l10n.todayDone,
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.textSecondary(brightness),
                ),
              ),
              SizedBox(height: AppSpacing.xs),
              ...viewModel.completedHabits.map((habit) {
                return Padding(
                  padding: EdgeInsets.only(bottom: AppSpacing.xs),
                  child:
                      _buildCompletedTile(habit, viewModel, brightness, l10n),
                );
              }),
              SizedBox(height: AppSpacing.md),
            ],
            // Remaining section
            if (viewModel.remainingHabits.isNotEmpty) ...[
              Text(
                l10n.todayRemaining,
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.textSecondary(brightness),
                ),
              ),
              SizedBox(height: AppSpacing.xs),
              TodayHabitsSection(
                habitsBySlot: _groupBySlot(viewModel.remainingHabits),
                domainResolver: viewModel.domainFor,
                logResolver: viewModel.todayLogFor,
                streakResolver: viewModel.streakFor,
                onToggle: (id) => viewModel.toggleHabit(id),
              ),
            ],
          ],
        );

      case TodayMode.bilan:
        // Day summary with domain breakdown
        return Column(
          key: const ValueKey('mode-bilan'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppDomainBreakdown(
              title: l10n.todayDaySummary,
              items: viewModel.domains.map((domain) {
                final minutes = viewModel.todayDomainMinutes[domain.id] ?? 0;
                return AppBreakdownItem(
                  icon: domain.icon,
                  label: domain.name,
                  value: minutes,
                  formattedValue: formatMinutes(minutes),
                );
              }).toList(),
              totalLabel: l10n.total,
              totalFormattedValue: formatMinutes(
                viewModel.todayDomainMinutes.values.fold(0, (a, b) => a + b),
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            // Still show habits for toggling
            TodayHabitsSection(
              habitsBySlot: viewModel.habitsByTimeSlot,
              domainResolver: viewModel.domainFor,
              logResolver: viewModel.todayLogFor,
              streakResolver: viewModel.streakFor,
              onToggle: (id) => viewModel.toggleHabit(id),
            ),
          ],
        );
    }
  }

  Widget _buildCompletedTile(
    dynamic habit,
    TodayViewModel viewModel,
    Brightness brightness,
    AppLocalizations l10n,
  ) {
    final streak = viewModel.streakFor(habit.id);

    return AnimatedOpacity(
      opacity: 1.0,
      duration: AppAnimations.medium,
      child: AppCard.filled(
        backgroundColor: AppColors.success.withValues(alpha: 0.05),
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            Icon(Icons.check_circle,
                color: AppColors.success,
                size: AppSizing.iconMd,
                semanticLabel: l10n.semanticsCompleted),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                habit.name,
                style: AppTypography.textMedium.copyWith(
                  color: AppColors.textSecondary(brightness),
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ),
            if (streak.currentStreak > 0)
              Text(
                '🔥 ${streak.currentStreak}j',
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary(brightness),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Map<TimeSlot, List<HabitEntity>> _groupBySlot(List<HabitEntity> habits) {
    final map = <TimeSlot, List<HabitEntity>>{};
    for (final habit in habits) {
      final slot = habit.timeSlot;
      map.putIfAbsent(slot, () => []).add(habit);
    }
    return Map.fromEntries(
      map.entries.toList()
        ..sort((a, b) => a.key.sortWeight.compareTo(b.key.sortWeight)),
    );
  }

  @override
  TodayViewModel viewModelBuilder(BuildContext context) => TodayViewModel();

  @override
  void onViewModelReady(TodayViewModel viewModel) => viewModel.init();
}
