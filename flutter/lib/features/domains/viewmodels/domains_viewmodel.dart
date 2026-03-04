import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '../../../domain/entities/domain_entity.dart';
import '../../../domain/repositories/i_domain_repository.dart';
import '../../../domain/repositories/i_habit_repository.dart';

/// ViewModel for managing life domains.
class DomainsViewModel extends BaseViewModel {
  final _domainRepo = locator<IDomainRepository>();
  final _habitRepo = locator<IHabitRepository>();

  List<DomainEntity> _activeDomains = [];
  List<DomainEntity> _archivedDomains = [];

  List<DomainEntity> get activeDomains => _activeDomains;
  List<DomainEntity> get archivedDomains => _archivedDomains;

  /// Habit count per domain ID.
  Map<String, int> _habitCounts = {};
  int getHabitCount(String domainId) => _habitCounts[domainId] ?? 0;

  bool _showArchived = false;
  bool get showArchived => _showArchived;

  void toggleShowArchived() {
    _showArchived = !_showArchived;
    rebuildUi();
  }

  Future<void> init() async {
    setBusy(true);
    await _loadDomains();
    setBusy(false);
  }

  Future<void> _loadDomains() async {
    final result = await _domainRepo.getDomains();
    result.fold(
      (failure) => setError(failure.message),
      (domains) {
        _activeDomains = domains.where((d) => !d.isArchived).toList()
          ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
        _archivedDomains = domains.where((d) => d.isArchived).toList();
      },
    );

    // Load habit counts per domain
    final habitsResult = await _habitRepo.getHabits(isArchived: false);
    habitsResult.fold(
      (failure) {}, // Non-blocking — counts just stay 0
      (habits) {
        final counts = <String, int>{};
        for (final habit in habits) {
          if (habit.domainId != null) {
            counts[habit.domainId!] = (counts[habit.domainId!] ?? 0) + 1;
          }
        }
        _habitCounts = counts;
      },
    );

    rebuildUi();
  }

  Future<void> createDomain(DomainEntity entity) async {
    final result = await _domainRepo.createDomain(
      entity.copyWith(sortOrder: _activeDomains.length),
    );
    result.fold(
      (failure) => setError(failure.message),
      (_) {},
    );
    if (result.isRight()) await _loadDomains();
  }

  Future<void> updateDomain(DomainEntity entity) async {
    final result = await _domainRepo.updateDomain(entity);
    result.fold(
      (failure) => setError(failure.message),
      (_) {},
    );
    if (result.isRight()) await _loadDomains();
  }

  Future<void> reorderDomains(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) newIndex--;
    final domain = _activeDomains.removeAt(oldIndex);
    _activeDomains.insert(newIndex, domain);
    rebuildUi();

    final orderedIds = _activeDomains.map((d) => d.id).toList();
    final result = await _domainRepo.reorderDomains(orderedIds);
    result.fold(
      (failure) {
        setError(failure.message);
        _loadDomains(); // Revert on failure
      },
      (_) {},
    );
  }

  Future<bool> archiveDomain(String id) async {
    // Cannot archive last active domain
    if (_activeDomains.length <= 1) {
      setError('Vous devez garder au moins un domaine actif.');
      return false;
    }

    final result = await _domainRepo.archiveDomain(id);
    result.fold(
      (failure) => setError(failure.message),
      (_) {},
    );
    if (result.isRight()) {
      await _loadDomains();
      return true;
    }
    return false;
  }

  Future<void> unarchiveDomain(String id) async {
    final result = await _domainRepo.unarchiveDomain(id);
    result.fold(
      (failure) => setError(failure.message),
      (_) {},
    );
    if (result.isRight()) await _loadDomains();
  }
}
