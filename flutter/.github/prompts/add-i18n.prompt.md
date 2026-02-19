# Add Internationalization (i18n)

Add translation support to the project or translate existing content.

## Task

- **Action**: ${{input:Action: setup (initial config), add-locale (new language), translate (add strings)}}
- **Locale**: ${{input:Locale code (e.g., en, fr, es, ar) - leave empty for setup}}
- **Feature/Screen**: ${{input:Which feature or screen to translate? (e.g., auth, home, settings)}}

## Initial Setup (if not configured)

### 1. Enable l10n in pubspec.yaml

```yaml
flutter:
  generate: true
```

### 2. Create l10n.yaml

```yaml
arb-dir: lib/l10n/arb
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
output-dir: lib/l10n/generated
```

### 3. Create ARB directory structure

```
lib/l10n/
├── arb/
│   ├── app_en.arb    # English (template)
│   ├── app_fr.arb    # French
│   └── app_es.arb    # Spanish
└── generated/        # Auto-generated
```

### 4. Configure MaterialApp

```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  // ...
)
```

## ARB File Format

### English Template (app_en.arb)

```json
{
  "@@locale": "en",
  
  "appName": "MyApp",
  "@appName": {
    "description": "The application name"
  },
  
  "welcomeMessage": "Welcome, {name}!",
  "@welcomeMessage": {
    "description": "Welcome message with user name",
    "placeholders": {
      "name": {
        "type": "String",
        "example": "John"
      }
    }
  },
  
  "itemCount": "{count, plural, =0{No items} =1{1 item} other{{count} items}}",
  "@itemCount": {
    "description": "Item count with pluralization",
    "placeholders": {
      "count": {
        "type": "int"
      }
    }
  },
  
  "loginButton": "Log In",
  "logoutButton": "Log Out",
  "emailLabel": "Email",
  "passwordLabel": "Password",
  "forgotPassword": "Forgot password?",
  
  "errorGeneric": "Something went wrong. Please try again.",
  "errorNetwork": "No internet connection.",
  "errorInvalidEmail": "Please enter a valid email address.",
  "errorInvalidPassword": "Password must be at least 8 characters."
}
```

### French Translation (app_fr.arb)

```json
{
  "@@locale": "fr",
  
  "appName": "MonApp",
  "welcomeMessage": "Bienvenue, {name} !",
  "itemCount": "{count, plural, =0{Aucun élément} =1{1 élément} other{{count} éléments}}",
  
  "loginButton": "Se connecter",
  "logoutButton": "Se déconnecter",
  "emailLabel": "Email",
  "passwordLabel": "Mot de passe",
  "forgotPassword": "Mot de passe oublié ?",
  
  "errorGeneric": "Une erreur est survenue. Veuillez réessayer.",
  "errorNetwork": "Pas de connexion internet.",
  "errorInvalidEmail": "Veuillez entrer une adresse email valide.",
  "errorInvalidPassword": "Le mot de passe doit contenir au moins 8 caractères."
}
```

## Usage in Code

```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// In widgets
Text(AppLocalizations.of(context)!.loginButton)

// With parameters
Text(AppLocalizations.of(context)!.welcomeMessage('John'))

// With plurals
Text(AppLocalizations.of(context)!.itemCount(5))

// Extension for cleaner access
extension BuildContextL10n on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

// Then use:
Text(context.l10n.loginButton)
```

## String Categories

Organize strings by category with prefixes:

| Prefix | Category | Example |
|--------|----------|---------|
| `btn` | Buttons | `btnLogin`, `btnSubmit` |
| `lbl` | Labels | `lblEmail`, `lblPassword` |
| `msg` | Messages | `msgWelcome`, `msgSuccess` |
| `err` | Errors | `errNetwork`, `errInvalid` |
| `ttl` | Titles | `ttlHome`, `ttlSettings` |
| `hint` | Hints | `hintEmail`, `hintSearch` |

## Generate Translations

```bash
flutter gen-l10n
```

## Guidelines

- Always use ARB files for translations
- Include descriptions for translators
- Use placeholders for dynamic content
- Use plurals for countable items
- Use select for gender/enum variations
- Never concatenate translated strings
- Keep keys descriptive and consistent
