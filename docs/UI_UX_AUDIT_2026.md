# LifeFlow — Audit UI/UX Complet (Mars 2026)

> **Évaluateur** : GitHub Copilot (Claude Opus 4.6)
> **Date** : 5 mars 2026
> **Cible** : App Flutter LifeFlow (habit tracker) — pré-release Play Store
> **Méthodologie** : Lecture exhaustive de tous les fichiers source (20 vues, 26 widgets DS, 7 fichiers tokens, widgets custom)

---

## Note Globale : 4.1 / 10

---

## 1. Architecture du Design System — 7.5/10

### Points forts
- 26 widgets DS + 6 charts = bon catalogue
- 7 fichiers de tokens bien structurés (colors, typography, spacing, radius, shadows, animations, theme)
- Barrel export propre via `design_system.dart`
- Page showcase (`design_showcase_view.dart`) pour visualiser les composants
- `flutter_screenutil` + `clamp()` pour la typographie fluide

### Points faibles
- Aucun token `AppSizing` pour les tailles d'icônes/composants → ~15 valeurs hardcodées (`size: 20`, `size: 44`, `size: 100`, etc.)
- `AppAnimations` **défini mais jamais utilisé** dans les vues réelles (seul `splash_view.dart` utilise des transitions)
- Pas de token d'élévation standardisé malgré `AppShadows`

### Fichiers concernés
- `flutter/lib/design_system/tokens/` — tous les fichiers tokens
- `flutter/lib/design_system/widgets/` — 26 widgets
- `flutter/lib/ui/views/design_showcase/design_showcase_view.dart`

---

## 2. Charte Graphique / Branding — 7/10

### Points forts
- Palette Porsche-inspired cohérente : monochrome + rouge `#D5001C` distinctif
- Hiérarchie claire : primary/success/error/warning/info bien définis
- Inter (Google Fonts) = choix safe, lisible, moderne
- 3 poids (400/600/700) suffisants pour la hiérarchie

### Points faibles
- Palette monochrome + 1 accent = **visuellement monotone** pour une app de bien-être/habitudes
- Aucune couleur secondaire pour différencier les domaines d'habitudes (santé, sport, mindfulness, etc.)
- Le rouge Porsche comme seul accent est **agressif** pour du wellness — un vert, un bleu ou un gradient serait plus approprié
- Les illustrations SVG d'onboarding apportent de la chaleur mais le reste de l'app est froid

### Recommandation
Ajouter 4-6 couleurs de domaines dans `AppColors` (ex: `domainHealth`, `domainFitness`, `domainMindfulness`, `domainWork`, `domainSocial`, `domainCreativity`) utilisées pour les chips, icônes et barres de progression.

---

## 3. Mode Sombre — 3/10

### Verdict : **Cassé.**

### 20+ violations hardcodées trouvées

| Fichier | Ligne | Violation |
|---------|-------|-----------|
| `modules/auth/views/register_view.dart` | L186 | `AppColors.textSecondaryLight` |
| `modules/auth/widgets/auth_header.dart` | L72 | `AppColors.textSecondaryLight` |
| `modules/auth/views/login_view.dart` | L158 | `AppColors.textSecondaryLight` |
| `modules/auth/widgets/social_login_buttons.dart` | L216 | `AppColors.textSecondaryLight` |
| `modules/auth/widgets/auth_form_fields.dart` | L138 | `AppColors.textTertiaryLight` |
| `modules/auth/widgets/auth_form_fields.dart` | L238 | `AppColors.textSecondaryLight` |
| `modules/auth/widgets/auth_form_fields.dart` | L311 | `AppColors.textSecondaryLight` |
| `modules/auth/views/forgot_password_view.dart` | L164 | `AppColors.textSecondaryLight` |
| `modules/profile/widgets/profile_field_widget.dart` | L174 | `AppColors.textSecondaryLight` |
| `modules/profile/widgets/profile_field_widget.dart` | L315 | `AppColors.textSecondaryLight` |
| `modules/profile/views/profile_view.dart` | L94 | `AppColors.textSecondaryLight` |
| `modules/profile/views/profile_view.dart` | L206 | `AppColors.textSecondaryLight` |
| `modules/settings/views/settings_view.dart` | L229 | `AppColors.textPrimaryLight` |
| `modules/onboarding/views/onboarding_view.dart` | L55 | `AppColors.textSecondaryLight` |
| `modules/onboarding/widgets/onboarding_navigation.dart` | L50 | `AppColors.textSecondaryLight` |
| `modules/onboarding/widgets/onboarding_navigation.dart` | L124 | `AppColors.textSecondaryLight` |
| `modules/onboarding/widgets/onboarding_slide_widget.dart` | L63 | `AppColors.textSecondaryLight` |
| `modules/onboarding/widgets/onboarding_slide_widget.dart` | L191 | `AppColors.textSecondaryLight` |
| `ui/dialogs/info_alert/info_alert_dialog.dart` | L29 | `Colors.white` hardcodé |
| `ui/dialogs/info_alert/info_alert_dialog.dart` | L55 | `AppColors.textSecondaryLight` |
| `ui/dialogs/info_alert/info_alert_dialog.dart` | L85 | `Colors.black` hardcodé |
| `ui/dialogs/info_alert/info_alert_dialog.dart` | L91 | `Colors.white` hardcodé |

