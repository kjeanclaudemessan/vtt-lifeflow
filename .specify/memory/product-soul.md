# Product Soul — L'ADN de Chaque App

> **Ce fichier est lu AVANT de coder quoi que ce soit.**
> Il définit le QUOI et le POURQUOI : philosophie produit, positionnement émotionnel, garde-fous stratégiques.
> Il s'applique à TOUTES les apps produites par la factory — pas seulement LifeFlow.
>
> **Ce fichier ne contient PAS :** de code, de widgets, de tokens, de patterns d'implémentation.
> Pour le COMMENT → voir `flutter/.github/instructions/*.instructions.md`
> Pour les contraintes techniques → voir `constitution.md` §III
>
> **Priorité :** Constitution > Product Soul > Experience Architecture > Wireframe Rules > Content Rules

---

## I. Philosophie Fondamentale

### Le produit n'est pas l'app. Le produit est ce que l'utilisateur DEVIENT.

Personne ne télécharge un habit tracker pour tracker des habitudes.
Personne ne télécharge un budget app pour voir des chiffres.

| Ce qu'il télécharge | Ce qu'il achète VRAIMENT |
|---------------------|-------------------------|
| Habit tracker | Le sentiment de devenir meilleur chaque jour |
| Budget app | La paix financière, le contrôle |
| Meditation app | Le pouvoir de calmer son esprit |
| Todo list | Le soulagement de ne rien oublier |
| Fitness app | La fierté de son propre corps |
| Language app | L'identité de "quelqu'un qui parle 3 langues" |
| Note-taking | La confiance que ses idées ne se perdent pas |
| Time tracker | La preuve qu'il utilise bien son temps |

**RÈGLE SUPRÊME :** Chaque écran ne répond pas à "quelle feature j'affiche" mais à **"quel sentiment je provoque"**.

---

## II. Job to Be Done (Émotionnel)

### Avant de concevoir n'importe quelle app, répondre à ces 5 questions :

```
1. QUAND l'utilisateur "embauche" cette app ?
   (Pas "quand il veut tracker" — mais "quand il se sent en perte 
   de contrôle et veut reprendre les rênes")

2. QUEL sentiment il recherche APRÈS utilisation ?
   (Pas "informé" — plutôt "soulagé", "fier", "motivé", "en paix", 
   "en contrôle", "léger")

3. CONTRE QUOI l'app est en compétition ?
   (Pas d'autres apps — mais : ne rien faire, un tableur, un carnet, 
   un post-it, demander à un ami, l'habitude de tout garder en tête)

4. QUELLE est la promesse en une phrase ?
   (Pas une tagline marketing — la phrase que l'utilisateur dirait 
   à un ami : "Cette app m'aide à...")

5. QUAND l'utilisateur se dit "ça vaut le coup" ?
   (Le moment "aha!" — quand il comprend la valeur. Ex: quand il voit 
   son premier bilan hebdo, quand il atteint 7 jours de streak, 
   quand il retrouve une note en 3 secondes)
```

### Ces réponses vont dans `spec.md` AVANT les user stories. Pas après.

---

## III. Les 7 Vérités Produit

### Vérité #1 : La première impression est permanente

L'utilisateur décide en 30 secondes s'il garde l'app.

Ce qui compte dans ces 30 secondes :
1. **Est-ce que c'est beau ?** → oui = permission de continuer
2. **Est-ce que je comprends ?** → une phrase, pas un onboarding
3. **Est-ce que j'ai quelque chose tout de suite ?** → contenu pré-rempli, suggestions, templates — JAMAIS un écran vide

Le premier écran après auth n'est JAMAIS vide. L'app propose des templates, des exemples, des suggestions contextuelles. L'empty state du premier lancement est une first-run experience dédiée, pas le même empty state que "l'utilisateur a tout supprimé".

### Vérité #2 : Les gens quittent en silence

Les 4 tueurs de rétention (par ordre) :

| Tueur | Antidote |
|-------|----------|
| **CONFUSION** — "Je ne sais pas quoi faire" | Un écran = un verbe. L'action primaire est évidente. |
| **FRICTION** — "Ça me demande trop d'effort" | Max 3 inputs avant la première valeur. Defaults intelligents. |
| **INVISIBILITÉ** — "Je ne vois pas le bénéfice" | Feedback immédiat après chaque action. Progression visible. |
| **OUBLI** — "J'ai oublié que l'app existait" | Notifications à valeur ajoutée (jamais "tu n'as pas ouvert l'app"). |

### Vérité #3 : La complexité est un bug

