```instructions
---
applyTo: "**/*.dart"
---
# Sizing Instructions

> These instructions apply to ALL Dart files.
> Ensures consistent sizing through tokens instead of magic numbers.

---

## Core Rule

**No magic numbers for sizes.** All icon sizes, avatar sizes, indicator sizes, and component dimensions MUST use `AppSizing` tokens or `flutter_screenutil` extensions.

---

## AppSizing Token Reference

Use these standard sizes defined in `app_sizing.dart`:

```dart
/// Standard icon sizes
class AppSizing {
  // Icons
  static const double iconXs = 12.0;
  static const double iconSm = 16.0;
  static const double iconMd = 20.0;
  static const double iconLg = 24.0;
  static const double iconXl = 32.0;
  static const double iconXxl = 48.0;

  // Avatars
  static const double avatarSm = 32.0;
  static const double avatarMd = 48.0;
  static const double avatarLg = 64.0;
  static const double avatarXl = 96.0;
  static const double avatarXxl = 128.0;

  // Touch targets (minimum 48dp per Material Design)
  static const double touchTarget = 48.0;
  static const double touchTargetSm = 44.0;

  // Indicators
  static const double indicatorSm = 8.0;
  static const double indicatorMd = 12.0;
  static const double indicatorLg = 16.0;

  // Progress
  static const double progressHeight = 4.0;
  static const double progressHeightLg = 8.0;
  static const double circularProgressSm = 32.0;
  static const double circularProgressMd = 48.0;
  static const double circularProgressLg = 64.0;

  // Misc
  static const double dividerThickness = 1.0;
  static const double badgeSize = 20.0;
  static const double chipHeight = 32.0;
  static const double fabSize = 56.0;
  static const double appBarHeight = 56.0;
  static const double bottomNavHeight = 64.0;
}
```

---

## Forbidden Patterns

### Magic Numbers for Icons

```dart
// ❌ FORBIDDEN
Icon(Icons.check, size: 20)
Icon(Icons.settings, size: 24)
Icon(Icons.close, size: 16)
Icon(Icons.person, size: 100)

// ✅ CORRECT
Icon(Icons.check, size: AppSizing.iconMd)
Icon(Icons.settings, size: AppSizing.iconLg)
Icon(Icons.close, size: AppSizing.iconSm)
Icon(Icons.person, size: AppSizing.avatarXl)
```

### Magic Numbers for Containers

```dart
// ❌ FORBIDDEN
SizedBox(width: 44, height: 44)
SizedBox(width: 48, height: 48)
Container(width: 100, height: 100)

// ✅ CORRECT
SizedBox.square(dimension: AppSizing.touchTargetSm)
SizedBox.square(dimension: AppSizing.touchTarget)
SizedBox.square(dimension: AppSizing.avatarXl)
```

### Magic Numbers for Progress

```dart
// ❌ FORBIDDEN
SizedBox(width: 32, height: 32, child: CircularProgressIndicator())
LinearProgressIndicator(minHeight: 8)

// ✅ CORRECT
SizedBox.square(
  dimension: AppSizing.circularProgressSm,
  child: CircularProgressIndicator(),
)
LinearProgressIndicator(minHeight: AppSizing.progressHeightLg)
```

---

## Responsive Sizing

For sizes that should scale with screen, use `flutter_screenutil`:

```dart
// ✅ CORRECT — responsive sizing
SizedBox(width: 44.w, height: 44.w)   // Scales with width
Icon(Icons.check, size: 20.sp)         // Scales with text

// ✅ ALSO CORRECT — fixed token sizes (for icons, touch targets)
Icon(Icons.check, size: AppSizing.iconMd)  // Fixed, consistent
```

**Rule of thumb:**
- Use `AppSizing` tokens for **standard components** (icons, avatars, touch targets)
- Use `.w` / `.h` / `.r` for **layout-specific dimensions** that should scale
- Use `.sp` for **text-related sizes** only

---

## When to Add New Tokens

If you need a size that doesn't fit existing tokens:

1. **Check if an existing token works** (prefer reuse)
2. **Add to `AppSizing`** with a semantic name
3. **Never hardcode** — even "just this once"

```dart
// Adding a new token:
class AppSizing {
  // ... existing tokens ...
  
  // Habit check area
  static const double habitCheckArea = 44.0;
  static const double habitCheckIcon = 18.0;
}
```
```
