#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Clone le template VTT vers un nouveau dossier en excluant tous les fichiers gitignored.

.DESCRIPTION
    Utilise `git ls-files` pour lister uniquement les fichiers trackés (respecte TOUS les .gitignore),
    puis les copie vers la destination. Fonctionne sans dépôt distant.

.PARAMETER Destination
    Chemin du dossier de destination (ex: F:\programmation\vtt\lifeflow)

.PARAMETER ProjectName
    Nom du projet (ex: lifeflow). Utilisé pour nommer le dossier si Destination est un parent.

.PARAMETER IncludeUntracked
    Inclut aussi les fichiers non-trackés mais non-ignorés (nouveaux fichiers pas encore git add).

.EXAMPLE
    .\clone_template.ps1 -Destination "F:\programmation\vtt\lifeflow"
    .\clone_template.ps1 -Destination "F:\programmation\vtt" -ProjectName "lifeflow"
    .\clone_template.ps1 -Destination "F:\programmation\vtt\lifeflow" -IncludeUntracked
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$Destination,

    [string]$ProjectName,

    [switch]$IncludeUntracked,

    [switch]$DryRun
)

# ══════════════════════════════════════════════════════════════════════════════
# Configuration
# ══════════════════════════════════════════════════════════════════════════════

$ErrorActionPreference = "Stop"
$SourceRoot = $PSScriptRoot  # Le dossier où se trouve ce script = racine du template

# Si ProjectName est fourni et Destination est un dossier parent, on ajoute le nom
if ($ProjectName -and (Test-Path $Destination -PathType Container)) {
    $Destination = Join-Path $Destination $ProjectName
}

# ══════════════════════════════════════════════════════════════════════════════
# Validation
# ══════════════════════════════════════════════════════════════════════════════

Write-Host ""
Write-Host "╔══════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║           VTT Template — Clone Script                      ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Vérifier que git est disponible
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "❌ git n'est pas installé ou pas dans le PATH." -ForegroundColor Red
    exit 1
}

# Vérifier qu'on est dans un repo git
Push-Location $SourceRoot
try {
    $gitCheck = git rev-parse --is-inside-work-tree 2>&1
    if ($gitCheck -ne "true") {
        Write-Host "❌ $SourceRoot n'est pas un dépôt git." -ForegroundColor Red
        Write-Host "   Initialisez avec: git init && git add -A && git commit -m 'init'" -ForegroundColor Yellow
        exit 1
    }
} catch {
    Write-Host "❌ $SourceRoot n'est pas un dépôt git." -ForegroundColor Red
    exit 1
}

# Vérifier que la destination n'existe pas déjà (ou est vide)
if (Test-Path $Destination) {
    $existingItems = Get-ChildItem $Destination -Force
    if ($existingItems.Count -gt 0) {
        Write-Host "⚠️  Le dossier destination existe et n'est pas vide:" -ForegroundColor Yellow
        Write-Host "   $Destination" -ForegroundColor Yellow
        Write-Host ""
        $confirm = Read-Host "   Continuer et écraser ? (o/N)"
        if ($confirm -notin @("o", "O", "oui", "y", "yes")) {
            Write-Host "❌ Annulé." -ForegroundColor Red
            Pop-Location
            exit 0
        }
    }
}

# ══════════════════════════════════════════════════════════════════════════════
# Collecter la liste des fichiers
# ══════════════════════════════════════════════════════════════════════════════

Write-Host "📂 Source    : $SourceRoot" -ForegroundColor White
Write-Host "📂 Destination: $Destination" -ForegroundColor White
Write-Host ""

# git ls-files : liste tous les fichiers trackés (respecte .gitignore)
Write-Host "🔍 Lecture des fichiers trackés (respecte tous les .gitignore)..." -ForegroundColor Gray

$trackedFiles = git ls-files --cached | Where-Object { $_ -ne "" }

if ($IncludeUntracked) {
    # Ajoute aussi les fichiers non-trackés mais non-ignorés (nouveaux fichiers)
    Write-Host "🔍 Inclusion des fichiers non-trackés non-ignorés..." -ForegroundColor Gray
    $untrackedFiles = git ls-files --others --exclude-standard | Where-Object { $_ -ne "" }
    $allFiles = @($trackedFiles) + @($untrackedFiles) | Select-Object -Unique
} else {
    $allFiles = $trackedFiles
}

# Exclure le script lui-même et les fichiers de config template
$excludePatterns = @(
    "clone_template.ps1"
    # Ajouter d'autres exclusions spécifiques ici si nécessaire
)

$filesToCopy = $allFiles | Where-Object {
    $file = $_
    $exclude = $false
    foreach ($pattern in $excludePatterns) {
        if ($file -like $pattern) {
            $exclude = $true
            break
        }
    }
    -not $exclude
}

$totalFiles = ($filesToCopy | Measure-Object).Count

if ($totalFiles -eq 0) {
    Write-Host "❌ Aucun fichier à copier. Vérifiez que le dépôt a des fichiers committés." -ForegroundColor Red
    Pop-Location
    exit 1
}

