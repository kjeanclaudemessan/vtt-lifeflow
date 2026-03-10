```instructions
---
applyTo: "**/*_view.dart,**/*_viewmodel.dart,**/app.dart"
---
# Design System — Navigation Patterns

> Consistent navigation across all VTT apps.
> Bottom Navigation (4 tabs) + stack screens. No drawer.
> FAB for primary action. SliverAppBar for collapsing headers.

---

## Primary Pattern: Bottom Navigation + Stack

```
┌──────────────────────────┐
│      SliverAppBar         │  ← Collapsing header
│      (title, actions)     │
├──────────────────────────┤
│                          │
│      Screen Content      │  ← Stack navigation within each tab
│                          │
│                          │
├──────────────────────────┤
│  🏠   📊   ➕   📋   👤  │  ← Bottom Navigation (4-5 tabs)
└──────────────────────────┘
              ↑
         FAB (optional)
```

---

## Bottom Navigation

### Configuration

- **Tabs**: 4 tabs (recommended). 5 max for content-heavy apps.
- **Icons**: Lucide, `AppSizing.iconLg` (24dp).
- **Labels**: Always visible below icons. Never icon-only.
- **Active indicator**: Primary color on icon + label. Filled icon variant.
- **Inactive**: `onSurfaceVariant` color. Outlined icon variant.

### Standard Tab Structure (Flow apps)

| Tab | Icon | Label |
|-----|------|-------|
| 1 — Home | `LucideIcons.home` | Accueil |
| 2 — Progress | `LucideIcons.barChart3` | Progrès |
| 3 — AI Coach | `LucideIcons.sparkles` | Coach IA |
| 4 — Profile | `LucideIcons.user` | Profil |

### Standard Tab Structure (Pro apps)

| Tab | Icon | Label |
|-----|------|-------|
| 1 — Dashboard | `LucideIcons.layoutDashboard` | Tableau |
| 2 — Clients | `LucideIcons.users` | Clients |
| 3 — Documents | `LucideIcons.fileText` | Documents |
| 4 — Settings | `LucideIcons.settings` | Réglages |

### Rules

```dart
// ✅ CORRECT — labeled bottom nav with animation
BottomNavigationBar(
  type: BottomNavigationBarType.fixed,
  selectedItemColor: context.colorScheme.primary,
  unselectedItemColor: context.colorScheme.onSurfaceVariant,
  selectedLabelStyle: AppTypography.labelSmall,
  unselectedLabelStyle: AppTypography.labelSmall,
  items: [...],
)

// ❌ FORBIDDEN — icon-only navigation
BottomNavigationBar(showSelectedLabels: false, showUnselectedLabels: false)

