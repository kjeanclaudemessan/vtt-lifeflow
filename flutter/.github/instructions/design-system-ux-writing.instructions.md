```instructions
---
applyTo: "**/*_view.dart,**/*_dialog.dart,**/l10n/**"
---
# Design System — UX Writing, Voice & Micro-Copy Emotional Library

> VTT apps speak with ONE voice: human, warm, precise.
> ALL user-facing text is localized (ARB files). Zero hardcoded strings.
> Micro-copy is emotional and rotated to avoid repetition.

---

## Tone & Voice

### Per App Family

| Family | Tone | Tutoiement | Examples |
|--------|------|-----------|----------|
| **Flow** (LifeFlow, IronFlow...) | Warm, encouraging, personal | **Tu** | "Tu as accompli ta journée !", "Continue comme ça" |
| **Pro** (HustlePro, ForgePro...) | Professional, efficient, respectful | **Vous** | "Votre document est prêt", "Facture envoyée" |
| **Community** (ChurchFlow, CareFlow...) | Inclusive, welcoming, collective | **Tu** (members) / **Vous** (admin) | "Bienvenue dans le groupe", "Vous avez 3 nouvelles inscriptions" |

### Universal Rules

1. **No jargon** — "Enregistré" not "Persisté en base de données."
2. **No blame** — "Quelque chose a cassé" not "Tu as fait une erreur."
3. **Active voice** — "Sauvegarde ta progression" not "Ta progression sera sauvegardée."
4. **Positive framing** — "Encore 2 habitudes" not "Tu n'as pas fait 2 habitudes."

---

## Text Length Rules

| Element | Max Length | Example |
|---------|-----------|---------|
| **Screen title** | 5 words | "Mes habitudes" |
| **Button label** | 3 words | "Sauvegarder" |
| **Description** | 15 words | "Ajoute tes habitudes quotidiennes pour suivre ta progression" |
| **Error message** | 12 words | "Service indisponible. Réessaie." |
| **Snackbar** | 8 words | "Habitude sauvegardée !" |
| **Empty state title** | 5 words | "Pas encore d'habitudes" |
| **Empty state desc** | 15 words | "Commence par ajouter ta première habitude quotidienne" |

---

## Button Labels

- **Always a verb** (action-oriented): "Sauvegarder", "Continuer", "Ajouter", "Commencer".
- **Never vague**: "OK", "Suivant" → only for progression steps, never for primary actions.
- **Destructive actions**: "Supprimer" (not "Delete"), red variant.
- **Cancel actions**: "Annuler" (neutral, never guilt-tripping).

| Good | Bad | Why |
|------|-----|-----|
| "Créer une habitude" | "Nouveau" | Explicit action |
| "Supprimer" | "Oui, supprimer" | Clear without redundancy |
| "Annuler" | "Non, je veux garder" | Neutral option |
| "Plus tard" | "Non merci" | No shame |
| "Commencer l'essai" | "Essai gratuit" | Verb-first |

---

## Error Messages

### Structure: What happened + What to do

```
[Human description]. [Next action].
```

| Context | Message |
|---------|---------|
| Network error | "Pas de connexion. Vérifie ton réseau et réessaie." |
| Server error | "Service momentanément indisponible. Réessaie dans un instant." |
| Form validation | "Ce champ est requis." / "Adresse email invalide." |
| Auth error | "Email ou mot de passe incorrect." |
| Timeout | "Ça prend plus longtemps que prévu. Réessaie." |
| Permission denied | "Tu n'as pas accès à cette fonctionnalité." |

### Rules

- **Never show technical messages** to users (no "Error 500", no "SocketException").
- **Always offer a next step** (retry button, "Réessaie", guidance).
- **Never blame the user** ("Incorrect input" → "Ce champ est requis").

---

## Success Messages

| Context | Message | Style |
|---------|---------|-------|
| Save | "C'est noté !" | Encouraging |
| Create | "Habitude créée !" | Celebratory |
| Delete | "Supprimé." | Neutral |
| Update | "Modifications enregistrées." | Neutral |
| Profile | "Profil mis à jour !" | Encouraging |

---

## Loading Text

- **Primary**: Animated dots (`...`) — no text needed for most cases.
- **Long operations**: Contextual message — "Préparation..." / "Synchronisation..." / "Analyse en cours..."
- **Never show raw**: "Loading", "Please wait."

---

## Date & Time Formats

| Context | Format | Example |
|---------|--------|---------|
| Recent (< 1 min) | "À l'instant" | — |
| Recent (< 1 hour) | "Il y a X min" | "Il y a 5 min" |
| Recent (< 24 hours) | "Il y a X h" | "Il y a 3 h" |
| This week | Day name | "Lundi" |
| This year | Day + Month | "10 mars" |
| Older | Full date | "10 mars 2025" |
| Precise timestamp | Date + Time | "10 mars 2026 à 14:30" |

### Rules

- Use **relative dates** when < 24h.
- Use **absolute dates** otherwise.
- Format via `intl` package with locale-aware formatting.
- Never use `dd/MM/yyyy` — always spelled out month name.

---

## Languages

- **Default**: Français.
- **Day 1 support**: Français (`fr`) + English (`en`).
- **Future**: Arabic (`ar`), Spanish (`es`), Portuguese (`pt`).
- **RTL fallback font**: Noto Sans Arabic.

---

## Micro-Copy Emotional Library

### Categories

6 emotional categories, 10+ variants each, stored in ARB files:

### 1. Encouragement (daily actions)

```json
"encouragement_1": "Continue comme ça !",
"encouragement_2": "Tu avances bien.",
"encouragement_3": "Encore un pas de fait.",
"encouragement_4": "Beau travail.",
"encouragement_5": "Chaque effort compte.",
"encouragement_6": "Tu es sur la bonne voie.",
"encouragement_7": "Bien joué !",
"encouragement_8": "Ça fait plaisir à voir.",
"encouragement_9": "Un de plus !",
"encouragement_10": "Tu progresses."
```

### 2. Félicitation (milestones)

```json
"celebration_1": "Bravo !",
"celebration_2": "Objectif atteint !",
"celebration_3": "Impressionnant !",
"celebration_4": "Tu gères !",
"celebration_5": "Journée parfaite !",
"celebration_6": "Excellent travail !",
"celebration_7": "Mission accomplie !",
"celebration_8": "Chapeau !",
"celebration_9": "Tu as tout donné !",
"celebration_10": "Record battu !"
```

### 3. Réconfort (after error/failure)

```json
"comfort_1": "Pas de souci, ça arrive.",
"comfort_2": "On réessaie ?",
"comfort_3": "Ce n'est pas grave.",
"comfort_4": "Demain est un nouveau jour.",
"comfort_5": "Reprends quand tu veux.",
"comfort_6": "L'important c'est d'essayer.",
"comfort_7": "Ça arrive aux meilleurs.",
"comfort_8": "Pas de pression.",
"comfort_9": "Un pas à la fois.",
"comfort_10": "Tout va bien."
```

### 4. Motivation (return after absence)

```json
"welcome_back_1": "Content de te revoir !",
"welcome_back_2": "Reprends là où tu en étais.",
"welcome_back_3": "Bon retour !",
"welcome_back_4": "Prêt à continuer ?",
"welcome_back_5": "C'est reparti !",
"welcome_back_6": "Tu nous as manqué !",
"welcome_back_7": "De retour, c'est bien.",
"welcome_back_8": "Bienvenue !",
"welcome_back_9": "On reprend ?",
"welcome_back_10": "Heureux de te retrouver."
```

### 5. Humour léger (rare, subtle)

```json
"humor_1": "Facile, non ?",
"humor_2": "Comme sur des roulettes.",
"humor_3": "Et voilà !",
"humor_4": "Rapide comme l'éclair.",
"humor_5": "Rien ne t'arrête."
```

### 6. Urgence douce (time-sensitive but not pressuring)

```json
"gentle_urgency_1": "Plus que quelques jours.",
"gentle_urgency_2": "Ton essai se termine bientôt.",
"gentle_urgency_3": "Pense à sauvegarder.",
"gentle_urgency_4": "Dernière étape !",
"gentle_urgency_5": "Presque fini."
```

### Rotation Logic

```dart
// Select a random variant to avoid repetition
String getEncouragement(AppLocalizations l10n) {
  final messages = [
    l10n.encouragement_1,
    l10n.encouragement_2,
    // ... up to l10n.encouragement_10
  ];
  return messages[DateTime.now().millisecond % messages.length];
}
```

### App-Specific Tone (via ThemeExtension or config)

| App | Metaphor Domain | Example |
|-----|----------------|---------|
| IronFlow | Sport/fitness | "Nouvelle série !" / "Rep après rep." |
| SpiritFlow | Spiritual/inspiration | "Que cette journée soit bénie." |
| HustlePro | Business/hustle | "Un client de plus !" / "Business en mode." |
| WealthFlow | Finance/growth | "Ton portefeuille te remercie." |

---

## ARB File Structure

```
lib/l10n/arb/
├── app_fr.arb    # French (template)
├── app_en.arb    # English
├── app_ar.arb    # Arabic (future)
└── app_es.arb    # Spanish (future)
```

### Key Naming Convention

```json
{
  "screenName_elementType_description": "Value",
  "habits_title": "Mes habitudes",
  "habits_empty_title": "Pas encore d'habitudes",
  "habits_empty_description": "Commence par ajouter ta première habitude.",
  "habits_button_add": "Ajouter une habitude",
  "common_error_network": "Pas de connexion. Vérifie ton réseau.",
  "common_success_saved": "C'est noté !",
  "encouragement_1": "Continue comme ça !"
}
```

---

## Forbidden Words (content-rules §VII)

These words/patterns are **BANNED** from all user-facing text (ARB values, default params, instructions examples):

| Forbidden | Replacement |
|-----------|-------------|
| Oups / Oops | *(remove — rephrase)* |
| LOL, MDR | *(never)* |
| "Tu as échoué" | "Reprends quand tu veux" |
| "Erreur fatale" | "Service indisponible" |
| "Interdit" | "Non disponible" |
| Jargon technique (Error 500, SocketException) | Plain-language explanation |
| Blame phrasing ("Tu as fait une erreur") | Neutral ("Ce champ est requis") |
| Guilt-tripping ("Tu as perdu ta série") | Encouraging ("Reprends quand tu veux") |
| Formal "Vous" (Flow family) | "Tu" (per tone table above) |
| "Contenu" (for empty states) | *(use invitation verbs)* |
| "Pas de" / "Aucun" as title | *(use positive invitation)* |

> **Rule**: If a proposed text matches any pattern above, it MUST be rewritten before merge.

---

## Self-Check

- [ ] Zero `Text('...')` with hardcoded strings in views.
- [ ] All strings use `context.l10n.keyName`.
- [ ] No emoji prefixed labels in ARB files.
- [ ] No forbidden words in any ARB value.
- [ ] Error messages are neutral, never blame the user.
- [ ] Error messages are human-readable + offer a next action.
- [ ] Button labels are action verbs.
- [ ] Dates use relative format when < 24h.
```
