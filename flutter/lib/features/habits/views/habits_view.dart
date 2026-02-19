import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../design_system/design_system.dart';
import '../viewmodels/habits_viewmodel.dart';
import '../widgets/habit_check_tile.dart';

/// View listing all habits with domain filter chips.
class HabitsView extends StackedView<HabitsViewModel> {
  const HabitsView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    HabitsViewModel viewModel,
    Widget? child,
  ) {
    final brightness = Theme.of(context).brightness;
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.habitsTitle),
      ),
      body: viewModel.isBusy
          ? const AppLoadingState()
          : viewModel.hasError
              ? AppErrorState.generic(onRetry: viewModel.init)
              : _buildContent(context, viewModel, brightness),
      floatingActionButton: AppFab(
        icon: Icons.add,
        onPressed: () async {
          await locator<NavigationService>().navigateToHabitFormView();
          viewModel.refresh();
        },
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    HabitsViewModel viewModel,
    Brightness brightness,
  ) {
    final l10n = context.l10n;

    if (viewModel.filteredHabits.isEmpty &&
        viewModel.selectedDomainId == null) {
      return AppEmptyState(
        icon: Icons.repeat_outlined,
        title: l10n.habitsEmptyTitle,
        description: l10n.habitsEmptyDescription,
        actionLabel: l10n.habitAdd,
        onAction: () async {
          await locator<NavigationService>().navigateToHabitFormView();
          viewModel.refresh();
        },
      );
    }

    return Column(
      children: [
        // Domain filter chips
        if (viewModel.domains.isNotEmpty)
          _buildDomainFilters(context, viewModel, brightness),
        // Habits list
        Expanded(
          child: viewModel.filteredHabits.isEmpty
              ? Center(
                  child: Text(
                    l10n.todayNoHabits,
                    style: AppTypography.textMedium.copyWith(
                      color: AppColors.textSecondary(brightness),
                    ),
                  ),
                )
              : _buildHabitsList(context, viewModel, brightness),
        ),
      ],
    );
  }

  Widget _buildDomainFilters(
    BuildContext context,
    HabitsViewModel viewModel,
    Brightness brightness,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          AppChip.filter(
            label: 'Tous',
            isSelected: viewModel.selectedDomainId == null,
            onTap: () => viewModel.filterByDomain(null),
          ),
          SizedBox(width: AppSpacing.xs),
          ...viewModel.domains.map((domain) {
            return Padding(
              padding: EdgeInsets.only(right: AppSpacing.xs),
              child: AppChip.filter(
                label: '${domain.icon} ${domain.name}',
                isSelected: viewModel.selectedDomainId == domain.id,
                onTap: () => viewModel.filterByDomain(domain.id),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildHabitsList(
    BuildContext context,
    HabitsViewModel viewModel,
    Brightness brightness,
  ) {
    final habitsBySlot = viewModel.habitsByTimeSlot;

    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      itemCount: habitsBySlot.length,
      itemBuilder: (context, sectionIndex) {
        final entry = habitsBySlot.entries.elementAt(sectionIndex);
        final slot = entry.key;
        final habits = entry.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (sectionIndex > 0) SizedBox(height: AppSpacing.md),
            // Section header
            Text(
              slot.label,
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.textSecondary(brightness),
              ),
            ),
            SizedBox(height: AppSpacing.xs),
            // Habit tiles
            ...habits.map((habit) {
              return Padding(
                padding: EdgeInsets.only(bottom: AppSpacing.xs),
                child: HabitCheckTile(
                  habit: habit,
                  domain: viewModel.domainFor(habit.domainId),
                  log: viewModel.todayLogFor(habit.id),
                  streak: viewModel.streakFor(habit.id),
                  onToggle: () => viewModel.toggleHabit(habit.id),
                  onTap: () async {
                    await locator<NavigationService>()
                        .navigateToHabitFormView();
                    viewModel.refresh();
                  },
                ),
              );
            }),
          ],
        );
      },
    );
  }

  @override
  HabitsViewModel viewModelBuilder(BuildContext context) => HabitsViewModel();

  @override
  void onViewModelReady(HabitsViewModel viewModel) => viewModel.init();
}
