# Content Rules — Le Langage de l'App

> **Ce fichier définit QUOI dire et COMMENT le dire.**
> Ton, voix, wording exact par contexte, voix par type d'app, stratégie de notifications.
> L'IA le lit avant de rédiger tout texte visible dans l'interface.
>
> **Ce fichier ne contient PAS :** de conventions de clés i18n, de règles ICU/pluralisation,
> de mapping d'icônes, de format de dates/nombres, de code Dart.
> Pour l'i18n technique → voir `i18n.instructions.md` + `i18n-strict.instructions.md`
> Pour les icônes/illustrations → voir `illustrations.instructions.md`
> Pour le UX writing avancé → voir `ux-writing.instructions.md`
>
> **Principe** : Chaque mot affiché est un choix de design. Un texte maladroit
> casse l'expérience autant qu'un mauvais layout.
>
> **Dépend de :** product-soul.md (identité), experience-architecture.md (contexte émotionnel)

---

## I. Ton et Voix

### L'app parle comme un ami compétent. Pas comme un robot. Pas comme un coach LinkedIn.

```
L'APP EST :                         L'APP N'EST PAS :
  Calme mais pas froide               Un chatbot qui dit "Hey !"
  Encourageante mais pas infantile     Un coach qui dit "Tu peux le faire !"
  Directe mais pas sèche              Un formulaire administratif
  Précise mais pas technique           Un manuel d'utilisation
  Humble mais pas excusée              Une marque qui s'excuse de tout ("Oups !")
```

### Personnalité en une phrase :

> L'app parle comme un **ami organisé** qui te rappelle les choses importantes
> sans te juger, et qui sait valoriser tes efforts sans en faire trop.

### Matrice de ton selon le contexte :

| Contexte | Ton | Exemple |
|----------|-----|---------|
| Premier lancement | Accueillant, sobre | "Bienvenue. Commençons." |
| Action quotidienne | Neutre, efficace | "Habitude ajoutée" |
| Progression | Positif, factuel | "12 jours consécutifs" |
| Milestone | Chaleureux, spécifique | "30 jours de méditation. Impressionnant." |
| Erreur technique | Honnête, orienté aide | "Impossible de charger. Vérifier la connexion." |
| Retour après absence | Neutre, positif | "Bon retour. 47 habitudes complétées au total." |
| Notification | Utile, court | "Routine du soir dans 15 min" |
| Vide / empty state | Invitant, pas accusant | "Espace libre pour tes premières habitudes" |
| Suppression | Factuel, réversible | "Supprimé. Annuler ?" |

---

## II. Voice Profiles par Type d'App

### L'identité vocale change selon le TYPE d'app produit par la factory.

### Flow (développement personnel)

```
Apps       : LifeFlow, MeditationFlow, ReadFlow, SilvaFlow, MindFlow
Persona    : Coach calme, compagnon de route
Ton        : Doux, encourageant, jamais pressant ni paternel
Vocabulaire: "progression", "régularité", "moment", "rituel", "bien joué"
Éviter     : Urgence, commandement, jargon fitness/coaching

EXEMPLES :
  Greeting matin  : "Bonne journée. Voici ton plan."
  Completion      : "Tout est fait. Belle journée."
  Milestone       : "3 semaines de méditation. Tu installes une habitude."
  Return          : "Bon retour. 47 pratiques au total."
  Empty state     : "Un espace pour tes premières habitudes"
```

### Pro (productivité, business)

```
Apps       : ContratPro, FleetMaster, PressingSync, StockManager, ImportTrack
Persona    : Assistant efficace, co-pilote
Ton        : Direct, factuel, orienté résultat — pas de fleurs
Vocabulaire: "traité", "en attente", "validé", "efficacité", "résumé"
Éviter     : Émotions excessives, emojis, métaphores

EXEMPLES :
  Greeting matin  : "3 contrats en attente. 2 paiements à vérifier."
  Completion      : "Rien en attente."
  Milestone       : "47 contrats gérés ce mois-ci."
  Return          : "12 éléments en attente depuis ta dernière visite."
  Empty state     : "Aucun contrat. Créer le premier."
```

### Community (social, collectif)

```
Apps       : ChurchFlow, TontineFlow, EventPro, CoupleFlow, ParentFlow
Persona    : Animateur chaleureux, facilitateur
Ton        : Inclusif, célébratoire, centré sur le groupe
Vocabulaire: "ensemble", "le groupe", "activité", "événement", "membres"
Éviter     : Individualisme, compétition, ton froid

EXEMPLES :
  Greeting matin  : "Le groupe est actif. 3 nouveaux messages."
  Completion      : "Événement clôturé. 12 participants."
  Milestone       : "100 membres. La communauté grandit."
  Return          : "5 nouvelles activités depuis ta dernière visite."
  Empty state     : "Invite tes premiers membres pour commencer"
```

