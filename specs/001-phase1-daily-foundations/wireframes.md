# Wireframes: Phase 1 — Le Cockpit Quotidien

**Branch**: `001-phase1-daily-foundations` | **Date**: 2026-02-19 | **Revised**: 2026-02-19
**Design system**: Tous les wireframes utilisent `AppColors`, `AppSpacing`, `AppTextStyles`, `AppGaps`.
**Widgets DS**: `AppButton`, `AppCard`, `AppTextField`, `AppListTile`, `AppBadge`, `AppProgress`, `AppEmptyState`, `AppChip`, `AppBottomNav`, `AppFab`, `AppBottomSheet`, `AppSlider`.

---

## Navigation Structure

```
AppBottomNav (3 tabs)
├── Tab 0: TodayView         (🏠 home icon)
├── Tab 1: HabitsView         (🔄 repeat icon)
└── Tab 2: CounterView         (⏱️ timer icon)

AppBar actions:
├── Settings icon (gear) → SettingsView (existant)
└── Notifications icon → future (placeholder)

Settings → Domains management (DomainsView)
CounterView → Bilan hebdo (BilanView)
```

---

## 1. TodayView — Mode Matin (Tab 0, 5h-12h)

```
┌─────────────────────────────┐
│ ☰   Aujourd'hui        ⚙️  │  ← AppBar: title=l10n.today, settings icon
├─────────────────────────────┤
│                             │
│ 👋 Bonjour Amadou !         │  ← AppTextStyles.headlineSmall
│ Lundi 19 février            │  ← AppTextStyles.bodyMedium, AppColors.onSurfaceVariant
│                             │
│ ┌─────────────────────────┐ │  ← today_counter_summary (AppCard)
│ │ ⏱️ Cette semaine         │ │
│ │ ██████░░ 12h40 / 20h    │ │  ← AppProgress(0.63) + total
│ │ 🏥 5h20  💼 4h  🧠 3h20 │ │  ← Mini counters par domaine (chips)
│ └─────────────────────────┘ │
│                             │
│ ── Matin (6h – 12h) ────── │  ← Section header (AppTextStyles.labelLarge)
│ ┌─────────────────────────┐ │
│ │ ☐ Méditer               │ │  ← HabitCheckTile: checkbox + name
│ │   🏥 Santé  🔥 12j  10m │ │     AppChip(domain) + streak + durée
│ ├─────────────────────────┤ │
│ │ ☐ Sport                 │ │
│ │   🏥 Santé  🔥 5j   60m │ │
│ └─────────────────────────┘ │
│                             │
│ ── Après-midi (12h – 18h)── │
│ ┌─────────────────────────┐ │
│ │ ☐ Lire 30 min           │ │  ← Quantitative: nom + target
│ │   🧠 Dev perso  🔥 3j   │ │
│ └─────────────────────────┘ │
│                             │
│ ── Sans horaire ──────────── │
│ ┌─────────────────────────┐ │
│ │ ☐ Boire 2L d'eau ░░ 0%  │ │  ← Quantitative sans plage
│ │   🏥 Santé  ❄️ 8j   5m  │ │     ❄️ = streak avec freeze
│ └─────────────────────────┘ │
│                             │
├─────────────────────────────┤
│  🏠      🔄      ⏱️        │  ← AppBottomNav (3 tabs)
│ Today  Habits  Compteur     │
└─────────────────────────────┘
```

---

## 2. TodayView — Mode Progression (12h-18h)

