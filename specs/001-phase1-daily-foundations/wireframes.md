# Wireframes: Phase 1 — Daily Foundations

**Branch**: `001-phase1-daily-foundations` | **Date**: 2026-02-19
**Design system**: All wireframes reference `AppColors`, `AppSpacing`, `AppTextStyles`, `AppGaps`.
**Widgets**: `AppButton`, `AppCard`, `AppTextField`, `AppListTile`, `AppBadge`, `AppProgress`, `AppEmptyState`, `AppChip`, `AppBottomNav`.

---

## Navigation Structure

```
AppBottomNav
├── Tab 0: TodayView         (home icon)
├── Tab 1: HabitsView         (repeat icon)
├── Tab 2: [+] FAB            (capture inbox / quick create)
├── Tab 3: RoutinesView        (play-list icon)
└── Tab 4: TasksView           (check-square icon)
```

Inbox badge count shown on FAB or as AppBadge on a dedicated icon.

---

## 1. TodayView (Tab 0 — Main Screen)

```
┌─────────────────────────────┐
│ ☰   Aujourd'hui    🔔 [5]  │  ← AppBar: title=l10n.today, notif icon + AppBadge(inbox count)
├─────────────────────────────┤
│                             │
│ ┌─── 📅 Lun 19 Fév ──────┐ │  ← Date header (AppTextStyles.titleMedium)
│ └─────────────────────────┘ │
│                             │
│ ── Matin (6h – 8h) ─────── │  ← Time range section header (AppTextStyles.labelLarge)
│ ┌─────────────────────────┐ │
│ │ ☐ Méditer 10 min        │ │  ← HabitCheckTile: checkbox + name + domain chip
│ │   🟢 Santé   🔥 12j     │ │     AppChip(domain) + streak icon
│ ├─────────────────────────┤ │
│ │ ☐ Boire 2L   ████░ 75% │ │  ← Quantitative: AppProgress(0.75) inline
│ │   🟢 Santé   1500/2000  │ │     Value / target display
│ └─────────────────────────┘ │
│                             │
│ ── Midi (12h – 14h) ────── │
│ ┌─────────────────────────┐ │
│ │ ☐ Lire 30 min           │ │
│ │   🔵 Dev perso  🔥 3j   │ │
│ └─────────────────────────┘ │
│                             │
│ ── Routines ─────────────── │  ← Section header
│ ┌─────────────────────────┐ │
│ │ 🏃 Routine Matin        │ │  ← AppCard: routine name + step count + duration
│ │   4 étapes · ~30 min    │ │
│ │   [ ▶ Lancer ]          │ │     AppButton.primary (l10n.startRoutine)
│ └─────────────────────────┘ │
│                             │
│ ── Tâches du jour ────────── │  ← Section header + count
│ ┌─────────────────────────┐ │
│ │ ☐ Acheter du lait       │ │  ← AppListTile: checkbox + title
│ │   🟢 Santé  ● Haute     │ │     Priority indicator (AppBadge)
│ ├─────────────────────────┤ │
│ │ ☐ Préparer réunion      │ │
│ │   🟠 Travail ● Moyenne  │ │
│ ├─────────────────────────┤ │
│ │ ⚠ Appeler dentiste      │ │  ← Overdue: red text (AppColors.error)
│ │   🟢 Santé  hier        │ │     Overdue date label
│ └─────────────────────────┘ │
│                             │
│ ── Sans horaire ──────────── │  ← Habits without time range
│ ┌─────────────────────────┐ │
│ │ ☐ Gratitude journal     │ │
│ │   🔵 Dev perso          │ │
│ └─────────────────────────┘ │
│                             │
├─────────────────────────────┤
│ 🏠  📋  [＋]  🔄  ✅      │  ← AppBottomNav (5 tabs, center FAB)
└─────────────────────────────┘
```

**Empty state** (no data at all):
```
┌─────────────────────────────┐
│ ☰   Aujourd'hui    🔔       │
├─────────────────────────────┤
│                             │
│       ┌───────────┐        │
│       │  📋  ☀️   │        │  ← AppEmptyState
│       └───────────┘        │
│                             │
│  Votre journée est vide !   │  ← l10n.todayEmpty (AppTextStyles.headlineSmall)
│  Commencez par créer votre  │
│  première habitude.         │  ← l10n.todayEmptySubtitle (AppTextStyles.bodyMedium)
│                             │
│  [ Créer une habitude ]     │  ← AppButton.primary → HabitFormView
│                             │
├─────────────────────────────┤
│ 🏠  📋  [＋]  🔄  ✅      │
└─────────────────────────────┘
```

