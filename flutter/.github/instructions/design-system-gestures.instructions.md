```instructions
---
applyTo: "**/*_view.dart,**/widgets/**/*.dart"
---
# Design System — Gestes & Interactions Tactiles (Phase 24)

> Every gesture MUST provide visual + haptic feedback.
> Gestures are progressive: obvious actions first, advanced gestures discoverable later.
> Never break platform conventions (iOS edge swipe, Android back gesture).

---

## Gesture Map

| Gesture | Action | Feedback | Context |
|---------|--------|----------|---------|
| **Tap** | Primary action | Ripple + scale 0.95→1.0 | Buttons, cards, list items |
| **Double-tap** | Quick toggle (like/favorite) | Scale bounce + haptic | Cards, images, content items |
| **Long press** | Context menu / multi-select | Haptic selection + elevated shadow | List items, cards, grid items |
| **Swipe left** | Destructive action (delete/archive) | Red background reveal + haptic | List items (`Dismissible`) |
| **Swipe right** | Positive action (complete/mark read) | Green/primary background reveal + haptic | List items (`Dismissible`) |
| **Drag & drop** | Reorder items | Elevated shadow + haptic on pickup/drop | Reorderable lists, categories |
| **Pull-to-refresh** | Refresh data | Material indicator + haptic on trigger | Scrollable lists |
| **Pinch-to-zoom** | Zoom content | Smooth scale transform | Images, charts, PDF viewer |
| **Horizontal swipe** | Navigate tabs/pages | PageView snap + dot indicator update | Onboarding, tab sections |
| **Edge swipe (iOS)** | Navigate back | Native iOS pop transition | All screens (never override) |

---

## Swipe Actions (Dismissible/Slidable)

### Design

```
← Swipe Left (Destructive)          Swipe Right (Positive) →
┌─────────────────────────────────┐
│ 🗑️ Supprimer     [List Item]     ✅ Terminer │
│  red background                   green/primary │
└─────────────────────────────────┘
```

### Implementation

```dart
// ✅ CORRECT — Swipe with confirmation + haptic
Dismissible(
  key: ValueKey(item.id),
  direction: DismissDirection.horizontal,
  confirmDismiss: (direction) async {
    if (direction == DismissDirection.endToStart) {
      // Destructive: confirm via dialog
      HapticFeedback.mediumImpact();
      return await _showDeleteConfirmation(context);
    } else {
      // Positive: immediate action
      HapticFeedback.lightImpact();
      return true;
    }
  },
  onDismissed: (direction) {
    if (direction == DismissDirection.endToStart) {
      viewModel.deleteItem(item);
    } else {
      viewModel.completeItem(item);
    }
  },
  background: _buildSwipeBackground(
    color: AppColors.success,
    icon: LucideIcons.check,
    alignment: Alignment.centerLeft,
  ),
  secondaryBackground: _buildSwipeBackground(
    color: AppColors.error,
    icon: LucideIcons.trash2,
    alignment: Alignment.centerRight,
  ),
  child: listItem,
)

// ❌ FORBIDDEN — swipe without feedback or confirmation
Dismissible(
  key: ValueKey(item.id),
  onDismissed: (_) => viewModel.deleteItem(item),
  child: listItem,
)
```

### Swipe Background Builder

```dart
Widget _buildSwipeBackground({
  required Color color,
  required IconData icon,
  required AlignmentGeometry alignment,
}) {
  return Container(
    color: color,
    alignment: alignment,
    padding: EdgeInsets.symmetric(horizontal: AppSpacing.staticLg),
    child: Icon(icon, color: AppColors.white, size: AppSizing.iconLg,
                semanticLabel: ''),
  );
}
```

### Rules

| Rule | Value |
|------|-------|
| Swipe threshold | 40% of item width to trigger |
| Destructive swipe | ALWAYS requires confirmation dialog or undo snackbar |
| Positive swipe | Immediate execution + success haptic |
| Undo | Show `AppSnackbar` with "Annuler" action for 5 seconds |
| Haptic | `lightImpact()` at threshold, `mediumImpact()` on trigger |
| Disabled state | No swipe on disabled/locked items |

---

## Long Press (Context Menu)

### When to Use

- Revealing secondary actions (edit, share, move, pin).
- Entering multi-select mode.
- Showing quick info preview.

### Implementation

```dart
// ✅ CORRECT — long press with haptic + context menu
GestureDetector(
  onLongPress: () {
    HapticFeedback.selectionClick();
    _showContextMenu(context, item);
  },
  child: card,
)

