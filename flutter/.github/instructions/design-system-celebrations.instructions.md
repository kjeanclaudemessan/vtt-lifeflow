```instructions
---
applyTo: "**/*_view.dart,**/*_viewmodel.dart"
---
# Design System — Celebrations & Gamification

> Celebrate user achievements to reinforce positive behavior.
> Intensity scales with milestone importance.
> NEVER gamify to create addiction — celebrate to motivate.

---

## When to Celebrate

| Trigger | Intensity | Visual | Haptic |
|---------|-----------|--------|--------|
| **First signup** | Medium | Welcome animation + warm message | `mediumImpact` |
| **First action** (habit created, first entry) | Medium | Checkmark bounce + "C'est parti !" | `mediumImpact` |
| **Daily action** (habit checked) | Low | Checkmark scale + subtle glow | `mediumImpact` |
| **100% daily completion** | High | Confetti + "Journée parfaite !" | `heavyImpact` |
| **Streak 7 days** | High | Confetti + flame icon pulse | `heavyImpact` |
| **Streak 30 days** | Very High | Full confetti + special message | `heavyImpact` |
| **Streak 100 days** | Maximum | Confetti + Lottie celebration + gold badge | `heavyImpact` |
| **Goal reached** | High | Confetti + "Objectif atteint !" | `heavyImpact` |
| **Level up** (future) | High | Animation + badge reveal | `heavyImpact` |

---

## Visual Types

### 1. Checkmark Animation (Low intensity)

For single actions (habit checked, form saved):

```dart
// AnimatedScale bounce on success
AnimatedScale(
  scale: isCompleted ? 1.0 : 0.0,
  duration: AppAnimations.medium,
  curve: AppAnimations.spring, // bouncy
  child: Icon(
    LucideIcons.check,
    color: AppColors.success,
    size: AppSizing.iconLg,
    semanticLabel: context.l10n.completed,
  ),
)
```

### 2. Glow Pulse (Medium intensity)

For streaks and recurring achievements:

```dart
// Primary-colored glow that pulses once
TweenAnimationBuilder<double>(
  tween: Tween(begin: 0.0, end: 1.0),
  duration: AppAnimations.extraSlow,
  builder: (context, value, child) => Container(
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: context.colorScheme.primary.withOpacity(0.3 * value),
          blurRadius: 16 * value,
          spreadRadius: 4 * value,
        ),
      ],
    ),
    child: child,
  ),
)
```

### 3. Confetti (High intensity)

For major milestones (100% daily, streaks, goals):

```dart
// Use a confetti widget overlay
// Package: confetti or custom particle system
// Duration: 2-3 seconds
// Colors: Primary + Gold + Success + accent colors
// Direction: Top-down, spread from center
ConfettiWidget(
  confettiController: _controller,
  blastDirectionality: BlastDirectionality.explosive,
  colors: [
    context.colorScheme.primary,
    AppColors.premium,      // Gold
    AppColors.success,      // Green
    AppColors.info,         // Blue
  ],
  numberOfParticles: 20,
  gravity: 0.3,
)
```

### 4. Lottie (Maximum intensity)

For rare achievements (100-day streak, major goals):

```dart
// Full-screen Lottie overlay
Lottie.asset(
  'assets/lottie/celebration.json',
  width: double.infinity,
  repeat: false,
  onLoaded: (composition) {
    // Auto-dismiss after animation ends
  },
)
```

---

## Streak Counter

### Visual Pattern

```
🔥 7 jours → Flame icon + count
```

- Icon: `LucideIcons.flame` (primary color).
- Counter: `AppTypography.headingMedium`.
- Location: Dashboard header, profile stats.
- Broken streak: "Reprends quand tu veux 💪" — NO guilt, NO "You lost your streak."

### Rules

- Streak counter shows CURRENT streak only.
- Broken streaks are NEVER shown as a number ("0 jours").
- After breaking: "Reprends quand tu veux" (not "Tu as perdu ta série de 14 jours").
- Long streaks get visual upgrades: 7→bronze, 30→silver, 100→gold color on flame.

---

## Celebration Messages

Pool of messages (rotated, never repeated consecutively). Stored in ARB files:

### Encouragement (daily actions)

```
"Continue comme ça !"
"Encore un !"
"Tu avances bien."
"Beau travail."
"Chaque pas compte."
```

### Félicitation (milestones)

```
"Bravo !"
"Objectif atteint !"
"Impressionnant !"
"Tu gères !"
"Journée parfaite !"
```

### Réconfort (after failure/error)

```
"Pas de souci, ça arrive."
"On réessaie ?"
"C'est pas grave."
"Demain est un nouveau jour."
"Reprends quand tu veux."
```

### Retour (after absence)

```
"Content de te revoir !"
"Reprends là où tu en étais."
"Bon retour !"
"Prêt à continuer ?"
```

---

## Anti-Addiction Rules

- **NO daily login reward** that punishes skipping.
- **NO shame messaging** ("Tu as manqué 3 jours !").
- **NO FOMO** from other users' achievements.
- Streak messaging is always **positive or neutral**, never guilt-inducing.
- Celebration intensity is **capped** — no fullscreen popups every 5 minutes.
- Max **1 confetti event per session**.
- User can **disable celebrations** in Settings > Preferences.

---

## XP / Levels (NOT for v1)

- No XP/level system in v1 of LifeFlow.
- Planned for post-v1: simple badge system tied to real milestones.
- Badges are **earned, never purchased**.
- Badge design: circular, branded, flat illustration style.
```
