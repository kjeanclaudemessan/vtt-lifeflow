```instructions
---
applyTo: "**/*_view.dart,**/*_viewmodel.dart,**/l10n/**,**/*.arb"
---
# Design System — Internationalisation & Localisation (Phase 27)

> ALL user-facing text comes from ARB files via `context.l10n`.
> No hardcoded strings — not even "OK", "Cancel", or "...".
> Support FR (primary) + EN + AR (RTL) from day one.
> Numbers, dates, and currencies are locale-aware.

---

## Supported Locales

| Priority | Locale | Direction | Status |
|----------|--------|-----------|--------|
| **Primary** | `fr` (Français) | LTR | Always present |
| **Secondary** | `en` (English) | LTR | Always present |
| **Tertiary** | `ar` (العربية) | RTL | Planned — layout must support |
| **Future** | Local languages (Wolof, Bambara, Lingala...) | LTR | Via community translation |

### Configuration

```dart
// ✅ CORRECT — in MaterialApp
MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  locale: settingsService.locale, // user-chosen or system default
  localeResolutionCallback: (locale, supportedLocales) {
    // Match exact locale first, then language, fallback to French
    for (final supported in supportedLocales) {
      if (supported.languageCode == locale?.languageCode) return supported;
    }
    return const Locale('fr'); // French is the fallback
  },
)
```

---

## ARB File Structure

### File naming

```
lib/l10n/
├── app_fr.arb          # French (primary, source of truth)
├── app_en.arb          # English
└── app_ar.arb          # Arabic (RTL)
```

### ARB Key Naming Convention

| Pattern | Format | Example |
|---------|--------|---------|
| **Screen title** | `{screen}Title` | `"loginTitle": "Connexion"` |
| **Button label** | `{action}Button` or `{action}Cta` | `"saveButton": "Enregistrer"` |
| **Error message** | `{field}Error{Type}` | `"emailErrorInvalid": "Adresse e-mail invalide"` |
| **Empty state** | `{screen}EmptyTitle` / `{screen}EmptyDescription` | `"habitsEmptyTitle": "Pas encore d'habitudes"` |
| **Confirmation** | `{action}Confirmation` | `"deleteConfirmation": "Supprimer définitivement ?"` |
| **Common** | Prefixed `common` | `"commonCancel": "Annuler"` |
| **Notification** | `notification{Type}Title` | `"notificationReminderTitle": "Rappel"` |

### Examples

```json
// app_fr.arb (source of truth)
{
  "@@locale": "fr",

  "commonCancel": "Annuler",
  "commonSave": "Enregistrer",
  "commonDelete": "Supprimer",
  "commonRetry": "Réessayer",
  "commonNext": "Suivant",
  "commonBack": "Retour",
  "commonDone": "Terminé",
  "commonSearch": "Rechercher",
  "commonLoading": "Chargement...",
  "commonOk": "OK",

  "loginTitle": "Connexion",
  "loginSubtitle": "Content de te revoir",
  "loginEmailLabel": "E-mail",
  "loginPasswordLabel": "Mot de passe",
  "loginButton": "Se connecter",
  "loginForgotPassword": "Mot de passe oublié ?",

  "itemCount": "{count, plural, =0{Aucun élément} =1{1 élément} other{{count} éléments}}",
  "@itemCount": {
    "placeholders": {
      "count": { "type": "int" }
    }
  },

  "lastSeen": "Vu {date}",
  "@lastSeen": {
    "placeholders": {
      "date": { "type": "DateTime", "format": "yMMMd" }
    }
  }
}
```

---

## Pluralisation (ICU Message Format)

Always use ICU plural syntax for countable nouns. Never concatenate strings.

```json
// ✅ CORRECT — ICU plural format
{
  "taskCount": "{count, plural, =0{Aucune tâche} =1{1 tâche} other{{count} tâches}}",
  "@taskCount": {
    "placeholders": {
      "count": { "type": "int" }
    }
  },

  "memberCount": "{count, plural, =0{Aucun membre} =1{1 membre} other{{count} membres}}",
  "@memberCount": {
    "placeholders": {
      "count": { "type": "int" }
    }
  },

  "daysRemaining": "{count, plural, =0{Dernier jour} =1{1 jour restant} other{{count} jours restants}}",
  "@daysRemaining": {
    "placeholders": {
      "count": { "type": "int" }
    }
  }
}
```

```dart
// ✅ CORRECT — usage in dart
Text(context.l10n.taskCount(viewModel.tasks.length))

// ❌ FORBIDDEN — manual plural
Text('${count} tâche${count > 1 ? 's' : ''}')

// ❌ FORBIDDEN — hardcoded string
Text('Aucune tâche')
```

---

## Number & Currency Formatting

All numbers and currencies must be locale-aware via `intl` package.

### Numbers

```dart
import 'package:intl/intl.dart';

