# Quality Gates

Automated quality checks for Flutter + Supabase code.

## Quick Start

```powershell
# Run all gates
.\scripts\gates\verify-gates.ps1

# Run specific gates
.\scripts\gates\verify-gates.ps1 -Gate 2,3

# Check a single file
.\scripts\gates\verify-gates.ps1 -Gate 2,3,4 -Scope file -File "lib/features/habits/views/habits_view.dart"

# JSON output
.\scripts\gates\verify-gates.ps1 -Gate all -Json

# Auto-fix (dart format)
.\scripts\gates\verify-gates.ps1 -Gate 1 -Fix
```

## Gates

| Gate | Name | Scope | Severity | What it checks |
|------|------|-------|----------|----------------|
| 1 | Compilation | Flutter + Supabase | FAIL | `dart analyze`, `dart format`, Supabase DB reset |
| 2 | Pattern Structural | `*_view.dart`, `*_viewmodel.dart`, `*_entity.dart`, `*_model.dart`, `*_repo*.dart` | FAIL | Entity/model separation, state machine, i18n, naming |
| 3 | Architecture | All Dart files | FAIL | Layer deps, cross-feature imports, package whitelist |
| 4 | Experience | `*_view.dart` (features + modules) | WARN | Empty states, animations, haptic, skeleton loading, tone |
| 5 | Cross-Screen Reactivity | `*_viewmodel.dart` | WARN | Repo mutations must trigger `rebuildUi`/notify |
| 6 | Supabase RLS | Migrations | **DISABLED** | RLS policies on tables (re-enable when mandatory) |
| 7 | Tests | Flutter | FAIL | `flutter test` runner |

## Parameters

| Parameter | Values | Default | Description |
|-----------|--------|---------|-------------|
| `-Scope` | `file`, `task`, `phase`, `all` | `all` | What to check |
| `-Gate` | `1`-`7`, comma-separated, or `all` | `all` | Which gate(s) to run |
| `-File` | Path relative to `flutter/` | — | Specific file (when Scope=file) |
| `-Json` | Switch | Off | Write results to `gate-results.json` |
| `-Fix` | Switch | Off | Auto-fix (dart format) |

## Rule Reference

### Gate 2 — Pattern Structural

| Rule | Target | Checks |
|------|--------|--------|
| `entity-equatable` | `*_entity.dart` | Extends `Equatable` |
| `entity-no-json` | `*_entity.dart` | No `@JsonSerializable`, `fromJson`, `toJson` |
| `model-json` | `*_model.dart` | Has `@JsonSerializable` + `fromJson` + `toJson` |
| `model-extends-entity` | `*_model.dart` | Extends its entity |
| `repo-either` | `*_repository.dart` / `*_repo.dart` | Returns `Either<Failure, T>` |
| `view-state-machine` | `*_view.dart` | Handles `isBusy` + `hasError` states |
| `view-i18n` | `*_view.dart` | Uses `context.l10n`, no hardcoded text |
| `view-design-tokens` | `*_view.dart` | Uses AppColors/AppSpacing/AppTextStyles, no hardcoded values |
| `viewmodel-no-widgets` | `*_viewmodel.dart` | No Flutter widget imports |

### Gate 3 — Architecture

| Rule | Checks |
|------|--------|
| `arch-layer-deps` | domain/ does not import data/ or presentation/ |
| `arch-cross-feature` | Feature A does not import Feature B |
| `arch-package-whitelist` | Only approved packages in pubspec.yaml |

### Gate 4 — Experience

| Rule | Target | Checks |
|------|--------|--------|
| `exp-empty-state` | List views | `AppEmptyState` or `.isEmpty` check |
| `exp-sensory-animation` | All views | At least one animation widget |
| `exp-sensory-haptic` | All views | `HapticFeedback` usage |
| `exp-sensory-loading` | All views | Skeleton/shimmer preferred over spinner |
| `exp-personality-tone` | All views | No negative empty text ("Aucun resultat", "Rien ici") |

### Gate 5 — Cross-Screen Reactivity

| Rule | Target | Checks |
|------|--------|--------|
| `reactivity-mutations` | Viewmodels | `_repo.create/update/delete/...()` must pair with `rebuildUi`/notify/reload |
| `reactivity-method` | Per async method | Methods with repo mutations must have notify/reload |

## Post-Task Wrapper

After each implementation task, run the gate check with retry:

```powershell
# Full check after task T005
.\scripts\gates\run-post-task.ps1 -TaskId T005

# Scoped to specific files
.\scripts\gates\run-post-task.ps1 -TaskId T005 -Files "lib/features/habits/views/habits_view.dart" -Gate "2,3,4"

# Max 2 retries instead of 3
.\scripts\gates\run-post-task.ps1 -TaskId T005 -MaxRetries 2
```

The wrapper:
1. Runs `verify-gates.ps1` with `-Json`
2. Prints a formatted report (PASS/FAIL/WARN per gate)
3. On FAIL, generates a **correction prompt** to paste to the AI agent
4. Waits for corrections, then retries (up to 3 times by default)

## Pre-Commit Hook

Install the pre-commit hook to block commits with gate failures:

```powershell
Copy-Item scripts/gates/pre-commit .git/hooks/pre-commit
```

On Linux/macOS:
```bash
cp scripts/gates/pre-commit .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

Behavior:
- **Blocking** (gates 1, 2, 3): Commit aborted on FAIL
- **Advisory** (gates 4, 5, 7): Warnings printed but commit proceeds
- Bypass: `git commit --no-verify` (not recommended)

## speckit.implement Integration

The `speckit.implement` agent automatically runs gates after each task (step 9 in the agent workflow). On FAIL, it applies corrections and retries up to 3 times before moving to the next task.
