<# 
.SYNOPSIS
    LifeFlow — Run all tests across all layers.
.DESCRIPTION
    Runs Flutter unit tests, integration tests, FastAPI tests, and Supabase migration tests.
#>
param(
    [switch]$Flutter,
    [switch]$FastApi,
    [switch]$Supabase,
    [switch]$Integration,
    [switch]$Coverage,
    [switch]$All
)

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
$failed = @()

# Default: run all if no flags specified
if (-not $Flutter -and -not $FastApi -and -not $Supabase -and -not $Integration) {
    $All = $true
}

Write-Host "`n═══════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  LifeFlow — Test Runner" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════`n" -ForegroundColor Cyan

# ─────────────────────────────────────────────────────────────────────
# Flutter unit tests
# ─────────────────────────────────────────────────────────────────────
if ($Flutter -or $All) {
    Write-Host "🧪 Running Flutter unit tests..." -ForegroundColor Yellow
    Push-Location "$Root/flutter"
    try {
        $coverageFlag = if ($Coverage) { "--coverage" } else { "" }
        flutter test --exclude-tags=integration $coverageFlag
        if ($LASTEXITCODE -ne 0) { $failed += "Flutter unit" }
        else { Write-Host "✅ Flutter unit tests passed" -ForegroundColor Green }
    }
    finally { Pop-Location }
}

# ─────────────────────────────────────────────────────────────────────
# Flutter integration tests (requires local Supabase)
# ─────────────────────────────────────────────────────────────────────
if ($Integration -or $All) {
    Write-Host "`n🧪 Running Flutter integration tests..." -ForegroundColor Yellow
    Push-Location "$Root/flutter"
    try {
        flutter test --tags=integration --concurrency=1
        if ($LASTEXITCODE -ne 0) { $failed += "Flutter integration" }
        else { Write-Host "✅ Flutter integration tests passed" -ForegroundColor Green }
    }
    finally { Pop-Location }
}

# ─────────────────────────────────────────────────────────────────────
# FastAPI tests
# ─────────────────────────────────────────────────────────────────────
if ($FastApi -or $All) {
    Write-Host "`n🧪 Running FastAPI tests..." -ForegroundColor Yellow
    Push-Location "$Root/fastapi"
    try {
        $coverageFlag = if ($Coverage) { "--cov=app --cov-report=html" } else { "" }
        uv run pytest $coverageFlag
        if ($LASTEXITCODE -ne 0) { $failed += "FastAPI" }
        else { Write-Host "✅ FastAPI tests passed" -ForegroundColor Green }
    }
    finally { Pop-Location }
}

# ─────────────────────────────────────────────────────────────────────
# Supabase migration tests
# ─────────────────────────────────────────────────────────────────────
if ($Supabase -or $All) {
    Write-Host "`n🧪 Testing Supabase migrations..." -ForegroundColor Yellow
    Push-Location "$Root/supabase"
    try {
        supabase db reset
        if ($LASTEXITCODE -ne 0) { $failed += "Supabase migrations" }
        else { Write-Host "✅ Supabase migrations passed" -ForegroundColor Green }
    }
    finally { Pop-Location }
}

# ─────────────────────────────────────────────────────────────────────
# Summary
# ─────────────────────────────────────────────────────────────────────
Write-Host "`n═══════════════════════════════════════════════════" -ForegroundColor Cyan
if ($failed.Count -eq 0) {
    Write-Host "  ✅ All tests passed!" -ForegroundColor Green
} else {
    Write-Host "  ❌ Failed: $($failed -join ', ')" -ForegroundColor Red
    exit 1
}
Write-Host "═══════════════════════════════════════════════════`n" -ForegroundColor Cyan
