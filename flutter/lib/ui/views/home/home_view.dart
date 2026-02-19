import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../design_system/design_system.dart';
import '../../../features/counter/views/counter_view.dart';
import '../../../features/habits/views/habits_view.dart';
import '../../../features/today/views/today_view.dart';
import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? child) {
    final l10n = context.l10n;

    return Scaffold(
      body: IndexedStack(
        index: viewModel.currentTabIndex,
        children: const [
          TodayView(),
          HabitsView(),
          CounterView(),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: viewModel.currentTabIndex,
        onTap: viewModel.setTabIndex,
        items: [
          AppBottomNavItem(
            icon: Icons.today_outlined,
            selectedIcon: Icons.today,
            label: l10n.navToday,
          ),
          AppBottomNavItem(
            icon: Icons.check_circle_outline,
            selectedIcon: Icons.check_circle,
            label: l10n.navHabits,
          ),
          AppBottomNavItem(
            icon: Icons.timer_outlined,
            selectedIcon: Icons.timer,
            label: l10n.navCounter,
          ),
        ],
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();
}
