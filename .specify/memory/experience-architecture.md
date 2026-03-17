# Experience Architecture — L'Architecture Émotionnelle de Chaque Session

> **Ce fichier définit le RYTHME et l'ARC ÉMOTIONNEL de chaque session utilisateur.**
> Pas les layouts. Pas les widgets. Le timing psychologique, les moments critiques, les boucles de rétention.
> L'IA le lit avant de concevoir un flux ou un écran.
>
> **Ce fichier ne contient PAS :** de layouts spécifiques, de noms de widgets, de code Dart, de tokens de design.
> Pour les layouts → voir `wireframe-rules.md`
> Pour les animations/transitions → voir `motion.instructions.md`
> Pour les célébrations visuelles → voir `celebrations.instructions.md`
> Pour les états d'écran → voir `states.instructions.md`
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

Chaque View principale encode implicitement ces 4 temps :
1. **ARRIVÉE** → ce qui se charge en premier (header, résumé contextuel)
2. **RECONNAISSANCE** → les données personnalisées (progression, stats du jour)
3. **ACTION** → l'action primaire (la zone la plus visible)
4. **RÉCOMPENSE** → le feedback post-action

---

## II. Temps Psychologique

### L'app n'affiche pas la même chose selon l'heure. L'utilisateur n'EST PAS la même personne à 7h et à 22h.

### Les 4 Modes Temporels :

```
MATIN (6h-12h) — Mode INTENTION
  L'utilisateur se sent : plein de potentiel, légèrement anxieux
  L'app montre : le plan du jour, les actions du matin
  L'app cache : les bilans, les graphiques, les stats lourdes
  Ton : énergique mais pas agressif
  Sentiment cible : "Je sais ce que je fais aujourd'hui."

MI-JOURNÉE (12h-18h) — Mode EXÉCUTION
  L'utilisateur se sent : occupé, en mode productif ou en perte de focus
  L'app montre : l'état d'avancement, l'action en cours ou suivante
  L'app cache : les onboardings, les suggestions, le discovery
  Ton : neutre, efficace
  Sentiment cible : "Fait. Je continue."

SOIR (18h-22h) — Mode RÉFLEXION
  L'utilisateur se sent : fatigué, besoin de clôturer
  L'app montre : le bilan du jour (positif-first), la routine du soir
  L'app cache : les actions futures, les plannings
  Ton : réflexif, doux
  Sentiment cible : "J'ai quand même avancé. Bonne soirée."

NUIT (22h-6h) — Mode REPOS
  L'utilisateur ne devrait pas être dans l'app. S'il y est :
  L'app montre : interface ultra-minimale
  L'app NE fait PAS : notifications, tâches en retard, propositions d'action
  Sentiment cible : Calme.
```

```dart
// Le ViewModel expose un mode temporel
enum TimeMode { morning, midday, evening, night }

TimeMode get currentTimeMode {
  final hour = DateTime.now().hour;
  if (hour >= 6 && hour < 12) return TimeMode.morning;
  if (hour >= 12 && hour < 18) return TimeMode.midday;
  if (hour >= 18 && hour < 22) return TimeMode.evening;
  return TimeMode.night;
}
```

---

## III. Les 6 Moments Critiques

### Ce sont les moments où l'app soit gagne l'utilisateur pour toujours, soit le perd.

### Moment #1 : First Run (le premier lancement)

L'utilisateur décide en 30 secondes s'il garde l'app.

