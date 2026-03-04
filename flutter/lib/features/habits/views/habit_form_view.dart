import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../core/enums/lifeflow_enums.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../design_system/design_system.dart';
import '../../../domain/entities/domain_entity.dart';
import '../../../domain/entities/habit_entity.dart';
import '../../domains/widgets/domain_picker_sheet.dart';
import '../viewmodels/habit_form_viewmodel.dart';

/// View for creating / editing a habit.
class HabitFormView extends StackedView<HabitFormViewModel> {
  final HabitEntity? habit;

  const HabitFormView({Key? key, this.habit}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    HabitFormViewModel viewModel,
    Widget? child,
  ) {
    final brightness = Theme.of(context).brightness;
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          viewModel.isEditMode ? l10n.habitEdit : l10n.habitAdd,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: viewModel.isBusy ? null : viewModel.save,
          ),
        ],
      ),
      body: viewModel.isBusy
          ? const AppLoadingState()
          : SingleChildScrollView(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name field
                  AppTextField(
                    label: l10n.habitName,
                    hint: 'Ex: Méditer',
                    controller: viewModel.nameController,
                    errorText: viewModel.nameError,
                    autofocus: !viewModel.isEditMode,
                  ),
                  SizedBox(height: AppSpacing.md),

                  // Description field
                  AppTextField(
                    label: l10n.habitDescription,
                    hint: 'Description optionnelle...',
                    controller: viewModel.descriptionController,
                    maxLines: 3,
                  ),
                  SizedBox(height: AppSpacing.md),

                  // Domain picker
                  _buildDomainPicker(context, viewModel, brightness),
                  SizedBox(height: AppSpacing.md),

                  // Type toggle
                  _buildTypeToggle(context, viewModel, brightness),
                  SizedBox(height: AppSpacing.md),

                  // Quantitative fields (conditional)
                  if (viewModel.type == HabitType.quantitative) ...[
                    _buildQuantitativeFields(context, viewModel),
                    SizedBox(height: AppSpacing.md),
                  ],

                  // Estimated duration
                  _buildDurationSelector(context, viewModel, brightness),
                  SizedBox(height: AppSpacing.md),

                  // Time range
                  _buildTimeRange(context, viewModel, brightness),
                  SizedBox(height: AppSpacing.md),

                  // Frequency
                  _buildFrequencySelector(context, viewModel, brightness),
                  SizedBox(height: AppSpacing.xl),

                  // Save button
                  AppButton.primary(
                    label:
                        viewModel.isEditMode ? l10n.habitEdit : l10n.habitAdd,
                    onPressed: viewModel.save,
                    isLoading: viewModel.isBusy,
                    isFullWidth: true,
                  ),
                  SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
    );
  }

  Widget _buildDomainPicker(
    BuildContext context,
    HabitFormViewModel viewModel,
    Brightness brightness,
  ) {
    final l10n = context.l10n;
    final domain = viewModel.selectedDomain;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.habitDomain,
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.textPrimary(brightness),
          ),
        ),
        SizedBox(height: AppSpacing.xs),
        AppCard.outlined(
          onTap: () async {
            final selected = await DomainPickerSheet.show(
              context: context,
              domains: viewModel.domains,
              selectedDomainId: domain?.id,
              onCreateNew: () => _showCreateDomainDialog(context, viewModel),
            );
            if (selected != null) {
              viewModel.setSelectedDomain(selected);
            }
          },
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              if (domain != null) ...[
                Text(domain.icon, style: TextStyle(fontSize: 20)),
                SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    domain.name,
                    style: AppTypography.textMedium.copyWith(
                      color: AppColors.textPrimary(brightness),
                    ),
                  ),
                ),
              ] else
                Expanded(
                  child: Text(
                    l10n.habitSelectDomain,
                    style: AppTypography.textMedium.copyWith(
                      color: AppColors.textSecondary(brightness),
                    ),
                  ),
                ),
              Icon(
                Icons.arrow_drop_down,
                color: AppColors.textSecondary(brightness),
              ),
            ],
          ),
        ),
        if (viewModel.domainError != null) ...[
          SizedBox(height: AppSpacing.xxs),
          Text(
            viewModel.domainError!,
            style: AppTypography.caption.copyWith(
              color: AppColors.error,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTypeToggle(
    BuildContext context,
    HabitFormViewModel viewModel,
    Brightness brightness,
  ) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.habitType,
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.textPrimary(brightness),
          ),
        ),
        SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            Expanded(
              child: AppChip(
                label: l10n.habitTypeBinary,
                isSelected: viewModel.type == HabitType.binary,
                onTap: () => viewModel.setType(HabitType.binary),
              ),
            ),
            SizedBox(width: AppSpacing.xs),
            Expanded(
              child: AppChip(
                label: l10n.habitTypeQuantitative,
                isSelected: viewModel.type == HabitType.quantitative,
                onTap: () => viewModel.setType(HabitType.quantitative),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuantitativeFields(
    BuildContext context,
    HabitFormViewModel viewModel,
  ) {
    final l10n = context.l10n;

    return Row(
      children: [
        Expanded(
          child: AppTextField(
            label: l10n.habitTargetValue,
            hint: '30',
            controller: viewModel.targetValueController,
            keyboardType: TextInputType.number,
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Expanded(
          child: AppTextField(
            label: l10n.habitUnit,
            hint: 'min',
            controller: viewModel.unitController,
          ),
        ),
      ],
    );
  }

  Widget _buildDurationSelector(
    BuildContext context,
    HabitFormViewModel viewModel,
    Brightness brightness,
  ) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.habitEstimatedDuration,
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.textPrimary(brightness),
          ),
        ),
        SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: HabitFormViewModel.durationPresets.map((minutes) {
            final isSelected = viewModel.estimatedDurationMinutes == minutes;
            final label = minutes >= 60
                ? '${minutes ~/ 60}h${minutes % 60 > 0 ? "${minutes % 60}m" : ""}'
                : '${minutes}m';
            return AppChip(
              label: label,
              isSelected: isSelected,
              onTap: () => viewModel.setEstimatedDuration(minutes),
            );
          }).toList(),
        ),
        SizedBox(height: AppSpacing.xxs),
        Text(
          l10n.habitEstimatedDurationHelper,
          style: AppTypography.caption.copyWith(
            color: AppColors.textSecondary(brightness),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeRange(
    BuildContext context,
    HabitFormViewModel viewModel,
    Brightness brightness,
  ) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.habitTimeRange,
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.textPrimary(brightness),
          ),
        ),
        SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            Expanded(
              child: AppCard.outlined(
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: viewModel.startTime ??
                        const TimeOfDay(hour: 6, minute: 0),
                  );
                  viewModel.setStartTime(time);
                },
                padding: EdgeInsets.all(AppSpacing.sm),
                child: Center(
                  child: Text(
                    viewModel.startTime?.format(context) ?? '--:--',
                    style: AppTypography.textMedium.copyWith(
                      color: viewModel.startTime != null
                          ? AppColors.textPrimary(brightness)
                          : AppColors.textSecondary(brightness),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: Icon(
                Icons.arrow_forward,
                color: AppColors.textSecondary(brightness),
                size: 20,
              ),
            ),
            Expanded(
              child: AppCard.outlined(
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: viewModel.endTime ??
                        const TimeOfDay(hour: 8, minute: 0),
                  );
                  viewModel.setEndTime(time);
                },
                padding: EdgeInsets.all(AppSpacing.sm),
                child: Center(
                  child: Text(
                    viewModel.endTime?.format(context) ?? '--:--',
                    style: AppTypography.textMedium.copyWith(
                      color: viewModel.endTime != null
                          ? AppColors.textPrimary(brightness)
                          : AppColors.textSecondary(brightness),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFrequencySelector(
    BuildContext context,
    HabitFormViewModel viewModel,
    Brightness brightness,
  ) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.habitFrequency,
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.textPrimary(brightness),
          ),
        ),
        SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            Expanded(
              child: AppChip(
                label: l10n.habitFrequencyDaily,
                isSelected: viewModel.frequency == HabitFrequency.daily,
                onTap: () => viewModel.setFrequency(HabitFrequency.daily),
              ),
            ),
            SizedBox(width: AppSpacing.xs),
            Expanded(
              child: AppChip(
                label: l10n.habitFrequencyWeekly,
                isSelected: viewModel.frequency == HabitFrequency.weekly ||
                    viewModel.frequency == HabitFrequency.custom,
                onTap: () => viewModel.setFrequency(HabitFrequency.weekly),
              ),
            ),
          ],
        ),
        // Day selector (shown when weekly)
        if (viewModel.frequency != HabitFrequency.daily) ...[
          SizedBox(height: AppSpacing.sm),
          _buildDaySelector(context, viewModel, brightness),
        ],
      ],
    );
  }

  Widget _buildDaySelector(
    BuildContext context,
    HabitFormViewModel viewModel,
    Brightness brightness,
  ) {
    const days = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(7, (index) {
        final dayNumber = index + 1; // 1=Mon..7=Sun
        final isSelected = viewModel.frequencyDays.contains(dayNumber);

        return GestureDetector(
          onTap: () => viewModel.toggleFrequencyDay(dayNumber),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? AppColors.primary
                  : AppColors.surfaceSecondary(brightness),
            ),
            alignment: Alignment.center,
            child: Text(
              days[index],
              style: AppTypography.labelMedium.copyWith(
                color: isSelected
                    ? Colors.white
                    : AppColors.textPrimary(brightness),
              ),
            ),
          ),
        );
      }),
    );
  }

  Future<void> _showCreateDomainDialog(
    BuildContext context,
    HabitFormViewModel viewModel,
  ) async {
    final nameController = TextEditingController();
    final iconController = TextEditingController(text: '🎯');

    final result = await AppDialog.show<DomainEntity>(
      context: context,
      title: 'Nouveau domaine',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              SizedBox(
                width: 56,
                child: AppTextField(
                  label: 'Icône',
                  controller: iconController,
                  maxLength: 2,
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppTextField(
                  label: 'Nom',
                  hint: 'Ex: Santé',
                  controller: nameController,
                  autofocus: true,
                ),
              ),
            ],
          ),
        ],
      ),
      primaryAction: AppDialogAction(
        label: 'Créer',
        onPressed: () {
          final name = nameController.text.trim();
          if (name.isEmpty) return;
          final entity = DomainEntity.empty().copyWith(
            name: name,
            icon: iconController.text.trim().isEmpty
                ? '🎯'
                : iconController.text.trim(),
          );
          Navigator.of(context).pop(entity);
        },
      ),
      secondaryAction: AppDialogAction(
        label: 'Annuler',
        isSecondary: true,
        onPressed: () => Navigator.of(context).pop(),
      ),
    );

    if (result != null) {
      await viewModel.createDomainAndSelect(result);
    }
  }

  @override
  HabitFormViewModel viewModelBuilder(BuildContext context) =>
      HabitFormViewModel();

  @override
  void onViewModelReady(HabitFormViewModel viewModel) =>
      viewModel.init(habit: habit);
}
