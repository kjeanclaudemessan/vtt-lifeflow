# Experience Architecture — Comment Chaque Session Ressemble

> **Ce fichier définit l'ARCHITECTURE ÉMOTIONNELLE de chaque session utilisateur.**
> Pas les layouts. Pas les widgets. L'arc narratif, le rythme, le timing psychologique.
> L'IA le lit avant de concevoir un flux ou un écran.
>
> **Dépend de :** Product Soul (les principes) → ce fichier les applique au rythme d'usage.

---

## I. L'Arc Narratif de Chaque Session

### Chaque ouverture de l'app est une histoire en 4 temps :

```
ARRIVÉE (0-3s)
    L'utilisateur ouvre l'app. Il est dans un état émotionnel réel 
    (stressé, motivé, curieux, ennuyé, coupable de revenir après absence).
    L'app le reconnaît — pas avec des mots, mais avec ce qu'elle MONTRE en premier.

        ↓

RECONNAISSANCE (3-8s)
    L'app prouve qu'elle "sait" où en est l'utilisateur.
    Pas un "Bonjour !" générique.
    Un état contextuel : "3/5 aujourd'hui", "Ta routine du soir commence dans 20 min",
    "Semaine à 80%, joli rythme".

        ↓

ACTION (8-60s)
    L'utilisateur fait LA chose pour laquelle il est venu. UNE seule.
    L'app lui présente l'action la plus probable IMMÉDIATEMENT.
    Pas un menu. Pas un choix entre 12 options.
    L'action la plus pertinente est déjà devant lui.

        ↓

RÉCOMPENSE (2-5s)
    L'app confirme que l'action a eu de la valeur.
    Pas un toast "Sauvegardé".
    Un signal que quelque chose a changé : un compteur qui monte,
    un visuel qui évolue, un message qui reconnaît l'effort.
    Proportionnel à l'importance de l'action.
```

### Application Code :

Chaque View principale encode les 4 temps :
```
1. ARRIVÉE    → Ce qui se charge en premier (le header, le résumé contextuel)
2. RECOGNITION → Les données personnalisées (progression, stats du jour, état)
3. ACTION     → L'action primaire (le bouton/zone la plus visible)
4. RÉCOMPENSE → Le feedback post-action (animation, haptic, message, UI update)
```

---

## II. Temps Psychologique

### L'app n'affiche pas la même chose selon l'heure. Pas par caprice — parce que l'utilisateur n'EST PAS la même personne à 7h et à 22h.

### Les 4 Modes Temporels :

```
MATIN (6h-12h) — Mode INTENTION
═══════════════════════════════════════════════════
  L'utilisateur se sent : plein de potentiel, légèrement anxieux de la journée
  
  L'app montre :
    - Le plan du jour (pas les stats d'hier)
    - Les actions du matin en premier
    - Ton énergique mais pas agressif : "Bonne journée ! Voici ton plan."
  
  L'app cache :
    - Les bilans, les graphiques, les stats lourdes
    - Les notifications non urgentes
  
  Sentiment cible : "Je sais ce que je fais aujourd'hui."


MI-JOURNÉE (12h-18h) — Mode EXÉCUTION
═══════════════════════════════════════════════════
  L'utilisateur se sent : occupé, en mode productif ou en perte de focus
  
  L'app montre :
    - L'état d'avancement ("4/7 fait")
    - L'action en cours ou la prochaine action
    - Interface minimale : action rapide en <10 secondes
  
  L'app cache :
    - Les onboardings, les suggestions, le contenu discovery
  
  Sentiment cible : "Fait. Je continue."


SOIR (18h-22h) — Mode RÉFLEXION
═══════════════════════════════════════════════════
  L'utilisateur se sent : fatigué, besoin de clôturer, parfois culpabilisant
  
  L'app montre :
    - Le bilan du jour (positif-first : CE QUI A ÉTÉ FAIT, pas ce qui manque)
    - La routine du soir si applicable
    - Suggestions douces : journal, humeur, gratitude
  
  L'app cache :
    - Les actions futures (demain), les plannings
    - Pas de rappel de ce qui n'a pas été fait
  
  Sentiment cible : "J'ai quand même avancé. Bonne soirée."


NUIT (22h-6h) — Mode REPOS
═══════════════════════════════════════════════════
  L'utilisateur ne devrait pas être dans l'app. S'il y est :
  
  L'app montre :
    - Interface ultra-minimale
    - Pas de stimulation visuelle (animations réduites, luminosité douce)
  
  L'app dit : "Repose-toi. On se revoit demain 🌙" (si pertinent)
  
  L'app NE fait PAS :
    - Envoyer des notifications
    - Montrer des tâches en retard
    - Proposer des actions
  
  Sentiment cible : Calme.
```

