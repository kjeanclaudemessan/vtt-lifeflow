```instructions
---
applyTo: "**/*_view.dart"
---
# Design System — Experience Standard

> Every screen is a **moment in a relationship**, not a UI wireframe.
> The bar: **Todoist's polish + Headspace's soul**. Position 3.2/5 on the warmth scale.
> This file is the supreme quality gate — no screen ships without passing it.

---

## Who We're Building For

| Persona | Device | Context |
|---------|--------|---------|
| **Amadou** (28, Abidjan) | Samsung A54, 6GB RAM, 4G | Dev freelance, 6h30 screen/day, seeks structure |
| **Camille** (34, Lyon) | iPhone 14, 4G illimité | Marketing manager, 4h screen/day, seeks balance |

**Device floor**: Samsung A54 / iPhone 12. 60fps mandatory. APK < 25MB.

---

## The 3-Layer Rule

Every screen MUST have all 3 layers. If a layer is missing, the screen is not done.

| Layer | What | Example |
|-------|------|---------|
| **1. Functional** | Does the job correctly | Form submits, list loads, error retries |
| **2. Sensory** | Feels polished and alive | Staggered fade-in, haptic on success, animated progress |
| **3. Personality** | Speaks like "un pote lucide" | Contextual greeting, warm micro-copy, celebration on completion |

```dart
// ❌ LAYER 1 ONLY — functional but dead
Text('Loading...')

// ✅ ALL 3 LAYERS — functional + sensory + personality
AnimatedSwitcher(
  duration: AppAnimations.medium,
  child: Text(
    _getContextualGreeting(l10n), // Layer 3: personality
    key: ValueKey(greeting),
    style: AppTypography.bodyMedium.copyWith(
      color: context.colorScheme.onSurfaceVariant,
    ),
  ),
) // Layer 2: animated transition
```

---

## Voice & Tone in Code

| Principle | Rule | Forbidden |
|-----------|------|-----------|
| **Tu, pas vous** | Always informal, direct | "Veuillez", corporate speak |
| **Bienveillant** | Encourage, never blame | "Échec", "Raté", "Tu devrais" |
| **Clair** | One idea per sentence | Jargon, multi-clause explanations |
| **Ancré** | Concrete, actionable | Vague praise, "Performance", "Productivité" |

### Error states

```dart
// ❌ FORBIDDEN — blame, "Oups", vague
Text('Oups ! Une erreur est survenue. Réessayez plus tard.')

// ✅ CORRECT — honest, concrete, no guilt
Text(l10n.errorConnectionLost) // "Connexion perdue. On réessaie ?"
// With a retry button that says l10n.retry // "Réessayer"
```

### Empty states

```dart
// ❌ DEAD END — no invitation
Text('Aucune habitude')

