# Wireframe Rules — Les Structures d'Écran

> **Ce fichier définit les règles structurelles pour chaque wireframe d'écran.**
> L'IA le lit pour transformer un "je veux un écran de X" en wireframe précis, cohérent,
> respectant l'arc émotionnel (→ experience-architecture.md) et l'âme produit (→ product-soul.md).
>
> **Usage :** Ce n'est pas un design system (les composants sont dans le DS Flutter).
> C'est un système de DÉCISION pour QUEL composant mettre OÙ et POURQUOI.

---

## I. Framework "Users Do"

### Chaque écran se définit par ce que l'utilisateur FAIT, pas par ce qu'il VOIT.

```
AVANT (classique, interdit) :
  "La page Home a un AppBar, un ListView, un FloatingActionButton"
  → Décrit la structure. Ne dit rien sur le POURQUOI.

APRÈS (Users Do) :
  "L'utilisateur arrive sur Home → il voit où il en est (3s) → 
   il lance sa prochaine action → il reçoit un feedback"
  → Décrit le JOB. La structure EN DÉCOULE.
```

### Pour chaque écran, l'IA répond à 5 questions AVANT de wireframer :

```
1. USER DOES WHAT?     — L'action principale (verbe + objet)
2. USER NEEDS WHAT?    — L'info nécessaire avant d'agir
3. USER FEELS WHAT?    — L'émotion cible à la fin de l'interaction
4. USER COMES FROM?    — L'écran précédent (contexte de navigation)
5. USER GOES WHERE?    — L'écran suivant le plus probable
```

### Exemple — Écran "Mes Habitudes" :

```
1. DOES: Voir ses habitudes du jour et cocher celles faites
2. NEEDS: Liste des habitudes actives, état complété/non complété, streak
3. FEELS: Progression ("ça avance"), satisfaction (cocher = micro-win)
4. FROM: Home (tab navigation) ou notification
5. GOES: Détail habitude (tap) ou reste ici (toggle et sort)
```

→ Le wireframe DÉCOULE de ces réponses, pas l'inverse.

---

## II. Les 5 Couches d'un Wireframe

### Chaque wireframe se compose de 5 couches, de la plus stable à la plus variable :

### Couche 1 — Navigation Shell (identique partout)

```
RÈGLE : La navigation est INVISIBLE. L'utilisateur ne devrait jamais 
        "chercher" comment aller quelque part.

STRUCTURE :
  ┌──────────────────────────────────┐
  │ StatusBar (système)              │
  │ AppBar (titre / actions)         │
  │                                  │
  │         CONTENU                  │
  │     (couches 2-5)                │
  │                                  │
  │ BottomNavBar (AppBottomNav)      │
  │ SafeArea (système)               │
  └──────────────────────────────────┘

RÈGLES NAVIGATION :
  - AppBottomNav avec 4 items max sur mobile
  - 5 items = acceptable mais pas idéal
  - >5 items = redesign nécessaire (hamburger menu interdit)
  - L'onglet actif est ÉVIDENT (couleur + label, pas juste l'icône)
  - Chaque onglet a son propre Navigator (nested navigation)
  - AppBar : titre à gauche, actions à droite (2 max, 3 = overflow menu)
```

### Couche 2 — Zone Hero (le premier regard)

```
RÈGLE : La zone hero est ce que l'utilisateur voit en PREMIER, 
        avant de scroller. C'est la réponse à "Users Need What?".

TAILLE : 30-40% du viewport (au-dessus du fold)

CONTENU (au choix selon le type d'écran) :
  A. Métrique principale → Dashboard, bilan
     "72%" en grand, label en dessous
  
  B. Contexte temporel → Routines, planning
     "Mercredi 17 mars • Matin • 3 habitudes"
  
  C. Titre + description → Détail, fiche
     "[Icône] Méditation quotidienne • Streak: 12 jours"
  
  D. Rien (liste directe) → Listes utilitaires (settings, recherche)
     Commencer directement par le contenu

JAMAIS :
  - Image décorative sans information
  - Carrousel / slider en hero (les gens ne slide pas)
  - Trois métriques côte à côte dans le hero (en choisir UNE)
```

### Couche 3 — Zone de Contenu (le corps)

