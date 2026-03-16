# 📚 Documentation — LifeFlow

> Index de toute la documentation du projet LifeFlow.

---

## Structure

```
docs/
├── README.md                 ← Ce fichier
├── factory/                  — AI App Factory & Codage Autonome
├── product/                  — Produit LifeFlow (BM, personas, scoring)
├── architecture/             — Spécifications techniques
├── process/                  — Guides de développement & workflow
├── deployment/               — CI/CD & déploiement
└── design/                   — Design system, UX, voix & ton
```

---

## 🏭 factory/ — AI App Factory & Codage Autonome

Le système de production automatisée d'apps mobiles.

| Document | Description |
|----------|-------------|
| [ai-app-factory.md](factory/ai-app-factory.md) | Vision complète du système autonome (100+ apps, toolchain MCP, Telegram, SaaS) |
| [pipeline-strategy.md](factory/pipeline-strategy.md) | Stratégie d'exécution en 3 phases : Local → Orchestrateur → VPS + Telegram |
| [certified-gate-loop.md](factory/certified-gate-loop.md) | Partie 1 — Fondations : diagnostic, pyramide de gates, dérives IA, boucle de validation |
| [certified-gate-loop-part2.md](factory/certified-gate-loop-part2.md) | Partie 2 — Wireframe rules, validation visuelle MCP, vision "une instruction → app déployée" |

**Ordre de lecture :** ai-app-factory → certified-gate-loop → part2 → pipeline-strategy

---

## 📦 product/ — Produit LifeFlow

Tout ce qui concerne le produit du point de vue marché, utilisateurs et fonctionnalités.

| Document | Description |
|----------|-------------|
| [business-model.md](product/business-model.md) | Business model v3 : positionnement, valeur, pricing, projections |
| [personas.md](product/personas.md) | Personas primaire (Amadou) et secondaire (Camille) avec journées types |
| [competitive-analysis.md](product/competitive-analysis.md) | Analyse concurrentielle (directe, indirecte, substituts) |
| [feature-scoring.md](product/feature-scoring.md) | Grille de scoring des features par phase (impact, rétention, faisabilité) |
| [product-audit.md](product/product-audit.md) | Audit produit du BM original (5.0/10) et du BM v2 (6.8/10) |

**Ordre de lecture :** business-model → personas → competitive-analysis → feature-scoring → product-audit

---

## 🏗️ architecture/ — Spécifications Techniques

| Document | Description |
|----------|-------------|
| [IMPLEMENTATION.md](architecture/IMPLEMENTATION.md) | Spéc d'implémentation complète : data model, archi IA, wireframes ASCII, features par phase |

---

## ⚙️ process/ — Guides & Workflow de Développement

| Document | Description |
|----------|-------------|
| [DEVELOPER_GUIDE.md](process/DEVELOPER_GUIDE.md) | Guide développeur : setup, commandes Flutter/Supabase/FastAPI, troubleshooting |
| [SPECKIT.md](process/SPECKIT.md) | Guide SpecKit : installation, structure, workflow specify → plan → tasks → implement |

---

## 🚀 deployment/ — CI/CD & Déploiement

| Document | Description |
|----------|-------------|
| [CICD_PIPELINE.md](deployment/CICD_PIPELINE.md) | Architecture CI/CD : du commit au Store (GitHub Actions, Fastlane, Coolify) |
| [DEPLOYMENT_GUIDE.md](deployment/DEPLOYMENT_GUIDE.md) | Guide de déploiement : statut infrastructure, setup serveurs |

---

## 🎨 design/ — Design System & UX

| Document | Description |
|----------|-------------|
| [ds-config.md](design/ds-config.md) | Configuration du design system : palette LifeFlow, tokens, structure DS |
| [UI_UX_AUDIT_2026.md](design/UI_UX_AUDIT_2026.md) | Audit UI/UX complet de l'app Flutter (score 7.9/10) |
| [voice-and-tone.md](design/voice-and-tone.md) | Voix & ton de la marque : personnalité, règles d'écriture, patterns de copy |
| [VTT_DESIGN_KIT_PHASES.md](design/VTT_DESIGN_KIT_PHASES.md) | Plan en 53 phases du design system pour 200+ apps (Generic Core + Brand Skins) |

---

## 📄 Documents hors docs/

| Document | Emplacement | Description |
|----------|------------|-------------|
| [business_model_lifeflow.md](../business_model_lifeflow.md) | Racine | Document de vision produit complet (BM original v2.0, 700+ lignes) |
| [Constitution](../.specify/memory/constitution.md) | .specify/memory/ | Loi suprême du projet (architecture, naming, quality gates) |
| [Instructions Flutter](../flutter/.github/copilot-instructions.md) | flutter/.github/ | Instructions Copilot spécifiques Flutter (14+ fichiers) |

---

*Dernière mise à jour : 16 Mars 2026*