// ✅ CORRECT — locale-aware number formatting
final formatter = NumberFormat.decimalPattern(context.locale.languageCode);
Text(formatter.format(1234567.89));
// FR → "1 234 567,89"
// EN → "1,234,567.89"
// AR → "١٬٢٣٤٬٥٦٧٫٨٩"

// ❌ FORBIDDEN — hardcoded format
Text('1,234,567.89')
```

### Currency

```dart
// ✅ CORRECT — locale + currency-aware
final currencyFormatter = NumberFormat.currency(
  locale: context.locale.languageCode,
  symbol: viewModel.currencySymbol, // "FCFA", "€", "$"
  decimalDigits: 0, // FCFA has no decimals
);
Text(currencyFormatter.format(25000));
// FR + FCFA → "25 000 FCFA"
// EN + USD  → "$25,000"

// ❌ FORBIDDEN — manual currency formatting
Text('${amount} FCFA')
```

### Currency Display Rules

| Currency | Symbol position | Decimals | Example |
|----------|----------------|----------|---------|
| **FCFA** (XOF) | After amount | 0 | `25 000 FCFA` |
| **EUR** (€) | After amount (FR), before (EN) | 2 | `25,00 €` / `€25.00` |
| **USD** ($) | Before amount | 2 | `$25.00` |

---

## Date & Time Formatting

Use `intl` DateFormat with locale. Never hardcode date patterns.

### Relative Time Rules

| Condition | Format | Example (FR) |
|-----------|--------|-------------|
| < 1 minute | "À l'instant" | À l'instant |
| < 60 minutes | "Il y a Xmin" | Il y a 5min |
| < 24 hours | "Il y a Xh" | Il y a 3h |
| < 7 days | Day name | Lundi |
| Same year | "d MMMM" | 10 mars |
| Different year | "d MMMM yyyy" | 10 mars 2025 |

### Implementation

```dart
// ✅ CORRECT — locale-aware relative time
String formatRelativeTime(DateTime dateTime, BuildContext context) {
  final now = DateTime.now();
  final diff = now.difference(dateTime);
  final locale = context.locale.languageCode;

  if (diff.inMinutes < 1) return context.l10n.justNow;
  if (diff.inMinutes < 60) return context.l10n.minutesAgo(diff.inMinutes);
  if (diff.inHours < 24) return context.l10n.hoursAgo(diff.inHours);
  if (diff.inDays < 7) return DateFormat.EEEE(locale).format(dateTime);
  if (dateTime.year == now.year) return DateFormat.MMMd(locale).format(dateTime);
  return DateFormat.yMMMd(locale).format(dateTime);
}

// ❌ FORBIDDEN — hardcoded French date
Text('Il y a ${diff.inHours}h')
```

---

## Text Overflow Strategy

Some languages are 30-50% longer than French (German, Finnish). All UI must handle overflow.

### Rules

| Widget | Strategy |
|--------|----------|
| **AppBar title** | `maxLines: 1`, `overflow: TextOverflow.ellipsis` |
| **Button label** | Max 25 chars, `overflow: ellipsis`, `maxLines: 1` |
| **List tile title** | `maxLines: 2`, `overflow: TextOverflow.ellipsis` |
| **Card title** | `maxLines: 2`, `overflow: TextOverflow.ellipsis` |
| **Description text** | `maxLines: 3`, `overflow: TextOverflow.ellipsis` |
| **Tabs** | Short labels (1-2 words), wrap supported |

```dart
// ✅ CORRECT — text overflow protected
Text(
  context.l10n.settingsTitle,
  style: AppTypography.headingSmall,
  maxLines: 1,
  overflow: TextOverflow.ellipsis,
)

// ❌ FORBIDDEN — no overflow protection
Text(context.l10n.settingsTitle) // will overflow in German
```

### Width-Flexible Layouts

```dart
// ✅ CORRECT — flexible row for variable-length labels
Row(
  children: [
    Expanded(child: Text(context.l10n.label, overflow: TextOverflow.ellipsis)),
    AppGaps.horizontalSm,
    Text(value),
  ],
)

// ❌ FORBIDDEN — fixed-width label (breaks for long translations)
Row(
  children: [
    SizedBox(width: 100, child: Text(context.l10n.label)),
    Text(value),
  ],
)
```

---

## Image Localisation

### Rules

- **NEVER** embed text in images (SVG, PNG, Lottie). Use overlays instead.
- **Cultural relevance**: illustrations may need locale variants (e.g., currency symbols, clothing, scripts).
- **Direction-aware icons**: some icons must flip in RTL (arrows, progress bars) — others must NOT (clocks, checkmarks).

```dart
// ✅ CORRECT — text overlay on illustration, not baked in
Stack(
  alignment: Alignment.bottomCenter,
  children: [
    SvgPicture.asset('assets/illustrations/welcome.svg'),
    Padding(
      padding: EdgeInsets.all(AppSpacing.staticMd),
      child: Text(
        context.l10n.welcomeMessage,
        style: AppTypography.headingMedium,
        textAlign: TextAlign.center,
      ),
    ),
  ],
)