Les utilisateurs ne veulent pas "plus d'options". Ils veulent le bon résultat avec le moins de décisions possible.

**RÈGLE :** Si l'app peut prendre une décision intelligente à la place de l'utilisateur, elle la prend. Et offre de la changer dans les settings.

**Exemples :**
- Rappel d'habitude → défaut intelligent (matin 8h). Pas demandé au setup.
- Thème → suit le système (dark/light auto). Pas de sélecteur au premier lancement.
- Langue → détectée du téléphone. Sélecteur uniquement dans settings.
- Catégories → les 5-7 plus universelles proposées. L'utilisateur personnalise après.

### Vérité #4 : Les micro-interactions SONT le produit

Le produit n'est pas les features. Le produit est la **somme des sensations ressenties** pendant l'utilisation.

Chaque action utilisateur a TROIS retours simultanés :
1. **Visuel** — animation, changement d'état visible
2. **Haptique** — vibration proportionnelle à l'importance de l'action
3. **Informationnel** — confirmation que l'action a eu un effet

> Implémentation détaillée : `haptics.instructions.md`, `motion.instructions.md`, `states.instructions.md`

### Vérité #5 : L'onboarding n'est jamais fini

L'onboarding classique : 3 slides → inscription → app.
L'onboarding réel : 2 SEMAINES avant que l'utilisateur comprenne la valeur.

L'app continue d'"onboarder" subtilement, contextuellement. La découverte est contextuelle, JAMAIS calendaire.

> Le plan de progressive disclosure temporel est détaillé dans `experience-architecture.md` §VI.

### Vérité #6 : Le meilleur état est "tout est fait"

L'app doit avoir un état "tu as tout fait aujourd'hui". Et cet état doit être **LE PLUS BEAU ÉCRAN** de l'app.

Pas "Aucune tâche restante" → une illustration, un message de fierté, un résumé de la journée. L'utilisateur referme l'app satisfait. C'est l'état le plus puissant pour la rétention positive.

Chaque app à composante quotidienne doit avoir un **CompletionState** — un écran qui célèbre l'achèvement. Ce n'est pas un empty state, c'est un état de réussite.

### Vérité #7 : Le retour après absence est LE moment de vérité

80% des utilisateurs qui reviennent après 3+ jours d'absence décident s'ils continuent ou désinstallent.

**RÈGLE ABSOLUE :**
- L'app ne mentionne JAMAIS l'absence, JAMAIS la durée.
- L'app montre le cumulé positif (total, pas le trou récent).
- L'app propose UNE action facile pour reprendre ("Juste une habitude aujourd'hui ?").
- Le streak cassé est un "nouveau départ", pas une perte.

---

## IV. Feeling Framework

### Pour chaque app, AVANT de concevoir le premier écran :

```
IDENTITÉ
├─ Si l'app était une personne, qui serait-elle ?
│  (un coach calme ? un ami enthousiaste ? un assistant discret ?)
├─ Quel est le TON en 3 adjectifs ?
│  (ex: "calme, honnête, encourageant")
└─ Quelle est la PROMESSE en une phrase ?
   (ex: "Tu verras tes progrès chaque jour")

MOMENTS CLÉS
├─ L'instant "aha!" : quand la valeur est comprise
│  (ex: "quand il voit son premier bilan hebdomadaire")
├─ L'instant "wow" : quand il est agréablement surpris
│  (ex: "une célébration inattendue au 7ème jour consécutif")
└─ L'instant "mine" : quand il sent que c'est SON espace
   (ex: "quand ses catégories ont ses propres noms et icônes")

ANTI-FEELINGS (bugs émotionnels)
├─ L'app ne doit JAMAIS faire ressentir : ___
│  (ex: "culpabilité, confusion, submersion, infantilisation")
└─ Si cet anti-feeling apparaît, c'est un BUG.
   Pas un edge case. Un BUG à corriger en priorité.
```

### LifeFlow Feeling (exemple de référence) :

```
IDENTITÉ : Un compagnon calme qui observe tes progrès sans te juger.
TON : Calme, honnête, encourageant.
PROMESSE : "Tu vois clairement comment tu investis ton temps dans ce qui compte."

MOMENTS CLÉS :
- Aha! : Le premier bilan hebdomadaire avec répartition temps par domaine de vie
- Wow : Quand l'app détecte un pattern positif et le souligne ("3 semaines de méditation, beau travail")
- Mine : Quand les domaines de vie sont personnalisés avec noms, icônes, et couleurs choisies

ANTI-FEELINGS : Culpabilité, overwhelm, rigidité, surveillance.
```

---

## V. Principes de Décision Universels