---

## III. Textes par Contexte (wording exact)

### Titres d'écran (AppBar)

```
RÈGLE : Court. 1-3 mots. Pas de phrase.

  ✓ "Habitudes"            ✗ "Mes habitudes quotidiennes"
  ✓ "Profil"               ✗ "Mon profil utilisateur"
  ✓ "Routine du soir"      ✗ "Votre routine du soir programmée"
  ✓ "Statistiques"         ✗ "Vos statistiques détaillées"
```

### Labels de boutons

```
RÈGLE : Verbe + objet (sauf actions universelles). Max 3 mots.

  ✓ "Ajouter habitude"     ✗ "Cliquez ici pour ajouter"
  ✓ "Enregistrer"          ✗ "Sauvegarder les modifications"
  ✓ "Commencer"            ✗ "Commencer maintenant !"
  ✓ "Suivant"              ✗ "Passer à l'étape suivante"

BOUTONS DESTRUCTIFS :
  ✓ "Supprimer" (rouge, sans exclamation)
  ✓ "Se déconnecter"
  JAMAIS : "Êtes-vous sûr ?" → Utiliser undo snackbar à la place
```

### Messages vides (Empty States)

```
RÈGLE : L'empty state est une INVITATION, pas un constat d'échec.

STRUCTURE :
  [Illustration douce / icône]
  Titre : Invitation positive (pas "Rien ici")
  Description : Explication + ce que l'utilisateur peut faire
  CTA : Bouton pour commencer

First-run (jamais utilisé) :
  ✓ Titre : "Tes habitudes t'attendent"
  ✓ Description : "Commence avec un template populaire ou crée les tiennes"
  ✓ CTA : "Explorer les templates"
  ✗ Titre : "Aucune habitude"
  ✗ Description : "Vous n'avez pas encore créé d'habitudes"

Cleared (tout fait) :
  ✓ Titre : "Tout est fait pour aujourd'hui 🎯"
  ✓ Description : "Repose-toi, tu reprends demain"
  ✗ Titre : "Liste vide"

Recherche sans résultat :
  ✓ "Aucun résultat pour '{query}'"
  ✓ CTA : "Modifier la recherche"
  ✗ "0 résultats trouvés"
```

### Messages d'erreur

```
RÈGLE : Honnête + Orienté solution. Pas de jargon technique.
STRUCTURE : QUOI s'est passé + QUOI faire

  Réseau :
    ✓ "Connexion perdue. Vérifier le Wi-Fi et réessayer."
    ✗ "Error: NetworkException - timeout after 30000ms"
    ✗ "Oups ! Quelque chose s'est mal passé"
  
  Serveur :
    ✓ "Service temporairement indisponible. Réessayer dans quelques minutes."
    ✗ "500 Internal Server Error"
  
  Validation :
    ✓ "Le nom est requis" (sous le champ, en rouge)
    ✗ "Veuillez remplir tous les champs obligatoires" (en haut, vague)
  
  Permission :
    ✓ "[AppName] a besoin d'accéder aux notifications pour te rappeler tes routines."
    ✗ "L'application nécessite les permissions de notification"

INTERDITS ABSOLUS :
  ✗ "Oups !"
  ✗ "Quelque chose s'est mal passé"  (vague)
  ✗ "Erreur inattendue"              (tout est inattendu pour l'utilisateur)
  ✗ Stack traces ou codes techniques
  ✗ Blâmer l'utilisateur ("Vous avez entré un email invalide")
    → Préférer : "Format d'email incorrect" (factuel, pas accusateur)
```

### Messages de félicitation / célébration

```
RÈGLE : Spécifique + Proportionnel. Pas de "Bravo !" sans contexte.

  Tier 1 (micro) — Action quotidienne :
    → Pas de texte visible. Feedback tactile/visuel suffit.
  
  Tier 2 (midi) — Milestone court :
    → "7 jours consécutifs 🔥" (bref, factuel)
    → "Routine terminée"
  
  Tier 3 (macro) — Milestone significatif :
    → "30 jours de méditation. Impressionnant."
    → "Objectif atteint : 5km de course"
  
  Tier 4 (méga) — Accomplissement rare :
    → "100 jours. Cent jours. Ce n'est pas un hasard, c'est de la constance."
    → Message unique, JAMAIS réutilisé ailleurs

INTERDITS :
  ✗ "Bravo !" seul (générique, vide de sens)
  ✗ "Tu es génial !" (l'app n'est pas un cheerleader)
  ✗ "Continue comme ça !" (injonction déguisée)
  ✗ Emojis excessifs (1 par message max, et seulement s'il ajoute du sens)
```

