# LifeFlow — Audit UI/UX Complet (Mars 2026)

> **Évaluateur** : GitHub Copilot (Claude Opus 4.6)
> **Date initiale** : 5 mars 2026
> **Mise à jour** : 6 mars 2026 (post-correctifs Phase 22)
> **Cible** : App Flutter LifeFlow (habit tracker) — pré-release Play Store
> **Méthodologie** : Lecture exhaustive de tous les fichiers source (20 vues, 26 widgets DS, 8 fichiers tokens, widgets custom)

---

## Note Globale : 6.7 / 10 (↑ de 4.1)

---

## 1. Architecture du Design System — 8.5/10 (↑ de 7.5)

### Points forts
- 26 widgets DS + 6 charts = bon catalogue
- **8 fichiers de tokens** bien structurés (colors, typography, spacing, radius, shadows, animations, theme, **sizing**)
- Barrel export propre via `design_system.dart`
- Page showcase (`design_showcase_view.dart`) pour visualiser les composants
- `flutter_screenutil` + `clamp()` pour la typographie fluide
- ✅ **CORRIGÉ** : `AppSizing` créé avec ~30 tokens (icônes, avatars, touch targets, progress, badges, misc)
- ✅ **CORRIGÉ** : `AppAnimations` maintenant utilisé dans TodayView (AnimatedSwitcher), TodayHabitsSection (staggered fade-in), HabitCheckTile (AnimatedScale)

### Points faibles restants
- Pas de token d'élévation standardisé malgré `AppShadows`
- `AppSizing` pas encore systématiquement utilisé dans toutes les vues (adoption progressive)

---

## 2. Charte Graphique / Branding — 8.5/10 (↑ de 7.0)