```
┌─────────────────────────────┐
│ ☰   Aujourd'hui        ⚙️  │
├─────────────────────────────┤
│                             │
│ 🎯 3/5 habitudes faites     │  ← AppTextStyles.headlineSmall
│ Continue comme ça !          │  ← Message encourageant
│                             │
│ ┌─────────────────────────┐ │  ← Barre de progression jour
│ │ ████████████░░░░ 60%    │ │  ← AppProgress(0.6)
│ │ +1h10 aujourd'hui       │ │  ← Temps ajouté aujourd'hui
│ └─────────────────────────┘ │
│                             │
│ ── ✅ Faites ────────────── │  ← Habitudes cochées (collapsed)
│ ┌─────────────────────────┐ │
│ │ ✅ Méditer        🔥 13j │ │  ← Checked, grisé
│ │ ✅ Sport          🔥 6j  │ │
│ │ ✅ Lire 25/30min  🔥 4j  │ │  ← Quantitative: value/target
│ └─────────────────────────┘ │
│                             │
│ ── ⏳ Restantes ──────────── │  ← Habitudes non cochées (expanded)
│ ┌─────────────────────────┐ │
│ │ ☐ Gratitude journal     │ │
│ │   🧠 Dev perso     15m  │ │
│ ├─────────────────────────┤ │
│ │ ☐ Boire 2L  ████░ 75%  │ │
│ │   🏥 Santé  1500/2000ml │ │
│ └─────────────────────────┘ │
│                             │
├─────────────────────────────┤
│  🏠      🔄      ⏱️        │
└─────────────────────────────┘
```

---

## 3. TodayView — Mode Bilan (18h-5h)

```
┌─────────────────────────────┐
│ ☰   Aujourd'hui        ⚙️  │
├─────────────────────────────┤
│                             │
│ 🌙 Bonne soirée !           │
│ Tu as complété 4/5 habitudes│  ← AppTextStyles.headlineSmall
│                             │
│ ┌─────────────────────────┐ │  ← Résumé du jour (AppCard elevated)
│ │ 📊 Aujourd'hui           │ │
│ │ 🏥 Santé      1h15      │ │
│ │ 💼 Travail    0h        │ │  ← 0h = AppColors.onSurfaceVariant
│ │ 🧠 Dev perso  45m       │ │
│ │ ─────────────────────── │ │
│ │ Total: 2h00             │ │
│ └─────────────────────────┘ │
│                             │
│ ┌─────────────────────────┐ │  ← Si dimanche/lundi (AppCard accent)
│ │ 📊 Ton bilan de la       │ │
│ │    semaine est prêt !    │ │  ← AppColors.primary
│ │         [ Voir → ]       │ │  ← AppButton.text → BilanView
│ └─────────────────────────┘ │
│                             │
│ 💬 "Chaque jour compte,     │  ← Citation (AppTextStyles.bodySmall, italic)
│    même les imparfaits."    │
│                             │
├─────────────────────────────┤
│  🏠      🔄      ⏱️        │
└─────────────────────────────┘
```

---

## 4. TodayView — Empty State

```
┌─────────────────────────────┐
│ ☰   Aujourd'hui        ⚙️  │
├─────────────────────────────┤
│                             │
│                             │
│       🌱                    │  ← Illustration (simple icon)
│                             │
│   Ta journée est vide.      │  ← AppEmptyState
│   Crée ta première          │     title + subtitle
│   habitude pour commencer   │
│   à voir où va ton temps.   │
│                             │
│   [ Créer une habitude ]    │  ← AppButton.primary → HabitFormView
│                             │
│                             │
├─────────────────────────────┤
│  🏠      🔄      ⏱️        │
└─────────────────────────────┘
```

---

## 5. HabitsView (Tab 1)

```
┌─────────────────────────────┐
│ ←  Mes habitudes       🔍  │  ← AppBar: title, search icon
├─────────────────────────────┤
│                             │
│ [Toutes] [Santé] [Travail]  │  ← Filtre par domaine (AppChip toggleable)
│ [Dev perso] [+2]            │
│                             │
│ ┌─────────────────────────┐ │
│ │ 🏥 Méditer              │ │  ← AppCard: domain icon + name
│ │    Binaire · 10 min     │ │     Type + durée estimée
│ │    6h – 8h  🔥 12j      │ │     Plage + streak
│ ├─────────────────────────┤ │
│ │ 🏥 Sport                │ │
│ │    Binaire · 60 min     │ │
│ │    7h – 8h  🔥 5j       │ │
│ ├─────────────────────────┤ │
│ │ 🧠 Lire                 │ │
│ │    Quantitatif · 30 min │ │
│ │    12h – 14h  🔥 3j     │ │
│ ├─────────────────────────┤ │
│ │ 🏥 Boire 2L             │ │
│ │    Quantitatif · 5 min  │ │
│ │    Sans horaire  ❄️ 8j  │ │
│ └─────────────────────────┘ │
│                             │
│                         [+] │  ← AppFab → HabitFormView
├─────────────────────────────┤
│  🏠      🔄      ⏱️        │
└─────────────────────────────┘
```