### Quand l'IA hésite, ces 12 règles tranchent :

```
 1. Simple > Complexe
    Progressive disclosure. La puissance est cachée, la simplicité est devant.

 2. Un écran = Un job
    Si l'écran fait deux choses, le séparer en deux. 
    Sauf si les deux choses sont liées dans le même moment utilisateur.

 3. Bottom sheet > Dialog > Page
    Pour ≤4 champs : bottom sheet.
    Pour confirmation destructive : dialog.
    Pour >4 champs ou workflow multi-étapes : page.

 4. Defaults intelligents > Choix explicites
    L'app décide, l'utilisateur ajuste si besoin.

 5. Feedback immédiat > Feedback différé
    Chaque action a un retour en <300ms. Toujours.

 6. Montrer le positif > Montrer le négatif
    "3 habitudes complétées" > "2 habitudes manquées".
    La vue par défaut est toujours positive-first.

 7. Contexte > Exhaustivité
    Montrer ce qui est pertinent MAINTENANT > montrer tout.
    L'écran du matin ≠ l'écran du soir.

 8. Invitation > Instruction
    "Ajouter ta première routine ?" > "Aucune routine créée."
    L'empty state est une porte ouverte, pas un constat.

 9. Silence > Bruit
    Pas de notification sans information actionnable.
    Pas de badge sans contenu nouveau réel.
    Le silence est une feature.

10. Outil > Piège
    L'app se mesure au TEMPS GAGNÉ, pas au temps passé dedans.
    "Tu as tout fait 🎯" est le meilleur état possible.
    Pas de scroll infini, pas de gamification addictive.

11. Respecter le sommeil > Engager
    Aucune notification entre 22h et 6h. Si l'utilisateur est dans l'app 
    la nuit, interface ultra-minimale, pas de stimulation.

12. Données de l'utilisateur > Notre commodité
    Export facile, suppression propre, transparence totale.
    L'utilisateur doit pouvoir partir avec ses données.
```

---

## VI. Monétisation UX

### Le modèle freemium est un pacte de confiance, pas un piège.

```
PRINCIPES :
  1. La version gratuite est UTILE — pas un teaser amputé.
     L'utilisateur doit pouvoir tirer de la valeur réelle sans payer.
  
  2. Le premium débloque la PROFONDEUR, pas la surface.
     ✓ Stats avancées, export, insights IA, personnalisation profonde
     ✗ Création d'un 6ème item, suppression de la pub, thème sombre
  
  3. Le paywall arrive APRÈS l'aha-moment, JAMAIS avant.
     L'utilisateur doit comprendre la valeur AVANT qu'on lui propose de payer.
     Timing idéal : après le premier bilan significatif (~Jour 7).
  
  4. Jamais de publicité. Jamais. Zéro exception.
  
  5. Le premium NE RETIRE PAS de valeur au free.
     Si une feature était gratuite, elle le reste.
```

### Timing du paywall

```
INTERDIT :
  ✗ Au premier lancement (l'utilisateur ne connaît pas encore la valeur)
  ✗ Pendant un flow critique (au milieu d'une action)
  ✗ Après un échec (émotionnellement fragile)

IDÉAL :
  ✓ Après une célébration ("Tu as atteint 7 jours ! Découvre tes stats détaillées")
  ✓ Quand l'utilisateur CHERCHE la feature premium (il est prêt)
  ✓ Dans une page dédiée (accessible mais jamais imposée)
```

### Pricing localisé

```
  - Pas un prix unique mondial. Pricing adapté au pouvoir d'achat.
  - Mobile money + carte bancaire + in-app purchase selon la région.
  - Trial : 7 jours gratuit, pas de carte requise. L'utilisateur décide après.
  - Abonnement annuel = réduction significative (50%+).
  - Jamais de dark patterns dans le pricing (le prix le plus cher en évidence, le "best value" caché).
```

---

## VII. Rétention & Engagement

### L'engagement n'est pas de la manipulation. C'est de la valeur constante.

### Le Hook Éthique

```
TRIGGER (externe → interne)
  Jour 1-7   : Notifications utiles (rappels de routine, premier bilan)
  Jour 7-21  : L'utilisateur ouvre l'app PAR HABITUDE (trigger interne)
  Jour 21+   : L'app fait partie de sa routine. Les notifications sont optionnelles.

  L'objectif : l'utilisateur n'a PLUS BESOIN de la notification. 
  Si après 30 jours il dépend encore des notifications, c'est que la valeur n'est pas assez claire.

ACTION
  La plus simple possible. Ouvrir → faire UNE chose → fermer.
  Temps moyen par session : 30-90 secondes. Pas plus.

RÉCOMPENSE VARIABLE
  Pas la même félicitation chaque jour. Les messages varient. Les animations surprennent.
  La récompense est INFORMATIVE (progrès réel) pas ADDICTIVE (points fictifs).

INVESTISSEMENT
  L'utilisateur investit du temps et des données.
  Plus il utilise, plus l'app est personnalisée.
  Plus c'est personnalisé, plus c'est précieux.
  → C'est ça le moat, pas un paywall.
```