---

## 2. HabitsView (Tab 1)

```
┌─────────────────────────────┐
│ ☰    Habitudes       🔍  ＋│  ← AppBar: title=l10n.habits, search + add actions
├─────────────────────────────┤
│                             │
│ [Toutes] [Santé] [Travail]  │  ← Domain filter chips (AppChip, horizontal scroll)
│                             │
│ ┌─────────────────────────┐ │
│ │ Méditer 10 min          │ │  ← AppListTile: swipeable
│ │ 🟢 Santé · Binaire      │ │     Domain chip + type label
│ │ 6h – 8h  🔥 12 jours   │ │     Time range + streak
│ │ ☐ Aujourd'hui           │ │     Quick check toggle for today
│ ├─────────────────────────┤ │
│ │ Boire 2L d'eau          │ │
│ │ 🟢 Santé · Quantitatif  │ │
│ │ Toute la journée        │ │     No time range → "Anytime"
│ │ ████████░░ 75%          │ │     AppProgress bar
│ ├─────────────────────────┤ │
│ │ Lire 30 pages           │ │
│ │ 🔵 Dev perso · Quanti.  │ │
│ │ 18h – 20h  🔥 3 jours  │ │
│ │ ░░░░░░░░░░ 0%           │ │
│ └─────────────────────────┘ │
│                             │
│ ── Archivées (2) ────────── │  ← Collapsed section, tap to expand
│                             │
├─────────────────────────────┤
│ 🏠  📋  [＋]  🔄  ✅      │
└─────────────────────────────┘
```

---

## 3. HabitFormView (Create / Edit)

```
┌─────────────────────────────┐
│ ←  Nouvelle habitude        │  ← AppBar: back + title (l10n.newHabit / l10n.editHabit)
├─────────────────────────────┤
│                             │
│ Nom *                       │
│ ┌─────────────────────────┐ │  ← AppTextField (required)
│ │ Méditer                 │ │
│ └─────────────────────────┘ │
│                             │
│ Description                 │
│ ┌─────────────────────────┐ │  ← AppTextField (optional, multiline)
│ │                         │ │
│ └─────────────────────────┘ │
│                             │
│ Type                        │
│ ○ Binaire  ● Quantitatif   │  ← SegmentedButton / Radio
│                             │
│ ┌── Quantitatif ──────────┐ │  ← Conditional section (shown if quantitative)
│ │ Objectif *    Unité *   │ │
│ │ ┌────────┐  ┌────────┐  │ │  ← AppTextField (number) + AppTextField
│ │ │ 2000   │  │ ml     │  │ │
│ │ └────────┘  └────────┘  │ │
│ └─────────────────────────┘ │
│                             │
│ Domaine                     │
│ ┌─────────────────────────┐ │  ← Tap → DomainPickerSheet
│ │ 🟢 Santé            ▼  │ │
│ └─────────────────────────┘ │
│                             │
│ Plage horaire               │
│ ┌───────────┐ ┌───────────┐ │  ← TimePicker × 2
│ │ Début: 6h │ │ Fin: 8h   │ │
│ └───────────┘ └───────────┘ │
│                             │
│ Fréquence                   │
│ [Quotidien ▼]               │  ← AppDropdown (daily/weekly/custom)
│                             │
│ ┌── Jours (weekly/custom) ┐ │  ← Conditional: day selector chips
│ │ L  Ma  Me  J  V  S  D  │ │     Toggle chips for each day
│ └─────────────────────────┘ │
│                             │
│ [ Enregistrer ]             │  ← AppButton.primary (full width)
│                             │
├─────────────────────────────┤
│         (no bottom nav)     │
└─────────────────────────────┘
```

---

## 4. RoutinesView (Tab 3)

