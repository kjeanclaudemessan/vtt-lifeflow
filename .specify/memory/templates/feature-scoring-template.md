# Feature Scoring Template

> **Prérequis** : le Business Model et les Personas sont rédigés.
> Ce template priorise les features avec une grille objective.
> L'IA remplit ce document. Le créateur valide ou ajuste les scores.

---

## 🤖 INSTRUCTIONS IA

1. Lis le BM (section 9 — modules/features) et les Personas
2. Liste TOUTES les features identifiées dans le BM
3. Score chaque feature sur les 5 axes ci-dessous
4. Classe par score final décroissant
5. Propose un découpage en phases basé sur le scoring
6. Sois impitoyable : si une feature n'a pas sa place en Phase 1, dis-le même si le créateur l'aime
7. Le score n'est pas une opinion — justifie chaque note en une phrase

---

# Feature Scoring — [NOM DU PRODUIT]

> *Généré le [DATE] — basé sur le Business Model v[X] et les Personas*

---

## Grille de scoring

Chaque feature est évaluée sur 5 axes. Note de 1 à 5.

| Axe | Question | 1 (faible) | 5 (fort) |
|-----|----------|------------|----------|
| **Impact utilisateur** | Cette feature résout-elle une douleur forte du persona primaire ? | Nice-to-have, le persona ne la remarquerait pas si absente | Le persona ne télécharge PAS l'app sans cette feature |
| **Rétention** | Cette feature donne-t-elle une raison de REVENIR demain ? | Usage unique ou rare | Usage quotidien, l'app perd son sens sans elle |
| **Différenciation** | Cette feature nous distingue-t-elle de la concurrence ? | 10 apps font exactement ça | Personne ne fait ça comme nous |
| **Faisabilité** | Peut-on la construire correctement en 1-2 semaines ? | 2+ mois, dépendances lourdes, risque technique élevé | 1 semaine, pas de dépendance, tech maîtrisée |
| **Valeur croissante** | Cette feature devient-elle MEILLEURE avec le temps/les données ? | Aussi utile au jour 1 qu'au jour 100 | Exponentiellement meilleure avec l'accumulation |

### Score minimum par phase

| Phase | Score minimum | Logique |
|-------|--------------|---------|
| **Phase 1 (MVP)** | ≥ 18/25 | Seulement ce qui est vital, différenciant et faisable |
| **Phase 2** | ≥ 14/25 | Renforce la rétention et la valeur |
| **Phase 3** | ≥ 10/25 | Enrichit l'expérience |
| **Backlog** | < 10/25 | Peut-être jamais — et c'est OK |

---

## Scoring détaillé

> **IA** : Remplis UNE ligne par feature. Justifie chaque note ≤ 2 ou ≥ 4 en une phrase dans la colonne "Justification".

| # | Feature | Impact | Rétention | Différen. | Faisab. | Valeur+ | **TOTAL** | Phase | Justification clé |
|---|---------|--------|-----------|-----------|---------|---------|-----------|-------|--------------------|
| F01 | | /5 | /5 | /5 | /5 | /5 | **/25** | | |
| F02 | | /5 | /5 | /5 | /5 | /5 | **/25** | | |
| F03 | | /5 | /5 | /5 | /5 | /5 | **/25** | | |

---

## Classement par score

> **IA** : Reprends le tableau ci-dessus, trié par score décroissant. Sépare visuellement par phase.

### 🟢 Phase 1 — MVP (score ≥ 18)

| Rang | Feature | Score | Raison d'être en Phase 1 |
|------|---------|-------|--------------------------|
| 1 | | | |

### 🟡 Phase 2 — Renforcement (score 14-17)

| Rang | Feature | Score | Raison d'être en Phase 2 |
|------|---------|-------|--------------------------|
| | | | |

### 🔴 Phase 3 — Enrichissement (score 10-13)

| Rang | Feature | Score | Raison d'être en Phase 3 |
|------|---------|-------|--------------------------|
| | | | |

### ⚫ Backlog — Peut-être jamais (score < 10)

| Feature | Score | Pourquoi pas maintenant |
|---------|-------|------------------------|
| | | |

---

## Analyse croisée

### Features vitales (score Impact ≥ 4 ET Rétention ≥ 4)

> Ce sont les features CŒUR du produit. Si une seule manque, le produit est bancal.

### Features pièges (score Impact ≤ 2 mais Faisabilité = 5)

> Ce sont les features faciles à construire mais qui n'apportent rien. Le piège classique : on les construit parce qu'on PEUT, pas parce qu'on DOIT.

### Features moonshot (score Différenciation = 5 mais Faisabilité ≤ 2)

> Ce sont les features qui nous rendraient uniques mais qui sont très dures à faire. Les garder en tête pour plus tard.

---

## Dépendances

> **IA** : Certaines features dépendent d'autres. Cartographie les dépendances pour éviter de planifier une feature en Phase 1 si sa dépendance est en Phase 2.

```
[Feature A] → nécessite → [Feature B]
[Feature C] → nécessite → [Feature A] + [Feature D]
```

---

## Décision finale du créateur

> Après lecture du scoring, le créateur peut :
> - ✅ Valider le scoring tel quel
> - 🔄 Déplacer une feature d'une phase à l'autre (avec justification)
> - ❌ Supprimer une feature définitivement
>
> Toute modification doit être justifiée. "J'aime cette feature" n'est pas une justification.

| Feature déplacée | De → Vers | Justification |
|-----------------|-----------|---------------|
| | | |

---

## Résumé exécutif

> **IA** : En 5 lignes max :
> - Combien de features en Phase 1 ?
> - Quelle est LA feature qui fait ou défait le produit ?
> - Quelle feature a été la plus dure à scorer et pourquoi ?
> - Y a-t-il un trou (besoin du persona non couvert par aucune feature) ?
