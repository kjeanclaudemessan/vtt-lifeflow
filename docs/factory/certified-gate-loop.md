# Certified Gate Loop — Partie 1 : Fondations & Boucle de Validation

> **"Le code ne passe PAS à la tâche suivante tant que les gates de la tâche actuelle ne sont pas verts."**

**Version :** 1.0  
**Date :** 16 Mars 2026  
**Statut :** Conception  
**Prérequis :** SpecKit Workflow, Constitution LifeFlow v2.0  
**Suite :** [Partie 2 — Wireframes, Validation Visuelle & Vision Complète](certified-gate-loop-part2.md)  

---

## Table des Matières

1. [Le Problème](#1-le-problème)
2. [Diagnostic : Où l'IA Dérape](#2-diagnostic--où-lia-dérape)
3. [Le Concept : Certified Gate Loop](#3-le-concept--certified-gate-loop)
4. [La Pyramide des 6 Niveaux de Certitude](#4-la-pyramide-des-6-niveaux-de-certitude)
5. [Les 7 Dérives Courantes de l'IA](#5-les-7-dérives-courantes-de-lia)
6. [Les 4 Niveaux de Gates](#6-les-4-niveaux-de-gates)
7. [Les Parties Nécessitant Validation Humaine](#7-les-parties-nécessitant-validation-humaine)
8. [Stratégie d'Encodage du "Goût" — L'IA Qui Décide Comme Moi](#8-stratégie-dencodage-du-goût--lia-qui-décide-comme-moi)
9. [La Boucle Complète — Vision Synthétique](#9-la-boucle-complète--vision-synthétique)
10. [Stratégie d'Implémentation Incrémentale](#10-stratégie-dimplémentation-incrémentale)
11. [Questions de Design à Trancher](#11-questions-de-design-à-trancher)

---

## 1. Le Problème

### 1.1 L'état actuel : un système documentaire, pas exécutable

Le projet dispose d'un excellent système **documentaire** :

- Constitution (`.specify/memory/constitution.md`) — les règles suprêmes
- Instructions (`.github/instructions/*.instructions.md`) — 14+ fichiers de patterns
- Agents (`.github/agents/`) — 9 agents SpecKit + 9 agents Flutter
- Quality Gates — checklists dans la constitution
- SpecKit Pipeline — specify → plan → tasks → implement

**Mais il a un défaut fondamental :** les règles sont des textes que l'IA *devrait* lire, pas des **barrières qu'elle ne peut pas franchir**.

```
Aujourd'hui :

  constitution.md ──┐
  instructions/*.md ─┼── L'IA les LIT ──→ Génère du code ──→ Espère que c'est bon
  plan.md ──────────┘        ↑                                      ↓
                        (parfois                               Pas vérifié
                         elle oublie)                          automatiquement
```

### 1.2 Le gap par phase

| Phase | Validation actuelle | Gap |
|-------|-------------------|-----|
| **Avant** le code | `check-prerequisites.ps1` valide les docs | Excellent, aucun gap |
| **Pendant** le code | Rien. L'IA code, on espère | **Le trou noir** |
| **Après** le code | `speckit.analyze` (lecture seule, docs only) | Ne valide pas le CODE produit |

### 1.3 Le coût de ne rien faire

Sans validation automatique, chaque tâche produite par l'IA nécessite une relecture manuelle. Sur 100 tâches, ça représente des heures de review. Et certaines dérives passent quand même à travers l'oeil humain fatigué.

---

## 2. Diagnostic : Où l'IA Dérape

### 2.1 Les 3 types de dérive

| Type | Description | Exemple |
|------|-------------|---------|
| **Oubli de contexte** | Sur une longue session, l'IA "oublie" des instructions lues il y a 50 messages | Tâche 1 : i18n parfait. Tâche 20 : strings hardcodées |
| **Raccourcis** | L'IA prend le chemin le plus rapide | Hardcode une couleur, skip l'i18n, met de la logique dans la vue |
| **Interprétation** | L'IA comprend différemment une règle ambiguë | Invente un composant `AppLoaderButton` qui n'existe pas dans le DS |

### 2.2 Le pattern temporel de dégradation

```
Tâche 1-5 :  ✅ i18n, ✅ haptic, ✅ animations, ✅ accessibility
Tâche 6-10:  ✅ i18n, ✅ haptic, ❌ animations, ❌ accessibility
Tâche 11+ :  ✅ i18n, ❌ haptic, ❌ animations, ❌ accessibility
```

L'IA perd progressivement les standards les moins "visibles" (accessibility, haptics) tout en conservant les plus évidents (i18n, compilation).

---

## 3. Le Concept : Certified Gate Loop

### 3.1 Principe fondamental

> **Le code ne passe PAS à la tâche suivante tant que les gates de la tâche actuelle ne sont pas verts.**

Les règles ne sont plus des *suggestions documentaires* — elles deviennent des **scripts exécutables qui retournent PASS ou FAIL**.

### 3.2 La boucle pour chaque tâche

```
Pour chaque Tâche Ti dans tasks.md :

  ┌──────────────────────────────────────────────────────┐
  │                                                      │
  │  1. CHARGER ── Règles applicables au type de fichier │
  │       ↓                                              │
  │  2. CODER ── Générer/modifier le code                │
  │       ↓                                              │
  │  3. VALIDER ── Exécuter les gate-checks              │
  │       ↓                                              │
  │  ┌─ 4. GATE ── Tous les checks passent ?             │
  │  │      │                                            │
  │  │   NON → 5. DIAGNOSTIQUER (quel check, quel file)  │
  │  │      │                                            │
  │  │      → 6. CORRIGER (ciblé sur l'erreur exacte)    │
  │  │      │                                            │
  │  └──────┘  (max 3 itérations, sinon STOP + rapport)  │
  │                                                      │
  │  OUI → 7. CERTIFIER ── Marquer [X] dans tasks.md    │
  │                                                      │
  └──────────────────────────────────────────────────────┘
                        ↓
                  Tâche suivante Ti+1
```

### 3.3 Pourquoi cette approche est "certaine"

1. **Les règles ne sont pas des suggestions** — Ce sont des scripts exécutables qui retournent 0 ou 1
2. **L'IA ne peut pas "oublier"** — Même si elle génère du code non-conforme, le gate le détecte en 2 secondes
3. **La correction est ciblée** — Le gate dit "fichier X, ligne Y, règle Z violée" → l'IA corrige chirurgicalement
4. **Le nombre d'itérations est borné** — Max 3, sinon STOP avec rapport. Pas de boucle infinie
5. **Le code ne progresse que si c'est vert** — Chaque `[X]` dans tasks.md est garanti conforme
6. **C'est testable sans IA** — On peut lancer `verify-gates --scope=all` soi-même à tout moment

---

## 4. La Pyramide des 6 Niveaux de Certitude

```
                    ▲
                   /6\    DÉPLOIEMENT
                  /   \   "L'app est publiée et live"
                 /─────\
                /  5    \  VISUEL / UX
               / "L'app  \ "L'app est belle et cohérente
              /  se lance  \ dans l'émulateur"
             /──── et ──────\
            /  4  marche"    \  COMPORTEMENTAL
           / "Le test passe,  \ "Le workflow métier fonctionne"
          /  l'action produit  \
         /─── le bon résultat ──\
        /  3  ARCHITECTURAL      \  "Les couches se respectent,
       /  "Le code est dans le    \ les dépendances sont correctes"
      /─── bon tiroir" ───────────\
     /  2  PATTERN STRUCTUREL      \  "Chaque fichier suit SON pattern"
    / "Entity a Equatable, Model a  \
   /── toJson, View n'a pas de ─────\
  / 1  logique"   COMPILATION        \  "Ça compile, c'est formaté"
 / "dart analyze = 0, format = 0,     \
/─── supabase db reset = 0" ───────────\
```

### Couverture actuelle vs cible

| Niveau | Automatisable ? | Aujourd'hui | Le gap |
|--------|----------------|-------------|--------|
| **1. Compilation** | 100% | `dart analyze` + `format` dans constitution | Pas exécuté entre chaque tâche |
| **2. Pattern** | 95% | Règles dans les `.instructions.md` | Pas transformées en scripts grep |
| **3. Architecture** | 90% | Règles dans constitution | Pas de lint custom qui vérifie les imports |
| **4. Comportemental** | 80% | Tests d'intégration mandatés | Pas systématiquement exécutés |
| **5. Visuel/UX** | 40% | Agents ux-auditor, 12 dimensions | Requiert jugement humain ou vision IA |
| **6. Déploiement** | 70% | Plan dans ai-app-factory.md | Pas encore implémenté |

---

## 5. Les 7 Dérives Courantes de l'IA

### Dérive #1 : Le Raccourci de Prototypage

L'IA produit du code "qui marche" mais qui est un prototype :

```dart
// L'IA produit ça :
Text('Bienvenue !', style: TextStyle(fontSize: 24, color: Colors.blue))

// Au lieu de :
Text(context.l10n.welcomeGreeting, style: AppTypography.headlineMedium.copyWith(
  color: context.colorScheme.primary,
))
```

**Pourquoi ?** L'IA optimise pour la première solution fonctionnelle. Hardcoder est toujours plus rapide.

**Gate qui bloque :** Pattern structurel (grep) →
- `Colors\.` en dehors de `design_system/` = FAIL
- `TextStyle(fontSize` sans `AppTypography` = FAIL
- `Text('` ou `Text("` dans `features/` ou `modules/` = FAIL

---

### Dérive #2 : L'Empilement Plat

L'IA met tout dans un seul fichier, ou mélange les couches :

```dart
// L'IA met ça dans le ViewModel :
final response = await Supabase.instance.client
    .from('habits').select().eq('user_id', userId);
// Appel direct Supabase dans le ViewModel au lieu de passer par le repository
```

**Pourquoi ?** Chaque couche d'indirection est un effort supplémentaire pour l'IA.

**Gate qui bloque :** Architecture (analyse d'imports) →
- `viewmodel.dart` qui importe `supabase_flutter` = FAIL
- `_view.dart` qui importe `data/` = FAIL
- `domain/` qui importe autre chose que `equatable`, `dartz` = FAIL

---

### Dérive #3 : L'Oubli Progressif

Sur une session de 20+ tâches, l'IA commence bien (i18n, design system, haptics) puis "oublie" progressivement les standards moins évidents.

**Pourquoi ?** Le contexte se dilue. L'IA a 200k tokens de contexte, les premières instructions sont "loin".

**Gate qui bloque :** **Le gate ne se fatigue pas.** C'est LE point fort fondamental d'un script. Le check grep pour haptics est aussi strict à la tâche 30 qu'à la tâche 1. C'est pourquoi le gate doit tourner **après chaque tâche**, pas seulement à la fin.

---

### Dérive #4 : L'Invention Créative

L'IA invente un pattern qui n'existe pas dans les instructions :

```dart
// L'IA invente un "AppLoaderButton" qui n'existe pas dans le design system
AppLoaderButton(onTap: () => viewModel.save())

// Au lieu d'utiliser le composant existant :
AppButton.primary(label: l10n.save, onPressed: viewModel.save, isLoading: viewModel.isBusy)
```

**Pourquoi ?** L'IA est entraînée sur des millions de projets. Elle importe des patterns d'ailleurs.

**Gate qui bloque :** Pattern structurel →
- Liste blanche des composants DS autorisés : `AppButton`, `AppCard`, `AppTextField`, etc.
- Tout `App[A-Z]` qui n'est pas dans la liste = WARNING
- Tout `import` d'un package non listé dans `pubspec.yaml` = FAIL

---

### Dérive #5 : La State Machine Incomplète

L'IA gère le cas "content" et "loading" mais oublie "error" et "empty" :

```dart
// L'IA produit :
Widget builder(context, viewModel, child) {
  if (viewModel.isBusy) return AppSkeleton();
  return ListView(...); // et l'état erreur ? et l'état vide ?
}
```

**Pourquoi ?** "Happy path bias" — l'IA code le scénario qui marche d'abord.

**Gate qui bloque :** Pattern structurel →
- Tout `_view.dart` doit contenir les patterns `hasError` + `isBusy` + `isEmpty` (ou un helper `StateBuilder`)
- Grep : si `_view.dart` contient `isBusy` mais pas `hasError` = FAIL

---

### Dérive #6 : La Réactivité Oubliée

L'IA crée un CRUD parfait mais oublie de notifier les autres écrans :

```dart
// Crée l'habitude en DB... mais la liste des habitudes ne se rafraîchit pas
await _habitRepository.create(habit);
// Manque : _habitEventService.notifyChanged();
```

**Pourquoi ?** La réactivité cross-écran est un concept architectural avancé que l'IA ne voit pas depuis un seul fichier.

**Gate qui bloque :** Pattern structurel →
- Tout `create(`, `update(`, `delete(` dans un `_repository_impl.dart` dont le résultat est `Right(` doit être suivi dans le ViewModel d'un `notifyChanged()` — plus complexe à grep, mais faisable avec de l'AST ou des patterns regex multi-lignes.

---

### Dérive #7 : Le "Ça Compile, C'est Fini"

L'IA termine une tâche parce que `dart analyze` passe, mais l'écran n'a aucune animation, aucun haptic, aucune personality.

**Pourquoi ?** L'IA confond "pas d'erreur" avec "terminé".

**Gate qui bloque :** C'est ici que la **checklist 3-Layer** entre en jeu :
- Layer 1 (Fonctionnel) = le gate compile → automatisable
- Layer 2 (Sensory) = le gate vérifie `AnimatedSwitcher`, `HapticFeedback`, `AppSkeleton` → automatisable par grep
- Layer 3 (Personality) = le gate vérifie `l10n`, `brandSkin`, pas de `Text('` → automatisable par grep

---

## 6. Les 4 Niveaux de Gates

Chaque gate est une **commande exécutable** qui retourne PASS/FAIL :

### Gate 1 : Compilation (BLOQUANT)

```bash
dart analyze --no-fatal-infos
dart format --set-exit-if-changed .
supabase db reset  # si migration touchée
```

**Ce que ça garantit :** Le code compile, est formaté, et le schéma DB est cohérent.

**Déjà dans la constitution** mais pas exécuté automatiquement entre chaque tâche.

---

### Gate 2 : Pattern Structurel (BLOQUANT)

Des **scripts grep** qui vérifient les règles codifiables de la constitution :

| Règle constitution | Check exécutable |
|---|---|
| Entity utilise Equatable | `grep -L "extends Equatable" lib/**/entities/*_entity.dart` → doit être vide |
| Model a toEntity/fromEntity/fromJson/toJson | `grep -cL "toEntity\|fromEntity\|fromJson\|toJson" lib/**/models/*_model.dart` |
| Repo retourne Either | `grep -L "Either<Failure" lib/**/repositories/i_*_repository.dart` → doit être vide |
| Pas de logique dans les views | `grep -n "locator<\|repository\|\.save\|\.delete\|\.update" lib/**/*_view.dart` → doit être vide |
| Pas de couleurs hardcodées | `grep -rn "Colors\.\|Color(0x\|Color.fromRGBO" lib/ --include="*.dart" --exclude-dir=design_system` → doit être vide |
| Pas de strings hardcodées | `grep -n "Text(['\"]" lib/features/ lib/modules/` → doit être vide |
| Import cross-feature interdit | Vérifier qu'un `features/` n'importe pas depuis un autre `features/` |
| Naming conventions | Vérifier `*_view.dart`, `*_viewmodel.dart`, `*_entity.dart`, `*_model.dart`, `i_*_repository.dart` |
| State machine complète | Tout `_view.dart` avec `isBusy` doit aussi avoir `hasError` |
| Components DS uniquement | Tout `App[A-Z]` doit être dans la liste blanche des composants |

---

### Gate 3 : Architecture (BLOQUANT)

Vérifie les dépendances entre couches :

```
domain/ ne doit importer AUCUN package externe (sauf equatable, dartz)
data/   ne doit PAS importer de presentation/
views   ne doivent PAS importer de data/
features/ ne doivent PAS s'importer entre eux
modules/  ne doivent PAS s'importer entre eux
```

**Méthode :** Analyse statique des lignes `import` dans chaque fichier, comparée à la couche du fichier (déterminée par son chemin).

---

### Gate 4 : Comportemental (NON-BLOQUANT mais reporté)

```bash
flutter test  # si tests existent pour cette feature
```

**Non-bloquant** car les tests ne sont pas toujours écrits en même temps que le code (dépend de la stratégie TDD ou non).

---

### Gate Expérience (3-Layer Check)

Gate transversal qui vérifie la complétude des 3 couches de l'Experience Standard :

| Layer | Checks grep |
|-------|-------------|
| **1. Fonctionnel** | `hasError`, `isBusy`, `isEmpty` dans views. `Either<Failure` dans repos. `runBusyFuture` dans viewmodels. |
| **2. Sensory** | `AnimatedSwitcher` ou `AppStaggeredFadeIn` dans views. `HapticFeedback` dans viewmodels. `AppSkeleton` pour loading. |
| **3. Personality** | `context.l10n` dans views. Pas de `Text('` hardcodé. `AppEmptyState` pour les états vides. |

---

## 7. Les Parties Nécessitant Validation Humaine

### 7.1 Ce qui est automatisable à 100%

| Aspect | Méthode |
|--------|---------|
| Compilation / format | `dart analyze` + `dart format` |
| Naming conventions | Regex sur les noms de fichiers |
| Import rules (couches) | Grep sur les imports |
| Design tokens (pas de hardcode) | Grep antipatterns |
| i18n (pas de strings) | Grep `Text('` / `Text("` |
| State machine (error/busy/empty) | Grep patterns dans `_view.dart` |
| Either pattern | Grep sur les repos |
| Equatable/Model methods | Grep sur entities/models |

### 7.2 Ce qui est automatisable à ~70%

| Aspect | Méthode | Limite |
|--------|---------|--------|
| Haptic feedback | Grep `HapticFeedback` dans viewmodels | Vérifie la présence, pas la pertinence du type choisi |
| Animation coverage | Grep `AnimatedSwitcher`, `AppStaggeredFadeIn` | Détecte l'absence, pas la qualité de l'animation |
| Accessibility | Grep `semanticLabel`, `Semantics(` | Détecte l'absence, pas la qualité du label |
| Reactivity (notifyChanged) | Grep dans les viewmodels après create/update/delete | Patterns multi-lignes complexes |

### 7.3 Ce qui nécessite l'oeil humain (ou vision IA)

| Aspect | Pourquoi | Quand le valider |
|--------|----------|------------------|
| **Choix du layout** | "Est-ce que cette page devrait être un GridView ou un ListView ?" — l'IA ne sait pas sans wireframe | **Pendant `speckit.specify`** — fournir les wireframes ASCII |
| **Hiérarchie visuelle** | "Est-ce que l'élément important est bien mis en avant ?" | **Après implémentation** — screenshot émulateur |
| **Cohérence visuelle** | "Est-ce que cette page ressemble au reste de l'app ?" | **Après implémentation** — screenshot comparatif |
| **Ton/Voice** | "Est-ce que les messages sont dans le bon ton ?" | **Pendant `speckit.specify`** — valider les clés i18n |
| **UX Flow** | "Est-ce que le parcours utilisateur est logique ?" | **Pendant `speckit.plan`** — valider les flux |
| **Pertinence métier** | "Est-ce que cette feature résout bien le problème ?" | **Pendant `speckit.specify`** — valider les user stories |

### 7.4 Les Checkpoints Humains Stratégiques

L'humain n'intervient qu'à **4 moments** au lieu de superviser chaque ligne :

| Moment | Ce que l'humain fait | Durée estimée |
|--------|---------------------|---------------|
| **1. Spécification** | Décrit l'app/feature, valide les user stories et wireframes | 30-60 min |
| **2. Plan** | Valide l'architecture, le data-model, les choix techniques | 15-30 min |
| **3. Fin de User Story** | Regarde les screenshots, valide le visuel et l'UX | 5-10 min |
| **4. Pré-déploiement** | Teste l'app 5 min sur l'émulateur, valide le go | 5-10 min |

**Total temps humain par feature : ~1-2h** vs 8-40h de codage. Le reste est autonome et certifié par les gates.

---

## 8. Stratégie d'Encodage du "Goût" — L'IA Qui Décide Comme Moi

Pour que l'IA "pense comme l'humain" avec peu de prompts, 3 piliers :

### Pilier 1 : Les Archétypes d'Écran

Chaque type d'écran a une **recette complète**. L'IA ne décide pas du layout — elle regarde le type d'écran et applique la recette.

**Archétypes existants** (dans Experience Standard) :

| # | Archétype | Recette |
|---|-----------|---------|
| 1 | **Greeting** (Splash, Welcome back) | Logo breathe in, time-of-day greeting, subtle gradient, smooth transition OUT |
| 2 | **Form** (Login, Register, Edit) | Fields stagger top→bottom, focus highlight, haptic on submit, shake on error |
| 3 | **List** (Habits, Notifications) | Items stagger, pull-to-refresh, swipe-to-dismiss, skeleton loading, empty = invitation |
| 4 | **Celebration** (Streak, Goal complete) | Scale + glow from center, specific praise, confetti tier, fade after 3s |
| 5 | **Empty / Zero-state** | Icon + text fade in, subtle animation, CTA = invitation |

**Archétypes à ajouter** pour couvrir 100% des cas :

| # | Archétype | Cas d'usage |
|---|-----------|-------------|
| 6 | **Dashboard** | Home avec métriques, graphiques, résumé du jour |
| 7 | **Detail** | Fiche d'un élément (habitude, contact, transaction) |
| 8 | **Onboarding** | Séquence de slides avec progression |
| 9 | **Search** | Recherche + filtres + résultats |
| 10 | **Chat** | Messagerie, bulles, input en bas |
| 11 | **Calendar** | Vue calendrier + événements |
| 12 | **Settings** | Sections groupées, toggles, navigation |

Chaque archétype = une recette complète (layout, animations, haptics, states, personality). L'IA n'a plus à "décider", elle "exécute la recette".

---

### Pilier 2 : Les Principes de Décision (Tiebreakers)

Les cas où l'IA va hésiter sont prévisibles. On les résout en avance :

```
## Decision Tiebreakers (quand l'IA hésite)

 1. Simple vs Complexe      → Toujours le plus simple. Progressive disclosure.
 2. 1 écran vs 2 écrans     → 1 écran avec sections si <7 éléments, 2 écrans sinon.
 3. Bottom sheet vs Dialog   → Bottom sheet (sauf confirmation destructive → Dialog).
 4. FAB vs Button inline     → Button inline dans un AppEmptyState, FAB sur les listes peuplées.
 5. Tab bar vs Scroll        → Tabs si ≤4 catégories mutuellement exclusives, sinon scroll.
 6. Pull-to-refresh vs Auto  → Pull-to-refresh toujours. Auto-reload en plus si temps réel.
 7. Swipe-to-delete vs Btn   → Swipe avec confirmDismiss. Button en fallback accessibility.
 8. Skeleton vs Shimmer      → Skeleton (contour gris). Pas de shimmer (position 3.2/5 warmth).
 9. Snackbar vs Toast vs Dlg → Snackbar pour erreurs d'action. Dialog pour erreurs bloquantes (auth).
10. Icônes                   → LucideIcons exclusivement. Pas de Material Icons, pas de FontAwesome.
```

---

### Pilier 3 : Les Exemples de Référence (Gold Standards)

Le plus puissant. Au lieu de décrire des règles, pointer vers un **fichier** qui est le gold standard :

```
## Reference Implementations (l'IA doit s'en inspirer)

### Vue liste parfaite
→ lib/features/habits/views/habits_view.dart
  - State machine complète (error → busy → empty → content)
  - AppStaggeredFadeIn sur les items
  - RefreshIndicator + Slidable swipe
  - AppEmptyState avec CTA
  - Skeleton loading

### ViewModel parfait
→ lib/features/habits/viewmodels/habits_viewmodel.dart
  - runBusyFuture avec busyObject
  - Haptic sur chaque action
  - EventService subscription/unsubscription
  - Either handling complet

### Formulaire parfait
→ lib/modules/auth/views/login_view.dart
  - AppTextField avec validation
  - AppButton.primary avec isLoading
  - Staggered entrance
  - Error snackbar
```

Quand l'IA code un nouvel écran Liste, le prompt dit "inspire-toi de `habits_view.dart`" — et le **gate vérifie** que les mêmes patterns sont présents.

---

### Le fichier `decisions.md` — L'empreinte du créateur

Créer un fichier `.specify/memory/decisions.md` qui capture les patterns de décision récurrents :

```markdown
# Mes Décisions de Design (pour que l'IA décide comme moi)

## Philosophie produit
- Apps pour l'Afrique francophone d'abord, diaspora ensuite
- Mobile money avant carte bancaire
- Offline-first quand pertinent (zones de faible connectivité)
- Freemium : la version gratuite doit être UTILE, pas juste un teaser

## Choix UX que je fais toujours
- Onboarding en 3 slides max, skip possible
- Tab bar en bas, jamais de drawer/hamburger
- Dark mode par défaut (économie batterie AMOLED)
- FR comme langue par défaut, EN en second
- Pas de gamification agressive (pas de streaks culpabilisants)

## Choix techniques que je fais toujours
- Supabase > Firebase (open source, SQL, pas de vendor lock)
- Stacked > Riverpod > BLoC (notre stack VTT)
- GetIt > Provider pour DI
- LucideIcons > Material Icons
- go_router interdit — on utilise Stacked Navigation

## Quand je refuse un design
- Trop d'infos sur un écran (>5 sections visibles)
- Couleurs trop vives ou saturées
- Texte trop petit (<14sp pour le body)
- Pas de feedback visuel sur un tap (tout tap = réaction)
- Pop-up/dialog pour des infos non-critiques (utiliser bottom sheet)

## Mes "never"
- Jamais de publicité dans mes apps
- Jamais de dark patterns (faux boutons, notifications trompeuses)
- Jamais de tracking invasif
- Jamais de "premium required" sur une feature de base
- Jamais "Oups" dans un message d'erreur
```

Ce fichier est lu par l'IA à chaque début de session. Ce n'est pas une instruction technique — c'est **l'empreinte du créateur**. L'IA sait que si elle hésite entre un drawer et une tab bar, la réponse est toujours tab bar. Si elle hésite entre Firebase et Supabase, c'est toujours Supabase. Elle n'a plus besoin de demander.

---

## 9. La Boucle Complète — Vision Synthétique

```
                   HUMAIN (créateur)
                      │
         ┌────────────┼────────────┐
         │            │            │
    speckit.specify   │      speckit.plan
    (user stories,    │      (architecture,
     wireframes,      │       data-model,
     ton/voice)       │       flux UX)
         │            │            │
         └────────────┼────────────┘
                      │
              speckit.tasks
              (tâches ordonnées)
                      │
         ┌────────────┴────────────┐
         │     BOUCLE AUTONOME     │
         │                         │
         │   Pour chaque Tâche :   │
         │   ┌─────────────────┐   │
         │   │ 1. Charger les  │   │
         │   │    instructions │   │
         │   │    + archétype  │   │
         │   │    + référence  │   │
         │   ├─────────────────┤   │
         │   │ 2. Coder        │   │
         │   ├─────────────────┤   │
         │   │ 3. Gate 1:      │   │
         │   │    Compilation  │◄──┤── dart analyze + format
         │   ├─────────────────┤   │
         │   │ 4. Gate 2:      │   │
         │   │    Patterns     │◄──┤── grep antipatterns
         │   ├─────────────────┤   │
         │   │ 5. Gate 3:      │   │
         │   │    Architecture │◄──┤── import analysis
         │   ├─────────────────┤   │
         │   │ 6. Gate 4:      │   │
         │   │    3-Layer      │◄──┤── grep animations/haptic/i18n
         │   │    (Expérience) │   │
         │   ├─────────────────┤   │
         │   │ 7. Gate 5:      │   │
         │   │    Tests        │◄──┤── flutter test (si existent)
         │   ├─────────────────┤   │
         │   │ ❌ FAIL ?       │   │
         │   │ → Diagnostic    │   │
         │   │ → Correction    │   │
         │   │ → Re-gate       │   │
         │   │ (max 3 loops)   │   │
         │   ├─────────────────┤   │
         │   │ ✅ PASS ?       │   │
         │   │ → [X] tasks.md  │   │
         │   │ → Tâche suivante│   │
         │   └─────────────────┘   │
         │                         │
         └─────────────────────────┘
                      │
              ┌───────┴───────┐
              │  CHECKPOINT   │
              │  HUMAIN       │◄──── Fin de phase / fin de user story
              │               │
              │  • Screenshot │      L'IA génère des screenshots
              │    émulateur  │      via Mobile MCP ou preview
              │  • Rapport    │      et les envoie pour
              │    UX score   │      validation visuelle
              │  • Diff git   │
              └───────┬───────┘
                      │
              HUMAIN : "OK" ou "Ajuste X"
                      │
              Phase suivante...
                      │
         ┌────────────┴────────────┐
         │  DÉPLOIEMENT            │
         │  Gate 6: Build release  │
         │  Gate 7: Sign APK/AAB   │
         │  Gate 8: Upload Store   │
         └─────────────────────────┘
```

---

## 10. Stratégie d'Implémentation Incrémentale

### Phase A : Le Script de Gates (la fondation)

Un seul script : `verify-gates`

```
verify-gates --scope=file     → vérifie un fichier spécifique
verify-gates --scope=task     → vérifie tous les fichiers d'une tâche
verify-gates --scope=phase    → vérifie tous les fichiers d'une phase
verify-gates --scope=all      → vérifie tout le projet
```

Sortie : JSON structuré avec PASS/FAIL par gate, par fichier, par règle.

**Contenu :**
- Gate 1 : Wrapper autour de `dart analyze` + `dart format` + `supabase db reset`
- Gate 2 : Batterie de patterns grep (antipatterns)
- Gate 3 : Analyse d'imports et validation des dépendances entre couches
- Gate 4 : Check 3-Layer (fonctionnel + sensory + personality)

### Phase B : Intégration dans `speckit.implement`

Modifier l'agent `speckit.implement` pour qu'il exécute `verify-gates` après chaque tâche, et qu'il boucle s'il y a des FAIL (max 3 itérations).

### Phase C : Pre-commit hook

Même sans IA, personne ne peut commiter du code qui viole les gates.

```bash
# .git/hooks/pre-commit
verify-gates --scope=staged
```

### Phase D : Autonomie

Seulement quand les Phases A-C sont solides → brancher le pipeline externe (Telegram, émulateur, Play Store) tel que décrit dans `ai-app-factory.md`.

---

## 11. Questions de Design à Trancher

Avant de commencer l'implémentation :

### Q1 : Langage du script de gates

| Option | Pour | Contre |
|--------|------|--------|
| **PowerShell** | Cohérent avec `check-prerequisites.ps1`, cross-platform via pwsh | Pas d'AST analysis Dart |
| **Dart** | Cohérent avec le projet Flutter, peut faire de l'AST analysis native | Nouveau tooling à maintenir |
| **Python** | Env déjà existant dans `tools/`, bon pour le regex et parsing | Ajoute une dépendance |

### Q2 : Granularité d'exécution

| Option | Pour | Contre |
|--------|------|--------|
| **Par fichier créé** (tight loop) | Détection ultra-précoce, correction ciblée | Overhead d'exécution |
| **Par tâche** (batch) | Moins d'overhead, plus naturel | Erreurs détectées plus tard |

### Q3 : Sévérité progressive

| Option | Pour | Contre |
|--------|------|--------|
| **Tout bloquant jour 1** | Maximum de rigueur immédiate | Risque de frustration, beaucoup de faux positifs à calibrer |
| **Gate 1+2 d'abord, Gate 3+4 ensuite** | Adoption progressive, calibration | Trou de couverture temporaire |

### Q4 : Intégration agent

| Option | Pour | Contre |
|--------|------|--------|
| **Modifier `speckit.implement`** | Un seul agent, workflow unifié | Agent déjà complexe, risque de casser l'existant |
| **Nouvel agent `speckit.certify`** | Séparation des responsabilités, peut tourner indépendamment | Un agent de plus à maintenir |

---

## Annexe A : Les 3 Couches de Certitude (Résumé)

| Couche | Mécanisme | Ce qu'elle garantit |
|--------|-----------|-------------------|
| **Couche 1 : Scripts (verify-gates)** | Grep, dart analyze, import analysis | Le code est techniquement conforme. Zéro dérive structurelle possible. |
| **Couche 2 : Archétypes + Références** | Templates de recettes + fichiers gold standard | L'IA produit des écrans qui *ressemblent* à ce que l'humain aurait fait. |
| **Couche 3 : Decisions.md + Constitution** | Principes de goût et choix encodés | L'IA prend les mêmes *décisions* que l'humain quand elle hésite. |

Les couches 2 et 3 sont les "prompts d'analyse et principes". La couche 1 est le filet de sécurité qui rattrape tout ce que les couches 2 et 3 n'ont pas empêché.

Avec ces 3 couches, on peut lancer `speckit.implement` et aller dormir. Le lendemain, on a soit un code conforme, soit un rapport précis de ce qui a bloqué et pourquoi.

---

## Annexe B : Relation avec les Documents Existants

| Document | Rôle dans la boucle |
|----------|-------------------|
| `.specify/memory/constitution.md` | Source des règles que les gates transforment en scripts |
| `.github/copilot-instructions.md` | Instructions cross-stack lues par l'IA avant de coder |
| `flutter/.github/instructions/*.md` | Instructions détaillées par type de fichier, lues par l'IA |
| `flutter/.github/agents/code-reviewer.md` | Checklist de review — les mêmes checks deviennent des gates |
| `flutter/.github/agents/ux-auditor.md` | Audit UX 12 dimensions — Gate Expérience s'en inspire |
| `flutter/.github/agents/design-system-auditor.md` | Audit DS complet — les checks deviennent des gates grep |
| `.github/agents/speckit.implement.agent.md` | L'agent qui exécutera la boucle certifiée |
| `.github/agents/speckit.analyze.agent.md` | Analyse de cohérence docs — complémentaire aux gates code |
| `docs/ai-app-factory.md` | Vision du pipeline autonome complet — Phase D de ce document |
| `.specify/memory/decisions.md` | **À créer** — Pilier 3, l'empreinte du créateur |

---

**→ Suite : [Partie 2 — Wireframes, Validation Visuelle & Vision Complète](certified-gate-loop-part2.md)**

---

*Créé le : 2026-03-16*  
*Dernière mise à jour : 2026-03-16*  
*Statut : Conception — En discussion*
