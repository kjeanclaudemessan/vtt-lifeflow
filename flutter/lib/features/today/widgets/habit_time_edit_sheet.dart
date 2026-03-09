import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../design_system/design_system.dart';
import '../../../domain/entities/habit_entity.dart';

/// Result returned from the [HabitTimeEditSheet].
class TimeEditResult {
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  const TimeEditResult({required this.startTime, required this.endTime});
}

/// Bottom sheet for editing the actual start/end time of a completed habit.
///
/// Opened via long-press on a completed habit tile.
/// Returns a [TimeEditResult] with the adjusted times, or null if dismissed.
class HabitTimeEditSheet extends StatefulWidget {
  /// The habit whose actual execution time is being edited.
  final HabitEntity habit;

  /// Current actual start time (falls back to habit.startTime).
  final TimeOfDay? actualStartTime;

  /// Current actual end time (falls back to computed end time).
  final TimeOfDay? actualEndTime;

  const HabitTimeEditSheet({
    super.key,
    required this.habit,
    this.actualStartTime,
    this.actualEndTime,
  });

  /// Shows this sheet and returns the edited time range.
  static Future<TimeEditResult?> show({
    required BuildContext context,
    required HabitEntity habit,
    TimeOfDay? actualStartTime,
    TimeOfDay? actualEndTime,
  }) {
    return AppBottomSheet.show<TimeEditResult>(
      context: context,
      title: habit.name,
      subtitle: context.l10n.habitTimeEditSubtitle,
      child: HabitTimeEditSheet(
        habit: habit,
        actualStartTime: actualStartTime,
        actualEndTime: actualEndTime,
      ),
    );
  }

  @override
  State<HabitTimeEditSheet> createState() => _HabitTimeEditSheetState();
}

class _HabitTimeEditSheetState extends State<HabitTimeEditSheet> {
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;

  @override
  void initState() {
    super.initState();
    _startTime =
        widget.actualStartTime ?? widget.habit.startTime ?? TimeOfDay.now();
    _endTime = widget.actualEndTime ?? widget.habit.endTime ?? TimeOfDay.now();
  }

  String _formatDuration() {
    final startMinutes = _startTime.hour * 60 + _startTime.minute;
    final endMinutes = _endTime.hour * 60 + _endTime.minute;
    final diff = endMinutes >= startMinutes ? endMinutes - startMinutes : 0;
    if (diff < 60) return '${diff}min';
    final h = diff ~/ 60;
    final m = diff % 60;
    return m > 0 ? '${h}h${m.toString().padLeft(2, '0')}' : '${h}h';
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final l10n = context.l10n;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Time pickers row
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: _TimePickerCard(
                  label: l10n.habitActualStart,
                  time: _startTime,
                  brightness: brightness,
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: _startTime,
                    );
                    if (time != null) setState(() => _startTime = time);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                child: Icon(
                  Icons.arrow_forward,
                  color: AppColors.textSecondary(brightness),
                  size: AppSizing.iconMd,
                ),
              ),
              Expanded(
                child: _TimePickerCard(
                  label: l10n.habitActualEnd,
                  time: _endTime,
                  brightness: brightness,
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: _endTime,
                    );
                    if (time != null) setState(() => _endTime = time);
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: AppSpacing.sm),

        // Duration summary
        Text(
          '${l10n.habitActualDuration}: ${_formatDuration()}',
          style: AppTypography.caption.copyWith(
            color: AppColors.textSecondary(brightness),
          ),
        ),
        SizedBox(height: AppSpacing.lg),

        // Save button
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: AppButton.primary(
            label: l10n.save,
            onPressed: () => Navigator.of(
              context,
            ).pop(TimeEditResult(startTime: _startTime, endTime: _endTime)),
            isFullWidth: true,
          ),
        ),
        SizedBox(height: AppSpacing.md),
      ],
    );
  }
}

class _TimePickerCard extends StatelessWidget {
  final String label;
  final TimeOfDay time;
  final Brightness brightness;
  final VoidCallback onTap;

  const _TimePickerCard({
    required this.label,
    required this.time,
    required this.brightness,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: AppTypography.caption.copyWith(
            color: AppColors.textSecondary(brightness),
          ),
        ),
        SizedBox(height: AppSpacing.xxs),
        AppCard.outlined(
          onTap: onTap,
          padding: EdgeInsets.all(AppSpacing.sm),
          child: Center(
            child: Text(
              time.format(context),
              style: AppTypography.textLarge.copyWith(
                color: AppColors.textPrimary(brightness),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