```
┌─────────────────────────────┐
│ ☰    Routines        🔍  ＋│  ← AppBar
├─────────────────────────────┤
│                             │
│ ┌─────────────────────────┐ │
│ │ 🏃 Routine Matin        │ │  ← AppCard
│ │ 🟢 Santé                │ │     Domain chip
│ │ 4 étapes · ~30 min      │ │     Step count + total estimated duration
│ │                         │ │
│ │ [ ▶ Lancer ]  [ ✏ ]    │ │     AppButton.primary + edit icon button
│ ├─────────────────────────┤ │
│ │ 🌙 Routine Soir         │ │
│ │ 🔵 Dev perso            │ │
│ │ 3 étapes · ~20 min      │ │
│ │                         │ │
│ │ [ ▶ Lancer ]  [ ✏ ]    │ │
│ └─────────────────────────┘ │
│                             │
├─────────────────────────────┤
│ 🏠  📋  [＋]  🔄  ✅      │
└─────────────────────────────┘
```

---

## 5. RoutineFormView (Create / Edit)

```
┌─────────────────────────────┐
│ ←  Nouvelle routine         │  ← AppBar
├─────────────────────────────┤
│                             │
│ Nom *                       │
│ ┌─────────────────────────┐ │  ← AppTextField
│ │ Routine Matin           │ │
│ └─────────────────────────┘ │
│                             │
│ Description                 │
│ ┌─────────────────────────┐ │
│ │                         │ │
│ └─────────────────────────┘ │
│                             │
│ Domaine                     │
│ ┌─────────────────────────┐ │  ← Tap → DomainPickerSheet
│ │ 🟢 Santé            ▼  │ │
│ └─────────────────────────┘ │
│                             │
│ Étapes                      │  ← Section header
│ ┌─────────────────────────┐ │
│ │ ≡  1. Réveil     5 min  │ │  ← Drag handle + name + duration
│ │ ≡  2. Douche    10 min  │ │     ReorderableListView
│ │ ≡  3. Méditer   15 min  │ │
│ │ ≡  4. Petit-déj  0 min  │ │
│ └─────────────────────────┘ │
│                             │
│ [ ＋ Ajouter une étape ]   │  ← TextButton → StepFormDialog
│                             │
│ Durée totale: 30 min        │  ← Computed, AppTextStyles.labelLarge
│                             │
│ [ Enregistrer ]             │  ← AppButton.primary
│                             │
└─────────────────────────────┘
```

### StepFormDialog (Modal)

```
┌─────────────────────────┐
│   Nouvelle étape        │  ← Dialog title
│                         │
│ Nom *                   │
│ ┌─────────────────────┐ │
│ │ Douche              │ │
│ └─────────────────────┘ │
│                         │
│ Durée estimée (min) *   │
│ ┌─────────────────────┐ │
│ │ 10                  │ │
│ └─────────────────────┘ │
│                         │
│ Description             │
│ ┌─────────────────────┐ │
│ │                     │ │
│ └─────────────────────┘ │
│                         │
│ [Annuler]  [Ajouter]   │  ← AppButton.text + AppButton.primary
└─────────────────────────┘
```

---

## 6. RoutineRunnerView (Full Screen Overlay)

```
┌─────────────────────────────┐
│ ✕  Routine Matin    2/4    │  ← Close (abandon?) + title + step counter
├─────────────────────────────┤
│                             │
│                             │
│         ┌───────┐           │
│         │ 08:42 │           │  ← Timer countdown (large, AppTextStyles.displayLarge)
│         └───────┘           │     AppColors.primary when > 50% time left
│                             │     AppColors.warning when < 30%
│                             │     AppColors.error when < 10%
│                             │
│      ═══════════════        │  ← AppProgress.linear (time remaining)
│                             │
│   ┌───────────────────┐     │
│   │    🚿 Douche      │     │  ← Current step name (AppTextStyles.headlineMedium)
│   │   Durée: 10 min   │     │     Estimated duration label
│   └───────────────────┘     │
│                             │
│   Description de l'étape    │  ← Optional step description
│   si elle existe            │     (AppTextStyles.bodyMedium, muted color)
│                             │
│                             │
│  ┌───────────────────────┐  │
│  │     [ ▶ Suivant ]     │  │  ← AppButton.primary (large, full width)
│  └───────────────────────┘  │     "Terminer" on last step
│                             │
│  ── Progression ──────────  │
│  ✅ Réveil (5 min)          │  ← Completed steps (green check)
│  🔵 Douche (10 min) ◄──    │  ← Current step (highlighted)
│  ○  Méditer (15 min)        │  ← Upcoming steps (muted)
│  ○  Petit-déj (0 min)      │
│                             │
├─────────────────────────────┤
│  [ Passer ]   [ Abandonner ]│  ← Secondary actions
└─────────────────────────────┘
```

