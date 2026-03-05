```prompt
# Add Gestures to a View

Add swipe, pull-to-refresh, and long-press gestures to an existing view.

## Target

- **View File**: ${{input:Path to the view file (e.g., lib/features/habits/views/habits_view.dart)}}
- **Gesture Focus**: ${{input:What to add: pull-to-refresh, swipe-actions, long-press, or all}}

## Instructions

### Step 1: Analyze the View

Identify:
1. **Lists** that load remote data → need `RefreshIndicator`
2. **List items** with contextual actions (edit, delete, archive) → need `Slidable`
3. **Items** that can be dismissed (notifications) → need `Dismissible`
4. **Items** that could show quick actions → need long-press

### Step 2: Add Pull-to-Refresh

Wrap every data-driven `ListView` / `CustomScrollView`:

```dart
RefreshIndicator(
  onRefresh: viewModel.refreshData,
  color: AppColors.primary,
  child: ListView.builder(
    physics: const AlwaysScrollableScrollPhysics(),
    itemCount: viewModel.items.length,
    itemBuilder: (context, index) => _buildItem(viewModel.items[index]),
  ),
)
```

Add to ViewModel:
```dart
Future<void> refreshData() async {
  await _loadData();
}
```

### Step 3: Add Slidable Actions

Add `flutter_slidable` to `pubspec.yaml` if not present:
```yaml
dependencies:
  flutter_slidable: ^3.1.1
```

Wrap list items:
```dart
import 'package:flutter_slidable/flutter_slidable.dart';

Slidable(
  key: ValueKey(item.id),
  endActionPane: ActionPane(
    motion: const BehindMotion(),
    children: [
      SlidableAction(
        onPressed: (_) {
          HapticFeedback.lightImpact();
          viewModel.archiveItem(item.id);
        },
        backgroundColor: AppColors.warning,
        foregroundColor: AppColors.white,
        icon: Icons.archive,
        label: context.l10n.archive,
      ),
      SlidableAction(
        onPressed: (_) {
          HapticFeedback.mediumImpact();
          viewModel.confirmDelete(item.id);
        },
        backgroundColor: AppColors.error,
        foregroundColor: AppColors.white,
        icon: Icons.delete,
        label: context.l10n.delete,
      ),
    ],
  ),
  child: existingItemWidget,
)
```

### Step 4: Add Long-Press

```dart
GestureDetector(
  onLongPress: () {
    HapticFeedback.selectionClick();
    _showQuickActions(context, viewModel, item);
  },
  child: existingItemWidget,
)

void _showQuickActions(BuildContext context, ViewModel viewModel, Item item) {
  showModalBottomSheet(
    context: context,
    builder: (_) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.edit),
            title: Text(context.l10n.edit),
            onTap: () {
              Navigator.pop(context);
              viewModel.editItem(item.id);
            },
          ),
          ListTile(
            leading: Icon(Icons.archive),
            title: Text(context.l10n.archive),
            onTap: () {
              Navigator.pop(context);
              viewModel.archiveItem(item.id);
            },
          ),
        ],
      ),
    ),
  );
}
```

### Step 5: Add Dismissible (Notifications)

```dart
Dismissible(
  key: ValueKey(notification.id),
  direction: DismissDirection.endToStart,
  confirmDismiss: (_) async => true,  // Or show confirmation
  onDismissed: (_) {
    HapticFeedback.lightImpact();
    viewModel.dismiss(notification.id);
  },
  background: Container(
    alignment: Alignment.centerRight,
    padding: EdgeInsets.only(right: AppSpacing.lg),
    color: AppColors.error,
    child: Icon(Icons.delete, color: AppColors.white, semanticLabel: context.l10n.delete),
  ),
  child: notificationCard,
)
```

## Verification

- [ ] All data lists have `RefreshIndicator`
- [ ] `AlwaysScrollableScrollPhysics` used (so refresh works on empty lists)
- [ ] Slidable actions have haptic feedback
- [ ] Destructive swipe actions have confirmation
- [ ] Long-press provides alternative access to swipe actions
- [ ] ViewModel has corresponding `refreshData()` method
```
