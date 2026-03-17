# Product Soul — L'ADN de Chaque App

> **Ce fichier est lu AVANT de coder quoi que ce soit.**
> Il définit la philosophie produit, le positionnement émotionnel, et les garde-fous.
> Il s'applique à TOUTES les apps produites par la factory — pas seulement LifeFlow.
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

### Avant de coder n'importe quelle app, répondre à ces 5 questions :

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

```
L'utilisateur décide en 30 secondes s'il garde l'app.

Ce qui compte dans ces 30 secondes :
1. Est-ce que c'est beau ? (oui = permission de continuer)
2. Est-ce que je comprends ? (une phrase, pas un onboarding)
3. Est-ce que j'ai quelque chose tout de suite ? (contenu pré-rempli, 
   suggestions, templates — JAMAIS un écran vide)
```

**IMPLICATION CODE :** Le premier écran après auth n'est JAMAIS vide. L'app propose des templates, des exemples, des suggestions contextuelles. L'empty state du premier lancement est un écran spécial (first-run experience), pas le même empty state que "l'utilisateur a tout supprimé".

### Vérité #2 : Les gens quittent en silence

```
Les 4 tueurs de rétention (par ordre) :

1. CONFUSION   — "Je ne sais pas quoi faire"
2. FRICTION    — "Ça me demande trop d'effort"
3. INVISIBILITÉ — "Je ne vois pas le bénéfice"
4. OUBLI       — "J'ai oublié que l'app existait"
```

**IMPLICATION CODE :**
- Contre la confusion : un écran = un verbe. L'action primaire est évidente.
- Contre la friction : max 3 inputs avant la première valeur. Defaults intelligents.
- Contre l'invisibilité : feedback immédiat après chaque action. Progression visible.
- Contre l'oubli : notifications à valeur ajoutée (jamais "tu n'as pas ouvert l'app").

### Vérité #3 : La complexité est un bug

```
Les utilisateurs ne veulent pas "plus d'options".
Ils veulent le bon résultat avec le moins de décisions possible.

RÈGLE : Si l'app peut prendre une décision intelligente 
à la place de l'utilisateur, elle la prend.
Et offre de la changer dans les settings.
```

**EXEMPLES CONCRETS :**
- Rappel d'habitude → défaut intelligent (matin 8h). Pas demandé au setup.
- Thème → suit le système (dark/light auto). Pas de sélecteur au premier lancement.
- Langue → détectée du téléphone. Sélecteur uniquement dans settings.
- Catégories → les 5-7 plus universelles proposées. L'utilisateur personnalise après.

### Vérité #4 : Les micro-interactions SONT le produit

```
Le produit n'est pas les features.
Le produit est la SOMME des sensations ressenties pendant l'utilisation.

Un bouton qui donne un haptic + un léger bounce 
= l'utilisateur SENT que quelque chose s'est passé.

Un bouton qui change juste de couleur 
= l'utilisateur se DEMANDE si ça a marché.

Différence en code : 50ms d'animation + 1 ligne de haptic.
Différence en perception : tout.
```

**IMPLICATION CODE :** Chaque action utilisateur (tap, swipe, submit, delete) a TROIS retours simultanés :
1. **Visuel** — animation, changement d'état visible
2. **Haptique** — vibration légère proportionnelle à l'importance de l'action
3. **Informationnel** — confirmation que l'action a eu un effet (counter++, item disparu, message)

### Vérité #5 : L'onboarding n'est jamais fini

```
L'onboarding classique : 3 slides → inscription → app.
L'onboarding réel : 2 SEMAINES avant que l'utilisateur comprenne la valeur.

L'app doit continuer à "onboarder" subtilement, contextuellement.
```

**PROGRESSIVE DISCOVERY TEMPOREL :**
- Jour 1 : L'essentiel. UNE action à faire. Pas de complexity.
- Jour 3 : Discovery contextuel — "Tu savais que tu peux aussi X ?" (au bon moment, pas en popup)
- Jour 7 : Premier bilan. C'est LE moment de l'aha-moment. L'utilisateur voit sa progression.
- Jour 14 : Features secondaires apparaissent naturellement ("Les gens comme toi utilisent aussi...")
- Jour 30 : L'utilisateur est expert. Les raccourcis et les paramètres avancés deviennent visibles.

**JAMAIS** de feature gating temporel artificiel. La découverte est contextuelle, pas calendaire.

### Vérité #6 : Le meilleur état est "tout est fait"

```
L'app doit avoir un état "tu as tout fait aujourd'hui".
Et cet état doit être LE PLUS BEAU ÉCRAN de l'app.

Pas "Aucune tâche restante".
→ Une illustration, un message de fierté, un résumé de la journée.
→ L'utilisateur referme l'app satisfait.

C'est l'état le plus puissant pour la rétention positive.
L'utilisateur VEUT revenir pour retrouver ce sentiment.
```