// Context menu as bottom sheet (not popup menu)
void _showContextMenu(BuildContext context, Item item) {
  showModalBottomSheet(
    context: context,
    builder: (_) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          AppGaps.verticalSm,
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: context.colorScheme.onSurfaceVariant.withOpacity(0.3),
              borderRadius: AppRadius.full,
            ),
          ),
          AppGaps.verticalMd,
          // Actions
          AppListTile(
            leading: Icon(LucideIcons.pencil),
            title: context.l10n.edit,
            onTap: () { Navigator.pop(context); viewModel.editItem(item); },
          ),
          AppListTile(
            leading: Icon(LucideIcons.share2),
            title: context.l10n.share,
            onTap: () { Navigator.pop(context); viewModel.shareItem(item); },
          ),
          AppListTile(
            leading: Icon(LucideIcons.trash2, color: AppColors.error),
            title: context.l10n.delete,
            titleStyle: TextStyle(color: AppColors.error),
            onTap: () { Navigator.pop(context); viewModel.deleteItem(item); },
          ),
          AppGaps.verticalMd,
        ],
      ),
    ),
  );
}
```

### Rules

| Rule | Value |
|------|-------|
| Feedback | `HapticFeedback.selectionClick()` immediately on long press |
| Visual | Slight elevation/scale of pressed item (AnimatedScale 1.02) |
| Menu type | Bottom sheet (not context menu popup) — more touch-friendly |
| Max actions | 5 actions maximum per context menu |
| Destructive | Always last, always red text + red icon |
| Cancel | Tap outside or swipe down to dismiss |

---

## Drag & Drop (Reorder)

### When to Use

- Reordering habits, tasks, categories, priorities.
- Manual sorting of user-created lists.

### Implementation

```dart
// ✅ CORRECT — ReorderableListView with haptic
ReorderableListView.builder(
  onReorder: (oldIndex, newIndex) {
    HapticFeedback.mediumImpact();
    viewModel.reorderItems(oldIndex, newIndex);
  },
  proxyDecorator: (child, index, animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) => Material(
        elevation: 4,
        borderRadius: AppRadius.md,
        shadowColor: context.colorScheme.shadow.withOpacity(0.3),
        child: child,
      ),
      child: child,
    );
  },
  itemCount: items.length,
  itemBuilder: (context, index) => ListTile(
    key: ValueKey(items[index].id),
    leading: ReorderableDragStartListener(
      index: index,
      child: Icon(LucideIcons.gripVertical,
                  color: context.colorScheme.onSurfaceVariant,
                  semanticLabel: context.l10n.dragToReorder),
    ),
    title: Text(items[index].name),
  ),
)
```

### Rules

| Rule | Value |
|------|-------|
| Handle icon | `LucideIcons.gripVertical` — always visible |
| Pickup haptic | `mediumImpact()` on drag start |
| Drop haptic | `lightImpact()` on successful drop |
| Visual | Elevated shadow (elevation 4) during drag |
| Auto-scroll | Automatic near list edges during drag |
| Persist | Save new order immediately to backend |

---

## Pull-to-Refresh

### Implementation

```dart
// ✅ CORRECT — themed RefreshIndicator
RefreshIndicator(
  onRefresh: viewModel.refresh,
  color: context.colorScheme.primary,
  backgroundColor: context.colorScheme.surface,
  displacement: 40,
  strokeWidth: 2.5,
  child: listView,
)
```

### Rules

| Rule | Value |
|------|-------|
| Threshold distance | 80px pull before triggering |
| Haptic | `lightImpact()` when threshold reached (from ViewModel) |
| Indicator color | `colorScheme.primary` |
| Background | `colorScheme.surface` |
| Duration | Show indicator until data fetch completes |
| Error handling | Show snackbar if refresh fails, keep existing data |

---

## Double-Tap

### When to Use

- Quick favorite/like toggle on content cards.
- NOT for navigation or destructive actions.

### Implementation

```dart
// ✅ CORRECT — double-tap to favorite with animation
GestureDetector(
  onDoubleTap: () {
    HapticFeedback.lightImpact();
    viewModel.toggleFavorite(item);
  },
  child: Stack(
    children: [
      card,
      // Animated heart overlay on double-tap
      if (showHeartOverlay)
        Center(
          child: AnimatedScale(
            scale: showHeartOverlay ? 1.0 : 0.0,
            duration: AppAnimations.medium,
            curve: AppAnimations.spring,
            child: Icon(
              LucideIcons.heart,
              size: 80,
              color: AppColors.error.withOpacity(0.8),
            ),
          ),
        ),
    ],
  ),
)
```

### Rules

| Rule | Value |
|------|-------|
| Haptic | `lightImpact()` on trigger |
| Visual | Heart/star scale animation (0→1→0 over 600ms) |
| Scope | Favorites, likes ONLY — never for critical actions |
| Discoverability | Users discover by accident — always provide tap alternative |

---

## Pinch-to-Zoom

### When to Use

- Image gallery / full-screen image viewer.
- Charts and data visualizations.
- PDF viewer.

### Implementation

```dart
// ✅ CORRECT — InteractiveViewer for zoomable content
InteractiveViewer(
  minScale: 1.0,
  maxScale: 4.0,
  clipBehavior: Clip.none,
  panEnabled: true,
  child: Image.network(imageUrl, fit: BoxFit.contain),
)
```

### Rules

| Rule | Value |
|------|-------|
| Min scale | 1.0 (original size) |
| Max scale | 4.0x |
| Double-tap zoom | Cycle between 1.0x → 2.0x → 1.0x |
| Reset | Double-tap or pinch below 1.0x returns to 1.0x |
| Clip | Content can extend beyond boundaries during zoom |

---

## Horizontal Swipe (Tabs/Pages)

### When to Use

- Onboarding pages.
- Dashboard sections.
- Photo/media galleries.

### Implementation

```dart
// ✅ CORRECT — PageView with proper physics
PageView(
  controller: _pageController,
  physics: const BouncingScrollPhysics(),
  onPageChanged: viewModel.onPageChanged,
  children: pages,
)
```

### Rules

| Rule | Value |
|------|-------|
| Physics | `BouncingScrollPhysics()` (iOS feel) on both platforms |
| Indicator | Dot indicators synced to page position |
| Snap | Always snap to full page (never half-visible) |
| Edge behavior | Bounce effect at first/last page, no wrap-around |

---

## Edge Swipe (Platform Back)

### Rules

| Platform | Behavior |
|----------|----------|
| **iOS** | Edge swipe from left navigates back — NEVER override this |
| **Android** | Predictive back gesture (Android 14+) — must support |
| **Both** | `WillPopScope` / `PopScope` only for unsaved data confirmation |

```dart
// ✅ CORRECT — only intercept when there's unsaved data
PopScope(
  canPop: !viewModel.hasUnsavedChanges,
  onPopInvokedWithResult: (didPop, result) {
    if (!didPop) {
      _showDiscardDialog(context);
    }
  },
  child: scaffold,
)

