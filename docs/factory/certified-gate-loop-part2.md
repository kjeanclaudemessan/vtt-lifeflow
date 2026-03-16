# Certified Gate Loop — Partie 2 : Wireframes, Validation Visuelle & Vision Complète

> **"Une instruction simple → l'IA conçoit, code, valide visuellement et déploie."**

**Version :** 1.0  
**Date :** 16 Mars 2026  
**Statut :** Conception  
**Prérequis :** [Partie 1 — Fondations & Boucle de Validation](certified-gate-loop.md)  

---

## Table des Matières

1. [Évaluation de l'Approche](#1-évaluation-de-lapproche)
2. [La Vision Complète : De l'Instruction à l'App](#2-la-vision-complète--de-linstruction-à-lapp)
3. [Les Règles de Wireframe — La Clé Manquante](#3-les-règles-de-wireframe--la-clé-manquante)
4. [La Validation Visuelle via MCP — Le Dernier Maillon](#4-la-validation-visuelle-via-mcp--le-dernier-maillon)
5. [La Dimension Ultime — Une Instruction, Un Résultat Parfait](#5-la-dimension-ultime--une-instruction-un-résultat-parfait)
6. [Les Règles Complémentaires Manquantes](#6-les-règles-complémentaires-manquantes)
7. [Synthèse : Le Stack de Règles Complet](#7-synthèse--le-stack-de-règles-complet)

---

## 1. Évaluation de l'Approche

### 1.1 Pourquoi l'approche Certified Gate Loop est fondamentalement solide

La force de cette approche ne réside pas dans le fait de rendre l'IA "plus intelligente" — elle réside dans la **contrainte de l'espace de décision** pour que même une IA moyenne produise un résultat excellent. Les meilleurs systèmes industriels fonctionnent ainsi : des rails bien posés valent mieux qu'un pilote génial sans rails.

### 1.2 Les 3 ingrédients rares déjà en place

| Ingrédient | Détail | Pourquoi c'est rare |
|-----------|--------|-------------------|
| **Stack technique fixe** | Flutter + Stacked + Supabase | L'IA ne perd pas de temps à choisir la techno |
| **Design system codifié** | 14 fichiers d'instructions `.md` | Les règles esthétiques existent déjà en texte structuré |
| **Pipeline de specs** | SpecKit (specify → plan → tasks → implement) | La structure avant le code |

### 1.3 Les 2 maillons manquants identifiés

| Maillon | Rôle | Statut |
|---------|------|--------|
| **Règles de wireframe** (en amont) | L'IA n'a plus besoin qu'on lui dessine les écrans | **À créer** |
| **Validation visuelle** (en aval) | Certifier que le rendu est visuellement correct | **À configurer** (Mobile MCP) |

---

## 2. La Vision Complète : De l'Instruction à l'App

### 2.1 Aujourd'hui — les trous

```
Instruction humaine → [?] → speckit.specify → [?] → speckit.plan → tasks → implement → [?] → deploy
                       ↑                        ↑                                        ↑
                   L'IA ne sait              L'IA ne sait                          L'IA ne sait
                   pas quels écrans          pas quel layout                       pas si c'est
                   concevoir                 choisir                               visuellement bon
```

### 2.2 La cible

```
Instruction simple
       ↓
  ┌────┴────┐
  │ RÈGLES  │ ← Wireframe Rules + Decisions.md + Constitution + Archétypes
  │ ENCODED │
  └────┬────┘
       ↓
  speckit.specify (auto-wireframes)
       ↓
  speckit.plan (architecture auto)
       ↓
  speckit.tasks
       ↓
  speckit.implement + Certified Gate Loop
       ↓
  MCP Visual Validation (screenshots émulateur)
       ↓
  Deploy
```

**Zéro intervention humaine sauf validation finale.** Mais pour y arriver, il faut encoder 2 choses qui manquent : les **règles de wireframe** et la **validation visuelle**.

---

## 3. Les Règles de Wireframe — La Clé Manquante

### 3.1 Pourquoi c'est possible

Un wireframe n'est **PAS de l'art**. C'est une **décision structurelle** basée sur des paramètres mesurables :

| Paramètre | Valeur | Décision wireframe |
|-----------|--------|-------------------|
| Nombre de features principales | 3-5 | Bottom nav avec 3-5 tabs |
| Type de données | Liste d'items | ListView avec cards |
| Type de données | Métriques/stats | Dashboard avec graphiques |
| Actions utilisateur | CRUD sur une entité | Liste → Détail → Form |
| Flux d'entrée | Première utilisation | Onboarding 3 slides |
| Densité d'info par item | Faible (titre + subtitle) | ListTile simple |
| Densité d'info par item | Haute (image + titre + stats) | Card avec image |

Ce sont des **règles if/then déterministes**. L'IA n'a pas besoin de "créativité" — elle a besoin de la bonne table de décision.

### 3.2 Les 5 Couches de Règles Wireframe

#### Couche 1 : Structure de Navigation

```
RÈGLE: L'app a N features principales (extrait des user stories)

SI N ≤ 5 → Bottom Navigation Bar avec N tabs
SI N > 5 → Bottom Nav 4 tabs + "Plus" en 5ème tab
   - Les 4 tabs = les 4 features les plus fréquentes
   - "Plus" = sous-menu avec les features restantes

RÈGLE: Hiérarchie de navigation
Tab 1 = L'écran d'usage quotidien (Home / Dashboard / Today)
Tab 2 = La feature principale (la raison d'être de l'app)
Tab 3 = La feature secondaire
Tab 4 = Profil / Settings

JAMAIS de Drawer/Hamburger menu
JAMAIS de Tab Bar en haut
JAMAIS plus de 5 tabs en bas
```

#### Couche 2 : Architecture d'Écran

```
RÈGLE: Chaque user story = 1 à 3 écrans maximum

US type "consulter une liste" →
  Écran 1: Liste (avec search/filter si >10 items)
  Écran 2: Détail (tap sur un item)

US type "créer/modifier" →
  Écran 1: Formulaire (bottom sheet si ≤4 champs, full screen si >4)

US type "suivre sa progression" →
  Écran 1: Dashboard (graphiques + résumé)
  Écran 2: Historique détaillé (optionnel, accessible par tap)

US type "configurer" →
  Écran 1: Sections groupées avec toggles/navigation

US type "communiquer" →
  Écran 1: Liste de conversations
  Écran 2: Conversation (chat)
```

#### Couche 3 : Layout par Type d'Écran

```
RÈGLE: Densité d'information

Chaque écran a UN objectif principal.

SECTIONS VISIBLES sans scroll ≤ 5
  - SI >5 sections → splitter en 2 écrans ou utiliser des tabs internes

ITEMS PAR SECTION ≤ 7
  - SI >7 items → ListView.builder avec pagination
  - SI ≤3 items → Column simple (pas besoin de scroll)

CHAMPS PAR FORMULAIRE ≤ 8
  - SI >8 → grouper en étapes (stepper) ou sections avec headers

ACTIONS PAR ÉCRAN:
  - 1 action primaire (AppButton.primary ou FAB)
  - 0-2 actions secondaires (AppButton.outline ou icônes dans AppBar)
  - Actions contextuelles via swipe ou long-press, jamais boutons visibles
```

#### Couche 4 : Composant par Type de Donnée

```
RÈGLE: Mapping donnée → composant

Texte court (nom, titre)          → AppTextField
Texte long (description, notes)   → AppTextField(maxLines: 4)
Choix parmi ≤5 options            → SegmentedButton ou Radio
Choix parmi >5 options            → BottomSheet avec liste
Oui/Non                           → Switch (toggle)
Date                              → DatePicker
Heure                             → TimePicker
Date + Heure                      → DatePicker → TimePicker (2 étapes)
Nombre                            → AppTextField(keyboardType: number)
Montant                           → AppTextField + suffixe devise
Image                             → Tap zone avec icône camera/gallery
Couleur                           → Palette de 8-12 couleurs prédéfinies
Icône                             → Grid de 12-20 icônes prédéfinies
Rating/Score                      → Slider ou étoiles (1-5)

RÈGLE: Mapping liste → layout

Items simples (titre only)         → ListTile
Items avec subtitle                → ListTile avec subtitle
Items avec image                   → Card avec Image en haut
Items avec progression             → Card avec LinearProgress
Items grille (produits, gallery)   → GridView 2 colonnes
Items timeline (activités, logs)   → Timeline verticale avec date headers
```

#### Couche 5 : Flux et Enchaînement

```
RÈGLE: Premier lancement

1. Splash (1-2s, logo + app name)
2. Onboarding (3 slides, skip possible)
   - Slide 1: Proposition de valeur (ce que l'app fait)
   - Slide 2: Feature phare (screenshot ou illustration)
   - Slide 3: CTA d'inscription
3. Auth (Login / Register avec tabs)
4. Home (l'écran quotidien)

RÈGLE: Flux CRUD standard

Liste → [tap] → Détail → [edit] → Formulaire → [save] → Retour Détail
Liste → [FAB/+] → Formulaire → [save] → Retour Liste (item ajouté en haut)
Liste → [swipe] → Confirmation → Suppression (avec undo snackbar)

RÈGLE: Flux de recherche

Tap icône search → Barre search s'anime (expand) →
Résultats live (debounce 300ms) →
Filtres via BottomSheet (pas d'écran dédié) →
Tap résultat → Détail

RÈGLE: Transitions

Liste → Détail    : slide right (push)
Retour             : slide left (pop)
Formulaire/Modal   : slide up (bottom sheet)
Auth → Home        : cross-fade (clearStackAndShow)
Tab switch         : pas d'animation (instant)
```

### 3.3 Démonstration : de l'instruction au wireframe auto-généré

Avec ces 5 couches, quand l'IA reçoit :

```
"App de suivi d'habitudes avec 4 features : habitudes quotidiennes,
 routines, journal, statistiques"
```

Elle peut **déduire** sans aucun wireframe humain :

```
Navigation: Bottom Nav 4 tabs
  Tab 1: Aujourd'hui (dashboard quotidien)
  Tab 2: Habitudes (liste → détail → form)
  Tab 3: Journal (timeline → détail → form)
  Tab 4: Profil (settings groupées)

Écrans:
  1. Splash → Onboarding (3 slides) → Auth → Home
  2. Home/Aujourd'hui: Dashboard (progression du jour + habitudes du jour en liste)
  3. Habitudes: ListView de cards avec switch toggle + progression
  4. Habitude Détail: Stats (graphique) + historique (timeline)
  5. Habitude Form: BottomSheet (≤4 champs: nom, icône, fréquence, rappel)
  6. Journal: Timeline avec date headers + FAB pour nouvel entry
  7. Journal Form: Full screen (>4 champs: titre, contenu long, humeur, tags)
  8. Profil: Sections groupées (compte, préférences, données, aide)

Layout par écran:
  Dashboard → Header salutation + 2 métriques cards + liste habits du jour
  Liste → Search bar + filter chips + ListView.builder + FAB
  Détail → Header image/icône + sections info + actions
  Form → Champs staggered + bouton primary en bas
```

**C'est exactement ce qu'un humain aurait fait.** Les règles sont les mêmes qu'un humain applique inconsciemment.

---

## 4. La Validation Visuelle via MCP — Le Dernier Maillon

### 4.1 Pourquoi les gates grep ne suffisent pas

Les gates grep vérifient que le **code** est conforme. Mais le code conforme ne garantit pas un **rendu** conforme :

```dart
// Ce code passe TOUS les gates grep :
AppButton.primary(
  label: context.l10n.save,
  onPressed: viewModel.save,
)
// Mais si le bouton est caché sous le clavier, ou trop petit,
// ou chevauche un autre élément → les gates ne le voient pas
```

Il faut un **gate visuel** — et c'est là que Mobile MCP entre en jeu.

### 4.2 Gate 6 : Validation Visuelle (Mobile MCP)

```
Pour chaque écran implémenté :

  1. BUILD debug APK
  2. INSTALL sur émulateur via ADB
  3. NAVIGATE vers l'écran (Mobile MCP → click/swipe)
  4. SCREENSHOT (Mobile MCP → mobile_screenshot)
  5. LIST ELEMENTS (Mobile MCP → mobile_list_elements) → arbre d'accessibilité
  6. VALIDATE via LLM vision :
     - Les éléments sont-ils visibles et non tronqués ?
     - La hiérarchie visuelle est-elle respectée ?
     - Le dark mode rend-il correctement ?
     - Les touch targets sont-ils assez grands ? (≥48dp)
     - Le texte est-il lisible sur le fond ?
  7. VALIDATE via arbre d'accessibilité :
     - Tous les éléments interactifs ont un label ?
     - L'ordre de lecture est-il logique ?
     - Pas d'éléments qui se chevauchent ?
```

### 4.3 Règles de Validation Visuelle

Ce que le LLM vérifie systématiquement sur chaque screenshot :

#### Espacement
- Aucun élément ne touche les bords de l'écran (padding minimum visible)
- Les éléments sont alignés sur une grille cohérente
- L'espace entre les sections est visuellement supérieur à l'espace entre les items

#### Lisibilité
- Tout texte est lisible (contraste suffisant sur le fond)
- Aucun texte n'est tronqué (pas de "..." sauf si c'est voulu pour les longs titres)
- Les icônes sont reconnaissables (pas trop petites, pas pixelisées)

#### Hiérarchie
- L'action primaire est visuellement dominante (plus grande, colorée)
- Le titre de la page est le texte le plus grand
- Les éléments secondaires sont visuellement en retrait

#### Cohérence
- Comparer avec le screenshot de l'écran précédent :
  - Même position du header/title
  - Même style de navigation
  - Même palette de couleurs
  - Même espacement général

#### États
- Vérifier l'état vide (naviguer avant d'avoir des données)
- Vérifier l'état chargé (après ajout de données)
- Vérifier le dark mode (basculer le thème et re-screenshoter)
- Vérifier le mode paysage (rotation et re-screenshot) — optionnel

#### Interaction
- Chaque bouton/lien est tappable (Mobile MCP → click → vérifier navigation)
- Les formulaires acceptent l'input (Mobile MCP → type → vérifier)
- Le retour arrière fonctionne (Mobile MCP → press_key back)
- La navigation entre tabs fonctionne

### 4.4 Pipeline Visuel Complet

```
                     Code certifié par Gates 1-5
                              │
                              ▼
                    ┌──────────────────┐
                    │ flutter build apk│
                    │ --debug          │
                    └────────┬─────────┘
                             │
                    ┌────────▼─────────┐
                    │ adb install -r   │
                    │ app-debug.apk    │
                    └────────┬─────────┘
                             │
                    ┌────────▼─────────┐
                    │ Mobile MCP       │
                    │ launch_app       │
                    └────────┬─────────┘
                             │
              ┌──────────────┼──────────────┐
              ▼              ▼              ▼
        ┌──────────┐  ┌──────────┐  ┌──────────┐
        │ Écran 1  │  │ Écran 2  │  │ Écran N  │
        │          │  │          │  │          │
        │ navigate │  │ navigate │  │ navigate │
        │ screenshot│  │ screenshot│  │ screenshot│
        │ validate │  │ validate │  │ validate │
        └────┬─────┘  └────┬─────┘  └────┬─────┘
             │              │              │
             └──────────────┼──────────────┘
                            │
                     ┌──────▼──────┐
                     │ TOUS PASS ? │
                     └──────┬──────┘
                       OUI  │  NON
                       │    │    │
                       │    │    ▼
                       │    │  Rapport visuel
                       │    │  avec screenshots
                       │    │  annotés
                       │    │    │
                       │    │    ▼
                       │    │  Correction code
                       │    │  + re-build
                       │    │  + re-test
                       │    │  (max 3 loops)
                       │    │
                       ▼    │
                  ✅ CERTIFIÉ
                  VISUELLEMENT
```

---

## 5. La Dimension Ultime — Une Instruction, Un Résultat Parfait

### 5.1 Scénario concret de bout en bout

Avec tout en place, voici ce qui se passe quand on écrit :

```
"App de suivi de budget personnel pour l'Afrique francophone.
 Suivi des dépenses, catégories, objectifs d'épargne, rapports mensuels.
 Mobile money + espèces comme modes de paiement principaux."
```

**L'IA fait tout ça sans intervention :**

| Étape | Ce qui se passe | Garanti par |
|-------|----------------|-------------|
| 1 | Génère `spec.md` avec user stories + acceptance criteria | Constitution + decisions.md |
| 2 | Génère les wireframes ASCII en appliquant les Wireframe Rules | Règles wireframe (5 couches) |
| 3 | Génère `plan.md` avec archi, data-model, choix techniques | Constitution + stack fixe |
| 4 | Génère `tasks.md` avec tâches ordonnées | speckit.tasks agent |
| 5 | Crée la migration Supabase (tables, RLS) | Gate 1 : `supabase db reset` |
| 6 | Crée les entities (domain/) | Gate 2 : Equatable, props |
| 7 | Crée les models (data/) | Gate 2 : fromJson/toJson/toEntity |
| 8 | Crée les repositories | Gate 2 : Either\<Failure, T\> |
| 9 | Crée les viewmodels | Gate 2+4 : haptic, reactivity |
| 10 | Crée les views | Gate 2+4 : state machine, i18n, animations, DS components |
| 11 | Vérifie la compilation | Gate 1 : `dart analyze` |
| 12 | Vérifie l'architecture | Gate 3 : imports entre couches |
| 13 | Vérifie l'expérience 3-Layer | Gate 4 : fonctionnel + sensory + personality |
| 14 | Build + install émulateur | Gate 6 : Mobile MCP |
| 15 | Screenshot chaque écran + validation | Gate 6 : LLM vision + arbre a11y |
| 16 | Corrige si nécessaire (max 3 boucles) | Certified Gate Loop |
| 17 | Build release + sign | Gate déploiement |
| 18 | Upload Play Store | Playwright MCP / Fastlane |

**L'humain revoit à l'étape 2 (wireframes, 5 min) et à l'étape 15 (screenshots finaux, 5 min).**

### 5.2 Le "même plus" — ce qui devient possible

#### A. L'apprentissage inter-apps

Quand l'IA a codé 10 apps avec les règles, elle a une **bibliothèque de patterns validés**. L'app 11 est mieux que l'app 1 :

```
App 1  : Template Finance + règles → corrections gates → résultat OK
App 5  : Template Finance + règles + patterns de l'app 1-4 → moins de corrections
App 10 : Template Finance + règles + patterns de 1-9 → quasi zéro corrections
```

**Comment encoder ça :** Après chaque app réussie, les fichiers gold standard sont ajoutés à la bibliothèque de référence (Pilier 3). Le `decisions.md` s'enrichit des décisions spécifiques au domaine.

#### B. La génération de variantes

Une fois l'app "Suivi Budget" produite et validée pour le Cameroun :

```
"La même app, mais pour la Côte d'Ivoire. Devise XOF au lieu de XAF.
 Mobile Money : Orange Money et MTN au lieu de Orange et MTN."
```

L'IA duplique, change les constantes, re-gate, re-valide. **30 minutes au lieu de 8 heures.**

#### C. L'évolution autonome

```
"Ajoute une feature 'dettes' à l'app Budget.
 L'utilisateur peut enregistrer qui lui doit de l'argent et à qui il doit."
```

L'IA re-rentre dans la boucle SpecKit mais seulement pour la nouvelle feature. Les gates certifient qu'elle n'a rien cassé du code existant.

---

## 6. Les Règles Complémentaires Manquantes

Au-delà des wireframes, les dernières couches de règles qui ferment la boucle à 100%.

### 6.1 Règles de Contenu (i18n)

```
RÈGLE: Génération automatique des clés i18n

Screens de l'app →
  - Titre d'écran     : [feature]Title         (ex: habitsTitle = "Mes habitudes")
  - Sous-titre         : [feature]Subtitle
  - Empty state titre  : [feature]EmptyTitle    (ton: invitation, pas constat)
  - Empty state subtitle: [feature]EmptySubtitle (avec CTA implicite)
  - Bouton primaire    : [feature]Action         (ex: habitsAdd = "Nouvelle habitude")
  - Erreur             : error[Type]             (ton: honnête, concret, jamais "Oups")
  - Succès             : success[Action]         (ton: encourageant, personnalisé)

RÈGLE: Ton par contexte
  - Salutation        : heure du jour → "Bon matin" / "Bonne soirée"
  - Retour absence    : "Content de te revoir" (JAMAIS "Tu as manqué X jours")
  - Erreur            : "Connexion perdue. On réessaie ?" (JAMAIS "Échec" ou "Oups")
  - Vide              : "C'est calme ici" (JAMAIS "Aucun résultat" ou "Liste vide")
  - Succès            : spécifique ("Habitude créée !" pas "Opération réussie")
```

### 6.2 Règles d'Icônes

```
RÈGLE: Mapping feature → icône (LucideIcons exclusivement)

Habitudes     → LucideIcons.sparkles
Journal       → LucideIcons.bookOpen
Budget        → LucideIcons.wallet
Statistiques  → LucideIcons.barChart3
Profil        → LucideIcons.user
Paramètres    → LucideIcons.settings
Notifications → LucideIcons.bell
Recherche     → LucideIcons.search
Ajouter       → LucideIcons.plus
Modifier      → LucideIcons.pencil
Supprimer     → LucideIcons.trash2
Favori        → LucideIcons.heart
Partager      → LucideIcons.share2
Filtrer       → LucideIcons.filter
Calendrier    → LucideIcons.calendar
Horloge       → LucideIcons.clock
Succès        → LucideIcons.checkCircle
Erreur        → LucideIcons.alertCircle
Info          → LucideIcons.info

JAMAIS Material Icons
JAMAIS FontAwesome
JAMAIS icônes custom sans validation
```

### 6.3 Règles de Données Exemple (Seeds)

```
RÈGLE: Chaque feature doit avoir des données exemple réalistes

En mode développement, l'app doit afficher des données réalistes :

Noms      : prénoms africains francophones (Amadou, Fatou, Kofi, Aïcha, ...)
Montants  : en XAF/XOF (multiples de 500 ou 1000)
Dates     : dans les 30 derniers jours (pas en 2020)
Images    : placeholder avec icône (pas d'image externe en dev)
Emails    : [prenom]@example.com
Téléphones: format local (+237, +225, +221)

JAMAIS "Test 1", "Test 2", "Lorem ipsum"
JAMAIS de données en anglais pour des apps francophones
```

### 6.4 Archétypes d'Écran Complets

Archétypes existants (dans Experience Standard) :

| # | Archétype | Recette résumée |
|---|-----------|---------|
| 1 | **Greeting** (Splash, Welcome back) | Logo breathe in, time-of-day greeting, subtle gradient, smooth transition OUT |
| 2 | **Form** (Login, Register, Edit) | Fields stagger top→bottom, focus highlight, haptic on submit, shake on error |
| 3 | **List** (Habits, Notifications) | Items stagger, pull-to-refresh, swipe-to-dismiss, skeleton loading, empty = invitation |
| 4 | **Celebration** (Streak, Goal complete) | Scale + glow from center, specific praise, confetti tier, fade after 3s |
| 5 | **Empty / Zero-state** | Icon + text fade in, subtle animation, CTA = invitation |

Archétypes **à ajouter** pour couvrir 100% des cas :

| # | Archétype | Cas d'usage | Recette |
|---|-----------|-------------|---------|
| 6 | **Dashboard** | Home avec métriques, résumé du jour | Header salutation + grille de métriques + liste résumée + graphique compact |
| 7 | **Detail** | Fiche d'un élément (habitude, contact, transaction) | Header hero (image/icône + titre) + sections info + actions bottom |
| 8 | **Onboarding** | Séquence de slides avec progression | PageView + dots indicator + skip button + CTA final |
| 9 | **Search** | Recherche + filtres + résultats | Search bar animated + filter chips + results list + empty state |
| 10 | **Chat** | Messagerie, bulles, input en bas | List reverse + bubbles alternées + input sticky bottom + send button |
| 11 | **Calendar** | Vue calendrier + événements | Calendar widget + event list below + FAB pour créer |
| 12 | **Settings** | Sections groupées, toggles, navigation | Grouped sections avec headers + ListTile (toggle/nav/info) + version en footer |

Chaque archétype = une recette complète (layout, animations, haptics, states, personality). L'IA n'a plus à "décider", elle **exécute la recette**.

---

## 7. Synthèse : Le Stack de Règles Complet

### 7.1 Architecture globale

```
                    ┌─────────────────────────────┐
                    │     INSTRUCTION SIMPLE       │
                    │  "App de suivi de budget"    │
                    └──────────────┬──────────────┘
                                   │
              ┌────────────────────┼────────────────────┐
              │                    │                    │
     ┌────────▼────────┐  ┌───────▼───────┐  ┌────────▼────────┐
     │  decisions.md   │  │ wireframe     │  │  constitution   │
     │  (goût)         │  │ rules.md      │  │  (technique)    │
     │                 │  │ (structure)   │  │                 │
     │ • Philosophie   │  │ • Navigation  │  │ • Architecture  │
     │ • Choix UX      │  │ • Layouts     │  │ • Patterns      │
     │ • Nevers        │  │ • Composants  │  │ • Quality gates │
     │ • Tiebreakers   │  │ • Flux        │  │ • Naming        │
     └────────┬────────┘  └───────┬───────┘  └────────┬────────┘
              │                    │                    │
              └────────────────────┼────────────────────┘
                                   │
                    ┌──────────────▼──────────────┐
                    │    ARCHÉTYPES D'ÉCRAN       │
                    │  + RÉFÉRENCES GOLD STANDARD │
                    │  + INSTRUCTIONS .md (14+)   │
                    │  + CONTENT RULES            │
                    └──────────────┬──────────────┘
                                   │
                    ┌──────────────▼──────────────┐
                    │         SPECKIT             │
                    │  specify → plan → tasks     │
                    └──────────────┬──────────────┘
                                   │
                    ┌──────────────▼──────────────┐
                    │    CERTIFIED GATE LOOP      │
                    │                             │
                    │  Gate 1: Compilation        │
                    │  Gate 2: Pattern            │
                    │  Gate 3: Architecture       │
                    │  Gate 4: Experience 3-Layer  │
                    │  Gate 5: Tests              │
                    │  Gate 6: Visual (MCP)       │
                    └──────────────┬──────────────┘
                                   │
                    ┌──────────────▼──────────────┐
                    │      APP CERTIFIÉE          │
                    │   Prête au déploiement      │
                    └─────────────────────────────┘
```

### 7.2 Inventaire complet des fichiers de règles

| Fichier | Rôle | Statut |
|---------|------|--------|
| `.specify/memory/constitution.md` | Loi suprême technique | ✅ Existe |
| `.specify/memory/decisions.md` | Empreinte du créateur, goûts, nevers, tiebreakers | **À créer** |
| `.specify/memory/wireframe-rules.md` | Règles de structure d'écran et navigation | **À créer** |
| `.specify/memory/content-rules.md` | Ton, i18n patterns, icônes, données exemple | **À créer** |
| `flutter/.github/instructions/*.md` | 14+ fichiers de patterns Flutter | ✅ Existe |
| `flutter/.github/agents/*.md` | 9 agents Flutter (auditor, reviewer...) | ✅ Existe |
| `.github/agents/speckit.*.md` | 9 agents SpecKit | ✅ Existe |
| `docs/certified-gate-loop.md` | Partie 1 — Fondations & Boucle | ✅ Existe |
| `docs/certified-gate-loop-part2.md` | Partie 2 — Ce document | ✅ Existe |
| Script `verify-gates` | Les gates exécutables (compilation, pattern, archi, expérience) | **À créer** |
| Config MCP Mobile | Validation visuelle (screenshots, interactions) | **À configurer** |

### 7.3 Ordre d'implémentation recommandé

| Phase | Quoi | Impact |
|-------|------|--------|
| **A1** | Créer `decisions.md` | L'IA prend les bonnes décisions de goût |
| **A2** | Créer `wireframe-rules.md` | `speckit.specify` génère les wireframes auto |
| **A3** | Créer `content-rules.md` | L'IA génère le bon ton, les bonnes icônes |
| **B1** | Développer `verify-gates` (Gate 1+2) | Compilation + patterns vérifiés automatiquement |
| **B2** | Ajouter Gate 3 (architecture) | Imports entre couches vérifiés |
| **B3** | Ajouter Gate 4 (experience 3-Layer) | Fonctionnel + sensory + personality vérifiés |
| **C1** | Intégrer gates dans `speckit.implement` | Boucle autonome active |
| **C2** | Ajouter pre-commit hook | Sécurité même hors IA |
| **D1** | Configurer Mobile MCP | Gate 6 visuel disponible |
| **D2** | Intégrer Gate 6 dans la boucle | Validation visuelle autonome |
| **E1** | Pipeline déploiement (Fastlane / Playwright MCP) | De la compilation au Play Store |

### 7.4 Les 3 couches de certitude (rappel)

| Couche | Mécanisme | Ce qu'elle garantit |
|--------|-----------|-------------------|
| **Couche 1 : Scripts (verify-gates)** | Grep, dart analyze, import analysis, screenshots | Le code et le rendu sont techniquement conformes. Zéro dérive possible. |
| **Couche 2 : Archétypes + Références** | Templates de recettes + fichiers gold standard + wireframe rules | L'IA produit des écrans qui *ressemblent* à ce que l'humain aurait fait. |
| **Couche 3 : Decisions.md + Constitution + Content Rules** | Principes de goût, choix encodés, ton, icônes | L'IA prend les mêmes *décisions* que l'humain quand elle hésite. |

---

## Annexe A : Structure proposée pour `wireframe-rules.md`

```
# Règles de Wireframe

## 1. Principes de Design d'Information
   - Densité : max items/section, max sections/écran
   - Hiérarchie : titre > sous-titre > contenu > action
   - Progressive disclosure : surface simple, profondeur sur demande

## 2. Navigation
   - Quand utiliser bottom nav, tabs, navigation push
   - Nombre de tabs selon nombre de features
   - Ordre des tabs (fréquence d'usage)

## 3. Écrans par Type d'Action
   - Consulter → Liste + Détail
   - Créer/Modifier → Formulaire (bottom sheet ou full screen)
   - Analyser → Dashboard (graphiques + résumé)
   - Communiquer → Chat (liste + conversation)
   - Configurer → Settings (sections groupées)

## 4. Layout par Type de Données
   - Mapping donnée → composant
   - Mapping liste → layout (ListTile, Card, Grid, Timeline)

## 5. Flux Standards
   - Onboarding → Auth → Home
   - CRUD (Create, Read, Update, Delete)
   - Recherche → Filtres → Résultats
   - Notifications → Action

## 6. Règles de Composition
   - Header (salutation contextuelle ou titre de section)
   - Body (contenu principal, scrollable)
   - Footer (action primaire sticky si formulaire)
   - FAB (sur les listes, jamais sur les formulaires)

## 7. Règles par Archétype d'App
   - App de suivi (habits, santé) → Dashboard + Timeline
   - App de gestion (business) → CRUD + Rapports
   - App sociale (communauté) → Feed + Messages
   - App éducative → Leçons + Quiz + Progression
   - App financière → Transactions + Budget + Graphiques
```

---

## Annexe B : Relation entre Partie 1 et Partie 2

| Partie 1 | Partie 2 |
|----------|----------|
| Le problème et le diagnostic | La vision complète et la solution |
| Le concept de boucle | Les règles qui alimentent la boucle |
| Les 7 dérives de l'IA | Les mécanismes qui empêchent chaque dérive |
| Les 4 niveaux de gates (code) | Le gate visuel (MCP) qui complète |
| Validation humaine vs auto | Le chemin vers zéro intervention |
| Stratégie d'implémentation | Ordre de création des fichiers restants |

**Lecture recommandée :** Partie 1 d'abord (comprendre le problème et la boucle), puis Partie 2 (comprendre la vision complète et les règles manquantes).

---

*Créé le : 2026-03-16*  
*Dernière mise à jour : 2026-03-16*  
*Statut : Conception — En discussion*  
*Précédent : [Partie 1 — Fondations & Boucle de Validation](certified-gate-loop.md)*
