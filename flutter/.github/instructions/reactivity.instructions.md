---
applyTo: "**/*_viewmodel.dart,**/*_service.dart"
---

# Data Reactivity — Mandatory Patterns

> When data is created, updated, or deleted in ANY view, ALL other visible views
> showing that data MUST refresh automatically. No stale UI is acceptable.
>
> This is the #1 UX quality signal — the app must feel alive and connected.

---

## Architecture: Event Bus Pattern

The app uses lightweight event services (e.g., `HabitEventService`) as reactive buses.
Every domain entity that can be modified MUST have its own event service.

### 1. Event Service Template

```dart
/// Event bus for [EntityName] data changes.
///
/// Registered as [LazySingleton] in the locator.
class EntityEventService {
  final List<void Function()> _listeners = [];

  void addListener(void Function() callback) => _listeners.add(callback);
  void removeListener(void Function() callback) => _listeners.remove(callback);

  /// Notifies all listeners that entity data has changed.
  void notifyEntityChanged() {
    for (final listener in List.of(_listeners)) {
      listener();
    }
  }
}
```

### 2. Producer ViewModel (creates/updates/deletes)

```dart
class EntityFormViewModel extends BaseViewModel {
  final _entityRepo = locator<IEntityRepository>();
  final _eventService = locator<EntityEventService>();

  Future<void> save() async {
    final result = await runBusyFuture(_entityRepo.create(entity));
    result.fold(
      (failure) {
        HapticFeedback.heavyImpact();
        setError(failure.userMessage);
      },
      (created) {
        HapticFeedback.mediumImpact();
        // ✅ CRITICAL — notify ALL listeners
        _eventService.notifyEntityChanged();
        _navigationService.back(result: true);
      },
    );
  }
}
```

### 3. Consumer ViewModel (displays the data)

```dart
class EntityListViewModel extends BaseViewModel {
  final _eventService = locator<EntityEventService>();

  @override
  void initialise() {
    // ✅ CRITICAL — subscribe on init
    _eventService.addListener(_onDataChanged);
    _loadData();
  }

  void _onDataChanged() {
    // ✅ Reload fresh data from source of truth (Supabase)
    _loadData();
  }

  @override
  void dispose() {
    // ✅ CRITICAL — unsubscribe on dispose to prevent leaks
    _eventService.removeListener(_onDataChanged);
    super.dispose();
  }

  Future<void> _loadData() async {
    final result = await _entityRepo.getAll();
    result.fold(
      (failure) => setError(failure.userMessage),
      (data) {
        _items = data;
        rebuildUi();
      },
    );
  }
}
```

---

## Rules

### MUST DO

1. **Every entity type has an EventService** — `HabitEventService`, `DomainEventService`, `ProfileEventService`, etc.
2. **Every create/update/delete calls `notifyChanged()`** — immediately after successful mutation
3. **Every ViewModel displaying that data subscribes** — in `initialise()`, unsubscribe in `dispose()`
4. **Listeners reload from source of truth** — never pass data through the event (stale risk), always re-fetch from Supabase
5. **Register EventServices as `LazySingleton`** in `app.dart`
6. **Cross-feature refresh** — if habits view AND today view both show habits, both must subscribe to `HabitEventService`

### MUST NOT DO

1. **Never rely on `Navigator.pop(result)` alone** — only the direct caller gets the result, not other open views
2. **Never pass data through events** — events are notifications, not data carriers
3. **Never skip `dispose()`** — memory leak + ghost callbacks on dead viewmodels
4. **Never use `setState` for cross-widget communication** — use event services
5. **Never assume "the user will go back and see fresh data"** — tabs/bottom nav keep VMs alive

---

## Event Service Registry

Every entity MUST be registered. Check this list when adding new features:

| Entity | Service | Registered in `app.dart` |
|---|---|---|
| Habit | `HabitEventService` | ✅ `LazySingleton` |
| Domain | `DomainEventService` | ⬜ TODO |
| Profile | `ProfileEventService` | ⬜ TODO |
| Notification | `NotificationEventService` | ⬜ TODO |

> Update this table as new entities are added.

---

## Optimistic Updates (Advanced)

For instant feedback, update local state first, then sync:

```dart
Future<void> toggleHabit(String habitId) async {
  // 1. Optimistic local update
  _toggleLocally(habitId);
  rebuildUi();
  HapticFeedback.lightImpact();

  // 2. Server sync
  final result = await _repository.toggle(habitId);
  result.fold(
    (failure) {
      // 3. Rollback on failure
      _toggleLocally(habitId); // Revert
      rebuildUi();
      HapticFeedback.heavyImpact();
      setError(failure.userMessage);
    },
    (_) {
      // 4. Notify other views
      _eventService.notifyHabitChanged();
    },
  );
}
```

---

## Self-Check

```bash
# Find ViewModels that mutate data without notifying
grep -rn "\.create\|\.update\|\.delete\|\.archive" lib/features/ lib/modules/ \
  | grep "viewmodel" | grep -v "notifyChanged\|notifyHabitChanged\|notifyEntityChanged"
```