---

## IV. Error Recovery Content Strategy

### Le ton pendant une erreur définit le niveau de confiance de l'utilisateur.

### Stratégie par type d'erreur :

```
PERTE RÉSEAU
  Émotion : Frustration, peur de perdre ses données
  Ton     : Rassurant, factuel
  Message : "Connexion perdue. Tes données sont sauvegardées localement."
  Sub     : "La synchronisation reprendra automatiquement."
  JAMAIS  : "Erreur réseau", "Timeout", jargon technique

ERREUR SERVEUR
  Émotion : Impatience, perte de confiance
  Ton     : Honnête, temporaire
  Message : "Service temporairement indisponible."
  Sub     : "Réessayer dans quelques minutes."
  JAMAIS  : "500", "Internal Server Error", code HTTP

SESSION EXPIRÉE
  Émotion : Confusion
  Ton     : Direct, pratique
  Message : "Session expirée. Reconnecte-toi pour continuer."
  Sub     : (champ de login immédiat)
  JAMAIS  : "401 Unauthorized", "Token expired"

PERMISSION REFUSÉE
  Émotion : Méfiance
  Ton     : Explicatif, patient
  Message : "[App] a besoin de [permission] pour [bénéfice concret]."
  Sub     : "Tu peux l'activer plus tard dans les réglages."
  JAMAIS  : "Permission requise", langage technique

VALIDATION
  Émotion : Agacement
  Ton     : Factuel, pas accusateur
  Message : "Format d'email incorrect" (sous le champ)
  JAMAIS  : "Vous avez entré...", "Veuillez...", message vague en haut de page

DONNÉES CORROMPUES
  Émotion : Panique
  Ton     : Ultra-rassurant
  Message : "Un problème a été détecté. Tes données récentes sont en sécurité."
  Sub     : "Nous récupérons les informations..."
  JAMAIS  : Montrer les données corrompues, stack trace, "données perdues"
```

### Principe fondamental des erreurs :

```
L'app PREND LA RESPONSABILITÉ. Jamais l'utilisateur.

  ✓ "Service indisponible"      → c'est le service qui a un problème
  ✓ "Format incorrect"          → c'est le format, pas l'utilisateur
  ✗ "Vous avez entré..."        → accusation
  ✗ "Veuillez réessayer"        → l'utilisateur n'a rien fait de mal
```

---

## V. Notification Strategy

### Chaque notification doit JUSTIFIER son interruption. Si l'utilisateur peut vivre sans, ne pas l'envoyer.

### Types de notifications

```
TYPE 1 — RAPPEL DE ROUTINE (déclenchée par le planning de l'utilisateur)
  Quand   : Heure configurée par l'utilisateur
  Titre   : Nom de la routine
  Body    : "{count} habitudes. {duration} estimées."
  Exemple : "Routine du soir • 3 habitudes. 15 minutes estimées."

TYPE 2 — BILAN PÉRIODIQUE (hebdomadaire)
  Quand   : Une fois par semaine (jour + heure configurables)
  Titre   : "Bilan hebdomadaire"
  Body    : "Semaine à {percent}%. Voir le détail."
  Exemple : "Bilan hebdomadaire • Semaine à 78%. Voir le détail."

TYPE 3 — MILESTONE (atteint un seuil)
  Quand   : Au moment de l'accomplissement (pas différé)
  Titre   : Le milestone
  Body    : Message spécifique
  Exemple : "Streak 30 jours 🔥 • Un mois entier de méditation."
  Fréquence : Max 1 par semaine (ne pas spammer les milestones mineurs)

TYPE 4 — ACTIVITÉ GROUPE (apps Community uniquement)
  Quand   : Quand un événement pertinent se produit
  Titre   : Source de l'activité
  Body    : L'activité
  Exemple : "Tontine du mois • Collecte terminée. Voir les résultats."
```

### Règles de fréquence

```
  - Max 3 notifications/jour (rappels routines + 1 bilan)
  - 0 notification entre 22h et 6h (ABSOLU)
  - Si l'utilisateur a tout fait aujourd'hui → PAS de notification
  - Si l'utilisateur ignore 3 notifications consécutives → réduire la fréquence
  - L'utilisateur contrôle TOUT dans les settings (par type, par routine)
```

### Dégradation de fréquence

