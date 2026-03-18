import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../core/enums/lifeflow_enums.dart';
import '../../../domain/entities/domain_entity.dart';
import '../../../domain/entities/habit_entity.dart';
import '../../../domain/repositories/i_domain_repository.dart';
import '../../../domain/repositories/i_habit_repository.dart';
import '../../../services/analytics/analytics_service.dart';
import '../../../services/haptic_service.dart';
import '../../../services/habit_event_service.dart';
import '../../../services/local_notification/local_notification_scheduler.dart';

/// ViewModel for the habit create/edit form.
class HabitFormViewModel extends BaseViewModel {
  final _habitRepo = locator<IHabitRepository>();
  final _domainRepo = locator<IDomainRepository>();
  final _navigationService = locator<NavigationService>();
  final _haptic = locator<HapticService>();

  /// The habit being edited (null for create mode).
  HabitEntity? _editingHabit;
  bool get isEditMode => _editingHabit != null;

  /// Form field values.
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final targetValueController = TextEditingController();
  final unitController = TextEditingController();

  /// Domains list for picker.
  List<DomainEntity> _domains = [];
  List<DomainEntity> get domains =>
      _domains.where((d) => !d.isArchived).toList();

  /// Selected domain.
  DomainEntity? _selectedDomain;
  DomainEntity? get selectedDomain => _selectedDomain;

  /// Habit type (binary or quantitative).
  HabitType _type = HabitType.binary;
  HabitType get type => _type;

  /// Estimated duration in minutes.
  int _estimatedDurationMinutes = 15;
  int get estimatedDurationMinutes => _estimatedDurationMinutes;

  /// Available duration presets.
  static const durationPresets = [5, 10, 15, 30, 45, 60, 90, 120];

  /// Time range.
  TimeOfDay? _startTime;
  TimeOfDay? get startTime => _startTime;

  /// Notification settings.
  bool _notificationsEnabled = true;
  bool get notificationsEnabled => _notificationsEnabled;

  int _reminderOffsetMinutes = 5;
  int get reminderOffsetMinutes => _reminderOffsetMinutes;

  /// Available reminder offset presets (minutes before start time).
  static const offsetPresets = [0, 5, 10, 15, 30];

  /// Frequency.
  HabitFrequency _frequency = HabitFrequency.daily;
  HabitFrequency get frequency => _frequency;

  /// Selected days of the week (1=Mon..7=Sun).
  List<int> _frequencyDays = [];
  List<int> get frequencyDays => _frequencyDays;

  /// Form validation.
  String? _nameError;
  String? get nameError => _nameError;
  String? _domainError;
  String? get domainError => _domainError;

  /// Incremented on each validation failure to trigger shake animation.
  int _validationAttempt = 0;
  int get validationAttempt => _validationAttempt;

  /// Initialize with optional habit for editing.
  Future<void> init({HabitEntity? habit}) async {
    setBusy(true);

    // Load domains
    final domainsResult = await _domainRepo.getDomains();
    domainsResult.fold(
      (failure) => setError(failure.message),
      (domains) => _domains = domains,
    );

    // Populate form if editing
    if (habit != null) {
      _editingHabit = habit;
      nameController.text = habit.name;
      descriptionController.text = habit.description ?? '';
      _type = habit.type;
      targetValueController.text = habit.targetValue?.toString() ?? '';
      unitController.text = habit.unit ?? '';
      _estimatedDurationMinutes = habit.estimatedDurationMinutes;
      _startTime = habit.startTime;
      _notificationsEnabled = habit.notificationsEnabled;
      _reminderOffsetMinutes = habit.reminderOffsetMinutes;
      _frequency = habit.frequency;
      _frequencyDays = List.from(habit.frequencyDays);
      _selectedDomain = _domains
          .where((d) => d.id == habit.domainId)
          .firstOrNull;
    }

    setBusy(false);
  }

  void setType(HabitType type) {
    _type = type;
    rebuildUi();
  }