### Abandon Confirmation Dialog

```
┌─────────────────────────┐
│   Abandonner la routine?│
│                         │
│   Vous avez complété    │
│   2/4 étapes.           │
│   Un log sera sauvegardé│
│   avec le statut        │
│   "abandonné".          │
│                         │
│ [Continuer]  [Abandonner]│
└─────────────────────────┘
```

---

## 7. TasksView (Tab 4)

```
┌─────────────────────────────┐
│ ☰    Tâches          🔍  ＋│  ← AppBar
├─────────────────────────────┤
│                             │
│ [Toutes] [Santé] [Travail]  │  ← Domain filter chips
│                             │
│ [Actives ▼]                 │  ← Sort/filter dropdown: Actives, Terminées, Toutes
│                             │
│ ── En retard ───────────── │  ← Section: overdue (AppColors.error)
│ ┌─────────────────────────┐ │
│ │ ☐ Appeler dentiste      │ │  ← AppListTile
│ │   🟢 Santé  ● Haute     │ │     Priority badge (red for high)
│ │   📅 Hier               │ │     Overdue date in red
│ └─────────────────────────┘ │
│                             │
│ ── Aujourd'hui ──────────── │  ← Section: due today
│ ┌─────────────────────────┐ │
│ │ ☐ Acheter du lait       │ │
│ │   🟢 Santé  ● Haute     │ │
│ ├─────────────────────────┤ │
│ │ ☐ Préparer réunion      │ │
│ │   🟠 Travail ● Moyenne  │ │
│ └─────────────────────────┘ │
│                             │
│ ── À venir ─────────────── │  ← Section: future tasks
│ ┌─────────────────────────┐ │
│ │ ☐ Déclarer impôts       │ │
│ │   🟡 Finances ● Basse   │ │
│ │   📅 25 Fév             │ │
│ └─────────────────────────┘ │
│                             │
│ ── Sans date ──────────── │  ← Section: no due date
│ ┌─────────────────────────┐ │
│ │ ☐ Ranger le garage      │ │
│ │   🟢 Santé              │ │
│ └─────────────────────────┘ │
│                             │
├─────────────────────────────┤
│ 🏠  📋  [＋]  🔄  ✅      │
└─────────────────────────────┘
```

---

## 8. TaskFormView (Create / Edit)

```
┌─────────────────────────────┐
│ ←  Nouvelle tâche           │  ← AppBar
├─────────────────────────────┤
│                             │
│ Titre *                     │
│ ┌─────────────────────────┐ │  ← AppTextField
│ │ Acheter du lait         │ │
│ └─────────────────────────┘ │
│                             │
│ Description                 │
│ ┌─────────────────────────┐ │
│ │                         │ │
│ └─────────────────────────┘ │
│                             │
│ Domaine                     │
│ ┌─────────────────────────┐ │  ← Tap → DomainPickerSheet
│ │ 🟢 Santé            ▼  │ │
│ └─────────────────────────┘ │
│                             │
│ Priorité                    │
│ [Basse] [Moyenne] [Haute]   │  ← SegmentedButton (3 segments)
│                             │
│ Date d'échéance             │
│ ┌─────────────────────────┐ │  ← Tap → DatePicker
│ │ 📅 19 Fév 2026      ✕  │ │     Clear button to remove date
│ └─────────────────────────┘ │
│                             │
│ [ Enregistrer ]             │  ← AppButton.primary
│                             │
└─────────────────────────────┘
```

---

## 9. InboxView (FAB → Bottom Sheet or Dedicated Screen)

```
┌─────────────────────────────┐
│ ←  Inbox           📥 (3)  │  ← AppBar: title + pending count badge
├─────────────────────────────┤
│                             │
│ Capturer une idée           │
│ ┌───────────────────── 📤┐ │  ← AppTextField + send button
│ │ Appeler le dentiste     │ │     Auto-focus on open
│ └─────────────────────────┘ │     Submit → clear → ready for next
│                             │
│ ── En attente (3) ──────── │  ← Section header
│ ┌─────────────────────────┐ │
│ │ 📝 Acheter cadeau Marie │ │  ← AppListTile: tap → InboxTriageSheet
│ │    il y a 2h            │ │     Relative time
│ ├─────────────────────────┤ │
│ │ 📝 Idée article blog    │ │
│ │    il y a 5h            │ │
│ ├─────────────────────────┤ │
│ │ 📝 Appeler dentiste     │ │
│ │    à l'instant          │ │
│ └─────────────────────────┘ │
│                             │
│ ── Traités récemment ────── │  ← Collapsed section (optional, last 5)
│                             │
├─────────────────────────────┤
│ 🏠  📋  [＋]  🔄  ✅      │
└─────────────────────────────┘
```

