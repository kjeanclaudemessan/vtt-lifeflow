```instructions
---
applyTo: "**/*_view.dart,**/*_viewmodel.dart"
---
# Design System — Reusable UX Patterns

> 10 standardized UX patterns shared across all 200+ VTT apps.
> Every app uses some or all of these patterns.
> They MUST be implemented identically everywhere — no reinventing.
> All patterns use design tokens exclusively and follow the State Machine (Error → Loading → Empty → Content).

---

## Pattern 1: Auth Flow

### Screen Sequence

```
Splash → Login → Register → Forgot Password → OTP Verification → Onboarding → Home
                                                                        ↓
                                                              (return user skips)
```

### Login Screen

```dart
// Layout: centered, single column
Scaffold(
  backgroundColor: context.colorScheme.surface,
  body: SafeArea(
    child: SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.staticLg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppGaps.verticalXxl,
          // 1. App logo (SVG, branded primary color)
          SvgPicture.asset(brandSkin.appIcon, height: 64),
          AppGaps.verticalLg,
          // 2. Welcome title
          Text(context.l10n.welcomeBack, style: AppTypography.headingLarge),
          AppGaps.verticalXs,
          Text(context.l10n.loginSubtitle, style: AppTypography.bodyMd,
               textAlign: TextAlign.center),
          AppGaps.verticalXxl,
          // 3. Email field
          AppTextField(
            label: context.l10n.email,
            prefixIcon: LucideIcons.mail,
            keyboardType: TextInputType.emailAddress,
            errorText: viewModel.emailError,
            onChanged: viewModel.setEmail,
          ),
          AppGaps.verticalMd,
          // 4. Password field
          AppTextField(
            label: context.l10n.password,
            prefixIcon: LucideIcons.lock,
            variant: AppTextFieldVariant.password,
            errorText: viewModel.passwordError,
            onChanged: viewModel.setPassword,
          ),
          AppGaps.verticalSm,
          // 5. Forgot password (right-aligned, Ghost button)
          Align(
            alignment: Alignment.centerRight,
            child: AppButton(
              label: context.l10n.forgotPassword,
              variant: AppButtonVariant.ghost,
              onPressed: viewModel.goToForgotPassword,
            ),
          ),
          AppGaps.verticalLg,
          // 6. Login CTA (full width)
          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: context.l10n.login,
              variant: AppButtonVariant.primary,
              isLoading: viewModel.busy(loginBusyKey),
              onPressed: viewModel.canSubmit ? viewModel.login : null,
            ),
          ),
          AppGaps.verticalMd,
          // 7. Social login (optional)
          AppButton(
            label: context.l10n.continueWithGoogle,
            variant: AppButtonVariant.secondary,
            prefixIcon: LucideIcons.chrome,
            onPressed: viewModel.loginWithGoogle,
          ),
          AppGaps.verticalXxl,
          // 8. Register prompt
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(context.l10n.noAccount, style: AppTypography.bodyMd),
              AppButton(
                label: context.l10n.register,
                variant: AppButtonVariant.ghost,
                onPressed: viewModel.goToRegister,
              ),
            ],
          ),
        ],
      ),
    ),
  ),
)
```

### Rules

- **Validation**: on submit first, then inline per field after first error.
- **Password**: min 8 chars, visibility toggle, strength indicator optional.
- **Social login**: Google minimum. Apple on iOS. Never Facebook alone.
- **Transition from splash**: cross-fade (`CustomRoute` with `fadeIn`).
- **Post-login transition**: `clearStackAndShow(Routes.homeView)` — replace transition.
- **Error handling**: human message in snackbar ("Email ou mot de passe incorrect"), not "401 Unauthorized".
- **Haptic**: `mediumImpact` on successful login, `heavyImpact` on error.
- **Biometric**: if `biometric` module enabled, show fingerprint/face icon on login screen after first traditional login.

---

## Pattern 2: Onboarding

### Structure

```
Page 1 (Value prop) → Page 2 (Key feature) → Page 3 (CTA) → Home
      ●○○                    ○●○                   ○○●
