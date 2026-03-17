# Wireframe Rules — Le Système de Décision Structurel

> **Ce fichier définit les règles de DÉCISION pour construire un wireframe.**
> L'IA le lit pour transformer "je veux un écran de X" en structure précise et cohérente,
> respectant l'arc émotionnel (→ experience-architecture.md) et l'âme produit (→ product-soul.md).
>
> **Ce fichier ne contient PAS :** de valeurs de spacing, de noms de widgets, de code Dart,
> de breakpoints responsive, de patterns de navigation détaillés.
> Pour les tokens/spacing → voir `tokens.instructions.md`
> Pour la navigation → voir `navigation.instructions.md`
> Pour le responsive → voir `responsive.instructions.md`
> Pour les feedback tiers → voir `haptics.instructions.md` + `celebrations.instructions.md`
>
> **Usage :** Ce n'est pas un design system. C'est un système de DÉCISION pour QUEL composant mettre OÙ et POURQUOI.

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

## II. Les 5 Couches d'un Wireframe (Framework de Décision)

### Chaque wireframe se compose de 5 couches, de la plus stable à la plus variable.
### L'IA choisit le CONTENU de chaque couche. L'implémentation exacte est dans `.github/instructions/`.

### Couche 1 — Navigation Shell

La navigation est INVISIBLE. L'utilisateur ne devrait jamais "chercher" comment aller quelque part.

**Décisions de conception :**
- 4 items principaux (5 max). Au-delà → redesign.
- L'onglet actif est évident (couleur + label, pas juste l'icône).
- L'AppBar : titre à gauche, 2 actions max à droite.

> Implémentation détaillée : `navigation.instructions.md`

### Couche 2 — Zone Hero (le premier regard)

C'est ce que l'utilisateur voit en PREMIER, avant de scroller. C'est la réponse à "Users Need What?".

**Taille :** 30-40% du viewport (au-dessus du fold)

