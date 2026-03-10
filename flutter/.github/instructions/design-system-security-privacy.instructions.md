```instructions
---
applyTo: "**/*_view.dart,**/*_viewmodel.dart,**/*_service.dart"
---
# Design System — Sécurité & Privacy UX (Phase 34)

> User data is sacred. Security must be VISIBLE and REASSURING.
> Biometric lock, data masking, and GDPR export are non-negotiable.
> No screenshot on sensitive screens. Privacy labels explain everything.

---

## Biometric Lock (34.1)

### Rules

| Rule | Value |
|------|-------|
| Trigger | Optional — user enables in Settings > Security |
| Supported | Face ID (iOS), Fingerprint (Android), Iris (Samsung) |
| Fallback | Device PIN/password if biometric fails |
| Re-auth | Required after `appLockTimeout` in background |
| UI | Full-screen lock overlay on top of app content |
| Package | `local_auth` |

### Lock Screen

```
┌──────────────────────────┐
│                          │
│        [App Logo]        │  ← Brand icon (appIcon token)
│                          │
│     🔒 App verrouillée   │  ← headingMedium
│                          │
│   Utilise ton empreinte  │  ← bodyMd, onSurfaceVariant
│   pour déverrouiller     │
│                          │
│        [👆]              │  ← Fingerprint icon / Face ID icon
│                          │
│   [Utiliser le code PIN] │  ← Ghost button fallback
└──────────────────────────┘
```

```dart
// ✅ CORRECT — biometric auth flow
class BiometricService {
  final _localAuth = LocalAuthentication();

  Future<bool> authenticate(BuildContext context) async {
    final isAvailable = await _localAuth.canCheckBiometrics;
    if (!isAvailable) return true; // skip if not supported

    return await _localAuth.authenticate(
      localizedReason: context.l10n.biometricReason,
      options: const AuthenticationOptions(
        biometricOnly: false, // allow PIN fallback
        stickyAuth: true,
      ),
    );
  }
}
```

---

## App Lock Timeout (34.2)

When the app goes to background and returns after a timeout, re-require authentication.

| Setting | Default | Options |
|---------|---------|---------|
| **Timeout** | 5 minutes | Immediately, 1 min, 5 min, 15 min, 30 min, Never |
| **Configurable** | Yes — Settings > Security > Verrouillage automatique |
| **Trigger** | `AppLifecycleState.paused` → start timer |
| **Lock** | `AppLifecycleState.resumed` → check if timeout exceeded |

```dart
// ✅ CORRECT — app lock lifecycle handling
class AppLockService with WidgetsBindingObserver {
  DateTime? _pausedAt;
  Duration _lockTimeout = const Duration(minutes: 5);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        _pausedAt = DateTime.now();
        _maskSensitiveContent(); // for task switcher
        break;
      case AppLifecycleState.resumed:
        if (_shouldLock()) {
          _showLockScreen();
        }
        _unmaskSensitiveContent();
        break;
      default:
        break;
    }
  }

  bool _shouldLock() {
    if (_pausedAt == null) return false;
    return DateTime.now().difference(_pausedAt!) > _lockTimeout;
  }
}
```

### Settings UI

```dart
// ✅ CORRECT — lock timeout setting
AppListTile(
  leading: Icon(LucideIcons.timer, semanticLabel: context.l10n.autoLock),
  title: context.l10n.autoLockSetting,
  subtitle: _formatTimeout(viewModel.lockTimeout),
  trailing: Icon(LucideIcons.chevronRight),
  onTap: () => _showTimeoutPicker(context),
)
```

---

## Task Switcher Data Masking (34.3)

When the app goes to the task switcher (recent apps), **mask sensitive content** so screenshots in the recents view don't expose private data.

### Strategy

| Approach | Platform | Implementation |
|----------|----------|----------------|
| **Blur overlay** | iOS + Android | Show branded blur screen when `paused` |
| **Branded splash** | iOS + Android | Show app logo on surface color |
| **FLAG_SECURE** | Android only | Prevents screenshots and recents capture |

```dart
// ✅ CORRECT — mask content in task switcher
void _maskSensitiveContent() {
  // Show a branded overlay
  _overlayEntry = OverlayEntry(
    builder: (_) => Container(
      color: Theme.of(_context).colorScheme.surface,
      child: Center(
        child: SvgPicture.asset(
          _brandSkin.appIcon,
          height: 64,
          semanticsLabel: _brandSkin.appName,
        ),
      ),
    ),
  );
  Overlay.of(_context).insert(_overlayEntry!);
}

void _unmaskSensitiveContent() {
  _overlayEntry?.remove();
  _overlayEntry = null;
}
```

### Which Screens to Mask

| Screen | Mask? | Reason |
|--------|-------|--------|
| **Finance/money screens** | ✅ Always | Amounts, balances |
| **Profile** | ✅ | Personal info |
| **Chat messages** | ✅ | Private conversations |
| **Settings** | ❌ | No sensitive data |
| **Onboarding** | ❌ | Public info |
| **Login** | ❌ | Just input fields |

---

## Screenshot Policy (34.4)

Block screenshots on sensitive screens using platform-specific flags.

```dart
// ✅ CORRECT — block screenshots on Android
import 'package:flutter/services.dart';

