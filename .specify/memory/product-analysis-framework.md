# Product Analysis Framework — 2026 Edition

> **Reusable framework** for evaluating product decisions.
> Apply to: features, wireframes, UX flows, design systems, roadmap priorities.
> 26 criteria, 7 dimensions. Score each 1-10.

---

## I. DÉSIRABILITÉ (L'utilisateur EN VEUT)

### 1. Résolution de douleur vs création de plaisir
- Quelle douleur EXACTE disparaît en utilisant le produit ?
- L'utilisateur peut-il VERBALISER cette douleur à un ami en 1 phrase ?
- La douleur est-elle quotidienne (habit-forming) ou occasionnelle (utilitaire) ?
- Test : si tu retires l'app demain, qu'est-ce qui manque concrètement ?

### 2. Time-to-value (TTV)
- En combien de secondes l'utilisateur ressent-il la première valeur ?
- Benchmark 2026 : < 30 secondes ou l'utilisateur part
- L'onboarding EST le produit — pas un passage obligé avant le produit
- Chaque écran d'onboarding doit DONNER quelque chose, pas juste DEMANDER

### 3. Désir des gens en 2026
- **Anti-complexité** : après Notion/Obsidian, les gens fuient la configuration. Ils veulent "ça marche"
- **Authenticité** : les apps "corporate-polished" perdent face aux apps avec une personnalité, un ton, une opinion
- **Contrôle sans effort** : l'utilisateur veut sentir qu'il contrôle sans devoir tout configurer
- **Résultats tangibles** : pas de promesses abstraites ("soyez plus productif"). Montre-moi ce que j'ai fait AUJOURD'HUI
- **Privacy-conscious** : les gens se soucient de où vivent leurs données. "Local-first" est un argument de vente
- **Moins d'apps, plus d'intégration** : les gens veulent 1 app qui fait bien 3 choses, pas 3 apps qui font chacune 1 chose

### 4. Le premier écran
- Ce que l'utilisateur voit en ouvrant l'app détermine TOUT
- Doit répondre immédiatement à : "Qu'est-ce que je dois faire maintenant ?"
- Pas de dashboard vide. Pas de "bienvenue". De l'ACTION
- L'écran s'adapte au moment de la journée

---

## II. UTILISABILITÉ (L'utilisateur SAIT L'UTILISER)

### 5. Friction cognitive
- Chaque tap = un coût. Chaque champ = un coût. Chaque choix = un coût
- **Loi de Hick** : plus il y a d'options, plus la décision est lente
- Règle : si une action principale nécessite > 3 taps, c'est trop
- Les defaults intelligents éliminent 80% des choix (l'utilisateur modifie après, s'il veut)