// ❌ FORBIDDEN — text baked into the image
SvgPicture.asset('assets/illustrations/welcome_fr.svg') // un-localizable
```

### RTL Icon Rules

| Icon type | Flip in RTL? | Examples |
|-----------|-------------|----------|
| **Directional** | YES (auto via `Directionality`) | Arrows, chevrons, send, reply |
| **Non-directional** | NO | Clock, heart, star, checkmark, trash |
| **Text-embedded** | AVOID | Any icon with Latin text baked in |

---

## RTL (Right-to-Left) Support

### Automatic Support

Flutter handles most RTL automatically when using `Directionality`:
- `Row` → reverses children order
- `Padding` / `EdgeInsetsDirectional` → swaps start/end
- `Align` → swaps start/end

### Rules

```dart
// ✅ CORRECT — directional padding (RTL-safe)
padding: EdgeInsetsDirectional.only(start: AppSpacing.staticMd)

// ❌ FORBIDDEN — absolute left/right (breaks RTL)
padding: EdgeInsets.only(left: AppSpacing.staticMd)

// ✅ CORRECT — directional alignment
Align(alignment: AlignmentDirectional.centerStart, child: text)

// ❌ FORBIDDEN — absolute left/right (breaks RTL)
Align(alignment: Alignment.centerLeft, child: text)

// ✅ CORRECT — directional positioned
PositionedDirectional(start: 0, child: widget)

// ❌ FORBIDDEN
Positioned(left: 0, child: widget)
```

### Testing RTL

```dart
// Force RTL in dev for testing
Directionality(
  textDirection: TextDirection.rtl,
  child: MaterialApp(...),
)
```

---

## Translation Tooling

### Flutter gen-l10n (Primary)

```yaml
# l10n.yaml
arb-dir: lib/l10n
template-arb-file: app_fr.arb       # French = source of truth
output-localization-file: app_localizations.dart
output-class: AppLocalizations
nullable-getter: false               # never null — always present
```

### Workflow

1. **Developer** adds key to `app_fr.arb` (French source).
2. **Run** `flutter gen-l10n` to generate Dart code.
3. **Translator** adds translations to `app_en.arb`, `app_ar.arb`.
4. **CI** verifies all keys present in all ARB files.
5. **Missing key** → falls back to French automatically.

### Key Completeness Check

```dart
// In tests — verify all ARB files have the same keys
test('all ARB files have same keys', () {
  final frKeys = jsonDecode(File('lib/l10n/app_fr.arb').readAsStringSync())
      .keys.where((k) => !k.startsWith('@')).toSet();
  final enKeys = jsonDecode(File('lib/l10n/app_en.arb').readAsStringSync())
      .keys.where((k) => !k.startsWith('@')).toSet();

  expect(enKeys, equals(frKeys), reason: 'EN ARB missing keys: ${frKeys.difference(enKeys)}');
});
```

---

## Fallback Strategy

| Scenario | Behaviour |
|----------|-----------|
| **Missing key in target locale** | Fall back to French (`app_fr.arb`) |
| **Missing ARB file for locale** | Fall back to French |
| **User changes language** | Instant reload, no app restart |
| **System locale not supported** | French |
| **Plural form missing** | Use `other` form |

### Language Switcher (Settings)

```dart
// ✅ CORRECT — language setting with immediate effect
AppListTile(
  leading: Icon(LucideIcons.globe, semanticLabel: context.l10n.language),
  title: context.l10n.languageSetting,
  subtitle: _currentLanguageName(context),
  trailing: Icon(LucideIcons.chevronRight),
  onTap: () => _showLanguagePicker(context),
)

// Language picker bottom sheet
AppBottomSheet(
  title: context.l10n.chooseLanguage,
  children: [
    _LanguageTile(locale: Locale('fr'), label: 'Français', flag: '🇫🇷'),
    _LanguageTile(locale: Locale('en'), label: 'English', flag: '🇬🇧'),
    _LanguageTile(locale: Locale('ar'), label: 'العربية', flag: '🇸🇦'),
  ],
)
```

---

## i18n Audit Checklist

- [ ] Zero hardcoded strings in `*_view.dart` and `*_viewmodel.dart` files
- [ ] All ARB keys follow naming convention (`{screen}{Element}`)
- [ ] Plurals use ICU message format (never string concatenation)
- [ ] Numbers formatted via `NumberFormat` with locale
- [ ] Currencies formatted via `NumberFormat.currency` with locale
- [ ] Dates formatted via `DateFormat` with locale
- [ ] All `EdgeInsets` use `EdgeInsetsDirectional` (RTL-safe)
- [ ] No text baked into images or SVGs
- [ ] `maxLines` + `overflow` on all text widgets
- [ ] All ARB files have the same keys (no missing translations)
- [ ] French is the fallback locale in `localeResolutionCallback`
- [ ] `nullable-getter: false` in `l10n.yaml`
```