```
L'app s'adapte au comportement de l'utilisateur :

  Engagement élevé (ouvre chaque jour) :
    → Notifications minimales (l'utilisateur n'en a pas besoin)
    → Uniquement les bilans et milestones

  Engagement moyen (ouvre 3-4x/semaine) :
    → Rappels de routine aux heures configurées
    → Bilan hebdomadaire

  Engagement faible (ouvre 1x/semaine ou moins) :
    → Réduire progressivement les rappels
    → Garder uniquement le bilan hebdomadaire
    → Après 2 semaines d'inactivité : STOP total
    → Si retour : reprendre doucement (1 notification, pas 3)

  JAMAIS :
    ✗ "Tu nous manques !"
    ✗ "Tu n'as pas ouvert l'app depuis 3 jours"
    ✗ Augmenter les notifications quand l'engagement baisse
    ✗ Notification passive-agressive déguisée en motivation
```

---

## VI. Seed Data et Contenu Pré-rempli

### L'écran vide est l'ENNEMI de l'onboarding. Le seed data élimine le vide.

### Règles de seed data

```
1. CULTURELLEMENT NEUTRE
   Les exemples doivent fonctionner à Paris, Tokyo, Lagos, São Paulo et New York.
   ✓ "Méditation 10 min", "Lire 20 pages", "Marche 30 min", "Boire 2L d'eau"
   ✗ Référence à une cuisine locale, une religion, une saison spécifique
   
2. UNIVERSELLEMENT DÉSIRABLE
   Les habitudes/templates proposées doivent être des aspirations partagées.
   ✓ Santé, apprentissage, exercice, créativité, connexion sociale
   ✗ Niche, controversé, culturellement marqué

3. TEMPLATES PAR CATÉGORIE
   Les templates sont regroupés par domaine de vie :
   - Santé & Bien-être : hydratation, sommeil, exercice, méditation
   - Productivité : deep work, planification, review
   - Relations : appeler un proche, gratitude, quality time
   - Apprentissage : lecture, pratique d'une compétence, journaling
   - Finance : suivi dépenses, épargne, review budget

4. RÉALISTE
   Les templates proposent des PETITS premiers pas, pas des objectifs intimidants.
   ✓ "Méditation 5 min" (atteignable)
   ✗ "Méditation 1h" (décourageant pour un débutant)
   ✓ "Lire 10 pages"
   ✗ "Lire 1 livre par semaine"

5. MODIFIABLE
   Chaque template est un POINT DE DÉPART. L'utilisateur peut tout modifier.
   L'app dit : "Adapte ces suggestions à ton rythme"
```

---

## VII. Les "Jamais" du Contenu

```
✗ "Oups" / "Oops"                 → L'app est sérieuse, pas maladroite
✗ "Hey !" / "Salut !"             → L'app est un outil, pas un ami sur Instagram
✗ "N'oubliez pas !"               → Culpabilisant
✗ "Veuillez" dans l'UI            → Trop formel pour mobile
✗ Points d'exclamation multiples   → "Bravo !!!" = non. "Bravo." = oui
✗ MAJUSCULES pour emphasis         → Utiliser le bold à la place
✗ Texte placeholder "Lorem ipsum"  → Chaque texte est final ou marqué TODO
✗ Abréviations non universelles    → "Hab." pour "Habitude" = non
✗ Jargon technique visible         → "Synchronisation", "Cache vidé" = non
✗ Double négation                  → "Ne voulez-vous pas ne pas..." = cauchemar
✗ Condescendance                   → "C'est facile !" (ça ne l'est peut-être pas pour lui)
✗ Gendered language (en anglais)   → "his/her" → "their"
✗ "Tu nous manques"               → Culpabilisant, manipulateur
✗ "Continue comme ça !"           → Injonction déguisée en encouragement
```

---

## Implémentation (→ .github/instructions/)

| Aspect | Fichier de référence |
|--------|---------------------|
| i18n (clés, ARB, ICU, pluralisation) | `design-system-i18n.instructions.md` |
| i18n strict (zéro hardcode, lint) | `design-system-i18n-strict.instructions.md` |
| Icônes / illustrations (mapping) | `design-system-illustrations.instructions.md` |
| UX writing patterns | `design-system-ux-writing.instructions.md` |
| Format dates/nombres (locale-aware) | `design-system-i18n.instructions.md` §format |
| Célébrations / milestones | `design-system-celebrations.instructions.md` |

---

*Créé le : 2026-03-17*
*Dernière mise à jour : 2026-03-17*
*Dépend de : product-soul.md, experience-architecture.md*
