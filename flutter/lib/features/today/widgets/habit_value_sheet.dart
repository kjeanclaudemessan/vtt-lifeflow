import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../design_system/design_system.dart';
import '../../../domain/entities/habit_entity.dart';

/// Bottom sheet for entering a quantitative habit value.
///
/// Displays +/− buttons, a numeric input field, a progress bar,
/// and a confirm button. Returns null if dismissed, or the entered
/// [double] value when confirmed.
class HabitValueSheet extends StatefulWidget {
  /// The habit to log a value for.
  final HabitEntity habit;

  /// Current value (if already partially logged today).
  final double? currentValue;

  const HabitValueSheet({super.key, required this.habit, this.currentValue});

  /// Shows this sheet and returns the entered value, or null if cancelled.
  static Future<double?> show({
    required BuildContext context,
    required HabitEntity habit,
    double? currentValue,
  }) {
    return AppBottomSheet.show<double>(
      context: context,
      title: habit.name,
      subtitle: habit.description,
      child: HabitValueSheet(habit: habit, currentValue: currentValue),
    );
  }

  @override
  State<HabitValueSheet> createState() => _HabitValueSheetState();
}

class _HabitValueSheetState extends State<HabitValueSheet> {
  late final TextEditingController _controller;
  late double _value;

  double get _target => widget.habit.targetValue ?? 1;
  double get _progress => (_value / _target).clamp(0.0, 1.0);
  bool get _isCompleted => _value >= _target;

  @override
  void initState() {
    super.initState();
    _value = widget.currentValue ?? 0;
    _controller = TextEditingController(
      text: _value == _value.roundToDouble()
          ? _value.toInt().toString()
          : _value.toStringAsFixed(1),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _increment(double step) {
    setState(() {
      _value = (_value + step).clamp(0, _target * 10);
      _syncController();
    });
  }

  void _decrement(double step) {
    setState(() {
      _value = (_value - step).clamp(0, _target * 10);
      _syncController();
    });
  }

  void _syncController() {
    _controller.text = _value == _value.roundToDouble()
        ? _value.toInt().toString()
        : _value.toStringAsFixed(1);
  }

  void _onTextChanged(String text) {
    final parsed = double.tryParse(text);
    if (parsed != null) {
      setState(() => _value = parsed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final l10n = context.l10n;
    final unit = widget.habit.unit ?? '';
    final step = _target >= 100 ? 10.0 : (_target >= 10 ? 1.0 : 0.5);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Progress bar
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_value.toStringAsFixed(_value == _value.roundToDouble() ? 0 : 1)} / ${_target.toStringAsFixed(_target == _target.roundToDouble() ? 0 : 1)} $unit',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.textPrimary(brightness),
                    ),
                  ),
                  Text(
                    '${(_progress * 100).toInt()}%',
                    style: AppTypography.labelMedium.copyWith(
                      color: _isCompleted
                          ? AppColors.success
                          : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.xs),
              AppLinearProgress(value: _progress, height: 8),
            ],
          ),
        ),
        SizedBox(height: AppSpacing.lg),

        // Value input row: [−] [field] [+]
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _RoundButton(
              icon: Icons.remove,
              onTap: _value > 0 ? () => _decrement(step) : null,
            ),
            SizedBox(width: AppSpacing.md),
            SizedBox(
              width: 100,
              child: TextField(
                controller: _controller,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textAlign: TextAlign.center,
                style: AppTypography.headlineMedium.copyWith(
                  color: AppColors.textPrimary(brightness),
                ),
                decoration: InputDecoration(
                  suffixText: unit,
                  suffixStyle: AppTypography.textMedium.copyWith(
                    color: AppColors.textSecondary(brightness),
                  ),
                  border: InputBorder.none,
                ),
                onChanged: _onTextChanged,
              ),
            ),
            SizedBox(width: AppSpacing.md),
            _RoundButton(icon: Icons.add, onTap: () => _increment(step)),
          ],
        ),
        SizedBox(height: AppSpacing.lg),

        // Confirm button
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: AppButton.primary(
            label: _isCompleted ? l10n.habitValueComplete : l10n.habitValueSave,
            onPressed: () => Navigator.of(context).pop(_value),
            isFullWidth: true,
            leftIcon: _isCompleted ? Icons.check_circle : null,
          ),
        ),
        SizedBox(height: AppSpacing.md),
      ],
    );
  }
}

class _RoundButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _RoundButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    final primary = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppSizing.touchTargetMin,
        height: AppSizing.touchTargetMin,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: onTap != null
              ? primary.withValues(alpha: 0.1)
              : AppColors.surfaceSecondary(brightness),
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          color: onTap != null ? primary : AppColors.textTertiary(brightness),
          size: AppSizing.iconMd,
        ),
      ),
    );
  }
}