class ScreenshotPolicyService {
  /// Call when entering a sensitive screen
  void blockScreenshots() {
    // Android: FLAG_SECURE prevents screenshots + recents capture
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    // Platform channel to set FLAG_SECURE
    _channel.invokeMethod('setFlagSecure', true);
  }

  /// Call when leaving a sensitive screen
  void allowScreenshots() {
    _channel.invokeMethod('setFlagSecure', false);
  }
}
```

### Screens with Screenshot Blocking

| Screen | Block? |
|--------|--------|
| **Payment/finance details** | ✅ |
| **Password change** | ✅ |
| **2FA setup** | ✅ |
| **Private messages** | Optional (user setting) |
| **All other screens** | ❌ — allow screenshots |

---

## Privacy Labels (34.5)

Make data collection transparent. Show clear labels in Settings.

```dart
// ✅ CORRECT — Privacy section in Settings
AppSectionHeader(title: context.l10n.privacySection),

AppListTile(
  leading: Icon(LucideIcons.shield, semanticLabel: context.l10n.dataPrivacy),
  title: context.l10n.dataPrivacy,
  subtitle: context.l10n.dataEncryptedDescription,
  trailing: Icon(LucideIcons.chevronRight),
  onTap: viewModel.goToPrivacyDetails,
)

// Privacy details screen
Column(
  children: [
    _PrivacyItem(
      icon: LucideIcons.lock,
      title: context.l10n.encryptedInTransit,
      description: context.l10n.encryptedInTransitDescription,
    ),
    _PrivacyItem(
      icon: LucideIcons.database,
      title: context.l10n.dataStoredSecurely,
      description: context.l10n.dataStorageDescription,
    ),
    _PrivacyItem(
      icon: LucideIcons.eye,
      title: context.l10n.noDataSold,
      description: context.l10n.noDataSoldDescription,
    ),
    _PrivacyItem(
      icon: LucideIcons.trash2,
      title: context.l10n.deleteAnytime,
      description: context.l10n.deleteAnytimeDescription,
    ),
  ],
)
```

---

## Delete Account (34.6)

| Rule | Value |
|------|-------|
| Location | Settings > Compte > Supprimer mon compte |
| Process | 1. Tap → 2. Warning screen → 3. Type "SUPPRIMER" → 4. Confirm → 5. 30-day grace |
| Grace period | **30 days** — data recoverable if user logs back in |
| Export first | Offer "Exporter mes données" before deletion |
| Confirmation | Require typing "SUPPRIMER" (or localized equivalent) |
| Visual | Destructive red button, warning icon |
| Post-delete | Redirect to goodbye screen → clear local data → logout |

```dart
// ✅ CORRECT — delete account flow
AppButton(
  label: context.l10n.deleteAccount,
  variant: AppButtonVariant.destructive,
  leadingIcon: LucideIcons.trash2,
  onPressed: () async {
    // Step 1: Offer export first
    final wantsExport = await _showExportOfferDialog(context);
    if (wantsExport) await viewModel.exportData();

    // Step 2: Confirmation with typed input
    final confirmed = await _showDeleteConfirmation(context);
    if (!confirmed) return;

    // Step 3: Process deletion
    await viewModel.deleteAccount();
  },
)
```

---

## Data Export (34.7 — GDPR)

| Rule | Value |
|------|-------|
| Location | Settings > Données > Exporter mes données |
| Format | JSON (structured) + CSV (tabular) — user chooses |
| Scope | ALL user-generated content (profile, habits, notes, transactions) |
| Delivery | Generate file → download or email link |
| Timeline | Generated within 72 hours (GDPR compliance) |
| UI | Show progress, notify when ready |

---

## Consent Dialogs (34.8)

| Rule | Value |
|------|-------|
| Default | ALL toggles **OFF** by default (opt-in, never opt-out) |
| Analytics | "Partager des données anonymes pour améliorer l'app" |
| Crash reporting | "Envoyer les rapports d'erreur automatiquement" |
| Marketing | "Recevoir des offres et nouveautés par e-mail" |
| Revocable | User can change any consent in Settings > Privacy |
| Visual | Toggle switches with clear descriptions |

```dart
// ✅ CORRECT — consent toggles (all OFF by default)
class ConsentSettings {
  bool analyticsEnabled = false;   // OFF by default
  bool crashReportingEnabled = false; // OFF by default
  bool marketingEnabled = false;    // OFF by default
}
```

---

## Security Checklist

- [ ] Biometric lock available in Settings > Security
- [ ] App re-locks after configurable timeout (default: 5 min)
- [ ] Task switcher shows branded overlay, not app content
- [ ] Sensitive screens block screenshots (Android FLAG_SECURE)
- [ ] Privacy labels visible in Settings with clear language
- [ ] Delete account requires typed confirmation + 30-day grace
- [ ] Data export available (JSON + CSV) within 72h
- [ ] All consent toggles default to OFF (opt-in)
- [ ] Tokens stored in `flutter_secure_storage`
- [ ] No sensitive data logged to console in release mode
```
