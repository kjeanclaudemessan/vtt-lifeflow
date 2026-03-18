# ══════════════════════════════════════════════════════════════
# cleanup-lifeflow.ps1 — Supprime tous les éléments LifeFlow du template
# Exécuter APRÈS le renommage du projet (rename_project.ps1)
# Usage : .\cleanup-lifeflow.ps1 [-DryRun]
# ══════════════════════════════════════════════════════════════

param(
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

$foldersToDelete = @(
    "apps_docs",
    "specs",
    ".specify/specs",
    "flutter/lib/features/today",
    "flutter/lib/features/habits",
    "flutter/lib/features/domains",
    "flutter/lib/features/counter",
    "flutter/lib/features/bilan",
    "flutter/test/integration",
    "flutter/assets/images/onboarding",
    "tools/src/lifeflow_tools"
)

$filesToDelete = @(
    # Domain entities
    "flutter/lib/domain/entities/habit_entity.dart",
    "flutter/lib/domain/entities/habit_log_entity.dart",
    "flutter/lib/domain/entities/domain_entity.dart",
    "flutter/lib/domain/entities/streak_info.dart",
    "flutter/lib/domain/entities/weekly_bilan.dart",
    "flutter/lib/domain/entities/time_counter.dart",
    # Domain repositories
    "flutter/lib/domain/repositories/i_domain_repository.dart",
    "flutter/lib/domain/repositories/i_habit_repository.dart",
    # Data models
    "flutter/lib/data/models/habit_model.dart",
    "flutter/lib/data/models/habit_model.g.dart",
    "flutter/lib/data/models/habit_log_model.dart",
    "flutter/lib/data/models/habit_log_model.g.dart",
    "flutter/lib/data/models/domain_model.dart",
    "flutter/lib/data/models/domain_model.g.dart",
    # Data repositories
    "flutter/lib/data/repositories/habit_repository_impl.dart",
    "flutter/lib/data/repositories/domain_repository_impl.dart",
    # Services
    "flutter/lib/services/habit_event_service.dart",
    "flutter/lib/services/habit_toggle_service.dart",
    "flutter/lib/services/time_counter_service.dart",
    "flutter/lib/services/bilan_service.dart",
    # Assets
    "flutter/assets/icon/app_icon.png",
    "flutter/assets/lottie/onboarding_habits.json",
    "flutter/assets/lottie/onboarding_progress.json",
    "flutter/assets/lottie/onboarding_time.json",
    # Supabase migrations
    "supabase/migrations/20260220000001_create_domains.sql",
    "supabase/migrations/20260220000002_create_habits.sql",
    "supabase/migrations/20260220000003_create_routines.sql",
    "supabase/migrations/20260220000004_create_tasks.sql",
    "supabase/migrations/20260220000005_create_inbox_items.sql",
    "supabase/migrations/20260305000001_enhance_habits_and_logs.sql",
    # Root docs
    "business_model_lifeflow.md",
    "CHANGELOG.md",
    "MIGRATION_SUPABASE_CLOUD.md",
    # Screen maps
    "scripts/mobile/screen-maps/lifeflow.json",
    # Tools
    "tools/pyproject.toml",
    # Product docs
    "docs/product/business-model.md",
    "docs/product/personas.md",
    "docs/product/product-audit.md",
    "docs/product/competitive-analysis.md",
    "docs/product/feature-scoring.md",
    # Design docs
    "docs/design/ds-config.md",
    "docs/design/voice-and-tone.md",
    "docs/design/UI_UX_AUDIT_2026.md",
    # Factory docs (LifeFlow-specific)
    "docs/factory/pipeline-strategy.md",
    "docs/factory/factory-pipeline.tasks.md",
    "docs/factory/certified-gate-loop.md",
    "docs/factory/certified-gate-loop-part2.md"
)

Write-Host ""
Write-Host "=== Nettoyage du template — suppression des elements LifeFlow ===" -ForegroundColor Cyan
Write-Host ""

if ($DryRun) {
    Write-Host "[MODE DRY-RUN] Rien ne sera supprime." -ForegroundColor Yellow
    Write-Host ""
}

$deletedCount = 0

# --- Supprimer les dossiers ---
Write-Host "--- Dossiers ---" -ForegroundColor Magenta
foreach ($folder in $foldersToDelete) {
    if (Test-Path $folder) {
        if ($DryRun) {
            Write-Host "  [DRY] Supprimerait : $folder/" -ForegroundColor Yellow
        } else {
            Remove-Item -Recurse -Force $folder
            Write-Host "  Supprime : $folder/" -ForegroundColor Green
        }
        $deletedCount++
    } else {
        Write-Host "  Absent   : $folder/" -ForegroundColor DarkGray
    }
}

# --- Supprimer les fichiers ---
Write-Host ""
Write-Host "--- Fichiers ---" -ForegroundColor Magenta
foreach ($file in $filesToDelete) {
    if (Test-Path $file) {
        if ($DryRun) {
            Write-Host "  [DRY] Supprimerait : $file" -ForegroundColor Yellow
        } else {
            Remove-Item -Force $file
            Write-Host "  Supprime : $file" -ForegroundColor Green
        }
        $deletedCount++
    } else {
        Write-Host "  Absent   : $file" -ForegroundColor DarkGray
    }
}

Write-Host ""
Write-Host "=== $deletedCount elements traites ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "Actions manuelles restantes :" -ForegroundColor White
Write-Host "  1. Editer flutter/lib/app/app.dart — retirer imports, routes et DI LifeFlow" -ForegroundColor White
Write-Host "  2. Editer .specify/memory/constitution.md — generaliser titre et contenu" -ForegroundColor White
Write-Host "  3. Editer docs/process/DEVELOPER_GUIDE.md — renommer le titre" -ForegroundColor White
Write-Host "  4. Editer docs/README.md — retirer les entrees supprimees" -ForegroundColor White
Write-Host "  5. Lancer : cd flutter && dart run build_runner build --delete-conflicting-outputs" -ForegroundColor White
Write-Host "  6. Verifier : flutter pub get && dart analyze --no-fatal-warnings" -ForegroundColor White
Write-Host "  7. Verifier : cd supabase && supabase db reset" -ForegroundColor White
Write-Host ""