### Application Code :

```dart
// Le ViewModel principal expose un mode temporel
enum TimeMode { morning, midday, evening, night }

TimeMode get currentTimeMode {
  final hour = DateTime.now().hour;
  if (hour >= 6 && hour < 12) return TimeMode.morning;
  if (hour >= 12 && hour < 18) return TimeMode.midday;
  if (hour >= 18 && hour < 22) return TimeMode.evening;
  return TimeMode.night;
}

// La View adapte son contenu principal selon le mode
// Le greeting, l'ordre des sections, les actions visibles changent
```

---

## III. Les 6 Moments Critiques

### Ce sont les moments où l'app soit gagne l'utilisateur pour toujours, soit le perd.

### Moment #1 : First Run (le premier lancement)

```
ENJEU : L'utilisateur décide en 30 secondes s'il garde l'app.

SÉQUENCE OPTIMALE (max 60 secondes avant la valeur) :
  1. Splash (2s) → transition fluide, pas un logo qui traîne
  2. Proposition de valeur en 1 phrase (PAS 3 slides avec des illustrations)
     → "Construis tes habitudes. Vois ta progression."
     → OU : skip l'onboarding entièrement si la proposition est claire en-app
  3. Auth minimaliste (email + password, ou OAuth, RIEN D'AUTRE)
  4. Premier écran REMPLI :
     → Templates proposés ("Voici 5 habitudes populaires. Lesquelles te parlent ?")
     → OU contenu pré-rempli (domaines de vie par défaut, habitudes suggérées)
     → JAMAIS un écran vide avec "Crée ta première habitude"

RÈGLE DU FIRST RUN : 
  L'utilisateur doit RECEVOIR de la valeur avant d'en DONNER.
  L'app donne d'abord (templates, suggestions, data context).
  L'utilisateur personnalise après.
```

### Moment #2 : First Win (la première victoire)

```
ENJEU : L'utilisateur doit ressentir un succès dans les 2 premières minutes.

EXEMPLES :
  - Cocher sa première habitude → célébration disproportionnée 
    (animation, message "Première habitude !" — plus qu'un simple check)
  - Créer sa première routine → "Ta routine est prête ! Lance-la quand tu veux."
  - Configurer ses domaines de vie → visualisation immédiate (pas juste une liste)

RÈGLE : Le first win est DESIGNÉ, pas accidentel. 
L'app guide vers ce moment comme un tutoriel invisible.
```

### Moment #3 : Day 7 (l'aha-moment)

```
ENJEU : L'utilisateur comprend POURQUOI il continue d'utiliser l'app.

C'est le moment du premier bilan significatif.
Une semaine de data = assez pour montrer une tendance.

L'app doit :
  - Présenter un récapitulatif visuel impactant (pas un tableau — un RÉCIT)
  - "Cette semaine : 5 habitudes maintenues, 2h de méditation, streak de 4 jours"
  - Comparer à "la semaine d'avant" quand possible (même si la semaine d'avant = zéro)
  - Terminer par une projection : "Si tu continues : X en un mois"

C'EST LE MOMENT OÙ LE CHURN CHUTE. Si l'utilisateur passe le jour 7 
avec un aha-moment, la probabilité qu'il reste augmente dramatiquement.
```

### Moment #4 : The Dip (la baisse de motivation)

```
ENJEU : Entre le jour 10 et le jour 21, la nouveauté s'estompe. 
L'utilisateur a besoin de raisons de continuer.

L'app doit :
  - Varier les récompenses (pas le même message de félicitation chaque jour)
  - Introduire de la profondeur (features secondaires qui apparaissent naturellement)
  - Reconnaître les milestones : 10 jours, 2 semaines, 21 jours
  - Ne JAMAIS augmenter la friction (pas de nouvelles modales, pas de surveys)

L'app ne doit PAS :
  - Envoyer plus de notifications (l'utilisateur s'en lasse)
  - Proposer des "challenges" non demandés
  - Montrer des classements (la comparaison sociale démotive les gens en dip)
```

### Moment #5 : The Return (le retour après absence)

```
ENJEU : L'utilisateur revient après 3+ jours. C'est son dernier jugement.

L'app doit :
  1. NE PAS mentionner l'absence. Ni en jours, ni en ton.
  2. Montrer le TOTAL positif cumulé depuis le début (pas depuis la dernière visite)
  3. Proposer un redémarrage doux : "Juste une chose aujourd'hui ?"
  4. Le streak est un "nouveau départ !", pas un "streak perdu"
  5. Les settings/habitudes sont exactement comme ils les avaient laissées

L'app ne doit PAS :
  ✗ "Ça fait 5 jours qu'on ne t'a pas vu !"
  ✗ "Tu as manqué tes objectifs"
  ✗ "Streak perdu (était 12 jours)"
  ✗ Popup de ré-engagement
```