### Correctif attendu
Remplacer `AppColors.textSecondaryLight` → `AppColors.textSecondary(Theme.of(context).brightness)` partout.
Remplacer `Colors.white` / `Colors.black` → `Theme.of(context).colorScheme.surface` / `Theme.of(context).colorScheme.onSurface`.

### Note
Le helper `AppColors.textSecondary(brightness)` **existe déjà** dans `app_colors.dart`. Il suffit de l'utiliser. Les violations montrent que les développeurs ne connaissent pas (ou ignorent) les helpers disponibles.

---

## 4. Micro-interactions & Animations — 2/10

### Verdict : **Vide.**

- **0** `AnimatedSwitcher` dans tout le code utilisateur
- **0** `AnimatedCrossFade`
- **0** `AnimatedOpacity`
- Seul `splash_view.dart` utilise `SlideTransition` + `FadeTransition`
- `AppAnimations` définit des courbes, durées et builders... **qui ne sont jamais appelés**

### Interactions sans animation
| Action | Attendu 2026 | Actuel |
|--------|-------------|--------|
| Cocher habitude | Checkmark animé + scale bounce + confetti optionnel | Changement d'état instantané |
| Atteindre 100% | Celebration animation + haptic burst | Rien |
| Changer onglet TodayView (matin/progression/bilan) | Fade ou slide transition | Cut sec |
| Filtrer par domaine (HabitsView) | AnimatedList / fade | Cut sec |
| Compteur semaine (CounterView) | Animated counter / progress ring | Affichage statique |
| Apparition de carte | Staggered fade-in | Tout apparaît d'un coup |

### Recommandation prioritaire
1. Ajouter `AnimatedSwitcher` sur le contenu du TodayView (mode switching)
2. Ajouter une animation de checkmark dans `HabitCheckTile` (scale bounce via `AnimatedScale`)
3. Ajouter `AnimatedList` dans HabitsView pour les ajouts/suppressions
4. Utiliser les builders de `AppAnimations` déjà définis

---

## 5. Feedback Haptique — 0/10

### Verdict : **Inexistant.**

`HapticFeedback` n'apparaît **nulle part** dans le codebase.

| Action | Feedback attendu |
|--------|-----------------|
| Cocher habitude binaire | `HapticFeedback.lightImpact()` |
| Incrémenter habitude quantitative | `HapticFeedback.selectionClick()` |
| Atteindre objectif | `HapticFeedback.heavyImpact()` |
| Valider formulaire | `HapticFeedback.mediumImpact()` |
| Erreur de validation | `HapticFeedback.vibrate()` |
| Long press | `HapticFeedback.selectionClick()` |

### Recommandation
Créer un service `HapticService` centralisé avec des méthodes sémantiques (`success()`, `selection()`, `error()`, `warning()`). L'enregistrer dans le locator. Respecter les préférences système (certains utilisateurs désactivent les vibrations).

---

## 6. Gestes — 1/10

- **0** `Dismissible` widget dans les vues utilisateur
- **0** `Slidable` (package `flutter_slidable` non installé)
- Pas de swipe-to-archive sur les habitudes
- Pas de swipe-to-dismiss sur les notifications
- Pas de pull-to-refresh visible sur les listes
- Pas de long-press pour actions rapides
- Le seul geste est le **tap**

### Recommandation
1. Ajouter `flutter_slidable` pour les actions contextuelles sur les habitudes (archive, edit, delete)
2. Ajouter `RefreshIndicator` sur TodayView et HabitsView
3. Ajouter long-press sur `HabitCheckTile` pour accéder aux détails rapides

---

## 7. Accessibilité — 1/10

- **0** widget `Semantics()` dans le code utilisateur
- Pas de `ExcludeSemantics` / `MergeSemantics` custom
- Pas de labels pour les screen readers
- Les icônes n'ont pas de `semanticLabel`
- Le contraste n'a jamais été audité
- Pas de support pour les tailles de texte système (large text)

### Recommandation
1. Ajouter `Semantics` sur tous les éléments interactifs
2. Ajouter `semanticLabel` sur toutes les `Icon` widgets
3. Auditer les contrastes WCAG 2.1 AA (ratio minimum 4.5:1 pour le texte, 3:1 pour les grands textes)
4. Tester avec TalkBack (Android) et VoiceOver (iOS)

---

## 8. Internationalisation (i18n) — 6/10

### Points forts
- Système ARB en place (`l10n.yaml` configuré)
- La majorité des strings passe par les fichiers de traduction

