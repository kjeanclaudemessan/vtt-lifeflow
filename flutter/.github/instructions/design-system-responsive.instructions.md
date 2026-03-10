```instructions
---
applyTo: "**/*_view.dart,**/widgets/**/*.dart,**/*_layout.dart"
---
# Design System — Responsive & Multi-Device (Phase 26)

> Every screen MUST adapt to phone, tablet, and desktop.
> Use breakpoints + adaptive layout — NEVER fixed widths.
> Navigation morphs: BottomNav → NavigationRail → Sidebar.
> Touch targets scale with device density.

---

## Breakpoints

| Class | Width | Device | Columns | Gutter |
|-------|-------|--------|---------|--------|
| **Compact** | < 600dp | Phone | 4 | 16dp |
| **Medium** | 600–1023dp | Tablet, small desktop | 8 | 24dp |
| **Expanded** | ≥ 1024dp | Desktop, large tablet | 12 | 24dp |

### Breakpoint Utilities

```dart
// ✅ CORRECT — use ScreenUtil + MediaQuery breakpoints
extension ResponsiveExtension on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  bool get isCompact => screenWidth < 600;
  bool get isMedium => screenWidth >= 600 && screenWidth < 1024;
  bool get isExpanded => screenWidth >= 1024;

  /// Returns value based on current breakpoint
  T responsive<T>({
    required T compact,
    T? medium,
    T? expanded,
  }) {
    if (isExpanded) return expanded ?? medium ?? compact;
    if (isMedium) return medium ?? compact;
    return compact;
  }
}
```

```dart
// ✅ CORRECT — responsive value usage
padding: EdgeInsets.symmetric(
  horizontal: context.responsive(
    compact: AppSpacing.staticLg,   // 16dp
    medium: AppSpacing.staticXl,    // 24dp
    expanded: AppSpacing.staticXxl, // 32dp
  ),
),

// ❌ FORBIDDEN — fixed values ignoring device size
padding: EdgeInsets.symmetric(horizontal: 16),
```

---

## Adaptive Layout

### Single → Multi-Column Transition

```
Phone (Compact)         Tablet (Medium)           Desktop (Expanded)
┌──────────┐           ┌────────┬────────┐       ┌──────┬──────┬──────┐
│  List     │           │  List  │ Detail │       │ Nav  │ List │Detail│
│  (full)   │           │  (1/3) │ (2/3)  │       │(rail)│(1/3) │(2/3) │
│           │           │        │        │       │      │      │      │
│           │           │        │        │       │      │      │      │
└──────────┘           └────────┴────────┘       └──────┴──────┴──────┘
```

### Implementation

```dart
/// ✅ CORRECT — adaptive layout widget
class AppAdaptiveLayout extends StatelessWidget {
  final Widget compactBody;
  final Widget? mediumBody;
  final Widget? expandedBody;

  const AppAdaptiveLayout({
    required this.compactBody,
    this.mediumBody,
    this.expandedBody,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1024) {
          return expandedBody ?? mediumBody ?? compactBody;
        }
        if (constraints.maxWidth >= 600) {
          return mediumBody ?? compactBody;
        }
        return compactBody;
      },
    );
  }
}
```

---

## Adaptive Navigation

| Breakpoint | Navigation | Widget |
|------------|-----------|--------|
| **Compact** | Bottom Navigation Bar | `AppBottomNav` (max 5 items) |
| **Medium** | Navigation Rail (left) | `NavigationRail` (icons + optional labels) |
| **Expanded** | Sidebar (left, full) | `NavigationDrawer` (persistent, icons + labels) |

### Implementation

```dart
/// ✅ CORRECT — navigation morphs with breakpoint
class AppAdaptiveScaffold extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<AppNavDestination> destinations;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    // COMPACT — bottom nav
    if (context.isCompact) {
      return Scaffold(
        body: body,
        bottomNavigationBar: AppBottomNav(
          currentIndex: selectedIndex,
          onTap: onDestinationSelected,
          items: destinations.map((d) => d.toBottomNavItem()).toList(),
        ),
      );
    }

    // MEDIUM — navigation rail
    if (context.isMedium) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: selectedIndex,
              onDestinationSelected: onDestinationSelected,
              labelType: NavigationRailLabelType.selected,
              destinations: destinations
                  .map((d) => d.toRailDestination())
                  .toList(),
            ),
            const VerticalDivider(width: 1),
            Expanded(child: body),
          ],
        ),
      );
    }

    // EXPANDED — persistent sidebar
    return Scaffold(
      body: Row(
        children: [
          NavigationDrawer(
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            children: destinations
                .map((d) => d.toDrawerDestination())
                .toList(),
          ),
          Expanded(child: body),
        ],
      ),
    );
  }
}
```

```dart
// ❌ FORBIDDEN — hardcoded BottomNavigationBar on all devices
Scaffold(
  bottomNavigationBar: BottomNavigationBar(...), // breaks on tablet/desktop
)
```

---

## Master-Detail Pattern

On compact: list pushes to detail screen.
On medium/expanded: list on left, detail on right, side by side.

```dart
/// ✅ CORRECT — adaptive master-detail
class AppMasterDetail<T> extends StatelessWidget {
  final Widget listView;
  final Widget Function(T item) detailBuilder;
  final T? selectedItem;