### Moment #6 : The Share (le moment de recommandation)

```
ENJEU : L'utilisateur veut parler de l'app à quelqu'un. Faciliter ce moment.

Ce qui déclenche le partage :
  - Un milestone personnel visuellement partageable (pas un screenshot brut)
  - Une feature spécifique qui l'a épaté
  - Son propre résultat rendu beau (bilan visuel, streak card, progression)

L'app doit :
  - Avoir un "share card" pour les milestones (image générée, jolie, avec le logo)
  - Rendre la progression exportable en 1 tap
  - Ne JAMAIS demander "Note-nous sur le Store" sauf après un moment de joie évident
```

---

## IV. Archétypes d'Écran (avec l'arc narratif)

### Chaque type d'écran suit l'arc ARRIVÉE → RECONNAISSANCE → ACTION → RÉCOMPENSE

### 1. Dashboard / Home

```
JOB : "Comment je m'en sors ?" (réponse en 3 secondes)

ARRIVÉE    : Greeting contextuel (heure du jour + prénom optionnel)
RECOGNITION: Résumé quantifié personnel (X/Y fait, progression %, streak)
ACTION     : La prochaine chose à faire (le CTA le plus probable)
RÉCOMPENSE : Si tout est fait → CompletionState (voir Vérité #6)

LAYOUT :
  - Header : greeting + date
  - Zone 1 : métrique principale (le chiffre le plus important GROS)
  - Zone 2 : liste courte des actions du moment (max 5 visibles)
  - Zone 3 : résumé secondaire (graphique compact optionnel)
  - JAMAIS plus de 3 zones visuelles distinctes

STATES :
  - Morning : actions du jour, ton énergique
  - Midday : progression actuelle, ton neutre
  - Evening : bilan, ton réflexif
  - Completion : tout est fait → célébration douce
  - First run : suggestions et templates, pas vide
  - Return : welcome back + total cumulé
```

### 2. Liste (habits, tâches, items)

```
JOB : "Qu'est-ce que j'ai / qu'est-ce que je fais ?" 

ARRIVÉE    : Liste apparaît avec staggered fade, skeleton pendant le chargement
RECOGNITION: Tri intelligent (les plus pertinents en haut, pas alphabétique par défaut)
ACTION     : Interaction directe sur les items (toggle, swipe) + FAB pour créer
RÉCOMPENSE : Feedback immédiat sur toggle (haptic + animation)

LAYOUT :
  - Search bar (si >10 items probables)
  - Filter chips (si catégories)
  - Liste scrollable (ListTile ou Card selon densité)
  - FAB en bas à droite (créer nouveau)

STATES :
  - Loading → AppSkeleton
  - Empty → AppEmptyState (invitation, pas constat) + CTA
  - First-run empty → Templates/suggestions spéciales
  - Content → Liste avec interactions
  - Error → Message honnête + retry
```

### 3. Formulaire (create, edit)

```
JOB : "Je veux sauvegarder quelque chose" (le plus vite possible)

ARRIVÉE    : Champs apparaissent en stagger top→bottom
RECOGNITION: Pré-remplissage intelligent (defaults contextuels)
ACTION     : Remplir + soumettre
RÉCOMPENSE : Animation de succès + redirection vers le contexte (pas la liste brute)

LAYOUT :
  - ≤4 champs : Bottom sheet
  - >4 champs : Page complète
  - >8 champs : Stepper (grouper en étapes)
  - Bouton primaire sticky en bas (toujours visible, même avec le clavier)
  
RÈGLES :
  - Les champs optionnels sont CACHÉS par défaut (expansion "Plus d'options")
  - Le clavier ne masque jamais le bouton de soumission
  - Validation en temps réel (après que l'utilisateur quitte le champ, pas pendant la saisie)
  - Erreur = message sous le champ (pas snackbar/dialog)
```

### 4. Détail (fiche, profil d'item)

```
JOB : "Je veux tout savoir sur cet élément"

ARRIVÉE    : Header hero en premier (image/icône + titre), body en scroll
RECOGNITION: Stats personnelles liées à cet item (streak, progression, historique)
ACTION     : Actions contextuelles (edit, delete, share)
RÉCOMPENSE : Si modification → confirmation visuelle inline (pas de popup)

LAYOUT :
  - Header : icône/image + titre + subtitle + badge optionnel
  - Sections : infos groupées par thème (description, stats, historique)
  - Actions : en haut dans l'AppBar (edit, share) ou en bas (delete avec confirmation)
```