---

## 10. InboxTriageSheet (Bottom Sheet)

```
┌─────────────────────────────┐
│ ─── TriageSheet ─────────── │  ← Drag handle
│                             │
│   "Appeler le dentiste"     │  ← raw_text display (AppTextStyles.titleMedium)
│    Capturé il y a 2h        │
│                             │
│ Que voulez-vous en faire ?  │  ← l10n.inboxTriagePrompt
│                             │
│ ┌─────────────────────────┐ │
│ │ 📋  Créer une tâche     │ │  ← Tap → TaskFormView (pre-filled title)
│ ├─────────────────────────┤ │
│ │ 🔄  Créer une habitude  │ │  ← Tap → HabitFormView (pre-filled name)
│ ├─────────────────────────┤ │
│ │ 🗑  Supprimer           │ │  ← Discard → status = 'discarded'
│ └─────────────────────────┘ │
│                             │
│ [ Annuler ]                 │  ← AppButton.text → close sheet
│                             │
└─────────────────────────────┘
```

---

## 11. DomainsView (Settings → Domains)

```
┌─────────────────────────────┐
│ ←  Domaines de vie      ＋  │  ← AppBar: back + add
├─────────────────────────────┤
│                             │
│ Glissez pour réordonner     │  ← Hint text (AppTextStyles.bodySmall, muted)
│                             │
│ ┌─────────────────────────┐ │
│ │ ≡ 🟢 Santé          ✏  │ │  ← Drag handle + color dot + name + edit
│ │ ≡ 🟠 Travail        ✏  │ │     ReorderableListView
│ │ ≡ 🔴 Relations      ✏  │ │
│ │ ≡ 🟡 Finances       ✏  │ │
│ │ ≡ 🔵 Dev perso      ✏  │ │
│ │ ≡ 🟣 Spiritualité   ✏  │ │  ← User-added domain
│ └─────────────────────────┘ │
│                             │
│ ── Archivés (1) ──────────  │  ← Collapsed section
│ ┌─────────────────────────┐ │
│ │   ⚫ Ancien domaine  ↩  │ │  ← Restore button
│ └─────────────────────────┘ │
│                             │
└─────────────────────────────┘
```

---

## 12. DomainPickerSheet (Bottom Sheet — reused in forms)

```
┌─────────────────────────────┐
│ ─── Choisir un domaine ──── │  ← Drag handle + title
│                             │
│ ┌─────────────────────────┐ │
│ │ 🟢 Santé               │ │  ← AppListTile, tap to select
│ │ 🟠 Travail              │ │
│ │ 🔴 Relations            │ │     Only non-archived domains shown
│ │ 🟡 Finances             │ │
│ │ 🔵 Développement perso  │ │
│ │ 🟣 Spiritualité         │ │
│ └─────────────────────────┘ │
│                             │
│ [ ＋ Nouveau domaine ]     │  ← Optional: inline create
│                             │
└─────────────────────────────┘
```

---

## 13. DomainFormDialog (Create / Edit Domain)

```
┌─────────────────────────┐
│   Nouveau domaine       │  ← Dialog title
│                         │
│ Nom *                   │
│ ┌─────────────────────┐ │
│ │ Spiritualité        │ │
│ └─────────────────────┘ │
│                         │
│ Icône                   │
│ [🎯] [💪] [📚] [💰]   │  ← Emoji grid picker (scrollable)
│ [❤️] [🧘] [🌟] [🏠]   │
│                         │
│ Couleur                 │
│ [🟢][🟠][🔴][🟡]      │  ← Color selector circles
│ [🔵][🟣][⚫][🟤]      │
│                         │
│ [Annuler]  [Créer]     │  ← AppButton.text + AppButton.primary
└─────────────────────────┘
```

---

## 14. Onboarding — Step 2: Domain Selection