```

### Rules

| Rule | Value |
|------|-------|
| Max pages | 3 (never more) |
| Navigation | Horizontal swipe (PageView) |
| Progress | Dot indicators (`AppProgress.dots`) |
| Skip | "Passer" button top-right (Ghost) |
| Last page CTA | Primary button ("Commencer", "C'est parti !") |
| Illustrations | Full-width, flat 2D, branded primary color |
| Title | `AppTypography.headingLarge`, centered |
| Description | `AppTypography.bodyLg`, centered, max 2 lines |
| Background | `context.colorScheme.surface` |
| Transition | Fade between pages, 300ms |

### Layout per Page

```dart
Column(
  children: [
    Spacer(flex: 1),
    // Illustration (SVG or Lottie), 40% of screen height
    SvgPicture.asset(illustration, height: screenHeight * 0.4),
    Spacer(flex: 1),
    // Title
    Text(title, style: AppTypography.headingLarge, textAlign: TextAlign.center),
    AppGaps.verticalMd,
    // Description
    Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.staticXl),
      child: Text(description, style: AppTypography.bodyLg,
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyLg.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  )),
    ),
    Spacer(flex: 2),
  ],
)
```

### Persistence

- **Shown once**: Set `SharedPreferences` flag `onboarding_completed = true`.
- **Never again**: Return users go directly to login or home.
- **Reset**: available in dev/debug settings only.

---

## Pattern 3: Settings Screen

### Structure

```
┌──────────────────────────┐
│  Profile Header          │  ← Avatar + Name + Email + Edit CTA
├──────────────────────────┤
│  Section: Préférences    │
│  ├─ Thème (Dark/Light)   │  ← AppListTile with trailing toggle/chevron
│  ├─ Langue               │
│  ├─ Notifications        │
│  └─ Haptiques & sons     │
├──────────────────────────┤
│  Section: Compte         │
│  ├─ Données & export     │
│  ├─ Abonnement           │
│  └─ Supprimer le compte  │  ← Destructive color
├──────────────────────────┤
│  Section: À propos       │
│  ├─ Version              │  ← Trailing: "1.2.3 (42)"
│  ├─ Mentions légales     │
│  └─ Nous contacter       │
├──────────────────────────┤
│  Made with ❤️ by VTT     │  ← Footer, subtle
└──────────────────────────┘
```

### Rules

- **Background**: `context.colorScheme.surfaceContainerHighest` (grouped style).
- **Sections**: white/dark card per section (`context.colorScheme.surface`).
- **Section headers**: `AppTypography.labelLarge`, `onSurfaceVariant` color, all-caps, `AppSpacing.staticMd` padding.
- **Items**: `AppListTile` with `leading` icon, `title`, optional `subtitle`, `trailing` (chevron, toggle, text).
- **Chevron**: `LucideIcons.chevronRight` for navigation items, `AppSizing.iconMd` (20dp).
- **Toggles**: `AppToggle.switch` for on/off settings.
- **Destructive items**: `AppColors.error` for text + icon color (e.g., "Supprimer le compte").
- **Profile header**: `AppAvatar` (64dp) + name + email + "Modifier" ghost button.
- **Scroll**: `SingleChildScrollView`, NOT a list. Settings are finite.
- **No search bar** in settings (too few items).

### Theme Selection

```dart
// Modal bottom sheet with 3 options
AppBottomSheet(
  title: context.l10n.theme,
  children: [
    AppListTile(
      leading: Icon(LucideIcons.sun, semanticLabel: context.l10n.lightMode),
      title: context.l10n.lightMode,
      trailing: isLight ? Icon(LucideIcons.check, color: context.colorScheme.primary) : null,
      onTap: () => viewModel.setTheme(ThemeMode.light),
    ),
    AppListTile(
      leading: Icon(LucideIcons.moon, semanticLabel: context.l10n.darkMode),
      title: context.l10n.darkMode,
      trailing: isDark ? Icon(LucideIcons.check, color: context.colorScheme.primary) : null,
      onTap: () => viewModel.setTheme(ThemeMode.dark),
    ),
    AppListTile(
      leading: Icon(LucideIcons.smartphone, semanticLabel: context.l10n.systemMode),
      title: context.l10n.systemMode,
      trailing: isSystem ? Icon(LucideIcons.check, color: context.colorScheme.primary) : null,
      onTap: () => viewModel.setTheme(ThemeMode.system),
    ),
  ],
)
```

---

## Pattern 4: Search

### Structure

```
┌──────────────────────────┐
│  🔍 [Search field]    ✕  │  ← Autofocus on open, clear button
├──────────────────────────┤
│  Recent searches         │  ← Before typing (if any)
│  ├─ 🕒 "meditation"  ✕  │
│  └─ 🕒 "morning"     ✕  │
├──────────────────────────┤  ← After typing (results)
│  Résultats (3)           │
│  ├─ AppListTile item 1   │
│  ├─ AppListTile item 2   │
│  └─ AppListTile item 3   │
├──────────────────────────┤
│  OR: Empty state         │  ← No results
│  "Aucun résultat pour X" │
└──────────────────────────┘
```

### Rules

| Rule | Value |
|------|-------|
| Open transition | Slide from top or full-screen push |
| Search field | `AppTextField.search` with `LucideIcons.search` prefix |
| Debounce | 300ms after last keystroke before searching |
| Min query length | 2 characters to trigger search |
| Recent searches | Max 5, stored locally (`SharedPreferences`) |
| Clear recent | Individual `✕` on each + "Tout effacer" link |
| Results | `AppListTile` with highlighted matching text |
| No results | `AppEmptyState.compact(title: l10n.noResults, description: l10n.tryDifferentSearch)` |
| Loading | Skeleton list (3 items) during search |
| Haptic | `selectionClick` on selecting a result |

### Search Highlighting

```dart
// Highlight matching text in search results
RichText(
  text: TextSpan(
    children: highlightOccurrences(
      source: item.title,
      query: viewModel.searchQuery,
      normalStyle: AppTypography.bodyMd.copyWith(color: context.colorScheme.onSurface),
      highlightStyle: AppTypography.bodyMd.copyWith(
        color: context.colorScheme.primary,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
)
```

---

## Pattern 5: List → Detail

### Navigation Flow

```
List Screen              Detail Screen
┌──────────────┐         ┌──────────────┐
│  AppBar      │         │  ← Back   ⋮  │  ← Overflow menu (edit, delete, share)
├──────────────┤  tap →  ├──────────────┤
│  Item 1      │────────→│  Hero image  │  ← Optional hero transition
│  Item 2      │         │  Title       │
│  Item 3      │         │  Metadata    │
│  ...         │         │  Content     │
│              │         │              │
│              │         │  [CTA]       │  ← Primary action at bottom
└──────────────┘         └──────────────┘
```

### Rules

| Rule | Value |
|------|-------|
| List → Detail transition | Slide from right (default Stacked push) |
| Back button | `LucideIcons.arrowLeft` (push screen), NOT `X` |
| Detail AppBar | Max 2 actions (share + overflow menu) |
| Overflow menu | Edit, Delete, Share — via `PopupMenuButton` |
| Delete action | Destructive confirmation dialog + 5s undo snackbar |
| Loading detail | Skeleton matching detail layout |
| Error detail | `AppEmptyState.error` with retry |

### Detail Screen Layout

```dart
Scaffold(
  body: CustomScrollView(
    slivers: [
      // 1. Collapsing header (optional, for image-heavy content)
      SliverAppBar(
        expandedHeight: 200,
        pinned: true,
        leading: BackButton(semanticLabel: context.l10n.back),
        actions: [
          IconButton(
            icon: Icon(LucideIcons.share2, semanticLabel: context.l10n.share),
            onPressed: viewModel.share,
          ),
          PopupMenuButton<DetailAction>(
            icon: Icon(LucideIcons.moreVertical, semanticLabel: context.l10n.moreActions),
            itemBuilder: (context) => [
              PopupMenuItem(value: DetailAction.edit, child: Text(context.l10n.edit)),
              PopupMenuItem(value: DetailAction.delete,
                child: Text(context.l10n.delete,
                  style: TextStyle(color: AppColors.error))),
            ],
            onSelected: viewModel.onActionSelected,
          ),
        ],
        flexibleSpace: FlexibleSpaceBar(
          background: heroImage,
        ),
      ),
      // 2. Content body
      SliverPadding(
        padding: EdgeInsets.all(AppSpacing.staticLg),
        sliver: SliverList(
          delegate: SliverChildListDelegate([
            Text(item.title, style: AppTypography.headingLarge),
            AppGaps.verticalSm,
            Text(item.subtitle, style: AppTypography.bodyMd.copyWith(
              color: context.colorScheme.onSurfaceVariant)),
            AppGaps.verticalLg,
            // Content sections...
          ]),
        ),
      ),
    ],
  ),
)
```

### List Item Standard Layout

```dart
AppListTile(
  leading: AppAvatar(imageUrl: item.imageUrl, size: AppSizing.avatarMd),
  title: item.title,
  subtitle: item.formattedDate,
  trailing: Icon(LucideIcons.chevronRight, size: AppSizing.iconMd,
                 semanticLabel: context.l10n.viewDetails),
  onTap: () => viewModel.goToDetail(item.id),
)
```

---

## Pattern 6: Form Patterns

### Single-Step Form

```
┌──────────────────────────┐
│  ← Annuler    Titre  ✓  │  ← Cancel (ghost) + title + checkmark/save
├──────────────────────────┤
│  Field 1                 │
│  Field 2                 │
│  Field 3                 │
│  ...                     │
│                          │
│  [Sauvegarder]           │  ← Full-width primary CTA at bottom
└──────────────────────────┘
```

### Multi-Step Form

```
Step 1/3         Step 2/3         Step 3/3
┌──────────┐     ┌──────────┐     ┌──────────┐
│ ← Cancel │     │ ← Back   │     │ ← Back   │
│ ━━━○○○   │ →   │ ━━━━━○○  │ →   │ ━━━━━━━━ │
│ Fields   │     │ Fields   │     │ Summary  │
│          │     │          │     │          │
│ [Suivant]│     │ [Suivant]│     │ [Valider]│
└──────────┘     └──────────┘     └──────────┘
```

### Rules

| Rule | Value |
|------|-------|
| Open transition | Full-screen push (modal bottom slide) |
| CTA position | Bottom of screen (above keyboard when visible) |
| Validation timing | On submit first → then inline per field after first error |
| Required fields | Asterisk `*` after label text |
| Error display | Inline below field, red text (`AppColors.error`) |
| Save draft | Auto-save after 3 seconds of inactivity (if applicable) |
| Discard confirmation | If form has changes: "Abandonner les modifications ?" dialog |
| Keyboard | `TextInputAction.next` to traverse fields, `TextInputAction.done` on last field |
| Scroll | `SingleChildScrollView` with `keyboardDismissBehavior: onDrag` |
| Multi-step progress | `LinearProgressIndicator` at top, `step / totalSteps` fraction |

### Form Discard Confirmation

```dart
// In ViewModel
Future<bool> onWillPop() async {
  if (!_hasChanges) return true;
  final confirmed = await _dialogHelper.showConfirmation(
    title: context.l10n.discardChanges,
    message: context.l10n.discardChangesMessage,
    confirmLabel: context.l10n.discard,
    cancelLabel: context.l10n.keepEditing,
  );
  return confirmed;
}
```

### Field Ordering Convention

1. **Most important first** (name, title, main content).
2. **Related fields grouped** (address: street, city, zip).
3. **Optional fields last** (notes, tags, attachments).
4. **Toggles/checkboxes at the end** (visibility, notifications).

---

## Pattern 7: Error Handling (Full Strategy)

### Error Hierarchy

| Context | Type | UI Pattern |
|---------|------|------------|
| **Page load fails** | Blocking | `AppEmptyState.error` + retry button (full screen) |
| **Action fails** | Non-blocking | `AppSnackbar.error` + retry action (3s auto-dismiss) |
| **Field validation** | Inline | Red border + error text below field |
| **Network offline** | Persistent | Top banner (`MaterialBanner`) with "Hors ligne" |
| **Token expired** | Redirect | Auto-redirect to login, snackbar "Session expirée" |
| **Rate limited** | Temporary | Snackbar "Trop de tentatives, réessaie dans X secondes" |

### Error Message Rules

```dart
// ✅ CORRECT — human error messages
"Oups, quelque chose a cassé. Réessaie."
"Impossible de charger les données. Vérifie ta connexion."
"Email ou mot de passe incorrect."
"Ce nom est déjà utilisé. Essaie un autre."

// ❌ FORBIDDEN — technical errors exposed to users
"Error 500: Internal Server Error"
"SQLITE_CONSTRAINT: UNIQUE constraint failed"
"SocketException: Connection refused"
"null check operator used on a null value"
```

### Network Offline Banner

```dart
// Persistent banner at top of screen (below AppBar)
if (viewModel.isOffline) {
  MaterialBanner(
    content: Text(context.l10n.offlineMessage),
    leading: Icon(LucideIcons.wifiOff, semanticLabel: context.l10n.offline),
    backgroundColor: context.colorScheme.errorContainer,
    actions: [
      TextButton(
        onPressed: viewModel.retry,
        child: Text(context.l10n.retry),
      ),
    ],
  );
}
```

### Error Boundary (Global)

```dart
// In main.dart — catch unhandled errors
FlutterError.onError = (details) {
  // Log to error reporting service (if enabled)
  // Show generic error UI instead of red screen
  ErrorReportingService.report(details.exception, details.stack);
};

// In widget tree — ErrorWidget replacement
ErrorWidget.builder = (details) {
  return Center(
    child: AppEmptyState.error(
      title: context.l10n.unexpectedError,
      description: context.l10n.pleaseRestartApp,
    ),
  );
};
```

---

## Pattern 8: Paywall / Upsell

### When to Show

- **Feature gate**: user taps a premium feature → bottom sheet paywall.
- **Trial end**: banner at top after trial expires.
- **Settings > Abonnement**: always accessible for voluntary upgrade.
- **NEVER**: on first launch, during onboarding, or interrupting active work.

### Paywall Layout (Bottom Sheet)

```
┌──────────────────────────┐
│  ━━━━━━━━━━━━━━━━━━━━━━  │  ← Drag handle
│                          │
│  ✨ Passe au Premium     │  ← Gold accent color
│                          │
│  ✓ Fonctionnalité 1      │  ← Feature list (3-5 items)
│  ✓ Fonctionnalité 2      │
│  ✓ Fonctionnalité 3      │
│                          │
│  ┌────────────────────┐  │
│  │  Mensuel   Annuel  │  │  ← Segmented toggle
│  └────────────────────┘  │
│                          │
│  2 500 FCFA/mois         │  ← Price (clear, formatted)
│  soit 25 000 FCFA/an     │  ← Annual equivalent
│  Économise 33%           │  ← Savings callout (green)
│                          │
│  [S'abonner]             │  ← Primary CTA (full width)
│                          │
│  Restaurer un achat      │  ← Ghost link
│  Annuler quand tu veux   │  ← Reassurance text
└──────────────────────────┘
```

### Rules

| Rule | Value |
|------|-------|
| Feature list | Max 5 items, each with `LucideIcons.check` in success color |
| Price | Always show per-month AND annual equivalent |
| Currency | Local currency first (FCFA for West Africa), USD secondary |
| Annual savings | Green text, calculates actual savings percentage |
| Restore purchase | Visible at bottom, `AppButton.ghost` variant |
| Reassurance | "Annule quand tu veux" — always present |
| Trial | If applicable: "7 jours gratuits, puis X FCFA/mois" |
| Accent color | `AppColors.premium` (Gold `#D4A853`) for premium elements |
| Close | Drag down or tap outside — NEVER hide the close button |
| No dark patterns | No shame buttons, no fake urgency, no hidden costs |

### Feature Gate (Inline Lock)

```dart
// Locked feature shows lock icon + gentle upsell
AppListTile(
  leading: Icon(LucideIcons.lock, color: context.colorScheme.onSurfaceVariant,
                semanticLabel: context.l10n.premiumFeature),
  title: context.l10n.advancedAnalytics,
  subtitle: context.l10n.premiumOnly,
  trailing: AppBadge.label(label: 'PRO', color: AppColors.premium),
  onTap: viewModel.showPaywall,
)
```

---

## Pattern 9: Notification Center

### Structure

```
┌──────────────────────────┐
│  ← Notifications   ⋯    │  ← AppBar + "Tout marquer lu" overflow
├──────────────────────────┤
│  Aujourd'hui             │  ← Section header (relative date)
│  ┌──────────────────┐    │
│  │ 🔵 Titre          │    │  ← Unread = primary dot
│  │    Description     │    │
│  │    Il y a 2h       │    │
│  └──────────────────┘    │
│  ┌──────────────────┐    │
│  │    Titre (lu)      │    │  ← Read = no dot, muted text
│  │    Il y a 5h       │    │
│  └──────────────────┘    │
├──────────────────────────┤
│  Hier                    │
│  ...                     │
└──────────────────────────┘
```

### Rules

| Rule | Value |
|------|-------|
| Grouping | By date (Aujourd'hui, Hier, Cette semaine, Plus ancien) |
| Unread indicator | Primary-colored dot (`AppBadge.dot`) on left |
| Read state | Muted text color (`onSurfaceVariant`) after tapped |
| Swipe actions | Swipe left = mark read/unread. Swipe right = delete. |
| Empty state | `AppEmptyState(title: l10n.noNotifications, illustration: bell)` |
| Tap action | Navigate to relevant screen (deep link) |
| Overflow menu | "Tout marquer comme lu", "Paramètres de notifications" |
| Timestamp | Relative format: "Il y a 2h", "Hier", "10 mars" |
| Max visible | Paginate at 50 items, load more on scroll |
| Bell badge | `AppBadge.count(count: unreadCount)` on bottom nav icon |

### Notification Item Layout

```dart
AppListTile(
  leading: Stack(
    children: [
      CircleAvatar(
        backgroundColor: notification.iconBackground,
        child: Icon(notification.icon, size: AppSizing.iconMd,
                    semanticLabel: notification.semanticType),
      ),
      if (!notification.isRead)
        Positioned(
          top: 0, right: 0,
          child: AppBadge.dot(color: context.colorScheme.primary),
        ),
    ],
  ),
  title: notification.title,
  titleStyle: notification.isRead
      ? AppTypography.bodyMd
      : AppTypography.bodyMd.copyWith(fontWeight: FontWeight.w600),
  subtitle: notification.body,
  trailing: Text(
    notification.formattedTime,
    style: AppTypography.labelSmall.copyWith(
      color: context.colorScheme.onSurfaceVariant),
  ),
  onTap: () => viewModel.openNotification(notification),
)
```

---

## Pattern 10: Profile Screen

### Structure

```
┌──────────────────────────┐
│  ← Profil          ✏️    │  ← Edit button (AppBar action)
├──────────────────────────┤
│        [Avatar]          │  ← AppAvatar (96dp), centered
│      Nom Complet         │  ← headingMedium
│      email@example.com   │  ← bodyMd, onSurfaceVariant
├──────────────────────────┤
│  Stats (horizontal row)  │
│  ┌──────┬──────┬──────┐  │
│  │  42  │  7🔥 │  3   │  │  ← Stat cards
│  │ items│streak│ goals │  │
│  └──────┴──────┴──────┘  │
├──────────────────────────┤
│  Section: Activité       │
│  ├─ Calendrier (heatmap) │  ← Contribution graph (optional)
│  └─ Voir tout            │
├──────────────────────────┤
│  Section: Actions        │
│  ├─ Modifier le profil   │
│  ├─ Abonnement           │
│  └─ Réglages             │  ← navigates to Settings
└──────────────────────────┘
```

### Rules

| Rule | Value |
|------|-------|
| Avatar | `AppAvatar(size: AppSizing.avatarXl)` (96dp), centered |
| Avatar tap | Show bottom sheet: take photo, choose from gallery, remove |
| Name | `AppTypography.headingMedium`, centered |
| Email | `AppTypography.bodyMd`, `onSurfaceVariant`, centered |
| Stats row | 3 cards, equal width, bordered (`AppCard.outlined`) |
| Stat value | `AppTypography.headingSmall`, primary color for active values |
| Stat label | `AppTypography.labelSmall`, `onSurfaceVariant` |
| Edit | Full-screen push with form pattern (Pattern 6) |
| Scroll | `SingleChildScrollView`, not a list |

### Profile Stats Row

```dart
Row(
  children: [
    Expanded(child: _StatCard(
      value: viewModel.totalItems.toString(),
      label: context.l10n.items,
    )),
    AppGaps.horizontalSm,
    Expanded(child: _StatCard(
      value: '${viewModel.streak}🔥',
      label: context.l10n.streak,
    )),
    AppGaps.horizontalSm,
    Expanded(child: _StatCard(
      value: viewModel.goalsReached.toString(),
      label: context.l10n.goals,
    )),
  ],
)
```

### Avatar Change Bottom Sheet

```dart
AppBottomSheet(
  title: context.l10n.changeAvatar,
  children: [
    AppListTile(
      leading: Icon(LucideIcons.camera, semanticLabel: context.l10n.takePhoto),
      title: context.l10n.takePhoto,
      onTap: viewModel.takePhoto,
    ),
    AppListTile(
      leading: Icon(LucideIcons.image, semanticLabel: context.l10n.chooseFromGallery),
      title: context.l10n.chooseFromGallery,
      onTap: viewModel.pickFromGallery,
    ),
    if (viewModel.hasAvatar)
      AppListTile(
        leading: Icon(LucideIcons.trash2, semanticLabel: context.l10n.removeAvatar,
                      color: AppColors.error),
        title: context.l10n.removeAvatar,
        titleStyle: TextStyle(color: AppColors.error),
        onTap: viewModel.removeAvatar,
      ),
  ],
)
```

---

## Cross-Pattern Rules

These rules apply to ALL patterns above:

### Transitions

| From → To | Transition |
|-----------|-----------|
| List → Detail | Slide from right (push) |
| Screen → Form | Slide from bottom (modal) |
| Screen → Search | Slide from top or push |
| Tab → Tab | Fade (200ms) |
| Auth → Home | Cross-fade (replace) |
| Any → Bottom Sheet | Slide from bottom |

### Consistent Spacing

| Zone | Spacing |
|------|---------|
| Page horizontal padding | `AppSpacing.staticLg` (16dp) |
| Between sections | `AppSpacing.staticXl` (24dp) |
| Within section items | `AppSpacing.staticMd` (12dp) |
| Card internal padding | `AppSpacing.staticLg` (16dp) |
| Form fields gap | `AppSpacing.staticMd` (12dp) |

### Consistent AppBar

| Element | Rule |
|---------|------|
| Back button | `LucideIcons.arrowLeft` for push, `LucideIcons.x` for modal |
| Title | `AppTypography.headingSmall`, centered (iOS-style) or left (Material) |
| Actions | Max 2 visible, rest in overflow `LucideIcons.moreVertical` |
| Background | `context.colorScheme.surface` (transparent scroll) |

### i18n

- ALL text in these patterns comes from ARB files via `context.l10n`.
- No hardcoded strings. Not even "OK" or "Cancel."
- Date formats use the relative format rule: < 24h = "Il y a Xh", < 7d = "Lundi", else = "10 mars."

### Haptic Feedback (per pattern)

| Action | Haptic |
|--------|--------|
| Login success | `mediumImpact` |
| Login error | `heavyImpact` |
| Form submit success | `mediumImpact` |
| Form validation error | `heavyImpact` |
| Search result selected | `selectionClick` |
| Notification tapped | `selectionClick` |
| Setting toggled | `lightImpact` |
| Delete confirmed | `mediumImpact` |
| Swipe action triggered | `lightImpact` |
```