# ══════════════════════════════════════════════════════════════════════════════
# Résumé par sous-projet
# ══════════════════════════════════════════════════════════════════════════════

$flutterCount = ($filesToCopy | Where-Object { $_ -like "vtt_flutter_template/*" -or $_ -like "flutter/*" }).Count
$fastapiCount = ($filesToCopy | Where-Object { $_ -like "vtt_fastapi_template/*" -or $_ -like "fastapi/*" }).Count
$supabaseCount = ($filesToCopy | Where-Object { $_ -like "supabase/*" }).Count
$rootCount = $totalFiles - $flutterCount - $fastapiCount - $supabaseCount

Write-Host ""
Write-Host "📊 Résumé des fichiers à copier:" -ForegroundColor Cyan
Write-Host "   ├─ Flutter   : $flutterCount fichiers" -ForegroundColor White
Write-Host "   ├─ FastAPI   : $fastapiCount fichiers" -ForegroundColor White
Write-Host "   ├─ Supabase  : $supabaseCount fichiers" -ForegroundColor White
Write-Host "   ├─ Racine    : $rootCount fichiers" -ForegroundColor White
Write-Host "   └─ Total     : $totalFiles fichiers" -ForegroundColor Green
Write-Host ""

# ══════════════════════════════════════════════════════════════════════════════
# Liste les .gitignore détectés
# ══════════════════════════════════════════════════════════════════════════════

$gitignoreFiles = git ls-files --cached | Where-Object { $_ -like "*.gitignore" }
Write-Host "🛡️  .gitignore respectés:" -ForegroundColor Cyan
foreach ($gi in $gitignoreFiles) {
    Write-Host "   ├─ $gi" -ForegroundColor Gray
}
Write-Host ""

# ══════════════════════════════════════════════════════════════════════════════
# Dry Run
# ══════════════════════════════════════════════════════════════════════════════

if ($DryRun) {
    Write-Host "🏃 DRY RUN — Aucun fichier copié. Voici ce qui serait copié:" -ForegroundColor Yellow
    Write-Host ""
    foreach ($file in $filesToCopy) {
        Write-Host "   $file" -ForegroundColor Gray
    }
    Write-Host ""
    Write-Host "✅ Dry run terminé. Relancez sans -DryRun pour copier." -ForegroundColor Green
    Pop-Location
    exit 0
}

# ══════════════════════════════════════════════════════════════════════════════
# Copie
# ══════════════════════════════════════════════════════════════════════════════

Write-Host "📋 Copie en cours..." -ForegroundColor Cyan

$copied = 0
$errors = 0
$progressInterval = [Math]::Max(1, [Math]::Floor($totalFiles / 20))

foreach ($relativePath in $filesToCopy) {
    $sourcePath = Join-Path $SourceRoot $relativePath
    $destPath = Join-Path $Destination $relativePath

    # Créer le dossier parent si nécessaire
    $destDir = Split-Path $destPath -Parent
    if (-not (Test-Path $destDir)) {
        New-Item -ItemType Directory -Path $destDir -Force | Out-Null
    }

    try {
        Copy-Item -Path $sourcePath -Destination $destPath -Force
        $copied++

        # Afficher la progression tous les N fichiers
        if ($copied % $progressInterval -eq 0) {
            $pct = [Math]::Round(($copied / $totalFiles) * 100)
            Write-Host "   [$pct%] $copied / $totalFiles fichiers copiés..." -ForegroundColor Gray
        }
    } catch {
        Write-Host "   ⚠️  Erreur copie: $relativePath — $_" -ForegroundColor Yellow
        $errors++
    }
}

# ══════════════════════════════════════════════════════════════════════════════
# Résultat
# ══════════════════════════════════════════════════════════════════════════════

Write-Host ""
Write-Host "══════════════════════════════════════════════════════════════" -ForegroundColor Cyan

if ($errors -eq 0) {
    Write-Host "✅ Clone terminé avec succès !" -ForegroundColor Green
} else {
    Write-Host "⚠️  Clone terminé avec $errors erreur(s)." -ForegroundColor Yellow
}

Write-Host "   📂 $copied fichiers copiés vers:" -ForegroundColor White
Write-Host "   $Destination" -ForegroundColor White
Write-Host ""

# ══════════════════════════════════════════════════════════════════════════════
# Prochaines étapes
# ══════════════════════════════════════════════════════════════════════════════

Write-Host "📋 Prochaines étapes:" -ForegroundColor Cyan
Write-Host "   1. cd $Destination" -ForegroundColor White
Write-Host '   2. Éditer vtt.yaml (name, bundle_id, preset)' -ForegroundColor White
Write-Host '   3. .\init.ps1          # Renomme + supprime modules désactivés' -ForegroundColor White
Write-Host '   4. git init && git add -A && git commit -m "init: lifeflow from vtt_template"' -ForegroundColor White
Write-Host ""

Pop-Location