// ❌ FORBIDDEN — drawer navigation
Scaffold(drawer: Drawer(...))
```

---

## Drawer: NOT USED

- **No drawer** in any VTT app.
- All primary destinations live in Bottom Navigation.
- Secondary destinations (Settings, About, Help) are accessed via AppBar actions or profile tab.

---

## FAB (Floating Action Button)

### When to Use

- **Home screen**: if there's a primary creation action (add habit, add client, etc.).
- **NOT on every screen** — only where the main action is "create new."

### Style

```dart
FloatingActionButton(
  onPressed: viewModel.addNew,
  backgroundColor: context.colorScheme.primary,
  foregroundColor: context.colorScheme.onPrimary,
  shape: const CircleBorder(),
  child: Icon(LucideIcons.plus, size: AppSizing.iconLg, semanticLabel: context.l10n.add),
)
```

### Rules

- Shape: **Circle** (not extended, not mini— unless constrained).
- Position: Bottom-right (default Flutter position).
- Icon: `LucideIcons.plus` for creation, custom for specific actions.
- Color: `primary` background, `onPrimary` foreground.
- Never place FAB on screens with forms or detail views.

---

## AppBar / SliverAppBar

### Standard AppBar

```dart
SliverAppBar(
  floating: true,
  snap: true,
  title: Text(context.l10n.screenTitle, style: AppTypography.headingMedium),
  backgroundColor: context.colorScheme.surface,
  surfaceTintColor: Colors.transparent,
  actions: [
    // Max 2 action icons (not counting back)
    IconButton(
      icon: Icon(LucideIcons.search, semanticLabel: context.l10n.search),
      onPressed: viewModel.openSearch,
    ),
    IconButton(
      icon: Icon(LucideIcons.bell, semanticLabel: context.l10n.notifications),
      onPressed: viewModel.openNotifications,
    ),
  ],
)
```

### Collapsing Header

For screens with hero content (profile, dashboard):

```dart
SliverAppBar(
  expandedHeight: 200,
  pinned: true,
  flexibleSpace: FlexibleSpaceBar(
    title: Text(title),
    background: heroContent,
    collapseMode: CollapseMode.parallax,
  ),
)
```

### Rules

- Max **2 actions** in AppBar (not counting back button).
- Background: `context.colorScheme.surface` (transparent feel).
- No `surfaceTintColor` (Material You tint disabled).
- Title: `AppTypography.headingMedium`.

---

## Back Navigation

| Context | Widget | Behavior |
|---------|--------|----------|
| **Standard push** | ← Arrow (auto by Navigator) | Back to previous screen |
| **Modal / Form** | ✕ Close icon | Close modal, discard if unsaved |
| **iOS swipe back** | Edge swipe gesture | Native iOS behavior (enabled by default) |
| **Root tab** | No back button | Bottom nav handles this |

```dart
// ✅ Modal close button
AppBar(
  leading: IconButton(
    icon: Icon(LucideIcons.x, semanticLabel: context.l10n.close),
    onPressed: viewModel.close,
  ),
)
```

---

## Page Transitions

| Navigation Type | Transition | Code |
|----------------|------------|------|
| **Push** (list → detail) | Slide from right | Default Stacked route transition |
| **Modal** (create, filter) | Slide from bottom | `TransitionsBuilders.slideBottom` |
| **Replace** (splash → home) | Cross-fade | `TransitionsBuilders.fadeIn` |
| **Tab switch** | No animation | Instant (within Bottom Nav) |

```dart
// ✅ CORRECT — modal transition for creation screens
@StackedApp(routes: [
  MaterialRoute(page: AddHabitView, fullscreenDialog: true), // slides from bottom
])

// ❌ FORBIDDEN — raw Navigator.push
Navigator.push(context, MaterialPageRoute(builder: (_) => AddHabitView()));
```

---

## Bottom Sheets

### When to Use

| Content Type | Widget |
|-------------|--------|
| **Filters** | Modal bottom sheet |
| **Quick actions** | Modal bottom sheet (action list) |
| **Details preview** | Modal bottom sheet |
| **Long content** | DraggableScrollableSheet |

### Style

```dart
showModalBottomSheet(
  context: context,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xlValue)),
  ),
  backgroundColor: context.colorScheme.surface,
  builder: (context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      // Handle bar
      Container(
        width: 40,
        height: 4,
        margin: EdgeInsets.only(top: AppSpacing.staticSm),
        decoration: BoxDecoration(
          color: context.colorScheme.outlineVariant,
          borderRadius: AppRadius.pill,
        ),
      ),
      // Content...
    ],
  ),
)
```

---

## Modals vs Full-Screen

| Action | Navigation Type | Why |
|--------|----------------|-----|
| **Create** (add habit, new client) | Full-screen | Complex forms need space |
| **Edit** (edit field, rename) | Full-screen or bottom sheet | Depends on complexity |
| **Filter** | Bottom sheet | Quick, dismissible |
| **Confirm/Delete** | Dialog | Compact, focused |
| **Select** (pick category) | Bottom sheet | Scrollable list |
| **Preview** | Bottom sheet | Quick look, not committed |
```
