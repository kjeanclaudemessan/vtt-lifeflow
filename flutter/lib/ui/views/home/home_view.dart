import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../design_system/design_system.dart';
import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? child) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: AppSpacing.xxl),
                Column(
                  children: [
                    Text(
                      'Hello, STACKED!',
                      style: AppTypography.displaySmall.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: AppSpacing.md),
                    AppButton.primary(
                      label: viewModel.counterLabel,
                      onPressed: viewModel.incrementCounter,
                      isFullWidth: false,
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: AppSpacing.xl),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppButton.secondary(
                        label: 'Show Dialog',
                        onPressed: viewModel.showDialog,
                        size: AppButtonSize.small,
                      ),
                      AppButton.secondary(
                        label: 'Show Bottom Sheet',
                        onPressed: viewModel.showBottomSheet,
                        size: AppButtonSize.small,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();
}