### Courbe d'Engagement

```
JOUR 1     : First Win — l'utilisateur réussit quelque chose (30-60s)
JOUR 3     : Discovery — "Tu savais que tu peux aussi X ?"
JOUR 7     : Aha-moment — premier bilan significatif. CRITIQUE.
JOUR 10-21 : The Dip — la nouveauté s'estompe. VARIER les récompenses.
JOUR 21    : Habitude formée — l'app est intégrée dans la routine.
JOUR 30    : Power user — features avancées visibles naturellement.
JOUR 90    : Ambassadeur — l'utilisateur recommande spontanément.
```

### Ré-engagement (retour après absence)

```
RÈGLES :
  - NE JAMAIS mentionner l'absence. JAMAIS.
  - Montrer le total cumulé (pas le trou).
  - Proposer une action facile ("Juste une chose aujourd'hui ?").
  - Streak cassé = "Nouveau départ !" (positif).
  - Pas de notification "Tu nous manques".
  - Pas de popup de ré-engagement.
  
  Le message est : "Tu es le bienvenu. Voici où tu en es."
  Pas : "Tu as disparu et tu as tout perdu."
```

---

## VIII. Moat Framework (Ce qui rend l'app irremplaçable)

### 4 fossés construits progressivement :

```
FOSSÉ 1 — DONNÉES ACCUMULÉES
  Plus l'utilisateur utilise l'app, plus ses données ont de valeur.
  Historique d'habitudes, patterns détectés, bilans personnels, préférences.
  Quitter = perdre cette mémoire.
  
  IMPLICATION : L'app doit MONTRER la valeur des données accumulées.
  "En 3 mois : 47 habitudes tenues, 12h de méditation, 30 journées à 100%."
  L'utilisateur VOIT ce qu'il perdrait en partant.

FOSSÉ 2 — PERSONNALISATION PROFONDE
  Catégories renommées, icônes choisies, routines construites, seuils ajustés.
  Recréer tout ça ailleurs = friction énorme.
  
  IMPLICATION : Encourager la personnalisation tôt.
  "Renomme tes domaines de vie", "Choisis tes icônes", "Construis ta routine".

FOSSÉ 3 — IDENTITÉ CONSTRUITE
  "Je suis quelqu'un qui médite" (grâce à l'app).
  "Je suis organisé" (grâce à l'app).
  L'app devient partie de l'identité de l'utilisateur.
  
  IMPLICATION : Refléter l'identité. 
  "Tu es un méditant régulier" > "Tu as médité 30 fois".
  Le langage dit ce que l'utilisateur EST, pas ce qu'il A FAIT.

FOSSÉ 4 — EFFETS DE RÉSEAU (quand applicable)
  Partage de milestones, challenges entre amis, espaces collectifs.
  L'app gagne en valeur quand l'entourage l'utilise aussi.
  
  IMPLICATION : Le social est un BONUS, jamais le cœur.
  L'app est 100% valable en solo. Le social amplifie, il ne crée pas.
```

---

## IX. Analytics Principles

### On mesure la valeur produite, pas le temps passé.

```
NORTH STAR METRIC (par type d'app) :
  Habit tracker  → Habitudes complétées par semaine
  Budget app     → Écart budget prévu vs réel (plus petit = mieux)
  Meditation     → Minutes méditées par semaine
  Todo list      → Tâches complétées / tâches créées (ratio d'accomplissement)
  Time tracker   → Heures trackées par semaine

  La métrique mesure la VALEUR que l'utilisateur reçoit.
  PAS le temps dans l'app. PAS le nombre de sessions. PAS la DAU brute.
```

### Funnels à mesurer

```
  1. Install → First Open (attribution)
  2. First Open → Registration (conversion auth)
  3. Registration → First Value (temps jusqu'au premier win)
  4. First Value → Day 7 Return (rétention critique)
  5. Day 7 → Day 30 Return (habitude formée)
  6. Day 30 → Premium (conversion payante)
  7. Premium → Renewal (satisfaction long terme)
```

### Ce qu'on mesure — ce qu'on ne mesure PAS