---

## 6. HabitFormView (Create/Edit)

```
┌─────────────────────────────┐
│ ←  Nouvelle habitude   💾  │  ← AppBar: back + save icon
├─────────────────────────────┤
│                             │
│ Nom *                       │
│ ┌─────────────────────────┐ │  ← AppTextField (required)
│ │ Méditer                 │ │
│ └─────────────────────────┘ │
│                             │
│ Description                 │
│ ┌─────────────────────────┐ │  ← AppTextField (optional)
│ │ 10 minutes de pleine... │ │
│ └─────────────────────────┘ │
│                             │
│ Domaine *                   │
│ ┌─────────────────────────┐ │  ← Tap → DomainPickerSheet
│ │ 🏥 Santé            ▼   │ │
│ └─────────────────────────┘ │
│                             │
│ Type                        │
│ [ Binaire ]  [ Quantitatif ]│  ← Toggle (AppChip exclusive)
│                             │
│ ── Si Quantitatif ──────── │  ← Conditionnel
│ │ Objectif: [    30    ]   │ │  ← AppTextField numeric
│ │ Unité:    [   min    ]   │ │  ← AppTextField ou dropdown
│ └─────────────────────────┘ │
│                             │
│ Temps estimé *              │  ← ⚡ NOUVEAU CHAMP
│ ┌─────────────────────────┐ │
│ │ 10 minutes          ▼   │ │  ← AppSlider ou stepper
│ └─────────────────────────┘ │     (5, 10, 15, 30, 45, 60, 90, 120)
│ 💡 Ce temps sera compté     │  ← Helper text
│    dans ton compteur.       │
│                             │
│ Plage horaire (optionnel)   │
│ ┌──────┐     ┌──────┐      │
│ │ 06:00│  →  │ 08:00│      │  ← 2 time pickers
│ └──────┘     └──────┘      │
│                             │
│ Fréquence                   │
│ [Chaque jour] [X jours/sem] │  ← Toggle
│ ── Si X jours/sem ──────── │
│ │ L M M J V S D            │ │  ← Day selector (AppChip)
│ └─────────────────────────┘ │
│                             │
│ [ Créer l'habitude ]        │  ← AppButton.primary (full width)
│                             │
├─────────────────────────────┤
│  🏠      🔄      ⏱️        │
└─────────────────────────────┘
```

---

## 7. CounterView (Tab 2) — Compteur Temps

```
┌─────────────────────────────┐
│ ←  Mon temps           📅  │  ← AppBar: title + date picker (semaine)
├─────────────────────────────┤
│                             │
│ Semaine du 17 – 23 fév      │  ← AppTextStyles.titleSmall
│                             │
│ ┌─────────────────────────┐ │
│ │ Total: 12h40             │ │  ← AppTextStyles.headlineMedium, bold
│ │ ▲ +2h30 vs sem. dernière │ │  ← Delta (vert si positif)
│ └─────────────────────────┘ │
│                             │
│ 🏥 Santé                    │
│ ██████████████░░░░ 5h20     │  ← DomainTimeBar (couleur domaine)
│ ▲ +1h20                     │  ← Delta inline
│                             │
│ 💼 Travail                   │
│ ██████████░░░░░░░░ 4h00     │
│ ▼ -30min                    │  ← Delta négatif (rouge subtil)
│                             │
│ 🧠 Dev perso                 │
│ ████████░░░░░░░░░░ 3h20     │
│ ▲ +1h40                     │
│                             │
│ ── Détail tap ──────────── │  ← Tap sur un domaine → expand
│ ┌─────────────────────────┐ │
│ │ 🏥 Santé — 5h20          │ │  ← DomainTimeDetail
│ │  Méditer: 50min (10m×5j) │ │
│ │  Sport: 4h30 (60m×4j+30) │ │
│ │  Boire 2L: 25min (5m×5j) │ │
│ └─────────────────────────┘ │
│                             │
│ ┌─────────────────────────┐ │  ← AppCard accent (si bilan dispo)
│ │ 📊 Bilan de la semaine   │ │
│ │ dernière disponible      │ │
│ │      [ Voir le bilan ]   │ │  ← → BilanView
│ └─────────────────────────┘ │
│                             │
├─────────────────────────────┤
│  🏠      🔄      ⏱️        │
└─────────────────────────────┘
```

