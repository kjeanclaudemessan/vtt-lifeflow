```instructions
---
applyTo: "**/*.dart"
---
# Design System — Principles, Emotional Journey & Ethical Design

> Supreme laws of the VTT Design System.
> These principles override every other design or implementation decision.
> Priority: Constitution > Principles > Stack instructions > Feature plan.

---

## The 5 Design Principles

Every screen, component, and interaction MUST respect these 5 principles in order:

### 1. Clarté > Complexité

- One screen = one clear purpose. If you need a paragraph to explain the screen, it's too complex.
- Prefer whitespace over density. "Premium" means generous breathing room.
- Labels are explicit. Icons always have text companions on first use.
- No nested menus deeper than 2 levels.

```dart
// ✅ CORRECT — single action per primary CTA
AppButton(label: context.l10n.saveHabit, onPressed: viewModel.save)

// ❌ FORBIDDEN — multi-purpose button
AppButton(label: 'Save & Share & Export', onPressed: viewModel.doEverything)
```

### 2. Progressif > Tout-d'un-coup

- Show basic features first, reveal advanced ones after usage (progressive disclosure).
- Onboarding: max 3 pages. Advanced settings hidden until day 7+.
- Empty states are invitations, not dead ends: "Ajoute ta première habitude."
- Feature gates: lock icon + gentle upsell, never a wall.

### 3. Les données sont sacrées

- Never delete user data without explicit confirmation + undo period.
- Destructive actions require: red CTA + confirmation dialog + 5s undo snackbar.
- Always show sync status. Users must know if their data is safe.
- Export data = always available (Settings > Export).

```dart
// ✅ REQUIRED — destructive action with confirmation
Future<void> deleteHabit(String id) async {
  final confirmed = await _dialogHelper.showDestructiveConfirmation(
    title: context.l10n.deleteHabit,
    message: context.l10n.deleteHabitConfirmation,
  );
  if (!confirmed) return;
  // Show undo snackbar for 5 seconds before actual deletion
}
```

### 4. 1 écran = 1 objectif

- Each screen has ONE primary action (the FAB or main CTA).
- Secondary actions are in overflow menu, bottom sheet, or swipe actions.
- No more than 3 visible actions in AppBar (including back).
- Tab bars max 5 tabs, prefer 4.

### 5. L'IA aide, l'humain décide

- AI suggestions are always dismissible.
- AI never auto-applies changes — it proposes, user confirms.
- AI responses include a disclaimer: "L'IA peut se tromper."
- AI limits are visible: "3/10 questions gratuites aujourd'hui."

---

## Emotional Journey Map

Every moment in the app targets a specific emotion. Design & copy must align:

| Moment | Target Emotion | Design Expression |
|--------|---------------|-------------------|
| **First launch** | Curiosité + Confiance immédiate | Clean onboarding (3 pages max), no permissions asked, instant value preview |
| **First action** | Facilité ("c'était simple") | Pre-filled defaults, smart suggestions, max 3 taps to complete |
| **Daily use** | Calme productif | Minimal notifications, predictable navigation, no surprise layouts |
| **Achievement** | Fierté intérieure (not explosive) | Subtle confetti, checkmark animation + haptic, warm message |
| **Error / failure** | Réassuré + Guidé | Human error message, clear next step, "Réessayer" button, no blame |
| **Return after absence** | Bienvenue chaleureux + Zéro culpabilité | "Content de te revoir !", no broken streak guilt, gentle re-engagement |
| **Payment** | Valeur évidente + Confiance | Features comparison, transparent pricing, easy restore, no dark patterns |
| **Social sharing** | Fierté mesurée + Appartenance | Branded share card, tasteful stats, community feel |

### Implementation Rules

- **Encouragement messages**: Rotate from pool of 10+ variants (see ARB files).
- **Error messages**: Always human, never technical. "Oups, quelque chose a cassé. Réessaie." not "Error 500."
- **Return messages**: Never mention how long the user was away. No "Tu as manqué 14 jours."
- **Achievement messages**: Scale intensity with milestone importance.

---

## Ethical Design & Digital Wellbeing

### Anti-Addiction

- **NO infinite scroll.** Every list has a natural end or pagination.
- **NO culpabilizing streaks.** A broken streak says "Reprends quand tu veux" not "Tu as perdu ta série."
- **Usage reminders** for MindFlow, ReadFlow: "Tu utilises l'app depuis 45 min. Prends une pause 🌿" (opt-out available).
- **No autoplay** of any content (video, audio, next article).

### Notifications

- **Max 5 push per day** across all notification types.
- **Opt-in obligatoire** at first launch. Never assume consent.
- **Quiet hours: 22h–7h** by default, user-configurable in Settings.
- **Each notification category** has its own toggle (Reminders, Social, System, Marketing).

### Dark Patterns INTERDITS

| Pattern | Why It's Banned | Alternative |
|---------|----------------|-------------|
| Faux compteurs d'urgence | Manipulative FOMO | Honest "Offre valable jusqu'au [date]" |
| Shame buttons | Guilt-tripping | Neutral "Non merci" or "Plus tard" |
| Hidden costs | Trust destruction | All costs visible BEFORE payment screen |
| Pre-checked opt-ins | GDPR violation + ethics | All checkboxes unchecked by default |
| Mur de texte juridique | Incomprehensible consent | Plain language + summary bullet points |
| Confirm-shaming | Emotional manipulation | "Annuler" / "Continuer" — neutral verbs |
| Roach motel | Traps users | Unsubscribe = 2 taps, delete account = max 3 |

### Data Transparency

- **Settings > Privacy** shows ALL data collected and why.
- **No data collection without explicit purpose** displayed to user.
- **Analytics are anonymized** by default. PII stripped before transmission.

### User Control

- **Opt-out of everything** in max 2 taps.
- **Delete account**: visible in Settings > Account > Delete, 30-day grace period, data export offered first.
- **Export data**: JSON/CSV available for all user-generated content.
- **Consent is granular**: analytics, marketing, personalization — separate toggles.

---

## Principle Enforcement

### In Code Reviews

Every PR must pass the **Principles Checklist**:

- [ ] Each screen has ONE primary objective
- [ ] No hardcoded user-facing strings (i18n)
- [ ] Destructive actions have confirmation + undo
- [ ] AI features show disclaimer + are dismissible
- [ ] No dark patterns (check against banned list)
- [ ] Error messages are human-readable
- [ ] Loading states use skeleton (not spinner)
- [ ] Empty states invite action (not dead ends)

### In Copilot Agents

The `design-system-auditor` agent checks these principles automatically during audits.
```