```
  ✓ Taux de complétion des actions principales (l'app est-elle utile ?)
  ✓ Temps jusqu'au premier win (l'onboarding est-il efficace ?)
  ✓ Taux de retour J7 / J30 (l'app crée-t-elle de l'habitude ?)
  ✓ Feature adoption (quelles features ont de la valeur ?)
  ✓ Crash rate, erreurs (la qualité technique)
  
  ✗ Temps passé dans l'app (un outil DOIT être rapide)
  ✗ Nombre de notifications ouvertes (on ne veut pas de dépendance)
  ✗ Données personnelles détaillées (on agrège, on n'espionne pas)
  ✗ Scroll depth (pas de scroll infini)
```

---

## X. Privacy as Feature

### La transparence est un avantage compétitif, pas une contrainte légale.

```
  1. DATA MINIMALISM
     L'app ne collecte QUE ce qui est nécessaire au fonctionnement.
     Pas de "on collecte au cas où". Pas d'analytics tiers invasifs.
     Chaque donnée collectée a un POURQUOI explicable à l'utilisateur.
  
  2. TRANSPARENCE = TRUST
     L'utilisateur sait exactement ce qui est stocké et pourquoi.
     Un écran "Mes données" dans les settings montre ce que l'app sait sur lui.
     Pas de petits caractères, pas de surprises.
  
  3. EXPORT FACILE = CONFIANCE
     L'utilisateur peut exporter TOUTES ses données en 1 tap (JSON, CSV).
     Si l'utilisateur peut partir facilement, il CHOISIT de rester.
     Le lock-in par friction de départ est un anti-pattern.
  
  4. SUPPRESSION PROPRE
     "Supprimer mon compte" = suppression effective dans les 48h.
     Pas de "Êtes-vous vraiment sûr ? Votre streak sera perdu !".
     Factuel : "Vos données seront supprimées. Exporter d'abord ?"
  
  5. PAS DE TRACKING CACHÉ
     Pas de fingerprinting, pas de tracking cross-app.
     Analytics = mesurer la santé du produit, pas surveiller l'utilisateur.
     L'utilisateur peut désactiver les analytics (opt-out visible dans settings).
```

---

## XI. Les "Jamais" (Non-Négociables)

### Produit

```
  ✗ Jamais de publicité dans nos apps
  ✗ Jamais de dark patterns (faux boutons, notifications trompeuses, confusing unsubscribe)
  ✗ Jamais de tracking invasif (analytics = produit, pas surveillance)
  ✗ Jamais de "premium required" sur une feature de base
  ✗ Jamais de scroll infini sur du contenu généré pour retenir l'utilisateur
  ✗ Jamais de gamification punitive (streak cassé = perte, classement humiliant)
  ✗ Jamais de paywall AVANT l'aha-moment
  ✗ Jamais de rétention par culpabilité ("Tu nous manques", "Tu as manqué X jours")
```

### UX / Contenu

```
  ✗ Jamais "Oups" ou "Oops" dans un message d'erreur
  ✗ Jamais "Aucun résultat" ou "Liste vide" comme empty state
  ✗ Jamais mentionner l'absence de l'utilisateur
  ✗ Jamais d'onboarding > 3 écrans avant la première valeur
  ✗ Jamais forcer un choix non essentiel au premier lancement
  ✗ Jamais de notification sans information actionnable
  ✗ Jamais de notification entre 22h et 6h
```

### Technique → voir constitution.md §VII

---

## Implémentation (→ .github/instructions/)

| Aspect | Fichier de référence |
|--------|---------------------|
| Retour haptique | `design-system-haptics.instructions.md` |
| Animations/transitions | `design-system-motion.instructions.md` |
| États d'écran (loading/empty/error) | `design-system-states.instructions.md` |
| Célébrations visuelles | `design-system-celebrations.instructions.md` |
| Tokens (couleurs, spacing, typo) | `design-system-tokens.instructions.md` |
| Accessibilité | `design-system-accessibility.instructions.md` |
| Dark mode | `design-system-dark-mode.instructions.md` |
| Performance | `design-system-performance.instructions.md` |
| Navigation patterns | `design-system-navigation.instructions.md` |
| i18n / textes | `design-system-i18n.instructions.md` |
| Illustrations/icônes | `design-system-illustrations.instructions.md` |
| Architecture technique | `constitution.md` §III |
| Quality gates | `constitution.md` §VII |

---

*Créé le : 2026-03-17*
*Dernière mise à jour : 2026-03-17*
*Source : JTBD framework, Hooked (Nir Eyal), Certified Gate Loop, Privacy by Design*