---

## 8. CounterView — Empty State

```
┌─────────────────────────────┐
│ ←  Mon temps           📅  │
├─────────────────────────────┤
│                             │
│                             │
│          ⏱️                 │
│                             │
│   Ton temps t'attend.       │  ← AppEmptyState
│   Crée ta première          │
│   habitude pour voir        │
│   où vont tes heures.       │
│                             │
│   [ Créer une habitude ]    │  ← AppButton.primary
│                             │
├─────────────────────────────┤
│  🏠      🔄      ⏱️        │
└─────────────────────────────┘
```

---

## 9. BilanView (Weekly Summary)

```
┌─────────────────────────────┐
│ ←  Bilan semaine       📤  │  ← AppBar: back + share icon
├─────────────────────────────┤
│                             │
│ 📊 Semaine du 10 – 16 fév   │  ← AppTextStyles.titleMedium
│                             │
│ ┌─────────────────────────┐ │
│ │ 12h40 au total           │ │  ← AppTextStyles.headlineLarge, bold
│ │ ▲ +2h30 vs semaine       │ │
│ │   précédente              │ │
│ └─────────────────────────┘ │
│                             │
│ ── Temps par domaine ────── │
│                             │
│ 🏥 Santé                    │
│ ████████████████ 5h20  42%  │  ← Barre + % du total
│                             │
│ 💼 Travail                   │
│ ████████████░░░░ 4h00  32%  │
│                             │
│ 🧠 Dev perso                 │
│ ██████████░░░░░░ 3h20  26%  │
│                             │
│ ── Highlights ──────────── │
│ ┌─────────────────────────┐ │
│ │ 🏆 Habitude star         │ │  ← BilanHighlights
│ │    Méditer — 100% (7/7)  │ │
│ │                          │ │
│ │ 🔥 Plus long streak       │ │
│ │    Sport — 12 jours      │ │
│ │                          │ │
│ │ 📈 Taux de complétion     │ │
│ │    78% (27/35 habitudes) │ │
│ └─────────────────────────┘ │
│                             │
│ ── Si première semaine ─── │
│ ┌─────────────────────────┐ │
│ │ 🌱 Première semaine !     │ │  ← Au lieu du delta
│ │ Tu as posé les           │ │
│ │ fondations. Continue !   │ │
│ └─────────────────────────┘ │
│                             │
│ [    Partager mon bilan   ] │  ← AppButton.primary (full width)
│                             │
├─────────────────────────────┤
│  🏠      🔄      ⏱️        │
└─────────────────────────────┘
```

---

## 10. Bilan Share Widget (Screenshot optimisé)

```
┌─────────────────────────────┐
│                             │  ← Fond: AppColors.surface
│  LifeFlow 📊                │  ← Logo + titre
│  Semaine du 10 – 16 fév     │
│                             │
│  12h40 investies            │  ← Chiffre gros, AppColors.primary
│                             │
│  🏥 Santé      5h20  ████  │  ← Barres simplifiées
│  💼 Travail    4h00  ███   │
│  🧠 Dev perso  3h20  ██   │
│                             │
│  🏆 Star: Méditer (7/7)    │
│  🔥 Streak: 12 jours       │
│  📈 Complétion: 78%        │
│                             │
│  lifeflow.app               │  ← URL pour viralité
└─────────────────────────────┘
```

