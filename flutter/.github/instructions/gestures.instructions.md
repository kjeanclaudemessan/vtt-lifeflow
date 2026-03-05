```instructions
---
applyTo: "**/*_view.dart"
---
# Gesture Instructions

> These instructions apply to all View files.
> Ensures proper gesture support for a native-feeling experience.

---

## Core Rule

**Lists must support pull-to-refresh. List items must support contextual gestures.**
Don't rely on tap-only interactions — users expect swipe, long-press, and pull gestures.

---

## Required Patterns

### 1. Pull-to-Refresh on Data Lists

Every list that loads data from a remote source MUST have `RefreshIndicator`:

```dart
// ✅ REQUIRED
RefreshIndicator(
  onRefresh: viewModel.refreshData,
  color: AppColors.primary,
  child: ListView.builder(
    physics: const AlwaysScrollableScrollPhysics(),  // Required for empty lists
    itemCount: viewModel.items.length,
    itemBuilder: (context, index) => _buildItem(viewModel.items[index]),
  ),
)

// ❌ FORBIDDEN — no refresh mechanism
ListView.builder(
  itemCount: viewModel.items.length,
  itemBuilder: (context, index) => _buildItem(viewModel.items[index]),
)
```

**ViewModel side:**

```dart
Future<void> refreshData() async {
  // Don't use runBusyFuture — RefreshIndicator shows its own indicator
  await _loadData();
}
```

### 2. Swipe Actions on List Items (Slidable)

List items with contextual actions MUST use `flutter_slidable`:

```dart
// ✅ REQUIRED — swipe-to-reveal actions
import 'package:flutter_slidable/flutter_slidable.dart';

Slidable(
  key: ValueKey(habit.id),
  // Left swipe → destructive action
  endActionPane: ActionPane(
    motion: const BehindMotion(),
    children: [
      SlidableAction(
        onPressed: (_) => viewModel.archiveHabit(habit.id),
        backgroundColor: AppColors.warning,
        foregroundColor: AppColors.white,
        icon: Icons.archive,
        label: context.l10n.archive,
        borderRadius: AppRadius.md,
      ),
      SlidableAction(
        onPressed: (_) => viewModel.deleteHabit(habit.id),
        backgroundColor: AppColors.error,
        foregroundColor: AppColors.white,
        icon: Icons.delete,
        label: context.l10n.delete,
        borderRadius: AppRadius.md,
      ),
    ],
  ),
  // Right swipe → primary action (optional)
  startActionPane: ActionPane(
    motion: const BehindMotion(),
    extentRatio: 0.25,
    children: [
      SlidableAction(
        onPressed: (_) => viewModel.editHabit(habit.id),
        backgroundColor: AppColors.info,
        foregroundColor: AppColors.white,
        icon: Icons.edit,
        label: context.l10n.edit,
        borderRadius: AppRadius.md,
      ),
    ],
  ),
  child: HabitCheckTile(habit: habit),
)
```

### 3. Dismissible for Notifications

Notifications and temporary items should support swipe-to-dismiss:

```dart
// ✅ REQUIRED for notification items
Dismissible(
  key: ValueKey(notification.id),
  direction: DismissDirection.endToStart,
  onDismissed: (_) => viewModel.dismissNotification(notification.id),
  background: Container(
    alignment: Alignment.centerRight,
    padding: AppSpacing.edgeInsets.md,
    color: AppColors.error,
    child: Icon(Icons.delete, color: AppColors.white),
  ),
  child: NotificationCard(notification: notification),
)
```

### 4. Long-Press for Quick Actions

List items should support long-press for a quick-action menu:

```dart
// ✅ RECOMMENDED
GestureDetector(
  onLongPress: () {
    HapticFeedback.selectionClick();
    _showQuickActions(context, viewModel, habit);
  },
  child: HabitCheckTile(habit: habit),
)

void _showQuickActions(BuildContext context, HabitsViewModel viewModel, Habit habit) {
  showModalBottomSheet(
    context: context,
    builder: (_) => AppBottomSheet(
      title: habit.name,
      children: [
        AppListTile(
          leading: Icon(Icons.edit),
          title: context.l10n.edit,
          onTap: () => viewModel.editHabit(habit.id),
        ),
        AppListTile(
          leading: Icon(Icons.archive),
          title: context.l10n.archive,
          onTap: () => viewModel.archiveHabit(habit.id),
        ),
      ],
    ),
  );
}
```

---

## Views That MUST Have Gestures

| View | Required Gestures |
|---|---|
| `TodayView` | Pull-to-refresh |
| `HabitsView` | Pull-to-refresh, Slidable on items, Long-press |
| `CounterView` | Pull-to-refresh |
| `NotificationsView` | Dismissible on items, Pull-to-refresh |

---

## Don'ts

```dart
// ❌ Don't use Dismissible without confirmation for destructive actions
Dismissible(
  onDismissed: (_) => viewModel.deleteHabit(id),  // No undo? Add confirmDismiss
)

// ✅ Use confirmDismiss for destructive actions
Dismissible(
  confirmDismiss: (_) async {
    return await viewModel.confirmDelete(id);
  },
  onDismissed: (_) => viewModel.deleteHabit(id),
)

// ❌ Don't make swipe the only way to access an action
// Always provide a tap alternative (overflow menu, long-press, or visible button)

// ❌ Don't use horizontal swipe on horizontally scrollable content
// Swipe conflicts with horizontal scroll — use vertical or long-press instead
```
```