```
┌─────────────────────────────┐
│        Étape 2/3            │  ← AppProgress.linear (66%)
├─────────────────────────────┤
│                             │
│  Choisissez vos domaines    │  ← AppTextStyles.headlineSmall
│  de vie                     │
│                             │
│  Sélectionnez les domaines  │  ← AppTextStyles.bodyMedium (muted)
│  que vous souhaitez suivre. │
│                             │
│ ┌─────────────────────────┐ │
│ │ ☑ 🟢 Santé             │ │  ← Checkbox tiles (pre-selected defaults)
│ │ ☑ 🟠 Travail           │ │
│ │ ☑ 🔴 Relations         │ │
│ │ ☑ 🟡 Finances          │ │
│ │ ☑ 🔵 Développement     │ │
│ └─────────────────────────┘ │
│                             │
│ [ ＋ Ajouter un domaine ]  │  ← Opens DomainFormDialog
│                             │
│                             │
│ [ Continuer ]               │  ← AppButton.primary → Step 3
│                             │
└─────────────────────────────┘
```

---

## 15. Onboarding — Step 3: First Habit

```
┌─────────────────────────────┐
│        Étape 3/3            │  ← AppProgress.linear (100%)
├─────────────────────────────┤
│                             │
│  Créez votre première       │  ← AppTextStyles.headlineSmall
│  habitude                   │
│                             │
│  Commencez simplement.      │  ← AppTextStyles.bodyMedium (muted)
│  Vous pourrez en ajouter    │
│  d'autres plus tard.        │
│                             │
│ Suggestions:                │
│ ┌─────────────────────────┐ │
│ │ 🧘 Méditer 10 min      │ │  ← Tap to pre-fill form below
│ │ 💧 Boire 2L d'eau      │ │
│ │ 📖 Lire 30 min         │ │
│ │ 🏃 Faire du sport      │ │
│ └─────────────────────────┘ │
│                             │
│ -- ou créez la vôtre --     │
│                             │
│ Nom *                       │
│ ┌─────────────────────────┐ │
│ │                         │ │  ← AppTextField
│ └─────────────────────────┘ │
│                             │
│ Domaine                     │
│ ┌─────────────────────────┐ │  ← Pre-select first domain
│ │ 🟢 Santé            ▼  │ │
│ └─────────────────────────┘ │
│                             │
│ [ Commencer ]               │  ← AppButton.primary → TodayView
│ [ Passer ]                  │  ← AppButton.text → TodayView (skip)
│                             │
└─────────────────────────────┘
```

---

## Design System Widget Mapping

| Screen Element | Widget | Token |
|----------------|--------|-------|
| Habit check toggle | Custom `HabitCheckTile` | AppListTile + Checkbox |
| Quantitative progress | `AppProgress.linear` | AppColors.primary fill |
| Domain label | `AppChip` | Domain.color as chip background |
| Streak indicator | `Icon` + `Text` | 🔥 + AppTextStyles.labelSmall |
| Priority badge | `AppBadge` | high=AppColors.error, medium=AppColors.warning, low=AppColors.success |
| Overdue indicator | `Text` | AppColors.error, AppTextStyles.bodySmall |
| Timer display | `Text` | AppTextStyles.displayLarge |
| Timer progress | `AppProgress.linear` | Color changes by remaining % |
| Empty state | `AppEmptyState` | icon + title + subtitle + CTA button |
| Section headers | `Text` | AppTextStyles.labelLarge, divider below |
| Form fields | `AppTextField` | Standard spacing (AppSpacing.md) |
| Primary actions | `AppButton.primary` | Full width in forms |
| Secondary actions | `AppButton.text` | Inline |
| Bottom navigation | `AppBottomNav` | 5 items, center FAB |
| Bottom sheets | `showModalBottomSheet` | AppRadius.lg top corners |
| Cards | `AppCard` | AppShadows.sm, AppRadius.md |
| Drag handles | `Icon(Icons.drag_handle)` | Muted color |

---

## Interaction Notes

1. **Swipe actions** — HabitsView and TasksView items: swipe left = archive, swipe right = quick action (check/complete).
2. **Pull to refresh** — All list views support pull-to-refresh (re-fetch from Supabase).
3. **Loading states** — All views show shimmer/skeleton loading (not spinners) during data fetch.
4. **Haptic feedback** — Checkbox toggles and timer transitions trigger light haptic.
5. **Transitions** — Form views slide up from bottom. Runner view is a full-screen route with fade-in.
6. **Keyboard** — InboxView auto-focuses text field on open. Forms dismiss keyboard on scroll.
