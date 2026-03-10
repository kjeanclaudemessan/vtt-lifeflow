```instructions
---
applyTo: "**/*_view.dart,**/*_viewmodel.dart,**/*_service.dart,**/*_repository.dart"
---
# Design System — Offline & Sync (Phase 32)

> Users in Africa frequently lose connectivity. The app MUST work offline.
> Show cached data immediately. Queue writes for sync.
> Conflict resolution: last-write-wins with user notification.
> Always show connectivity and sync status clearly.

---

## Offline Strategy

### Feature Matrix

| Feature | Offline Read | Offline Write | Sync Strategy |
|---------|-------------|---------------|---------------|
| **View dashboard/list** | ✅ (cached data) | N/A | Stale-while-revalidate |
| **View detail** | ✅ (cached data) | N/A | Stale-while-revalidate |
| **Create item** | N/A | ✅ (queued) | Queue + sync on reconnect |
| **Update item** | N/A | ✅ (queued) | Queue + sync on reconnect |
| **Delete item** | N/A | ✅ (queued) | Queue + sync on reconnect |
| **Toggle (complete/like)** | N/A | ✅ (queued) | Queue + sync on reconnect |
| **Auth (login/register)** | ❌ | ❌ | Requires network |
| **File upload** | ❌ | ✅ (queued) | Queue, retry on reconnect |
| **Real-time chat** | ✅ (cached history) | ✅ (queued) | Queue + sync |

---

## Offline Indicator (32.2)

### Banner Hierarchy

| State | Indicator | Persistence |
|-------|-----------|-------------|
| **Online** | No indicator | — |
| **Offline (just lost)** | Snackbar: "Mode hors ligne" | 3 seconds |
| **Offline (persistent)** | `MaterialBanner` at top | Until reconnect |
| **Back online** | Snackbar: "Connexion rétablie" + sync starts | 3 seconds |
| **Syncing** | Subtle animated icon in AppBar | Until sync complete |
| **Sync error** | Snackbar: "Erreur de synchronisation" + retry | 5 seconds |

### Implementation

```dart
// ✅ CORRECT — connectivity-aware banner
class ConnectivityBanner extends StatelessWidget {
  final bool isOnline;
  final bool isSyncing;

  @override
  Widget build(BuildContext context) {
    if (isOnline && !isSyncing) return const SizedBox.shrink();

    if (!isOnline) {
      return MaterialBanner(
        content: Row(
          children: [
            Icon(LucideIcons.wifiOff, size: AppSizing.iconSm,
                 color: AppColors.warning,
                 semanticLabel: context.l10n.offlineMode),
            AppGaps.horizontalSm,
            Expanded(
              child: Text(context.l10n.offlineMessage,
                  style: AppTypography.bodySmall),
            ),
          ],
        ),
        backgroundColor: AppColors.warning.withOpacity(0.1),
        padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.staticMd, vertical: AppSpacing.staticSm),
        actions: [
          TextButton(
            onPressed: null, // no retry when truly offline
            child: Text(context.l10n.workingOffline),
          ),
        ],
      );
    }

    // Syncing state
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.staticMd, vertical: AppSpacing.staticXs),
      color: context.colorScheme.primaryContainer,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 12, height: 12,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              semanticsLabel: context.l10n.syncing,
            ),
          ),
          AppGaps.horizontalSm,
          Text(context.l10n.syncing, style: AppTypography.labelSmall),
        ],
      ),
    );
  }
}
```

---

## Action Queue (32.3)

Offline writes are queued locally and synced when connectivity returns.

### Queue Model

```dart
// ✅ CORRECT — pending action model
class PendingAction {
  final String id;
  final String entityType;    // 'habit', 'task', 'note'
  final String entityId;
  final ActionType actionType; // create, update, delete
  final Map<String, dynamic> payload;
  final DateTime createdAt;
  final int retryCount;       // max 3 retries

  bool get isExpired => retryCount >= 3;
}

enum ActionType { create, update, delete }
```

### Queue Service

```dart
// ✅ CORRECT — offline action queue
class OfflineQueueService {
  final _queue = <PendingAction>[];
  final _storage = HiveBox<PendingAction>('offline_queue');

  /// Enqueue an action for later sync
  Future<void> enqueue(PendingAction action) async {
    _queue.add(action);
    await _storage.put(action.id, action);
  }

  /// Process queue when back online (FIFO order)
  Future<void> processQueue() async {
    final pending = List<PendingAction>.from(_queue);

    for (final action in pending) {
      try {
        await _syncAction(action);
        await _storage.delete(action.id);
        _queue.remove(action);
      } catch (e) {
        action.retryCount++;
        if (action.isExpired) {
          // Notify user of failed sync
          _notifyFailedSync(action);
          await _storage.delete(action.id);
          _queue.remove(action);
        }
      }
    }
  }