  @override
  Widget build(BuildContext context) {
    if (context.isCompact) {
      // Phone: full-screen list, push to detail on tap
      return listView;
    }

    // Tablet/Desktop: side-by-side
    return Row(
      children: [
        SizedBox(
          width: context.responsive(
            compact: double.infinity,
            medium: 320,
            expanded: 400,
          ),
          child: listView,
        ),
        const VerticalDivider(width: 1),
        Expanded(
          child: selectedItem != null
              ? detailBuilder(selectedItem as T)
              : Center(
                  child: AppEmptyState(
                    illustration: AppIllustrations.selectItem,
                    title: context.l10n.selectAnItem,
                  ),
                ),
        ),
      ],
    );
  }
}
```

---

## Touch Targets & Density

| Breakpoint | Min touch target | Content density |
|------------|-----------------|-----------------|
| **Compact** | 48dp × 48dp | Comfortable — generous spacing |
| **Medium** | 44dp × 44dp | Standard — slightly reduced gaps |
| **Expanded** | 36dp × 36dp (mouse) | Dense — hover states, smaller targets |

### Implementation

```dart
// ✅ CORRECT — adaptive sizing
SizedBox(
  height: context.responsive(
    compact: 48.0,
    medium: 44.0,
    expanded: 36.0,
  ),
  child: button,
)

// ✅ CORRECT — adaptive list tile density
AppListTile(
  visualDensity: context.responsive(
    compact: VisualDensity.comfortable,
    medium: VisualDensity.standard,
    expanded: VisualDensity.compact,
  ),
  ...
)
```

---

## Orientation

| Device | Portrait | Landscape |
|--------|----------|-----------|
| **Phone** | Primary orientation — always supported | Optional — supported if content benefits (video, charts) |
| **Tablet** | Supported | Supported — layout reflows (may trigger Medium → Expanded) |
| **Desktop** | N/A | Always landscape |

### Rules

- Phone apps default to **portrait only** unless the feature explicitly needs landscape (e.g., video player, chart fullscreen).
- **Lock orientation** in `main.dart`:

```dart
// ✅ CORRECT — lock portrait on phone, free on tablet
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isTablet = MediaQueryData.fromView(
    WidgetsBinding.instance.platformDispatcher.views.first,
  ).size.shortestSide >= 600;

  if (!isTablet) {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
  runApp(const App());
}
```

---

## Foldable Devices

- Use `MediaQuery.displayFeatures` to detect hinge/fold.
- Avoid placing interactive content across the fold/hinge area.
- On foldable in open state, treat as medium breakpoint (two-pane layout).

```dart
// ✅ CORRECT — respect foldable hinge
final displayFeatures = MediaQuery.displayFeaturesOf(context);
final hasHinge = displayFeatures.any(
  (f) => f.type == DisplayFeatureType.hinge,
);