### Points forts
- ✅ **CHANGÉ** : Palette teal wellness — `#0D9488` primary remplace l'ancien rouge Porsche `#D5001C`
- Variants cohérents : primaryLight=#14B8A6, primaryDark=#0F766E, primaryContainer=#E6F7F5
- Inter (Google Fonts) = choix safe, lisible, moderne
- 3 poids (400/600/700) suffisants pour la hiérarchie
- ✅ **AJOUTÉ** : 6 couleurs de domaines (health=#10B981, fitness=#F59E0B, mindfulness=#8B5CF6, work=#3B82F6, social=#EC4899, creativity=#F97316)
- Map `domainColors` pour accès dynamique par nom

### Points faibles restants
- Les couleurs de domaines ne sont pas encore utilisées partout dans l'UI (chips, progress bars)
- Les illustrations SVG d'onboarding ne correspondent plus à la palette teal (à vérifier)

---

## 3. Mode Sombre — 8.5/10 (↑ de 3.0)

### Verdict : **Corrigé.**

✅ **20 violations corrigées** : Toutes les occurrences de `AppColors.textSecondaryLight` et `AppColors.textTertiaryLight` remplacées par les helpers brightness-aware.

| Fichier | Correction |
|---------|-----------|
| `modules/auth/views/register_view.dart` | ✅ `textSecondary(brightness)` |
| `modules/auth/widgets/auth_header.dart` | ✅ `textSecondary(brightness)` |
| `modules/auth/views/login_view.dart` | ✅ `textSecondary(brightness)` |
| `modules/auth/widgets/social_login_buttons.dart` | ✅ 2 fixes + Divider borderLight |
| `modules/auth/widgets/auth_form_fields.dart` | ✅ 3 fixes (textTertiaryLight, 2× textSecondaryLight) |
| `modules/auth/views/forgot_password_view.dart` | ✅ `textSecondary(brightness)` |
| `modules/profile/widgets/profile_field_widget.dart` | ✅ 2 fixes |
| `modules/profile/views/profile_view.dart` | ✅ 2 fixes |
| `modules/settings/views/settings_view.dart` | ✅ `context.colorScheme.onSurface` |
| `modules/onboarding/views/onboarding_view.dart` | ✅ `textSecondary(brightness)` |
| `modules/onboarding/widgets/onboarding_navigation.dart` | ✅ 2 fixes |
| `modules/onboarding/widgets/onboarding_slide_widget.dart` | ✅ 2 fixes |
| `ui/dialogs/info_alert/info_alert_dialog.dart` | ✅ `Colors.white`→`colorScheme.surface`, `Colors.black`→`colorScheme.onSurface` |
| `ui/bottom_sheets/notice/notice_sheet.dart` | ✅ `Colors.white`→`colorScheme.surface` |

### Points faibles restants
- Certains widgets DS internes (non-utilisateur) pourraient encore contenir des refs -Light/-Dark
- Le contraste en mode sombre n'a pas été audité avec un outil WCAG

---

## 4. Micro-interactions & Animations — 5.0/10 (↑ de 2.0)

### Corrections appliquées
- ✅ `AnimatedSwitcher` sur le header TodayView (mode morning/progress/bilan)
- ✅ `AnimatedSwitcher` sur le contenu TodayView (mode switching)
- ✅ `AnimatedScale` sur le checkbox dans `HabitCheckTile` (toggle animation)
- ✅ `AnimatedOpacity` sur les tiles complétées dans TodayView
- ✅ Staggered fade-in avec `TweenAnimationBuilder` sur les habit tiles dans `TodayHabitsSection`
- ✅ `ValueKey` ajoutés pour que AnimatedSwitcher détecte les changements de mode
- ✅ `AppAnimations` tokens maintenant réellement utilisés (durations, curves)

### Ce qui manque encore
| Action | Attendu 2026 | Actuel |
|--------|-------------|--------|
| Atteindre 100% | Celebration animation + confetti | Rien |
| Filtrer par domaine (HabitsView) | AnimatedList / fade | Cut sec |
| Compteur semaine (CounterView) | Animated counter / progress ring | Affichage statique |
| Ajout/suppression d'habitude | AnimatedList insert/remove | Rebuild complet |

---

## 5. Feedback Haptique — 7.0/10 (↑ de 0.0)

### Corrections appliquées
- ✅ `HapticService` créé (`flutter/lib/services/haptic_service.dart`)
- ✅ Enregistré comme `LazySingleton` dans le locator (app.dart)
- ✅ Méthodes sémantiques : `success()`, `error()`, `selection()`, `light()`, `warning()`
- ✅ Intégré dans `HabitFormViewModel` : `success()` on save, `error()` on failure
- ✅ Intégré dans `TodayViewModel.toggleHabit()` : `success()` on check, `light()` on uncheck
- ✅ Intégré dans `HabitsViewModel.toggleHabit()` : `success()` on check, `light()` on uncheck
- ✅ Intégré dans `HabitsViewModel.archiveHabit()` : `warning()` on archive, `success()` on done

### Ce qui manque encore
- Haptic sur incrémentation compteur quantitatif
- Haptic sur changement d'onglet bottom nav (selection click)
- Haptic sur pull-to-refresh
- Pas de vérification des préférences système (certains users désactivent les vibrations)

---

## 6. Gestes — 5.0/10 (↑ de 1.0)

### Corrections appliquées
- ✅ `RefreshIndicator` sur TodayView (déjà présent) + ajouté sur HabitsView
- ✅ `Dismissible` sur les habit tiles dans HabitsView (swipe-to-archive avec confirmation)
- ✅ Background reveal avec icône archive et couleur warning

### Ce qui manque encore
- `flutter_slidable` non installé (utilisation du Dismissible natif comme compromis)
- Pas de swipe-to-dismiss sur les notifications
- Pas de long-press pour actions rapides
- Pas de glisser-déposer pour réorganiser les habitudes

---

## 7. Accessibilité — 4.0/10 (↑ de 1.0)

### Corrections appliquées
- ✅ `Semantics` sur `HabitCheckTile` (label="{name}, completed/not completed", button=true)
- ✅ `Semantics` sur `AppBottomNav` items (label, button, selected)
- ✅ `Tooltip` sur les items de navigation bottom bar
- ✅ `AppFab` supportait déjà le `tooltip` (confirmé)

### Ce qui manque encore
- `semanticLabel` manquant sur la majorité des widgets `Icon`
- Pas d'audit de contraste WCAG 2.1 AA
- Pas de test TalkBack / VoiceOver
- `ExcludeSemantics` / `MergeSemantics` non utilisés pour optimiser l'arbre
- Support tailles de texte système (large text) non vérifié

---

## 8. Internationalisation (i18n) — 8.0/10 (↑ de 6.0)

### Corrections appliquées
- ✅ "✅ Faites" → `l10n.todayDone` (EN: "Done", FR: "Faites")
- ✅ "⏳ Restantes" → `l10n.todayRemaining` (EN: "Remaining", FR: "Restantes")
- ✅ "Profile Completion" → `l10n.profileCompletion`
- ✅ "Export Data" → `l10n.exportData`
- ✅ "Total: ${time}" → `l10n.counterTotalWithTime(time)` avec placeholder
- ✅ "vs sem. dernière" → `l10n.counterDeltaVsLastWeek(delta)` avec placeholder
- ✅ Emojis supprimés des labels (clean text via ARB)

### Points forts
- Système ARB complet avec `@placeholders` pour les strings paramétrisées
- Fichiers EN + FR maintenus en parallèle

### Points faibles restants
- Quelques strings FR probablement encore hardcodées dans des messages d'erreur
- Certains `slot.label` dans les enums ne passent pas par l10n
- Emojis dans les greetings (👋, 🎯, 🌙) restent hardcodés (acceptable mais non-i18n)

---

## 9. Formulaires & Validation — 6.0/10 (inchangé)

### Points forts
- `AppTextField` du DS bien utilisé
- Validation inline présente
- `HabitFormView` avec les bons champs
- ✅ `HapticService` feedback sur save success/error

### Points faibles
- Pas de scroll-to-first-error
- Pas d'animation sur les erreurs de champ (shake, highlight)
- Pas de sauvegarde draft automatique
- Gestion du clavier non vérifiée (padding bottom quand clavier ouvert)

---

## 10. Navigation & Architecture Écrans — 6.5/10 (inchangé)

### Points forts
- `IndexedStack` + `AppBottomNav` = navigation fluide entre onglets (pas de rebuild)
- `HabitEventService` → cross-view refresh bien câblé
- Routage Stacked classique et fonctionnel
- Push navigation pour détails/formulaires

### Points faibles
- Pas de recherche dans la liste des habitudes
- Pas de tri/filtres avancés (par fréquence, par progression)
- Le TodayView change de mode par heure (matin/progression/bilan) → l'utilisateur ne peut pas naviguer manuellement entre ces modes
- Pas de deep linking fonctionnel vers une habitude spécifique depuis une notification

---

## 11. Discipline des Tokens — 7.0/10 (↑ de 5.0)

| Aspect | Respect estimé | Commentaire |
|--------|---------------|-------------|
| Couleurs sémantiques | ~95% | ✅ Toutes les violations hardcodées corrigées |
| Spacing (`AppSpacing`, `AppGaps`) | ~85% | Bien utilisé |
| Typographie (`AppTypography`) | ~80% | Quelques `TextStyle(fontSize: 16)` hardcodés restants |
| Radius (`AppRadius`) | ~90% | Bon |
| Tailles d'icônes/composants | ~50% | ✅ `AppSizing` créé mais adoption en cours |
| Animations | ~40% | ✅ Tokens utilisés dans 4 fichiers (TodayView, TodayHabitsSection, HabitCheckTile) |

---

## 12. Perception Utilisateur (Fluidité & Friction) — 6.5/10 (↑ de 4.5)

### Frictions corrigées
1. ✅ **Cocher habitude** → haptic feedback success + scale animation sur checkbox
2. ✅ **Ajouter habitude** → haptic success sur save réussi, haptic error sur échec
3. ✅ **Mode sombre** → toutes les violations corrigées, texte lisible partout
4. ✅ **Transitions entre modes** → AnimatedSwitcher smooth header + content
5. ✅ **info_alert_dialog** → utilise les tokens colorScheme
6. ✅ **Swipe-to-archive** → Dismissible sur les habitudes dans HabitsView
7. ✅ **Pull-to-refresh** → RefreshIndicator sur HabitsView + TodayView
8. ✅ **Staggered load** → Habit tiles apparaissent avec fade-in progressif

### Frictions restantes
1. **Pas de recherche** quand on a 20+ habitudes
2. **Compteur** reste statique (pas d'animation numérique)
3. **Pas de celebration** à 100% completion
4. **Emojis dans les greetings** → "👋", "🎯", "🌙" restent hardcodés (acceptable mais non-i18n)

---

## Récapitulatif des Notes

| # | Critère | Avant | Après | Delta |
|---|---------|-------|-------|-------|
| 1 | Architecture Design System | 7.5 | 8.5 | +1.0 |
| 2 | Charte graphique / Branding | 7.0 | 8.5 | +1.5 |
| 3 | Mode sombre | 3.0 | 8.5 | +5.5 |
| 4 | Micro-interactions & Animations | 2.0 | 5.0 | +3.0 |
| 5 | Feedback haptique | 0.0 | 7.0 | +7.0 |
| 6 | Gestes | 1.0 | 5.0 | +4.0 |
| 7 | Accessibilité | 1.0 | 4.0 | +3.0 |
| 8 | i18n | 6.0 | 8.0 | +2.0 |
| 9 | Formulaires & Validation | 6.0 | 6.0 | — |
| 10 | Navigation & Architecture | 6.5 | 6.5 | — |
| 11 | Discipline tokens | 5.0 | 7.0 | +2.0 |
| 12 | Fluidité perçue | 4.5 | 6.5 | +2.0 |
| | **Moyenne** | **4.1** | **6.7** | **+2.6** |

---

## Changements Appliqués (Phase 22)

### P0 — Bloquant release ✅
1. ✅ 20 violations dark mode corrigées (`textSecondaryLight` → `textSecondary(brightness)`)
2. ✅ `Colors.white` / `Colors.black` hardcodés → tokens colorScheme
3. ✅ 6 strings hardcodées extraites vers ARB (avec placeholders)
4. ✅ Couleur primaire changée de rouge #D5001C à teal #0D9488

### P1 — Qualité perçue ✅
5. ✅ Animations : AnimatedSwitcher, AnimatedScale, AnimatedOpacity, staggered TweenAnimationBuilder
6. ✅ HapticService : créé, enregistré, intégré dans 3 ViewModels
7. ✅ AppSizing : fichier token créé avec ~30 tokens standardisés
8. ✅ 6 couleurs de domaines ajoutées à AppColors

### P2 — Différenciation (partiel)
9. ✅ Gestes : RefreshIndicator, Dismissible swipe-to-archive
10. ✅ Accessibilité basique : Semantics + Tooltip sur bottom nav et HabitCheckTile

---

## Priorités Restantes

### Pour atteindre 8.0/10 :
1. **Animations** : AnimatedList pour ajout/suppression, animation compteur CounterView
2. **Accessibilité** : semanticLabel sur tous les Icons, audit WCAG contraste, test TalkBack
3. **Gestes** : Long-press sur habitudes, swipe-to-dismiss notifications, flutter_slidable
4. **i18n** : Extraire les labels d'enum restants, supprimer les emojis des greetings
5. **Formulaires** : Scroll-to-error, animation shake sur erreur, sauvegarde draft

### Pour atteindre 9.0/10 :
6. **Celebration** : Animation + confetti quand 100% des habitudes sont complétées
7. **Recherche** : Barre de recherche dans HabitsView
8. **Deep linking** : Navigation vers habitude depuis notification push
9. **Compteur animé** : Progress ring animé + counter numérique
10. **Design system** : Migrer toutes les tailles hardcodées vers AppSizing