### Violations trouvées
| Fichier | String hardcodée | Langue |
|---------|-----------------|--------|
| `features/today/views/today_view.dart` | "✅ Faites" | FR |
| `features/today/views/today_view.dart` | "⏳ Restantes" | FR |
| `features/today/views/today_view.dart` | "📊 Aujourd'hui" | FR |
| `modules/profile/views/profile_view.dart` | "Profile Completion" | EN |
| `modules/profile/views/profile_view.dart` | "Export Data" | EN |
| `features/counter/views/counter_view.dart` | "Total" | EN |

### Problèmes additionnels
- Emojis dans les labels ("✅", "⏳", "📊") = mauvaise pratique i18n (non traduisibles, problèmes de rendu cross-platform)
- Mélange français/anglais dans les strings hardcodées

---

## 9. Formulaires & Validation — 6/10

### Points forts
- `AppTextField` du DS bien utilisé
- Validation inline présente
- `HabitFormView` avec les bons champs

### Points faibles
- Pas de scroll-to-first-error
- Pas d'animation sur les erreurs de champ (shake, highlight)
- Pas de sauvegarde draft automatique
- Gestion du clavier non vérifiée (padding bottom quand clavier ouvert)

---

## 10. Navigation & Architecture Écrans — 6.5/10

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

## 11. Discipline des Tokens — 5/10

| Aspect | Respect estimé | Commentaire |
|--------|---------------|-------------|
| Couleurs sémantiques | ~70% | Cassé par les 20+ hardcodés `Light`/`Dark` |
| Spacing (`AppSpacing`, `AppGaps`) | ~85% | Bien utilisé |
| Typographie (`AppTypography`) | ~80% | Quelques `TextStyle(fontSize: 16)` hardcodés |
| Radius (`AppRadius`) | ~90% | Bon |
| Tailles d'icônes/composants | ~30% | Pas de token `AppSizing`, tout est magique |
| Animations | ~5% | Tokens définis, jamais utilisés |

---

## 12. Perception Utilisateur (Fluidité & Friction) — 4.5/10

### Frictions identifiées
1. **Cocher habitude** → aucun feedback visuel/haptique → "est-ce que ça a marché ?"
2. **Ajouter habitude** → retour à la liste sans animation de confirmation
3. **Mode sombre** → texte potentiellement illisible (20+ violations)
4. **Pas de recherche** quand on a 20+ habitudes
5. **Emojis dans les labels** font "prototype scolaire"
6. **Pas de geste naturel** (swipe, long press pour actions rapides)
7. **Transitions entre états** = cuts secs, pas d'interpolation
8. **info_alert_dialog** a `Colors.white` et `Colors.black` hardcodés → cassé en dark mode

---

## Récapitulatif des Notes

| # | Critère | Note /10 |
|---|---------|----------|
| 1 | Architecture Design System | 7.5 |
| 2 | Charte graphique / Branding | 7.0 |
| 3 | Mode sombre | 3.0 |
| 4 | Micro-interactions & Animations | 2.0 |
| 5 | Feedback haptique | 0.0 |
| 6 | Gestes | 1.0 |
| 7 | Accessibilité | 1.0 |
| 8 | i18n | 6.0 |
| 9 | Formulaires & Validation | 6.0 |
| 10 | Navigation & Architecture | 6.5 |
| 11 | Discipline tokens | 5.0 |
| 12 | Fluidité perçue | 4.5 |
| | **Moyenne** | **4.1** |

---

## Priorités de Correction

### P0 — Bloquant release (à faire immédiatement)
1. Corriger les 20+ violations dark mode (`textSecondaryLight` → `textSecondary(brightness)`)
2. Remplacer `Colors.white` / `Colors.black` hardcodés → tokens thème
3. Extraire les strings hardcodées vers les fichiers ARB

### P1 — Qualité perçue (avant release)
4. Ajouter des micro-animations sur les interactions clés (check, mode switch, filter)
5. Ajouter le feedback haptique (`HapticService`)
6. Créer token `AppSizing` pour standardiser les tailles

### P2 — Différenciation (post-release v1.1)
7. Gestes avancés (swipe-to-archive, pull-to-refresh, long-press)
8. Accessibilité (`Semantics`, contraste WCAG, TalkBack/VoiceOver)
9. Couleurs de domaines pour les habitudes
10. Recherche dans la liste des habitudes

---

## Conclusion

L'**infrastructure** est solide (tokens, widgets DS, architecture MVVM, event bus). Mais l'**expérience utilisateur** est celle d'un MVP fonctionnel, pas d'une app prête pour le Play Store en 2026.

Les manques critiques :
1. **Mode sombre cassé** — 20+ violations, le helper existe mais n'est pas utilisé
2. **Zéro animation** — `AppAnimations` décoratif, jamais appelé
3. **Zéro feedback haptique** — standard attendu en 2026
4. **Zéro geste avancé** — tap-only UX
5. **Zéro accessibilité** — aucun `Semantics` widget

L'app fonctionne. Elle ne **délecte** pas.