```
RÈGLE : Le contenu respecte la loi de Miller — 7±2 éléments max 
        visibles sans scroll.

PATTERNS :
  A. Liste verticale
     - Items homogènes (même type : habitudes, tâches, notes)
     - AppListTile ou AppCard selon la densité d'info
     - ListTile = info dense, beaucoup d'items
     - Card = visuellement riche, peu d'items
  
  B. Grille
     - Items visuels (catégories, icônes, avatars)
     - 2 colonnes mobile (max 3 sur tablette)
     - Jamais pour du texte long
  
  C. Sections empilées
     - Dashboard, profil, détail complexe
     - Chaque section a un header + contenu
     - Sections séparées par AppGaps.md (pas des dividers)
     - Max 5 sections visibles (les suivantes en scroll)
  
  D. Stepper / Wizard
     - Formulaires longs (>4 champs) ou processus séquentiels
     - Indicateur de progression visible
     - Back possible à chaque étape

SCROLL :
  - Le scroll vertical est OK et attendu
  - Le scroll horizontal est INTERDIT dans le contenu principal
    (exception : une seule rangée de chips/filtres)
  - Si le contenu ne rentre pas : paginer ou grouper, pas tout mettre
```

### Couche 4 — Zone d'Action (le CTA)

```
RÈGLE : Chaque écran a UNE action principale. 
        L'utilisateur ne doit pas choisir quoi faire.

PATTERNS :
  A. FAB (Floating Action Button)
     - action = "Créer nouveau" (habitude, note, routine)
     - Position : bottom-right, 16dp du bord
     - UNE seule FAB par écran (jamais mini-FAB, jamais speed dial)
  
  B. Bouton sticky en bas
     - action = "Valider/Soumettre" (formulaire, confirmation)
     - Pleine largeur, padding horizontal, au-dessus du BottomNav ou du SafeArea
     - TOUJOURS visible, même avec le clavier
  
  C. Action inline
     - action = "Toggle/modifier" sur un item
     - Checkbox, switch, swipe gesture
     - Feedback immédiat (haptic + animation)
  
  D. Action dans l'AppBar
     - action = "Modifier/Partager/Sauvegarder" (détail, profil)
     - Icône à droite dans l'AppBar
     - Max 2 icônes, sinon overflow menu

JAMAIS :
  - 2 boutons primaires côte à côte (un est primaire, l'autre est ghost/text)
  - Un CTA sous le fold sans indication qu'il faut scroller
  - Un bouton "Annuler" qui est aussi gros que "Valider"
```

### Couche 5 — Zone de Feedback (la récompense)

```
RÈGLE : Le feedback est proportionnel à l'importance de l'action.

HIÉRARCHIE :
  Tier 1 (micro) — Actions quotidiennes récurrentes
    → Haptic léger + animation subtile (scale 1.0→1.1→1.0 en 200ms)
    → Pas de texte, pas de popup
    → Ex : cocher une habitude, changer un toggle
  
  Tier 2 (midi) — Actions significatives
    → Snackbar de confirmation (2s, auto-dismiss)
    → OU inline update visible (compteur +1, barre de progression)
    → Ex : sauvegarder un formulaire, terminer une routine
  
  Tier 3 (macro) — Milestones et célébrations
    → Écran dédié ou overlay animé (3-5s)
    → Message spécifique (pas générique)
    → Ex : compléter un streak, atteindre un objectif
  
  Tier 4 (méga) — Accomplissements rares
    → Full-screen celebration avec share card
    → Message unique et personnalisé
    → Ex : streak 100 jours, tout compléter

JAMAIS :
  - Dialog/AlertDialog pour confirmer une action non-destructive
  - Toast "Sauvegardé !" pour chaque action mineure
  - Pas de feedback du tout (l'utilisateur doute si ça a marché)
```

---

## III. Règles de Densité et Espacement

```
ESPACEMENTS (utiliser AppGaps/AppSpacing exclusivement) :

  Entre sections        : AppGaps.lg (24dp)
  Entre items de liste  : AppGaps.sm (8dp) ou 0 si ListTile
  Padding écran         : AppSpacing.md (16dp) horizontal
  Padding bottom        : AppSpacing.lg (24dp) minimum (safe area)
  Entre label et input  : AppGaps.xs (4dp)

DENSITÉ :
  Mobile portrait : 1 colonne, items empilés
  Mobile paysage  : éviter, mais si forcé = 2 colonnes
  Tablette        : 2 colonnes content, side-by-side layout si master-detail

TYPOGRAPHIE (utiliser AppTextStyles exclusivement) :
  Hero / Métrique       : displayLarge ou displayMedium
  Titre de section      : titleMedium
  Titre d'item (card)   : bodyLarge
  Description / body    : bodyMedium
  Label / caption       : labelSmall (AppColors.textSecondary)
```

