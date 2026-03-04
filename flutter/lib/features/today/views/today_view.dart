import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../core/enums/lifeflow_enums.dart';
import '../../../core/extensions/context_extensions.dart';
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
            onPressed: () =>
                locator<NavigationService>().navigateToProfileView(),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () =>
                locator<NavigationService>().navigateToSettingsView(),
          ),
        ],
      ),
      body: viewModel.isBusy
          ? const AppLoadingState()
          : viewModel.hasError
              ? AppErrorState.generic(onRetry: viewModel.init)
              : viewModel.todayHabits.isEmpty
                  ? _buildEmptyState(context, l10n)
                  : RefreshIndicator(
                      onRefresh: viewModel.refresh,
                      child: _buildContent(context, viewModel, brightness),
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
        _buildHeader(context, viewModel, brightness),
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
        _buildModeContent(context, viewModel, brightness),
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
    final dateLabel = DateFormat('EEEE d MMMM', 'fr_FR').format(now);

    switch (viewModel.mode) {
      case TodayMode.morning:
        return Column(
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
    switch (viewModel.mode) {
      case TodayMode.morning:
        // All habits grouped by time slot
        return TodayHabitsSection(
          habitsBySlot: viewModel.habitsByTimeSlot,
          domainResolver: viewModel.domainFor,
          logResolver: viewModel.todayLogFor,
          streakResolver: viewModel.streakFor,
          onToggle: (id) => viewModel.toggleHabit(id),
        );

      case TodayMode.progress:
        // Done (collapsed) + Remaining (expanded)
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Completed section
            if (viewModel.completedHabits.isNotEmpty) ...[
              Text(
                '✅ Faites',
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.textSecondary(brightness),
                ),
              ),
              SizedBox(height: AppSpacing.xs),
              ...viewModel.completedHabits.map((habit) {
                return Padding(
                  padding: EdgeInsets.only(bottom: AppSpacing.xs),
                  child: _buildCompletedTile(habit, viewModel, brightness),
                );
              }),
              SizedBox(height: AppSpacing.md),
            ],
            // Remaining section
            if (viewModel.remainingHabits.isNotEmpty) ...[
              Text(
                '⏳ Restantes',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDaySummary(viewModel, brightness),
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
  ) {
    final streak = viewModel.streakFor(habit.id);

    return AppCard.filled(
      backgroundColor: AppColors.success.withValues(alpha: 0.05),
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: AppColors.success, size: 20),
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
    );
  }

  Widget _buildDaySummary(
    TodayViewModel viewModel,
    Brightness brightness,
  ) {
    final domainMinutes = viewModel.todayDomainMinutes;

    return AppCard.elevated(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📊 Aujourd\'hui',
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textPrimary(brightness),
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          ...viewModel.domains.map((domain) {
            final minutes = domainMinutes[domain.id] ?? 0;
            return Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.xxs),
              child: Row(
                children: [
                  Text(domain.icon, style: TextStyle(fontSize: 16)),
                  SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      domain.name,
                      style: AppTypography.textSmall.copyWith(
                        color: minutes > 0
                            ? AppColors.textPrimary(brightness)
                            : AppColors.textSecondary(brightness),
                      ),
                    ),
                  ),
                  Text(
                    _formatMinutes(minutes),
                    style: AppTypography.textSmall.copyWith(
                      color: minutes > 0
                          ? AppColors.textPrimary(brightness)
                          : AppColors.textSecondary(brightness),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }),
          Divider(color: AppColors.border(brightness)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.textPrimary(brightness),
                ),
              ),
              Text(
                _formatMinutes(
                  domainMinutes.values.fold(0, (a, b) => a + b),
                ),
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
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

  String _formatMinutes(int minutes) {
    if (minutes >= 60) {
      final h = minutes ~/ 60;
      final m = minutes % 60;
      return m > 0 ? '${h}h${m.toString().padLeft(2, '0')}' : '${h}h';
    }
    return '${minutes}m';
  }

  @override
  TodayViewModel viewModelBuilder(BuildContext context) => TodayViewModel();

  @override
  void onViewModelReady(TodayViewModel viewModel) => viewModel.init();
}