**IMPLICATION CODE :** Chaque app à composante quotidienne doit avoir un `CompletionState` — un écran/widget spécifique qui célèbre l'achèvement. Ce n'est pas un empty state, c'est un état de réussite.

### Vérité #7 : Le retour après absence est LE moment de vérité

```
80% des utilisateurs qui reviennent après 3+ jours d'absence
décident s'ils continuent ou désinstallent.

Si l'app dit : "Tu as manqué 3 jours" → désinstallation mentale.
Si l'app dit : "Ravi de te revoir. Voici où tu en es." → seconde chance.
```

**RÈGLE ABSOLUE :**
- L'app ne mentionne JAMAIS l'absence, JAMAIS la durée.
- L'app montre le cumulé positif (total, pas le trou récent).
- L'app propose UNE action facile pour reprendre ("Juste une habitude aujourd'hui ?").
- Le streak cassé est un "nouveau départ", pas une perte.

---

## IV. Feeling Framework

### Pour chaque app, AVANT de coder le premier écran :

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
TON : Calme, honnête, encouraging.
PROMESSE : "Tu vois clairement comment tu investis ton temps dans ce qui compte."

MOMENTS CLÉS :
- Aha! : Le premier bilan hebdomadaire avec répartition temps par domaine de vie
- Wow : Quand l'app détecte un pattern positif et le souligne ("3 semaines de méditation, beau travail")
- Mine : Quand les domaines de vie sont personnalisés avec noms, icônes, et couleurs choisies

ANTI-FEELINGS : Culpabilité, overwhelm, rigidité, surveillance.
```

---

## V. Principes de Décision Universels

### Quand l'IA hésite, ces règles tranchent :

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
```

---

## VI. Choix Techniques Universels

### Stack et Architecture

```
STACK : Flutter + Stacked MVVM + Supabase + GetIt DI
  - Stacked pour le state management (ViewModels + Services)
  - GetIt (via locator) pour l'injection de dépendances
  - Supabase pour le backend (Auth, DB, Storage, Realtime, Edge Functions)
  - FastAPI uniquement pour le traitement lourd (IA, batch, webhooks)

NAVIGATION : Stacked NavigationService
  - Jamais go_router, jamais Navigator.push direct
  - clearStackAndShow pour les transitions auth→home
  - pushNamed pour navigation forward, pop pour le retour

ICÔNES : LucideIcons exclusivement
  - Jamais Material Icons, jamais FontAwesome, jamais d'icônes custom non validées
  - Cohérence visuelle sur toutes les apps

DESIGN SYSTEM : Composants App* exclusivement dans features/
  - AppButton, AppCard, AppTextField, AppListTile, AppBadge, AppProgress, 
    AppEmptyState, AppChip, AppBottomNav, AppSkeleton
  - Tokens : AppColors, AppSpacing, AppTypography, AppRadius, AppShadows
  - Jamais de Colors., TextStyle(fontSize, EdgeInsets.all() dans features/
```

### Monétisation

```
MODÈLE : Freemium universel
  - La version gratuite est UTILE, pas un teaser.
  - Le premium débloque la profondeur, pas la surface.
  - Jamais de paywall sur une feature de base.
  - Jamais de publicité.

PAIEMENT : Adapté au marché
  - Mobile money + carte bancaire + in-app purchase selon la région
  - Pricing localisé (pas un prix unique mondial)
```

---

## VII. Les "Jamais" (Non-Négociables)

```
PRODUIT
  ✗ Jamais de publicité dans nos apps
  ✗ Jamais de dark patterns (faux boutons, notifications trompeuses)
  ✗ Jamais de tracking invasif (analytics = produit, pas surveillance)
  ✗ Jamais de "premium required" sur une feature de base
  ✗ Jamais de scroll infini sur du contenu généré pour retenir l'utilisateur
  ✗ Jamais de gamification punitive (streak cassé = perte, classement humiliant)

UX / CONTENU
  ✗ Jamais "Oups" ou "Oops" dans un message d'erreur
  ✗ Jamais "Aucun résultat" ou "Liste vide" comme empty state
  ✗ Jamais mentionner l'absence de l'utilisateur ("Tu as manqué X jours")
  ✗ Jamais d'onboarding > 3 écrans avant la première valeur
  ✗ Jamais forcer un choix non essentiel au premier lancement
  ✗ Jamais de notification sans information actionnable

TECHNIQUE
  ✗ Jamais de logique métier dans les Views
  ✗ Jamais d'appels Supabase/HTTP directs dans les ViewModels
  ✗ Jamais d'import cross-feature (features/X → features/Y)
  ✗ Jamais de couleurs ou typography hardcodées dans features/
  ✗ Jamais de strings hardcodées (i18n obligatoire)
  ✗ Jamais de table Supabase sans RLS
```

---

*Créé le : 2026-03-17*
*Dernière mise à jour : 2026-03-17*
*Source : Analyse des meilleurs produits 2024-2026, JTBD framework, Hooked (Nir Eyal), Certified Gate Loop*