if (hasHinge) {
  // Use TwoPane layout, avoiding the hinge area
  return TwoPaneLayout(
    startPane: listView,
    endPane: detailView,
    paneProportion: 0.5,
  );
}
```

---

## Web Support (Flutter Web)

When deploying to Flutter Web, these additional rules apply:

| Concern | Rule |
|---------|------|
| **Hover states** | All interactive elements show cursor pointer + hover highlight |
| **Right-click** | Context menus via `ContextMenuRegion` where relevant |
| **Keyboard shortcuts** | Ctrl+S (save), Escape (close), Tab (focus navigation) |
| **Scroll** | Mouse wheel smooth scroll, scroll bars visible |
| **Selection** | Text is selectable by default (`SelectionArea`) |
| **URL routing** | Deep link URLs for all screens |
| **Loading** | Show branded splash during WASM/JS engine load |

### Hover States

```dart
// ✅ CORRECT — hover state for web/desktop
MouseRegion(
  cursor: SystemMouseCursors.click,
  child: AnimatedContainer(
    duration: AppAnimations.fast,
    decoration: BoxDecoration(
      color: isHovered
          ? context.colorScheme.primary.withOpacity(0.08)
          : Colors.transparent,
      borderRadius: AppRadius.md,
    ),
    child: content,
  ),
)
```

---

## Keyboard Shortcuts (Tablet + Desktop)

| Shortcut | Action | Context |
|----------|--------|---------|
| `Ctrl/Cmd + S` | Save form | Edit screens |
| `Escape` | Close modal/dialog | Overlays |
| `Tab` | Next field | Forms |
| `Shift + Tab` | Previous field | Forms |
| `Enter` | Submit / confirm | Dialogs, search |
| `Ctrl/Cmd + F` | Open search | List screens |
| `Ctrl/Cmd + N` | New item | List screens |
| `Delete/Backspace` | Delete selected | Selection mode |

### Implementation

```dart
// ✅ CORRECT — keyboard shortcuts with CallbackShortcuts
CallbackShortcuts(
  bindings: {
    const SingleActivator(LogicalKeyboardKey.keyS, control: true):
        viewModel.save,
    const SingleActivator(LogicalKeyboardKey.escape):
        () => Navigator.of(context).pop(),
    const SingleActivator(LogicalKeyboardKey.keyF, control: true):
        viewModel.toggleSearch,
    const SingleActivator(LogicalKeyboardKey.keyN, control: true):
        viewModel.createNew,
  },
  child: Focus(
    autofocus: true,
    child: scaffold,
  ),
)
```

---

## Responsive Grid

For content-heavy layouts (dashboard, gallery), use a responsive grid:

```dart
/// ✅ CORRECT — responsive grid with adaptive cross-axis count
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: context.responsive(
      compact: 2,
      medium: 3,
      expanded: 4,
    ),
    mainAxisSpacing: AppSpacing.staticMd,
    crossAxisSpacing: AppSpacing.staticMd,
    childAspectRatio: context.responsive(
      compact: 1.0,
      medium: 1.1,
      expanded: 1.2,
    ),
  ),
  itemCount: items.length,
  itemBuilder: (context, index) => itemCard(items[index]),
)
```

---

## Max Content Width

On expanded breakpoints, avoid stretching content to full width. Constrain max width:

```dart
// ✅ CORRECT — constrain content on wide screens
Center(
  child: ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 720),
    child: content,
  ),
)

// ❌ FORBIDDEN — unconstrained content stretching full width on desktop
SizedBox(width: double.infinity, child: content)
```

| Content type | Max width |
|-------------|-----------|
| **Forms** | 480dp |
| **Content (articles, detail)** | 720dp |
| **Dashboard** | 1200dp |
| **Full-bleed (tables, data grids)** | No limit |

---

## Testing Checklist

- [ ] Test on 360dp width (small phone — Galaxy S8)
- [ ] Test on 414dp width (standard phone — iPhone 15)
- [ ] Test on 768dp width (tablet portrait — iPad)
- [ ] Test on 1024dp width (tablet landscape / small desktop)
- [ ] Test on 1440dp width (desktop)
- [ ] Test orientation change on tablet
- [ ] Verify touch targets ≥ 48dp on compact
- [ ] Verify navigation morphs at each breakpoint
- [ ] Verify master-detail on medium/expanded
- [ ] Test with keyboard on desktop (Tab, Enter, Escape, shortcuts)
- [ ] Test foldable hinge avoidance (if applicable)
```
