```instructions
---
applyTo: "**/*_view.dart,**/*_dialog.dart,**/*_sheet.dart,**/widgets/**/*.dart"
---
# Strict i18n Instructions

> These instructions apply to all View, Dialog, BottomSheet, and Widget files.
> Ensures zero hardcoded user-facing strings.

---

## Core Rule

**ZERO hardcoded user-facing strings.** Every text displayed to the user MUST come from ARB translation files via `context.l10n`.

---

## Forbidden Patterns

### Hardcoded Strings

```dart
// ❌ FORBIDDEN — any language
Text('Login')
Text('Connexion')
Text('Faites')
Text('Profile Completion')
Text('Total')
Text('Export Data')
Text('Restantes')

// ✅ CORRECT
Text(context.l10n.login)
Text(context.l10n.profileCompletion)
Text(context.l10n.total)
Text(context.l10n.exportData)
```

### Emoji-Prefixed Labels

```dart
// ❌ FORBIDDEN — emojis are not translatable and render differently cross-platform
Text('✅ Faites')
Text('⏳ Restantes')
Text('📊 Aujourd\'hui')
Text('🔥 Streak')

// ✅ CORRECT — use Icon + l10n text separately
Row(
  children: [
    Icon(Icons.check_circle, color: AppColors.success, semanticLabel: ''),
    AppGaps.w8,
    Text(context.l10n.completed),
  ],
)
```

### Interpolated Strings

```dart
// ❌ FORBIDDEN
Text('${count} habitudes complétées')
Text('Bonjour $name')

// ✅ CORRECT — use ARB placeholders
// In app_en.arb: "habitsCompleted": "{count} habits completed"
// In app_fr.arb: "habitsCompleted": "{count} habitudes complétées"
Text(context.l10n.habitsCompleted(count))
Text(context.l10n.greeting(name))
```

### Plural Strings

```dart
// ❌ FORBIDDEN
Text(count == 1 ? '1 habit' : '$count habits')

// ✅ CORRECT — use ARB plural
// In app_en.arb:
// "habitCount": "{count, plural, =0{No habits} =1{1 habit} other{{count} habits}}"
Text(context.l10n.habitCount(count))
```

---

## Allowed Exceptions

### Technical / Non-User-Facing Strings

```dart
// ✅ OK — log messages
Logger.info('User logged in: $userId');

// ✅ OK — API constants
static const baseUrl = 'https://api.example.com';

// ✅ OK — keys, identifiers
static const loginBusyKey = 'login';

// ✅ OK — format patterns
DateFormat('HH:mm').format(dateTime);  // But prefer l10n date formats
```

### Design Showcase View

```dart
// ✅ OK — design_showcase_view.dart uses placeholder text for display
Text('Sample Button Label')
Text('Example Card Title')
```

---

## ARB Conventions

### Key Naming

```json
// Use camelCase, descriptive, grouped by feature
{
  // Auth
  "loginTitle": "Sign in to your account",
  "loginEmailLabel": "Email address",
  "loginPasswordLabel": "Password",
  "loginButton": "Sign In",
  "loginForgotPassword": "Forgot password?",

  // Habits
  "habitsTitle": "My Habits",
  "habitsEmpty": "No habits yet. Create your first one!",
  "habitsCompleted": "Completed",
  "habitsRemaining": "Remaining",
  "habitsToday": "Today",

  // Common
  "commonSave": "Save",
  "commonCancel": "Cancel",
  "commonDelete": "Delete",
  "commonRetry": "Retry"
}
```

### Description Annotations

```json
{
  "habitsCompleted": "Completed",
  "@habitsCompleted": {
    "description": "Label for completed habits count in today view"
  },
  "habitCount": "{count, plural, =0{No habits} =1{1 habit} other{{count} habits}}",
  "@habitCount": {
    "description": "Plural form for habit count",
    "placeholders": {
      "count": {
        "type": "int"
      }
    }
  }
}
```

---

## Quick Check

Before committing, grep for violations:

```bash
# Find potential hardcoded strings in views
grep -rn "Text('[^']*[a-zA-ZÀ-ÿ]" lib/features/ lib/modules/ lib/ui/
grep -rn 'Text("[^"]*[a-zA-ZÀ-ÿ]' lib/features/ lib/modules/ lib/ui/
```

Any match that isn't `context.l10n.*` is a violation (excluding design_showcase).
```