### 6. Patterns d'interaction natifs 2026
- **Bottom sheets** > modals plein écran (pour les actions rapides)
- **Swipe gestures** > tap sur icône (pour les actions fréquentes)
- **Long press** > menu contextuel `⋯` (pour les options)
- **Haptic feedback** sur chaque action significative (confirmation physique)
- **Animations de transition** = continuité spatiale (l'utilisateur sait où il est)
- **Pull-to-refresh est mort** → realtime ou fetch au focus
- **Skeleton/shimmer** > spinners (le contenu "arrive", il n'est pas "chargé")

### 7. Densité informationnelle
- L'utilisateur SCANNE (2s) avant de LIRE
- Hiérarchie visuelle : titre → chiffre/badge → détail secondaire
- Les métriques (streak, %, compteurs) sont de la **dopamine visuelle** — toujours visibles
- Le détail (description, historique, settings) est à 1 tap de profondeur

### 8. Micro-sessions
- Usage réel : 15-30 secondes, 10-15 fois par jour
- Pas 5 minutes, 2 fois par jour — c'est un fantasme
- Chaque session doit avoir un "done" satisfaisant avant 20 secondes
- L'app doit être utile même si l'utilisateur l'ouvre 3 secondes

---

## III. PSYCHOLOGIE & COMPORTEMENT

### 9. Boucles d'engagement
- **Trigger** → **Action** → **Reward** → **Investment** (modèle Hook, Nir Eyal)
- Le trigger doit être externe d'abord (notif), puis interne (habitude)
- La reward doit être variable (pas toujours le même feedback)
- L'investment rend le départ coûteux (données, personnalisation, historique)

### 10. Gamification mesurée
- Les streaks motivent ET stressent. Prévoir une mécanique de "grâce" (streak freeze, jour off)
- Les badges/niveaux fonctionnent SI ils sont rares et significatifs. Trop de badges = zéro valeur
- Ne jamais gamifier au point que l'utilisateur "game" le système (cocher sans faire)
- **Progression visible** : l'utilisateur doit voir d'où il vient (pas juste où il est)

### 11. Le paradoxe de la motivation
- Les gens téléchargent l'app au pic de motivation (Nouvel An, lundi matin)
- La rétention se joue quand la motivation disparaît (jeudi soir, semaine 3)
- Le produit doit être utile ET agréable quand l'utilisateur n'a PAS envie de l'utiliser
- L'app ne doit jamais culpabiliser. "Pas fait" ≠ "échoué"

### 12. Ancrage temporel
- Matin = planification, énergie, intention
- Midi = checkpoint, micro-ajustement
- Soir = bilan, satisfaction, clôture
- L'app doit s'adapter au MOMENT de la journée (pas le même écran à 7h et 22h)

---

## IV. TECHNIQUE & PERFORMANCE

### 13. Cold start < 1 seconde
- Le premier paint avec du contenu réel en < 1s
- Skeleton screens pour les données async
- Cache local (Hive/Drift) pour l'affichage instantané, sync en background

### 14. Optimistic updates
- L'UI réagit IMMÉDIATEMENT à l'action de l'utilisateur
- Le sync avec le serveur se fait en background
- Si erreur → revert l'UI + snackbar explicatif
- L'utilisateur ne doit JAMAIS voir un spinner pour une action CRUD basique

### 15. Offline-first mindset
- Même si Phase 1 est online-only, l'architecture doit prévoir la queue d'actions
- Les données récentes sont en cache local
- Pas de polling. Realtime (websocket) pour les changements + fetch au app resume

### 16. Battery & data
- Zéro polling en background
- Notifications push via FCM/APNs, pas via polling
- Images/assets en cache agressif
- Dark mode = économie batterie sur OLED (majorité des écrans en 2026)

---

## V. DESIGN & MARQUE

### 17. Identité visuelle mémorable
- L'app doit être reconnaissable en 1 screenshot
- Une palette réduite (2-3 couleurs max en usage quotidien)
- Une "signature" interaction (le swipe de Tinder, le pull de Twitter)
- Typographie distinctive mais lisible

### 18. Dark mode = citoyen de première classe
- Pas un "filtre inversé" du light mode
- Design pensé dark-first en 2026 (la majorité des users sont en dark)
- Les couleurs des domaines/badges doivent fonctionner sur les deux modes

### 19. Accessibilité = marché
- 15% de la population a un handicap. C'est un marché, pas une contrainte
- Contraste WCAG AA minimum, AAA pour le texte principal
- Touch targets ≥ 48dp
- Pas de dépendance aux couleurs seules (icône + couleur + label)
- Support VoiceOver/TalkBack sur les actions clés
- Tailles de texte dynamiques (respecter le scaling système)

---

## VI. BUSINESS & ADOPTION

### 20. Viralité organique
- L'utilisateur peut-il MONTRER l'app à un ami en 10 secondes ?
- Y a-t-il un artifact partageable ? (screenshot d'un streak, bilan de semaine)
- Le produit résout-il un problème que les gens VERBALISENT entre eux ?

### 21. Rétention > acquisition
- D1 retention benchmark 2026 : 40%+
- D7 : 20%+
- D30 : 10%+
- Chaque % de rétention vaut 10x plus qu'un nouveau download
- La rétention se design, elle ne se fixe pas après coup

### 22. Monétisation non-hostile
- Freemium généreux (le free doit être VRAIMENT utile, pas castré)
- Premium = power features, pas des features de base derrière un paywall
- Pas de pubs. Jamais. C'est 2026, les gens paient ou partent
- Prix = café par mois (3-5€/mois). Au-dessus, l'utilisateur compare

### 23. Scalabilité du produit
- La Phase 1 a N features. La Phase 4 en aura 3N
- La navigation absorbe-t-elle les ajouts sans refonte ?
- Le layout peut-il accueillir de nouvelles sections ?
- La DB schema est-elle extensible sans migrations destructives ?

---

## VII. MARCHÉ & CONTEXTE 2026

### 24. Saturation & différenciation
- Il existe déjà 50+ apps dans ta catégorie. POURQUOI celle-ci ?
- La différenciation doit être résumable en 1 phrase
- Le "10x better" n'existe plus. C'est le "different angle" qui gagne
- Exemples : Linear (pas meilleur que Jira, mais plus opinionated), Arc (pas meilleur que Chrome, mais repensé)

### 25. AI comme commodité
- En 2026, "on a de l'IA" n'est plus un argument. TOUT LE MONDE a de l'IA
- L'IA doit être INVISIBLE (des suggestions intelligentes, pas un chatbot)
- L'utilisateur ne veut pas "parler à une IA". Il veut que l'app comprenne sans qu'on lui demande
- L'IA est un outil, pas une feature

### 26. Platform expectations
- iOS users attendent du polish, des animations fluides, du natif
- Android users acceptent plus de customisation mais attendent Material 3
- Cross-platform (Flutter) doit respecter les conventions de CHAQUE plateforme
- Les widgets adaptatifs (Cupertino vs Material) ne sont plus optionnels

---

## Usage

Pour chaque décision (feature, wireframe, flow), passer les critères pertinents :

```
| Critère | Score /10 | Justification | Action |
|---------|-----------|---------------|--------|
| ...     | ...       | ...           | ...    |
```

Minimum 8/10 sur les critères I (désirabilité) pour valider une feature.
Minimum 7/10 sur les critères II (utilisabilité) pour valider un wireframe.
Les critères III (psychologie) différencient une app "correcte" d'une app "addictive".