  /// Number of pending actions
  int get pendingCount => _queue.length;
}
```

### Queue Rules

| Rule | Value |
|------|-------|
| Storage | Hive (lightweight, fast) or Drift (if complex queries needed) |
| Order | FIFO — process in creation order |
| Max retries | 3 — after that, notify user and drop |
| Max queue size | 100 actions — warn user if approaching limit |
| Conflict | Last-write-wins (server timestamp) |
| Deduplication | If same entity has multiple updates queued, merge into latest |

---

## Conflict Resolution (32.4)

### Strategy: Last-Write-Wins + User Notification

When the same entity was modified both locally (offline) and remotely (another device), the **most recent write wins** based on timestamp. The user is notified.

```dart
// ✅ CORRECT — conflict detection
Future<SyncResult> syncEntity(PendingAction action) async {
  final serverVersion = await _repository.getById(action.entityId);

  if (serverVersion != null &&
      serverVersion.updatedAt.isAfter(action.createdAt)) {
    // Conflict: server has newer data
    // Last-write-wins: server version takes precedence
    _snackbarService.showInfo(
      message: context.l10n.syncConflictServerWins,
    );
    return SyncResult.conflictServerWins;
  }

  // No conflict: push local changes
  await _repository.upsert(action.payload);
  return SyncResult.success;
}
```

### Conflict UX

| Scenario | Behaviour |
|----------|-----------|
| **Server newer** | Keep server version, discard local. Notify: "Des modifications plus récentes ont été trouvées" |
| **Local newer** | Push local to server. Silent success. |
| **Same timestamp** | Keep server version (tie-breaker). |
| **Delete conflict** | If deleted on server, remove locally too. Notify if local had edits. |

---

## Local Storage (32.5)

### Storage Selection

| Storage | Use for | Package |
|---------|---------|---------|
| **SharedPreferences** | Settings, flags, single values | `shared_preferences` |
| **Hive** | Offline queue, cached lists, lightweight models | `hive_flutter` |
| **Drift (SQLite)** | Complex queries, relational data, large datasets | `drift` |
| **CachedNetworkImage** | Image caching | `cached_network_image` |

### Rules

- **Cache expiry**: Default 24 hours. Configurable per entity type.
- **Cache invalidation**: Clear on logout. Refresh on pull-to-refresh.
- **Encrypted storage**: Use `flutter_secure_storage` for tokens and sensitive data.
- **Storage limit**: Warn user if local storage exceeds 100MB.

```dart
// ✅ CORRECT — cache with expiry
class CacheService {
  Future<T?> get<T>(String key, {Duration maxAge = const Duration(hours: 24)}) async {
    final entry = await _box.get(key);
    if (entry == null) return null;

    final age = DateTime.now().difference(entry.cachedAt);
    if (age > maxAge) {
      await _box.delete(key); // expired
      return null;
    }
    return entry.data as T;
  }

  Future<void> set<T>(String key, T data) async {
    await _box.put(key, CacheEntry(data: data, cachedAt: DateTime.now()));
  }

  Future<void> clearAll() async => await _box.clear();
}
```

---

## Sync Indicator (32.6)

### Subtle Sync in AppBar

```dart
// ✅ CORRECT — animated sync icon in AppBar action
if (syncService.isSyncing) {
  RotationTransition(
    turns: _syncAnimationController, // infinite slow rotation
    child: Icon(LucideIcons.refreshCw, size: AppSizing.iconSm,
                semanticLabel: context.l10n.syncing),
  ),
}
```

### Sync Status in Settings

```dart
// ✅ CORRECT — sync status in settings
AppListTile(
  leading: Icon(LucideIcons.refreshCw, semanticLabel: context.l10n.syncStatus),
  title: context.l10n.syncStatus,
  subtitle: viewModel.lastSyncTime != null
      ? context.l10n.lastSynced(formatRelativeTime(viewModel.lastSyncTime!))
      : context.l10n.neverSynced,
  trailing: viewModel.pendingActions > 0
      ? AppBadge.count(count: viewModel.pendingActions)
      : Icon(LucideIcons.checkCircle2, color: AppColors.success,
             semanticLabel: context.l10n.upToDate),
  onTap: viewModel.forceSyncNow,
)
```

---

## Offline-First Architecture

```
┌─────────────────────────────────────────────────┐
│                    UI Layer                      │
│              (Views + ViewModels)                 │
├─────────────────────────────────────────────────┤
│               Repository Layer                   │
│   ┌─────────────────────────────────────────┐   │
│   │  get() → check cache → if miss → API    │   │
│   │  save() → write cache + enqueue sync     │   │
│   │  delete() → mark deleted + enqueue sync  │   │
│   └─────────────────────────────────────────┘   │
├────────────────────┬────────────────────────────┤
│    Local Cache     │     Remote API              │
│   (Hive / Drift)   │   (Supabase / FastAPI)      │
│                    │                             │
│  ← offline data →  │  ← online data →            │
└────────────────────┴────────────────────────────┘
│                    │
│  OfflineQueueService monitors connectivity       │
│  and processes pending actions on reconnect       │
└──────────────────────────────────────────────────┘
```

---

## Offline Checklist

- [ ] All list/detail views show cached data when offline
- [ ] Offline banner appears within 2 seconds of losing connectivity
- [ ] Reconnection snackbar confirms "Connexion rétablie"
- [ ] CRUD actions are queued and synced on reconnect (FIFO)
- [ ] Queue handles max 3 retries per action
- [ ] Conflict resolution uses last-write-wins
- [ ] User is notified of sync conflicts
- [ ] Cache has expiry (24h default)
- [ ] Tokens stored in `flutter_secure_storage`, not Hive
- [ ] Sync status visible in Settings
- [ ] Force sync button available in Settings
- [ ] Cache clears on logout
```
