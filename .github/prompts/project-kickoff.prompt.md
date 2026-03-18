---
mode: agent
description: "Kickoff prompt for a newly cloned VTT template project. Run this FIRST after cloning, renaming, and cleanup."
---

# Project Kickoff — {PROJECT_NAME}

You are starting work on a **new project** built from the VTT monorepo template (Flutter + FastAPI + Supabase).

## Step 1 — Understand the architecture

Read these files IN ORDER to understand the project conventions:

1. `.github/copilot-instructions.md` — Monorepo architecture, module system, cross-layer communication
2. `.specify/memory/constitution.md` — Supreme law: architecture principles, quality gates, governance
3. `flutter/.github/copilot-instructions.md` — Flutter patterns (Stacked MVVM, Clean Architecture, DI)
4. `supabase/.github/copilot-instructions.md` — Database conventions (migrations, RLS, naming)
5. `fastapi/.github/copilot-instructions.md` — Backend patterns (only if FastAPI is used)
6. `docs/process/DEVELOPER_GUIDE.md` — Quick reference for setup, build, deploy

## Step 2 — Understand the existing codebase

Explore the current state of the project:

1. Read `flutter/lib/app/app.dart` — All registered routes, services, and repositories
2. List `flutter/lib/modules/` — Core modules already available (auth, profile, settings, etc.)
3. List `flutter/lib/features/` — Project-specific features (may be empty if freshly cleaned)
4. List `flutter/lib/domain/entities/` — Existing domain entities
5. List `flutter/lib/services/` — Available services (analytics, storage, sync, notifications, etc.)
6. List `supabase/migrations/` — Current database schema
7. List `flutter/lib/ui/widgets/` — Design system widgets available

## Step 3 — Understand the workflow

This project uses the **SpecKit pipeline**. Every feature follows:

```
/speckit.specify → /speckit.plan → /speckit.tasks → /speckit.implement
```

- **No coding without specs** — always run `/speckit.specify` first
- **Constitution check** — `plan.md` must validate every architecture principle
- **Coding order** — Supabase migrations → Domain entities → Data models/repos → DI → Features → Tests
- **Quality gates** — RLS on every table, Either<Failure,T> on every repo, design system tokens only, i18n mandatory

## Step 4 — Available prompts

The following prompts are available for common tasks:

### Feature development
- `/create-feature` — Scaffold a new feature (view, viewmodel, widgets)
- `/create-model` — Create entity + model pair following separation rules
- `/create-repository` — Create repo contract + implementation
- `/create-service` — Create a new service
- `/create-widget` — Create a design system widget

### Quality
- `/write-tests` — Generate tests for a feature
- `/fix-bug` — Debug and fix an issue
- `/refactor` — Refactor existing code
- `/audit-screen-design` — Audit a screen against design system
- `/audit-ux` — UX audit of a feature

### Enhancement
- `/add-i18n` — Add translations to a feature
- `/add-accessibility` — Add a11y support
- `/add-animations` — Add animations
- `/add-haptics` — Add haptic feedback

### Backend
- `/create-api-endpoint` — Create a FastAPI endpoint

## Step 5 — What to do now

Tell me:
1. **What is this project?** (app name, purpose, target users)
2. **What is the first feature to build?** (describe it in user story format)

I will then run `/speckit.specify` to start the spec-driven development pipeline.

---

## Architecture summary (for quick reference)

```
┌─────────────┐         ┌─────────────┐         ┌─────────────┐
│   Flutter    │ ◄─────► │  Supabase   │ ◄─────► │   FastAPI   │
│  (Client)    │  direct │  (BaaS)     │  svc key│  (Backend)  │
└─────────────┘         └─────────────┘         └─────────────┘
       │                                               │
       └──────── HTTP REST (heavy logic ONLY) ─────────┘
```

**Flutter folder structure:**
```
flutter/lib/
├── app/          ← DI registration, routes (app.dart)
├── core/         ← Extensions, constants, theme, l10n
├── data/         ← Models (@JsonSerializable), Repository implementations
├── domain/       ← Entities (pure Dart, Equatable), Repository contracts
├── features/     ← YOUR features (views, viewmodels, widgets)
├── modules/      ← Core modules (auth, profile, settings, splash, onboarding)
├── services/     ← Technical services (analytics, storage, sync, notifications)
└── ui/           ← Design system widgets, bottom sheets, dialogs
```

**Non-negotiable rules:**
- Entity/Model separation (domain/ vs data/)
- Either<Failure, T> for all repo methods
- Design system tokens only (AppColors, AppSpacing, AppTextStyles, AppGaps)
- i18n for all user-facing strings (context.l10n.xxx)
- RLS on every Supabase table
- Views contain NO business logic
- Features do NOT import from other features
