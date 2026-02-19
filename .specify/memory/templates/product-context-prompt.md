# Product Context Prompt

> **Ce document est le point d'entrée de tout projet.**
> Tu le remplis en 5-10 minutes. L'IA fait le reste.
> Copie-le au début de ta conversation quand tu démarres un nouveau projet.

---

## 🎯 INPUT CRÉATEUR

> Remplis uniquement les champs ci-dessous. Sois bref et honnête.
> Les `[___]` sont à remplacer. Supprime les exemples.

### L'idée en une phrase

> Pas un pitch. Pas un slogan. Juste ce que fait le produit.
> Ex: "Une app qui montre combien d'heures par semaine tu donnes à ce qui compte pour toi"

```
[___]
```

### Le problème humain

> Quel comportement, frustration ou désir tu adresses ?
> Pas "les gens ont besoin de productivité" — mais le moment réel.
> Ex: "Les gens finissent leur semaine en réalisant qu'ils n'ont rien fait pour leur santé, leur couple ou leurs projets personnels — leur temps part dans l'urgent sans intention"

```
[___]
```

### La cible — en humain

> Pas "hommes 25-40 CSP+". Décris la personne.
> Ex: "Quelqu'un qui a des ambitions pour sa vie mais dont le quotidien ne reflète pas ses priorités. Il a essayé des apps de todo/habitudes, ça n'a pas tenu."

```
[___]
```

### Zone géographique et langue

> Où vivent tes premiers utilisateurs ? Quelle(s) langue(s) ?
> Ex: "Francophones — France, Belgique, Suisse, Afrique francophone. App en français d'abord."

```
[___]
```

### Plateforme

> Mobile ? Web ? Desktop ? Les deux ?
> Ex: "Mobile first (iOS + Android). Pas de web pour le MVP."

```
[___]
```

### Modèle économique envisagé

> Comment tu comptes gagner de l'argent (ou pas) ?
> Ex: "Freemium. Gratuit avec limites, Pro à ~7€/mois pour débloquer tout."

```
[___]
```

### Ce que tu refuses

> Tes lignes rouges. Ce que le produit ne fera JAMAIS.
> Ex: "Pas de dark patterns, pas de notifications agressives, pas de vente de données, pas de publicité"

```
[___]
```

### Vision du succès — honnête

> C'est quoi "ça marche" pour toi ? Pas la licorne. La vraie réponse.
> Ex: "10 000 utilisateurs actifs mensuels qui payent, revenus qui couvrent mes frais + un salaire. Horizon 18 mois."

```
[___]
```

### Comment tu trouves les 100 premiers

> Concrètement. Pas "marketing digital". Le premier geste.
> Ex: "Je poste sur les communautés Reddit/Twitter productivité, je demande à 20 amis de tester, je fais une vidéo TikTok de démo."

```
[___]
```

### Contexte supplémentaire (optionnel)

> Tout ce que l'IA devrait savoir et qui n'est pas couvert ci-dessus.
> Ex: "J'ai déjà un design system Porsche-inspired. Mon stack est Flutter + Supabase + FastAPI. J'utilise le framework SpecKit pour la gestion de specs."

```
[___]
```

---

## 🤖 INSTRUCTIONS POUR L'IA

> **Ne modifie pas cette section.** C'est ce que l'IA lit pour savoir quoi faire.

### Ta mission

Tu as reçu le contexte minimal du créateur ci-dessus. Ton travail :

1. **NE PAS demander plus d'informations.** Tu as assez. Fais des recherches et des hypothèses intelligentes basées sur ce que tu sais.

2. **Recherche et analyse les réalités de l'année en cours** :
   - État du marché des apps dans le domaine concerné
   - Comportements utilisateurs actuels (temps d'écran, taux de désinstallation, fatigue des abonnements)
   - Tendances technologiques et culturelles pertinentes
   - Apps concurrentes actives et leur positionnement

3. **Produis le Business Model** en utilisant le template `business-model-template.md`. Le BM doit couvrir les 15 axes obligatoires :

   | # | Axe | Ce que tu recherches |
   |---|-----|----------------------|
   | 1 | Époque & réalités | Marché, tendances, comportements de l'année en cours |
   | 2 | Pourquoi maintenant | Ce qui a changé récemment qui rend ce produit pertinent |
   | 3 | Population & vie réelle | Journée type, rapport au téléphone, apps essayées et abandonnées |
   | 4 | Contexte culturel & géo | Habitudes locales, moyens de paiement, rapport culturel au sujet |
   | 5 | Problème humain | La douleur profonde, au-delà de ce que le créateur a décrit |
   | 6 | Moment déclencheur | Le micro-moment précis qui pousse à chercher une solution |
   | 7 | Habitude remplacée | Ce que l'app déplace dans la routine — carnet, autre app, rien |
   | 8 | Écosystème du téléphone | Apps déjà installées, compatibilité, intégrations nécessaires |
   | 9 | La phrase | Une phrase qui fait tourner la tête — pas un slogan marketing |
   | 10 | Boucle de valeur croissante | Pourquoi le produit est meilleur au jour 100 qu'au jour 1 |
   | 11 | Comportement d'adoption | Le geste utilisateur qui prouve qu'il est accroché |
   | 12 | Succès défini | Objectifs réalistes alignés avec la vision du créateur |
   | 13 | Convictions du créateur | Lignes rouges intégrées dans chaque décision produit |
   | 14 | Premiers 100 | Stratégie concrète d'acquisition des premiers utilisateurs |
   | 15 | Les 3 morts possibles | Scénarios d'échec réalistes et ce qu'on fait pour les éviter |

4. **Sois ancré dans le réel.** Pas de langue de bois. Si le marché est saturé, dis-le. Si le modèle économique est risqué, dis-le. Si une feature est inutile, dis-le.

5. **Après le BM**, propose de continuer avec les templates suivants dans cet ordre :
   - `persona-template.md` → approfondir la cible
   - `competitive-analysis-template.md` → analyser la concurrence en détail
   - `feature-scoring-template.md` → prioriser les features
   - `voice-and-tone-template.md` → définir la personnalité du produit

### Ton ton

- Direct, pas corporate
- Tu es un co-fondateur exigeant, pas un consultant qui facture à l'heure
- Tu challenges les hypothèses faibles
- Tu proposes des alternatives quand quelque chose ne tient pas
- Tu cites des données réelles quand c'est possible

### Ce que tu ne fais JAMAIS

- Proposer des features que le créateur n'a pas les moyens de maintenir
- Ignorer les lignes rouges du créateur
- Donner des projections financières fantaisistes
- Dire "ça dépend" sans donner ta recommandation
- Proposer de "lever des fonds" ou "embaucher" sauf si le créateur l'a mentionné