// ❌ FORBIDDEN — blocking back navigation without reason
PopScope(
  canPop: false,
  child: scaffold,
)
```

---

## Velocity Thresholds

| Gesture | Slow (< 500 px/s) | Fast (≥ 500 px/s) |
|---------|--------------------|--------------------|
| Swipe dismiss | Requires 40% threshold | Dismisses at any distance |
| Page swipe | Settles to nearest page | Advances to next page |
| Pull-to-refresh | Needs full pull distance | Triggers at 50% distance |
| Fling scroll | Standard velocity | Momentum scroll continues |

---

## Accessibility

| Rule | Implementation |
|------|----------------|
| **All gestures have tap alternatives** | Swipe actions also available in overflow menu / long press |
| **Semantics labels** | Every gesture target has `semanticLabel` |
| **Large touch targets** | Minimum 48x48dp for all interactive elements |
| **Reduce motion** | Skip animations for `MediaQuery.disableAnimations` |
| **Screen reader** | Announce gesture actions via `Semantics(onLongPress: ...)` |

```dart
// ✅ CORRECT — swipe action also available via menu
Semantics(
  label: context.l10n.itemName(item.name),
  customSemanticsActions: {
    CustomSemanticsAction(label: context.l10n.delete): () => viewModel.deleteItem(item),
    CustomSemanticsAction(label: context.l10n.complete): () => viewModel.completeItem(item),
  },
  child: dismissibleItem,
)
```

---

## Self-Check

- [ ] Every swipe-to-delete has an undo mechanism (snackbar 5s).
- [ ] Every long press triggers `HapticFeedback.selectionClick()`.
- [ ] Drag handles use `LucideIcons.gripVertical`.
- [ ] Pull-to-refresh uses themed `RefreshIndicator`.
- [ ] iOS edge swipe is never overridden.
- [ ] All gesture-only actions have accessible tap alternatives.
- [ ] Double-tap is ONLY used for favorites/likes (never destructive).
- [ ] Pinch-to-zoom min=1.0, max=4.0 on images/charts.
```