**Séquence optimale (max 60s avant la valeur) :**
1. Splash (2s) → transition fluide
2. Proposition de valeur en 1 phrase (PAS 3 slides d'illustrations)
3. Auth minimaliste (email + password, ou OAuth, RIEN D'AUTRE)
4. Premier écran REMPLI : templates, suggestions, contenu pré-rempli — JAMAIS vide

**Règle :** L'utilisateur REÇOIT de la valeur avant d'en DONNER.

### Moment #2 : First Win (la première victoire)

L'utilisateur doit ressentir un succès dans les 2 premières minutes.

- Cocher sa première habitude → célébration disproportionnée
- Créer sa première routine → "Ta routine est prête !"
- Configurer ses domaines → visualisation immédiate

**Règle :** Le first win est DESIGNÉ, pas accidentel. L'app guide vers ce moment comme un tutoriel invisible.

### Moment #3 : Day 7 (l'aha-moment)

C'est le moment du premier bilan significatif. Une semaine de data = assez pour une tendance.

L'app doit :
- Présenter un récapitulatif visuel impactant (un RÉCIT, pas un tableau)
- Comparer à "la semaine d'avant" quand possible
- Terminer par une projection : "Si tu continues : X en un mois"

**C'est LE moment où le churn chute.** Si l'utilisateur passe le jour 7 avec un aha-moment, la probabilité qu'il reste augmente dramatiquement.

### Moment #4 : The Dip (la baisse de motivation, jours 10-21)

La nouveauté s'estompe. L'utilisateur a besoin de raisons de continuer.

**L'app doit :**
- Varier les récompenses (pas le même message chaque jour)
- Introduire de la profondeur (features secondaires qui apparaissent naturellement)
- Reconnaître les milestones : 10 jours, 2 semaines, 21 jours
- Proposer des insights sur les patterns détectés ("Tu médites surtout le matin")

**L'app ne doit PAS :**
- Envoyer PLUS de notifications (l'utilisateur s'en lasse)
- Proposer des challenges non demandés
- Montrer des classements (la comparaison sociale démotive en dip)
- Augmenter la friction (pas de modales, pas de surveys)

### Moment #5 : The Return (le retour après absence)

L'utilisateur revient après 3+ jours. C'est son dernier jugement.

**Séquence :**
1. NE PAS mentionner l'absence. Ni en jours, ni en ton.
2. Montrer le TOTAL positif cumulé depuis le début
3. Proposer un redémarrage doux : "Juste une chose aujourd'hui ?"
4. Le streak est un "nouveau départ !", pas un "streak perdu"
5. Les settings/données sont exactement comme il les avait laissées

**Jamais :** "Ça fait 5 jours !", "Tu as manqué tes objectifs", "Streak perdu", popup de ré-engagement.

### Moment #6 : The Share (le moment de recommandation)

Ce qui déclenche le partage :
- Un milestone visuellement partageable (share card générée, pas screenshot brut)
- Son propre résultat rendu beau (bilan visuel, streak card, progression)

L'app doit rendre la progression exportable en 1 tap. Ne JAMAIS demander "Note-nous sur le Store" sauf après un moment de joie évident.

---

## IV. Rétention Loop Architecture

### Le cycle d'engagement éthique

```
TRIGGER → ACTION → RÉCOMPENSE → INVESTISSEMENT → (loop)

TRIGGER
  Externe (jours 1-7)  : notification utile, rappel de routine
  Interne (jour 7+)    : habitude, besoin de vérifier, envie de cocher
  Le but : passer du trigger externe à l'interne le plus vite possible.

ACTION
  La plus courte possible. 30-90 secondes par session.
  L'app n'est PAS un réseau social. L'utilisateur fait sa chose et sort.

RÉCOMPENSE
  Variable : les messages changent. Les animations surprennent.
  Informative : progrès réel (stats, patterns, insights).
  JAMAIS addictive : pas de points fictifs, pas de streaks punitifs.

INVESTISSEMENT
  Chaque utilisation enrichit l'app : données, personnalisation, historique.
  L'app devient plus précieuse avec le temps.
  C'est l'investissement (pas le paywall) qui crée la rétention.
```

### Dégradation Gracieuse de l'Engagement

```
Si l'utilisateur ralentit son usage :
  Semaine 1 : Notifications normales (rappels de routine)
  Semaine 2 : Réduire à 1 notification/jour maximum
  Semaine 3 : 1 notification tous les 2 jours, contenu "bilan" type
  Semaine 4+ : Stop. Silence. L'app attend son retour sans harceler.

  Quand il revient : "Bon retour. Voici ton total." Pas "Tu nous manquais !"
```

### Variable Rewards par Tier d'Action

```
QUOTIDIEN (check habitude, compléter routine) :
  Pool de 10+ messages courts alternés : 
  "✓", "Fait.", "Un pas de plus.", "Régulier.", "C'est noté."
  L'animation haptic/visuel varie aussi subtilement.

HEBDOMADAIRE (bilan de la semaine) :
  Insight unique basé sur les données réelles :
  "Cette semaine : +2 habitudes vs la semaine dernière."
  "Tu médites surtout le matin. Ça te va ?"

MILESTONE (streak 7, 30, 100) :
  Message unique, spécifique, jamais réutilisé.
  "30 jours. Un mois entier. Tu as prouvé que c'est possible."
```

---

## V. Archétypes d'Écran (JOB + ARC + STATES)

### Chaque type d'écran suit l'arc ARRIVÉE → RECONNAISSANCE → ACTION → RÉCOMPENSE

> Les layouts, les widgets, et le code spécifique sont dans `wireframe-rules.md` et les `.github/instructions/`.
> Ici : le JOB émotionnel et les STATES temporels UNIQUEMENT.

### 1. Dashboard / Home

```
JOB : "Comment je m'en sors ?" (réponse en 3 secondes)

ARRIVÉE    : Greeting contextuel (heure du jour)
RECOGNITION: Résumé quantifié personnel (X/Y, progression %, streak)
ACTION     : La prochaine chose à faire (le CTA le plus probable)
RÉCOMPENSE : Si tout est fait → CompletionState

STATES TEMPORELS :
  Matin → actions du jour, ton énergique
  Midi  → progression actuelle, ton neutre
  Soir  → bilan, ton réflexif
  Nuit  → ultra-minimal

STATES CRITIQUES :
  First run → suggestions + templates, pas vide
  Return    → welcome back + total cumulé  
  Completion → tout est fait → célébration douce
```

### 2. Liste (habits, tâches, items)

```
JOB : "Qu'est-ce que j'ai / qu'est-ce que je fais ?"

ARRIVÉE    : Contenu apparaît rapidement
RECOGNITION: Tri intelligent (pertinents d'abord, pas alphabétique)
ACTION     : Interaction directe (toggle, swipe) + création
RÉCOMPENSE : Feedback immédiat sur chaque interaction

STATES CRITIQUES :
  First-run empty → Templates/suggestions spéciales
  Cleared empty   → Message de fierté si approprié
  Content         → Liste avec interactions directes
```

### 3. Formulaire (create, edit)

```
JOB : "Sauvegarder quelque chose" (le plus vite possible)

ARRIVÉE    : Champs pré-remplis intelligemment (defaults contextuels)  
ACTION     : Remplir + soumettre
RÉCOMPENSE : Confirmation + redirection vers le contexte pertinent

RÈGLES DÉCISIONNELLES :
  ≤4 champs → Bottom sheet
  >4 champs → Page complète
  >8 champs → Stepper
  Champs optionnels → cachés par défaut ("Plus d'options")
```

### 4. Détail (fiche, profil d'item)

```
JOB : "Tout savoir sur cet élément"

ARRIVÉE    : Header hero (icône + titre)
RECOGNITION: Stats personnelles liées (streak, progression, historique)
ACTION     : Edit, delete, share (contextuels)
RÉCOMPENSE : Confirmation inline (pas de popup)
```

### 5. Célébration (streak, milestone, completion)

```
JOB : "Me faire sentir que j'ai réussi quelque chose"

ÉPHÉMÈRE (3-5s) mais MÉMORABLE.
Message spécifique (PAS "Bravo !").
Proportionnel à l'importance du milestone.
```

### 6. Empty / Zero State

```
JOB : "Donner envie de commencer, pas montrer le vide"

First-run  → Templates, suggestions, invitation
Cleared    → Message de fierté OU invitation douce
JAMAIS : "Liste vide", "Aucun élément"
```

### 7. Settings / Profil

```
JOB : "Ajuster l'app à mes préférences" (visite rare)

Les settings sont pour les POWER USERS.
Les defaults intelligents font que la plupart ne visitent jamais cette page.
```

### 8. Onboarding

```
JOB : "Comprendre la valeur en 30 secondes"

PRÉFÉRÉ (2026) : Pas de slides. Auth rapide, puis l'app MONTRE sa valeur.
FALLBACK : 3 slides max. Skip toujours visible.

Les utilisateurs de 2026 skip tout. Montrer > Dire.
```

---

## VI. Progressive Disclosure Temporal (J1 → J90)

### Plan de découverte sur 3 mois :

```
JOUR 1 — INSTALLATION & FIRST WIN
  L'utilisateur voit     : L'essentiel. UNE action à faire.
  L'app propose          : Templates, contenu pré-rempli
  Objectif               : First win dans les 2 minutes
  Feature depth          : Surface uniquement

JOUR 2-3 — HABITUDE NAISSANTE
  L'utilisateur fait     : Sa routine de base (ouvrir → cocher → fermer)
  L'app propose          : Rien de nouveau. Solidifier l'habitude de base.
  Objectif               : L'utilisateur revient de lui-même
  
JOUR 3-7 — DISCOVERY CONTEXTUEL
  L'utilisateur voit     : Des tips contextuels (pas des popups !)
  L'app propose          : "Tu savais que tu peux aussi X ?" (au bon moment)
  Objectif               : Découverte d'une 2ème feature
  Feature depth          : Filtres, personnalisation légère

JOUR 7 — AHA-MOMENT (CRITIQUE)
  L'utilisateur voit     : Premier bilan hebdomadaire avec visuel impactant
  L'app propose          : Projection "Si tu continues : X en un mois"
  Objectif               : Comprendre POURQUOI continuer
  Feature depth          : Stats de base, trends

JOUR 7-14 — APPROPRIATION
  L'utilisateur fait     : Personnalise (renomme, réorganise, ajuste)
  L'app propose          : Suggestions de personnalisation contextuelles
  Objectif               : L'app devient SON espace (moment "mine")
  Feature depth          : Personnalisation, organisation

JOUR 14-21 — THE DIP (TRAVERSÉE)
  L'utilisateur sent     : La nouveauté s'estompe
  L'app fait             : Varier les rewards, détecter des patterns, introduire de la profondeur
  Objectif               : Garder l'intérêt par la VALEUR (pas la stimulation)
  Feature depth          : Insights, patterns détectés

JOUR 21-30 — HABITUDE FORMÉE
  L'utilisateur est      : En mode automatique. Ouvrir l'app = réflexe.
  L'app révèle           : Features avancées (export, stats détaillées, automatisations)
  Objectif               : L'utilisateur sent qu'il a encore à découvrir
  Feature depth          : Power features, raccourcis

JOUR 30-90 — POWER USER & AMBASSADEUR
  L'utilisateur a        : Accumulé assez de données pour voir des trends long terme
  L'app propose          : Bilans mensuels, comparaisons de tendance, share cards
  Objectif               : L'utilisateur recommande spontanément
  Feature depth          : Tout est accessible
```

**JAMAIS** de feature gating temporel artificiel. Le calendrier ci-dessus guide la PRÉSENTATION, pas le verrouillage.

---

## VII. Error Recovery Flows

### Quand quelque chose casse, l'émotion prime sur la technique.

### Par type d'erreur :

```
PERTE RÉSEAU (mid-action)
  Émotion de l'utilisateur : Frustration, peur de perdre ses données
  L'app fait               : 
    1. Sauvegarde locale silencieuse (les données ne sont PAS perdues)
    2. Indicateur discret "Hors ligne" (pas une modale)
    3. Sync automatique au retour de la connexion
    4. Confirmation : "Tout a été synchronisé."
  L'app dit                : "Connexion perdue. Tes données sont sauvegardées localement."
  L'app NE dit PAS         : "NetworkException", "timeout", "Oups !"

ERREUR SERVEUR (500)
  Émotion de l'utilisateur : Impatience, perte de confiance
  L'app fait               : 
    1. Retry automatique silencieux (1 fois après 3s)
    2. Si échec : message + action
  L'app dit                : "Service temporairement indisponible. Réessayer dans quelques minutes."
  L'app NE dit PAS         : "Internal Server Error", le code HTTP

TOKEN EXPIRÉ (mid-session)
  Émotion de l'utilisateur : Confusion ("pourquoi ça ne marche plus ?")
  L'app fait               : 
    1. Refresh automatique du token (silencieux, invisible)
    2. Retry de l'action qui a échoué
    3. Si refresh impossible → redirection douce vers login
  L'app dit (si re-login)  : "Session expirée. Reconnecte-toi pour continuer."
  L'app NE dit PAS         : "401 Unauthorized"

ERREUR DE VALIDATION (formulaire)
  Émotion de l'utilisateur : Agacement ("qu'est-ce que j'ai mal fait ?"
  L'app fait               : 
    1. Message sous le champ concerné (pas un toast en haut)
    2. Le champ invalide est visuellement marqué
    3. Le message est factuel, pas accusateur
  L'app dit                : "Format d'email incorrect" (pas "Vous avez entré...")

PERMISSION REFUSÉE (caméra, notifs, localisation)
  Émotion de l'utilisateur : Méfiance ("pourquoi l'app veut ça ?"
  L'app fait               :
    1. Explique POURQUOI avant de demander 
    2. Si refusé : dégrade gracieusement (feature marche sans, en mode réduit)
    3. Propose d'activer plus tard dans les settings
  L'app dit                : "[AppName] a besoin de X pour [bénéfice utilisateur]."

DONNÉES CORROMPUES / INCOHÉRENTES
  Émotion de l'utilisateur : Panique
  L'app fait               :
    1. Ne JAMAIS montrer les données corrompues
    2. Tenter une récupération silencieuse (re-fetch serveur)
    3. Si impossible : informer + offrir export de ce qui est récupérable
  L'app dit                : "Un problème a été détecté. Tes données récentes sont en sécurité."
```

---

## VIII. Profils d'App : Flow vs Pro vs Community

### L'arc émotionnel varie selon le TYPE d'app produit par la factory.

### Flow (développement personnel)
```
Apps         : LifeFlow, MeditationFlow, ReadFlow, SilvaFlow, MindFlow
Personnalité : Coach calme, compagnon de route
Ton          : Doux, encourageant, jamais pressant
Arc dominant : La SÉRÉNITÉ. L'app rassure et accompagne.
Engagement   : Basé sur les rituels quotidiens (matin, midi, soir)
Metric       : Régularité de la pratique (pas intensité)
Aha-moment   : "Cette semaine, 5 jours de méditation. Tu installe une habitude."
```

### Pro (productivité, business)
```
Apps         : ContratPro, FleetMaster, PressingSync, StockManager, ImportTrack
Personnalité : Assistant efficace, co-pilote
Ton          : Direct, factuel, orienté résultat
Arc dominant : L'EFFICACITÉ. L'app fait gagner du temps.
Engagement   : Basé sur les tasks et les résultats
Metric       : Temps gagné, tâches accomplies, erreurs évitées
Aha-moment   : "Ce mois-ci, 47 contrats gérés en 12h au lieu de 30h."
```

### Community (social, collectif)
```
Apps         : ChurchFlow, TontineFlow, EventPro, CoupleFlow, ParentFlow
Personnalité : Animateur, facilitateur
Ton          : Chaleureux, inclusif, célébratoire
Arc dominant : La CONNEXION. L'app rapproche les gens.
Engagement   : Basé sur l'interaction avec les autres
Metric       : Activité du groupe, participation, événements réussis
Aha-moment   : "12 membres actifs cette semaine. L'élan se construit."
```

### Impact sur l'architecture d'expérience

| Aspect | Flow | Pro | Community |
|--------|------|-----|-----------|
| Session type | Rituel quotidien (30-90s) | Task-based (2-5min) | Consultation + interaction |
| Notification strategy | Rappels doux, max 2/jour | Alerts urgentes + bilans | Activité du groupe |
| Completion state | Célébration douce | "Rien en attente" factuel | "Le groupe est actif" |
| The Dip strategy | Varier les insights | Montrer le ROI cumulé | Montrer la dynamique |
| Return after absence | Total positif | "X en attente" neutre | "Nouveaux messages/activité" |
| Empty state | Invitation contemplative | Template business | Inviter des membres |

---

## Implémentation (→ .github/instructions/)

| Aspect | Fichier de référence |
|--------|---------------------|
| Animations / transitions | `design-system-motion.instructions.md` |
| Célébrations visuelles | `design-system-celebrations.instructions.md` |
| États d'écran (loading/empty/error) | `design-system-states.instructions.md` |
| Navigation patterns | `design-system-navigation.instructions.md` |
| Composants UI | `design-system-components.instructions.md` |
| Haptics feedback | `design-system-haptics.instructions.md` |
| Offline / sync | `design-system-offline-sync.instructions.md` |
| UX patterns avancés | `design-system-ux-patterns.instructions.md` |
| Layouts/responsive | `design-system-responsive.instructions.md` |

---

*Créé le : 2026-03-17*
*Dernière mise à jour : 2026-03-17*
*Dépend de : product-soul.md*