// ✅ INVITATION — warm, actionable
AppEmptyState(
  icon: LucideIcons.sparkles,
  title: l10n.habitsEmptyTitle,     // "C'est calme ici"
  subtitle: l10n.habitsEmptySubtitle, // "Ajoute ta première habitude"
  actionLabel: l10n.habitsAdd,       // "Créer une habitude"
  onAction: viewModel.addHabit,
)
```

### Return after absence

```
// Zero guilt. Zero streak-shame. Just warmth.
"Content de te revoir" — NEVER "Tu as manqué 5 jours"
```

---

## Emotional Register by UxPack

Each `UxPack` defines the emotional temperature of screens:

| UxPack | Tone | Animation energy | Celebrations | Example apps |
|--------|------|-------------------|-------------|-------------|
| **flow** | Warm, encouraging | Gentle, breathing | Frequent micro + medium | LifeFlow, MindFlow, SpiritFlow |
| **pro** | Confident, efficient | Crisp, precise | Sparse, milestone-only | HustlePro, ForgePro |
| **community** | Inviting, social | Playful, bouncy | Social-triggered | ChurchFlow |

```dart
// Adapt animation energy to UxPack
final uxPack = context.brandSkin.uxPack;
final entranceDuration = switch (uxPack) {
  UxPack.flow => AppAnimations.slow,       // Gentle, breathing
  UxPack.pro => AppAnimations.fast,        // Crisp, efficient
  UxPack.community => AppAnimations.medium, // Playful
};
```

---

## Screen Archetype Recipes

Every screen falls into one of these archetypes. Use the recipe as a baseline.

### 1. Greeting (Splash, Welcome back)

- **Entrance**: Logo breathes in (scale 0.8→1.0, slow + easeOut), then text fades staggered
- **Personality**: Time-of-day greeting + app name from `context.brandSkin.appName`
- **Sensory**: Subtle gradient shift, haptic on ready, smooth transition OUT
- **Exit**: Content fades out before navigation (never a hard cut)

### 2. Form (Login, Register, Profile edit)

- **Entrance**: Fields stagger in top-to-bottom (AppStaggeredFadeIn)
- **Personality**: Encouraging placeholder text, password strength with warm feedback
- **Sensory**: Focus field highlight animation, haptic on submit, shake on error
- **Exit**: Success → micro celebration + haptic before transition

### 3. List (Habits, Notifications, Settings sections)

- **Entrance**: Items stagger from top (AppStaggeredFadeIn, 50ms per item)
- **Personality**: Empty state = invitation with warmth, not a dead end
- **Sensory**: Pull-to-refresh with branded color, swipe-to-dismiss with haptic, skeleton loading
- **Exit**: Selected item grows slightly before pushing detail

### 4. Celebration (Streak, Goal complete, Level up)

- **Entrance**: Scale + glow from center
- **Personality**: Specific praise ("7 jours d'affilée !"), never generic
- **Sensory**: CelebrationService tier (micro/medium/major), haptic, optional confetti
- **Exit**: Gentle fade after 3s or user dismiss

### 5. Empty / Zero-state

- **Entrance**: Icon + text fade in together
- **Personality**: "C'est calme ici" tone, CTA is an invitation
- **Sensory**: Subtle icon animation (pulse or float), AppButton.primary for CTA
- **Exit**: New item appears with AppStaggeredFadeIn at index 0

---

## Mandatory Screen Checklist

Before validating ANY screen, check ALL items:

### Functional
- [ ] All states handled: loading, loaded, empty, error
- [ ] Error state has retry action with clear message (no "Oups")
- [ ] Loading uses `AppSkeleton` (never a bare CircularProgressIndicator)
- [ ] Navigation uses `clearStackAndShow` or proper route builder

### Sensory
- [ ] Content entrance is animated (AppStaggeredFadeIn or AnimatedSwitcher)
- [ ] State transitions use AnimatedSwitcher with AppAnimations tokens
- [ ] At least one haptic feedback point per screen (success, selection, or error)
- [ ] No raw Duration() or Curves — only AppAnimations tokens
- [ ] Respects `MediaQuery.disableAnimations`

### Personality
- [ ] App name uses `context.brandSkin.appName` (never hardcoded)
- [ ] All text uses `context.l10n.*` (never hardcoded strings)
- [ ] Colors from `context.colorScheme.*` or `context.brandSkin.*` (never AppColors.xxx() for themed colors)
- [ ] Spacing from AppSpacing tokens (never raw numbers)
- [ ] Typography from AppTypography (never raw TextStyle)
- [ ] Empty states are invitations, not dead ends
- [ ] Error messages are honest and concrete, never blame the user

### Accessibility
- [ ] Semantics labels on all interactive elements
- [ ] Minimum touch target 48x48
- [ ] Color contrast ratio ≥ 4.5:1 (text) / 3:1 (UI elements)
- [ ] Screen reader announces state changes
- [ ] Dynamic text scaling respected (no fixed font sizes outside AppTypography)

### Performance
- [ ] 60fps on Samsung A54 (test with DevTools Performance overlay)
- [ ] No unnecessary rebuilds (const constructors, selective rebuildUi)
- [ ] Images have explicit size constraints
- [ ] Lists use ListView.builder (never Column with .map)

---

## Animation Budget Per Screen

| Screen type | Max concurrent animations | Lottie allowed | Heavy effects |
|-------------|--------------------------|-----------------|---------------|
| Splash | 3–4 (logo + text + progress + gradient) | Yes (1 file) | Gradient shift OK |
| Form | 2–3 (stagger + focus + submit) | No | Shake on error OK |
| List | 1–2 (stagger + pull-to-refresh) | No | No |
| Celebration | 2–3 (scale + glow + confetti) | Yes (1 file) | Confetti OK (1x/session) |
| Settings | 1 (stagger) | No | No |

---

## Anti-Patterns (NEVER)

```dart
// ❌ NEVER — hardcoded app name
Text('LifeFlow')
// ✅ ALWAYS
Text(context.brandSkin.appName)

// ❌ NEVER — static text without l10n
Text('Bienvenue !')
// ✅ ALWAYS
Text(l10n.welcomeGreeting)

// ❌ NEVER — bare loading indicator
CircularProgressIndicator()
// ✅ ALWAYS — skeleton or branded progress
AppSkeleton(child: ...)
AppLinearProgress(value: progress)

// ❌ NEVER — instant content appearance
Column(children: items.map((i) => ItemTile(i)).toList())
// ✅ ALWAYS — staggered entrance
ListView.builder(
  itemBuilder: (context, index) => AppStaggeredFadeIn(
    index: index,
    child: ItemTile(items[index]),
  ),
)

// ❌ NEVER — mechanical token-only upgrade
// "I replaced AppColors.red with context.colorScheme.error" ← Not enough!
// ✅ ALWAYS — experience upgrade
// "I added staggered entrance, contextual greeting, haptic feedback,
//  warm error state with retry, and Semantics labels"

// ❌ NEVER — guilt or blame in return states
Text('Tu as manqué 3 jours !')
// ✅ ALWAYS — warmth on return
Text(l10n.welcomeBack) // "Content de te revoir"
```

---

## Brand Skin Integration

Every screen must adapt to the active brand skin:

```dart
// Access brand tokens
final skin = context.brandSkin;
final appName = skin.appName;        // "LifeFlow", "IronFlow", etc.
final uxPack = skin.uxPack;          // UxPack.flow, .pro, .community
final primary = context.colorScheme.primary; // Brand primary color

// Adapt greeting by UxPack
final greeting = switch (uxPack) {
  UxPack.flow => l10n.greetingFlow,       // Warm, personal
  UxPack.pro => l10n.greetingPro,         // Confident, direct
  UxPack.community => l10n.greetingCommunity, // Inviting, social
};
```

---

## Quality Positioning

> **Todoist** = 4/5 polish, 1.5/5 warmth → clinical perfection
> **Headspace** = 3/5 polish, 5/5 warmth → emotional, sometimes over-designed
> **Us** = 3.5/5 polish, 3.2/5 warmth → **polished AND human**
>
> Every screen should feel like opening a well-crafted journal,
> not like launching a corporate dashboard.

```