**Types de Hero (au choix selon l'écran) :**

| Type | Usage | Contenu |
|------|-------|---------|
| A. Métrique | Dashboard, bilan | UN chiffre en grand + label |
| B. Contexte temporel | Routines, planning | Jour + heure + résumé |
| C. Titre + description | Détail, fiche | Icône + titre + stats |
| D. Rien (liste directe) | Settings, recherche | Commencer directement par le contenu |

**Jamais :**
- Image décorative sans information
- Carrousel / slider en hero (les gens ne slide pas)
- Trois métriques côte à côte (en choisir UNE)

### Couche 3 — Zone de Contenu (le corps)

Le contenu respecte la **loi de Miller** — 7±2 éléments max visibles sans scroll.

**Patterns :**

| Pattern | Quand | Notes |
|---------|-------|-------|
| A. Liste verticale | Items homogènes (habitudes, tâches) | ListTile = dense, Card = visuellement riche |
| B. Grille | Items visuels (catégories, icônes) | 2 colonnes mobile. Jamais pour du texte long |
| C. Sections empilées | Dashboard, profil, détail complexe | Max 5 sections visibles |
| D. Stepper / Wizard | Formulaires >4 champs | Indicateur de progression visible |

**Scroll :**
- Vertical = OK et attendu.
- Horizontal = INTERDIT dans le contenu principal (exception : une rangée de chips/filtres).

### Couche 4 — Zone d'Action (le CTA)

Chaque écran a UNE action principale. L'utilisateur ne doit pas choisir quoi faire.

**Patterns :**

| Pattern | Pour | Règle |
|---------|------|-------|
| A. FAB | "Créer nouveau" | Bottom-right. UN seul par écran. |
| B. Bouton sticky bas | "Valider/Soumettre" | Pleine largeur. Toujours visible même avec clavier. |
| C. Action inline | "Toggle/modifier" sur item | Feedback immédiat. |
| D. Action AppBar | "Modifier/Partager" | Max 2 icônes, sinon overflow. |

**Jamais :**
- 2 boutons primaires côte à côte (1 primaire + 1 secondaire/text)
- Un CTA sous le fold sans indication de scroll
- Un "Annuler" aussi gros que "Valider"

### Couche 5 — Zone de Feedback (la récompense)

Le feedback est proportionnel à l'importance de l'action.

**Hiérarchie de décision :**

| Tier | Pour | Feedback |
|------|------|----------|
| 1 (micro) | Actions quotidiennes récurrentes | Haptic léger + animation subtile. Pas de texte. |
| 2 (midi) | Actions significatives | Snackbar ou inline update visible |
| 3 (macro) | Milestones | Overlay animé 3-5s + message spécifique |
| 4 (méga) | Accomplissements rares | Full celebration + share card |

**Jamais :**
- Dialog pour confirmer une action non-destructive
- Toast "Sauvegardé !" pour chaque action mineure
- Zéro feedback (l'utilisateur doute)

> Implémentation des feedbacks : `haptics.instructions.md` + `celebrations.instructions.md`

---

## III. Restraint Principle

### Chaque écran a UN focus. Si un élément ne sert pas ce focus, il n'a rien à faire là.

**Méthode de validation "Masque" :**
```
Pour chaque élément de l'écran, se demander :
  "Si je masque cet élément, l'écran perd-il sa raison d'être ?"
  
  OUI → L'élément est essentiel. Il reste.
  NON → L'élément est du bruit. Il part (ou va en profondeur 1/2).
```

**Application :**
```
DASHBOARD
  Essentiel : métrique principale + prochaine action + progression du jour
  Bruit     : graphique historique (profondeur 1), stats détaillées (profondeur 2)

LISTE
  Essentiel : les items + leur état + création
  Bruit     : les statistiques de la liste (profondeur 1)

FORMULAIRE
  Essentiel : les champs requis + le bouton submit
  Bruit     : les champs optionnels ("Plus d'options", collapsé par défaut)

DÉTAIL
  Essentiel : identité de l'item + ses stats clés
  Bruit     : historique complet (profondeur 1), paramètres avancés (profondeur 2)
```

**Règle quantitative :**
```
  - Si l'écran a plus de 3 zones visuelles distinctes → simplifier
  - Si l'écran cumulé > 2 scrolls de contenu → paginer ou grouper
  - Si l'utilisateur hésite > 2 secondes sur quoi faire → le focus est flou
```

---

## IV. Platform-Specific UX

### L'app respecte les conventions de la plateforme. Les utilisateurs s'y attendent.

### iOS vs Android

| Aspect | iOS | Android |
|--------|-----|---------|
| Retour | Swipe-back depuis le bord gauche | Predictive back gesture (system) |
| Titres | Large titles dans le header (collapse on scroll) | Titre standard dans AppBar |
| Couleurs système | Accent = bleu système par défaut | Dynamic Color / Material You |
| Affichage | Safe area top + bottom (notch, home indicator) | Edge-to-edge (transparent status/nav bars) |
| Partage | Share sheet native iOS | Intent system Android |
| Haptics | UIImpactFeedback (heavy/medium/light) | Vibration patterns |
| Dialogs | iOS-style bottom sheets + alert dialogs | Material bottom sheets + dialogs |
| Scroll | Bounce overscroll | Glow overscroll |

### Règles cross-platform

```
  1. JAMAIS émuler les patterns d'une plateforme sur l'autre.
     Pas de back-swipe iOS sur Android. Pas de Material dialogs sur iOS.
  
  2. Le CONTENU est identique. Le COMPORTEMENT s'adapte.
     Même information, même flow, même arc émotionnel.
     L'interaction physique suit les conventions de la plateforme.
  
  3. Les fonts suivent la plateforme.
     iOS : SF Pro. Android : Roboto (ou la font Material de la skin).
     La font cross-platform est un FALLBACK, pas le premier choix.

  4. Les icônes restent LucideIcons (cohérence factory).
     Exception : system icons (back, share, more) suivent la plateforme.
```

---

## V. Déduction Automatique (workflow IA)

### Comment l'IA passe de l'instruction au wireframe :

```
INSTRUCTION : "Créer un écran qui affiche les habitudes du jour"

ÉTAPE 1 — Users Do :
  1. DOES: Voir ses habitudes, cocher celles complétées
  2. NEEDS: Liste habitudes actives, état complété, streak personnel
  3. FEELS: Progression, satisfaction du check
  4. FROM: Home (BottomNav), notification
  5. GOES: Détail habitude, reste sur place

ÉTAPE 2 — Archétype émotionnel (→ experience-architecture.md) :
  → Type "Liste" avec toggle inline

ÉTAPE 3 — Les 5 Couches :
  Couche 1: Navigation (actif sur "Habitudes") + AppBar avec filtre
  Couche 2: Hero = contexte jour ("Mercredi • 3/7 complétées")
  Couche 3: Liste verticale avec interactions directes (toggle)
  Couche 4: FAB "Ajouter habitude"
  Couche 5: Toggle → feedback tier 1 (micro)

ÉTAPE 4 — Restraint Check :
  Métrique du jour : essentiel (reste)
  Liste habitudes  : essentiel (reste)
  Stats historique : bruit (profondeur 1, scroll)
  Graphique semaine: bruit (profondeur 2, sous-page)

ÉTAPE 5 — States (→ states.instructions.md pour implémentation) :
  Loading → Skeleton
  Empty (first run) → Suggestions + templates
  Empty (cleared) → "Tout fait ! 🎯"
  Content → Liste interactive
  Error → Message + retry

ÉTAPE 6 — Temps psychologique (→ experience-architecture.md) :
  Matin → Tri par routine du matin, ton "Bonne journée"
  Midi → Tri par non-complétées en premier, ton neutre
  Soir → Bilan "X sur Y aujourd'hui", ton réflexif

ÉTAPE 7 — Platform check (→ §IV de ce fichier) :
  iOS → Large title "Habitudes", swipe-back, bounce overscroll
  Android → Standard AppBar, predictive back, edge-to-edge
```

---

## VI. Anti-Patterns (wireframes à refuser)

### Structurels (décisions)

```
✗ ÉCRAN SANS FOCUS CLAIR
  Test : "Que fait l'utilisateur ici en UNE phrase ?"
  Si la réponse contient "et", l'écran fait trop de choses.

✗ CARROUSEL EN HERO
  95% des utilisateurs ne slide jamais le 2ème item.
  Alternative : Un seul contenu hero. Le reste en scroll vertical.

✗ ÉCRAN VIDE APRÈS CREATE
  L'écran vide punit l'utilisateur qui n'a pas encore de données.
  Alternative : Templates, suggestions, contenu par défaut.

✗ TAB BAR + BOTTOM NAV
  Double navigation = confusion.
  Un seul système de nav. Tabs DANS une page = OK. Tabs comme nav principale = non.

✗ SCROLL HORIZONTAL DE CONTENU
  Invisible, les utilisateurs ne le découvrent pas.
  Alternative : Vertical. Toujours vertical. (sauf chips/filtres sur 1 rang)

✗ DOUBLE CTA PRIMAIRE
  Paralyse la décision.
  Alternative : 1 primaire (filled) + 1 secondaire (outlined/text)

✗ DIALOG POUR ACTION NON-DESTRUCTIVE
  "Voulez-vous vraiment sauvegarder ?" insulte l'utilisateur.
  Alternative : Sauvegarder directement. Undo si nécessaire.
```

> Les anti-patterns de navigation (hamburger menu, etc.) sont dans `navigation.instructions.md`.
> Les anti-patterns de performance (loading spinners, etc.) sont dans `performance.instructions.md`.

---

## Implémentation (→ .github/instructions/)

| Aspect | Fichier de référence |
|--------|---------------------|
| Navigation (BottomNav, AppBar, nested nav) | `design-system-navigation.instructions.md` |
| Tokens (spacing, radius, shadows, colors) | `design-system-tokens.instructions.md` |
| Responsive (breakpoints, colonnes, adaptive) | `design-system-responsive.instructions.md` |
| Haptics (tiers, vibrations, platform) | `design-system-haptics.instructions.md` |
| Célébrations visuelles | `design-system-celebrations.instructions.md` |
| États d'écran (loading, empty, error) | `design-system-states.instructions.md` |
| Composants (widgets App*) | `design-system-components.instructions.md` |
| Motion (animations, transitions) | `design-system-motion.instructions.md` |
| Performance (skeleton, lazy, optimisations) | `design-system-performance.instructions.md` |

---

*Créé le : 2026-03-17*
*Dernière mise à jour : 2026-03-17*
*Dépend de : product-soul.md, experience-architecture.md*