---

## IV. Déduction Automatique (workflow IA)

### Comment l'IA passe de l'instruction au wireframe :

```
INSTRUCTION : "Créer un écran qui affiche les habitudes du jour"

ÉTAPE 1 — Users Do :
  1. DOES: Voir ses habitudes, cocher celles complétées
  2. NEEDS: Liste habitudes actives, état complété, streak personnel
  3. FEELS: Progression, satisfaction du check
  4. FROM: Home (BottomNav), notification
  5. GOES: Détail habitude, reste sur place

ÉTAPE 2 — Archétype (→ experience-architecture.md) :
  → Type "Liste" avec toggle inline

ÉTAPE 3 — Couches :
  Couche 1: BottomNav (actif sur "Habitudes") + AppBar("Habitudes", actions: [filter])
  Couche 2: Hero = contexte jour ("Mercredi • 3/7 complétées")
  Couche 3: Liste verticale d'AppListTile avec leading icon, trailing checkbox
  Couche 4: FAB "Ajouter habitude"
  Couche 5: Toggle checkbox → haptic + scale animation (Tier 1)

ÉTAPE 4 — States :
  Loading → Skeleton (6 items shimmer)
  Empty (first run) → AppEmptyState + suggestions templates
  Empty (cleared) → "Tout fait ! 🎯"
  Content → Liste interactive
  Error → Message + retry

ÉTAPE 5 — Temps psychologique :
  Matin → Tri par routine du matin, ton "Bonne journée"
  Midi → Tri par non-complétées en premier, ton neutre
  Soir → Bilan "X sur Y aujourd'hui", ton réflexif
```

---

## V. Anti-Patterns (wireframes à refuser)

```
✗ MENU HAMBURGER
  Raison : cache la navigation, détruit la découvrabilité
  Alternative : BottomNav avec 4-5 items

✗ CARROUSEL EN HERO
  Raison : 95% des utilisateurs ne slide jamais le 2ème item
  Alternative : Un seul contenu hero. Le reste en scroll vertical.

✗ TAB BAR + BOTTOM NAV
  Raison : double navigation = confusion
  Alternative : Un seul système de nav. Tabs DANS une page = OK. Tabs comme nav principale = non.

✗ ÉCRAN VIDE APRÈS CREATE
  Raison : l'écran vide punit l'utilisateur qui n'a pas encore de données
  Alternative : Templates, suggestions, contenu par défaut

✗ MODAL POUR TOUT
  Raison : les modals interrompent le flow
  Alternative : Bottom sheet pour les formulaires courts, inline expansion pour les détails

✗ SCROLL HORIZONTAL DE CONTENU
  Raison : invisible, les utilisateurs ne le découvrent pas
  Alternative : Vertical. Toujours vertical. (sauf chips/filtres sur 1 rang)

✗ DOUBLE CTA PRIMAIRE
  Raison : paralyse la décision
  Alternative : 1 primaire (filled) + 1 secondaire (outlined/text)

✗ LOADING SPINNER PLEIN ÉCRAN
  Raison : donne l'impression que l'app est lente
  Alternative : Skeleton shimmer (contenu fantôme)

✗ DIALOG POUR CONFIRMER DES ACTIONS NON-DESTRUCTIVES
  Raison : "Voulez-vous vraiment sauvegarder ?" insulte l'utilisateur
  Alternative : Sauvegarder directement. Undo si nécessaire.
```

---

## VI. Responsive Breakpoints

```
MOBILE (< 600dp)    : Navigation BottomNav, 1 colonne, FAB
TABLETTE (600-1200) : Navigation Rail ou BottomNav, 2 colonnes, master-detail
DESKTOP (> 1200)    : Navigation Rail permanent, 3 colonnes si utile

L'application Flutter cible MOBILE FIRST.
Le responsive vers tablette est un bonus, pas un objectif initial.
desktop = version web si applicable.
```

---

*Créé le : 2026-03-17*
*Dernière mise à jour : 2026-03-17*
*Dépend de : product-soul.md, experience-architecture.md*