  void setSelectedDomain(DomainEntity domain) {
    _selectedDomain = domain;
    _domainError = null;
    rebuildUi();
  }

  void setEstimatedDuration(int minutes) {
    _estimatedDurationMinutes = minutes;
    rebuildUi();
  }

  void setStartTime(TimeOfDay? time) {
    _startTime = time;
    rebuildUi();
  }

  void setNotificationsEnabled(bool enabled) {
    _notificationsEnabled = enabled;
    rebuildUi();
  }

  void setReminderOffsetMinutes(int minutes) {
    _reminderOffsetMinutes = minutes;
    rebuildUi();
  }

  void setFrequency(HabitFrequency frequency) {
    _frequency = frequency;
    if (frequency == HabitFrequency.daily) {
      _frequencyDays = [];
    }
    rebuildUi();
  }

  void toggleFrequencyDay(int day) {
    if (_frequencyDays.contains(day)) {
      _frequencyDays.remove(day);
    } else {
      _frequencyDays.add(day);
    }
    rebuildUi();
  }

  /// Validates and saves the habit.
  Future<void> save({
    String nameRequiredMessage = 'Name is required',
    String domainRequiredMessage = 'Select a domain',
  }) async {
    // Validate
    _nameError = null;
    _domainError = null;

    final name = nameController.text.trim();
    if (name.isEmpty) {
      _nameError = nameRequiredMessage;
      _haptic.error();
      _validationAttempt++;
      rebuildUi();
      return;
    }
    if (_selectedDomain == null) {
      _domainError = domainRequiredMessage;
      _haptic.error();
      _validationAttempt++;
      rebuildUi();
      return;
    }

    setBusy(true);

    final now = DateTime.now();
    final entity = HabitEntity(
      id: _editingHabit?.id ?? '',
      userId: _editingHabit?.userId ?? '',
      domainId: _selectedDomain!.id,
      name: name,
      description: descriptionController.text.trim().isEmpty
          ? null
          : descriptionController.text.trim(),
      type: _type,
      targetValue: _type == HabitType.quantitative
          ? double.tryParse(targetValueController.text.trim())
          : null,
      unit: _type == HabitType.quantitative
          ? unitController.text.trim().isEmpty
                ? null
                : unitController.text.trim()
          : null,
      estimatedDurationMinutes: _estimatedDurationMinutes,
      startTime: _startTime,
      notificationsEnabled: _notificationsEnabled,
      reminderOffsetMinutes: _reminderOffsetMinutes,
      frequency: _frequency,
      frequencyDays: _frequencyDays,
      isArchived: _editingHabit?.isArchived ?? false,
      createdAt: _editingHabit?.createdAt ?? now,
      updatedAt: now,
    );

    final result = isEditMode
        ? await _habitRepo.updateHabit(entity)
        : await _habitRepo.createHabit(entity);

    result.fold(
      (failure) {
        _haptic.error();
        setError(failure.message);
        setBusy(false);
      },
      (savedHabit) {
        _haptic.success();
        locator<AnalyticsService>().capture(
          isEditMode ? 'habit_updated' : 'habit_created',
          properties: {
            'domain': _selectedDomain?.name ?? '',
            'type': _type.name,
            'frequency': _frequency.name,
            'has_time_slot': _startTime != null,
          },
        );

        // Schedule/update local notification reminder
        locator<LocalNotificationScheduler>().scheduleHabitReminder(savedHabit);

        // Notify all listening views (Today, Habits, Counter) to refresh
        locator<HabitEventService>().notifyHabitChanged();

        setBusy(false);
        _navigationService.back(result: true);
      },
    );
  }

  /// Creates a new domain and selects it in the form.
  Future<void> createDomainAndSelect(DomainEntity domain) async {
    final result = await _domainRepo.createDomain(domain);
    result.fold((failure) => setError(failure.message), (created) {
      _domains.add(created);
      _selectedDomain = created;
      _domainError = null;
      rebuildUi();
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    targetValueController.dispose();
    unitController.dispose();
    super.dispose();
  }
}