### 5. Célébration (streak, milestone, completion)

```
JOB : "Me faire sentir que j'ai réussi quelque chose"

L'écran de célébration est ÉPHÉMÈRE (3-5 secondes) mais MÉMORABLE.

SÉQUENCE :
  1. Scale + glow depuis le centre (0-500ms)
  2. Message spécifique (PAS "Bravo !" générique — "7 jours de méditation 🧘")
  3. Chiffre héro (le nombre impressionnant en grand)
  4. Illustration ou animation contextuelle
  5. Fade out progressif vers l'écran suivant (pas de bouton "Fermer")

PROPORTIONNALITÉ :
  - Action quotidienne → micro-animation + haptic léger
  - Streak 7 jours → écran dédié 3s
  - Streak 30 jours → écran dédié + share card proposée
  - Streak 100 jours → full celebration + message unique
```

### 6. Empty / Zero State

```
JOB : "L'app doit me donner envie de commencer, pas me montrer le vide"

DEUX TYPES :
  A. First-run empty (jamais utilisé cette feature)
     → Templates, suggestions, "Les gens commencent souvent par..."
     → CTA : "Commencer avec un template" OU "Créer le mien"
     → Illustration douce, pas de texte technique
     
  B. Cleared empty (l'utilisateur a tout fait/supprimé) 
     → Message de fierté si approprié ("Tout est fait pour aujourd'hui 🎯")
     → OU invitation douce si supprimé ("Prêt quand tu voudras recommencer")
     → JAMAIS "Liste vide" ou "Aucun élément"
```

### 7. Settings / Profil

```
JOB : "Ajuster l'app à mes préférences" (visite rare mais importante)

LAYOUT :
  - Sections groupées avec headers (Compte, Préférences, Données, À propos)
  - ListTile avec toggle/navigation/info
  - Max 10 settings visibles. Le reste dans des sous-pages.
  - Version de l'app en footer (discrete)

RÈGLE : Les settings sont pour les POWER USERS. 
Les defaults intelligents font que la plupart ne visitent jamais cette page.
```

### 8. Onboarding

```
JOB : "Comprendre la valeur en 30 secondes"

OPTION A — Onboarding classique (3 slides max) :
  Slide 1 : Proposition de valeur (CE que l'app fait)
  Slide 2 : Feature différenciante (COMMENT elle le fait différemment)
  Slide 3 : CTA inscription
  Skip toujours visible.

OPTION B — Onboarding in-context (préféré en 2026) :
  Pas de slides. Auth rapide, puis l'app MONTRE sa valeur directement
  avec du contenu pré-rempli et des tooltips contextuels.

L'onboarding classique est de MOINS EN MOINS efficace. 
Les utilisateurs de 2026 skip tout. Préférer l'option B.
```

---

## V. Patterns Transversaux

### Progressive Disclosure (spatial)

```
Surface : Ce qui est visible au premier regard (titre, stat principale, CTA)
Profondeur 1 : Ce qui apparaît au scroll ou au tap (détails, historique)
Profondeur 2 : Ce qui est dans les settings ou les sous-pages (configuration avancée)

RÈGLE : Chaque niveau de profondeur divise l'audience par 5.
100% voient la surface. 20% scrollent. 4% vont dans les settings.
→ Mettre l'essentiel en surface. Toujours.
```

### Progressive Disclosure (temporel)

```
Jour 1   : Features de base (create, view, check)
Semaine 1 : Discovery features (filtres, personnalisation, raccourcis)
Mois 1   : Power features (export, stats avancées, automatisations)

Les features avancées ne sont pas CACHÉES — elles sont INTRODUITES 
au bon moment, quand l'utilisateur est prêt. Via tooltips contextuels, 
pas via onboarding forcé.
```

### Transitions et Navigation

```
Liste → Détail     : slide right (hero animation sur l'image/titre si possible)
Retour             : slide left (pop)
Formulaire / Modal : slide up (bottom sheet ou page modale)
Auth → Home        : cross-fade (clearStackAndShow, sentiment de "nouveau monde")
Tab switch         : instant (pas d'animation, la navigation est utilitaire)
Célébration        : scale + fade depuis le centre
Suppression        : item slide out + undo snackbar
```

---

*Créé le : 2026-03-17*
*Dernière mise à jour : 2026-03-17*
*Dépend de : product-soul.md*