*Ce widget n'est jamais affiché à l'écran — il est rendu en mémoire via `RepaintBoundary.toImage()` puis partagé.*

---

## 11. DomainsView (Settings → Domaines)

```
┌─────────────────────────────┐
│ ←  Mes domaines        [+] │  ← AppBar: back + add icon
├─────────────────────────────┤
│                             │
│ ≡ 🏥 Santé                  │  ← DomainTile: drag handle + icon + name
│      5 habitudes            │     Nombre d'habitudes liées
│ ≡ 💼 Travail                 │
│      3 habitudes            │
│ ≡ 💙 Relations               │
│      0 habitudes            │
│ ≡ 🧠 Développement perso    │
│      2 habitudes            │
│                             │
│ ── Archivés ─────────────── │  ← Section collapsed
│ ┌─────────────────────────┐ │
│ │ 💰 Finances (archivé)   │ │  ← Grisé, action "Restaurer"
│ └─────────────────────────┘ │
│                             │
│ 💡 Glisse pour réordonner.  │  ← Helper text
│    Swipe ← pour archiver.  │
│                             │
└─────────────────────────────┘
```

---

## 12. DomainPickerSheet (Bottom Sheet réutilisable)

```
┌─────────────────────────────┐
│         ─────               │  ← Drag handle
│ Choisir un domaine          │  ← AppTextStyles.titleMedium
├─────────────────────────────┤
│                             │
│ 🏥 Santé                    │  ← Tappable list item
│ 💼 Travail                   │
│ 💙 Relations                 │
│ 🧠 Développement perso      │
│                             │
│ [ + Nouveau domaine ]       │  ← AppButton.text → inline creation
│                             │
└─────────────────────────────┘
```

---

## 13. Onboarding — Étape Domaines

```
┌─────────────────────────────┐
│                      Passer │  ← Skip button (AppTextStyles.labelMedium)
├─────────────────────────────┤
│                             │
│ 🌍                          │
│ Tes domaines de vie          │  ← AppTextStyles.headlineMedium
│ Sur quoi veux-tu             │
│ investir ton temps ?         │
│                             │
│ ┌─────────────────────────┐ │
│ │ ✅ 🏥 Santé              │ │  ← Checkbox list (pré-cochés)
│ │ ✅ 💼 Travail             │ │
│ │ ✅ 💙 Relations           │ │
│ │ ✅ 💰 Finances            │ │
│ │ ✅ 🧠 Dev perso           │ │
│ └─────────────────────────┘ │
│                             │
│ [ + Ajouter un domaine ]    │  ← AppButton.text
│                             │
│                             │
│ [      Continuer →      ]   │  ← AppButton.primary
│                             │
│ ● ● ◉ ●                    │  ← Step indicator (2/4)
└─────────────────────────────┘
```

---

## 14. Streak Badge Detail (Bottom Sheet)

```
┌─────────────────────────────┐
│         ─────               │
│ 🔥 Streak: Méditer          │
├─────────────────────────────┤
│                             │
│ 12 jours consécutifs        │  ← Streak actuel
│ Record: 15 jours            │  ← Meilleur streak
│                             │
│ Derniers 14 jours:          │
│ 🔥🔥🔥❄️🔥🔥🔥🔥🔥🔥🔥🔥☐☐    │
│ ↑ freeze utilisé            │  ← ❄️ = freeze, ☐ = pas encore
│                             │
│ Freeze: 1/semaine (actif)   │  ← Status
│ Prochain freeze dispo: jeu  │
│                             │
└─────────────────────────────┘
```

---

## Responsive Notes

| Breakpoint | Comportement |
|-----------|-------------|
| Mobile (< 600px) | Layout par défaut — tous les wireframes ci-dessus |
| Tablet (600-900px) | TodayView: counter summary à droite en side panel |
| Desktop (> 900px) | 3 colonnes: Today + Habits + Counter visibles simultanément |

*Phase 1 cible principalement mobile. Tablet/desktop sont des bonus via `flutter_screenutil` + responsive breakpoints.*
