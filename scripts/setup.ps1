<# 
.SYNOPSIS
    LifeFlow — Full project setup script.
.DESCRIPTION
    Installs all dependencies for Flutter, FastAPI, and Supabase.
    Run once after cloning the repo.
#>
param(
    [switch]$SkipFlutter,
    [switch]$SkipFastApi,
    [switch]$SkipSupabase
)

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot

Write-Host "`n═══════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  LifeFlow — Project Setup" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════`n" -ForegroundColor Cyan

# ─────────────────────────────────────────────────────────────────────
# Prerequisites check
# ─────────────────────────────────────────────────────────────────────
function Test-Command($cmd) {
    return [bool](Get-Command $cmd -ErrorAction SilentlyContinue)
}

$missing = @()
if (-not (Test-Command "flutter"))   { $missing += "Flutter" }
if (-not (Test-Command "dart"))      { $missing += "Dart" }
if (-not (Test-Command "uv"))       { $missing += "uv (astral.sh/uv)" }
if (-not (Test-Command "supabase"))  { $missing += "Supabase CLI" }
if (-not (Test-Command "git"))       { $missing += "Git" }

if ($missing.Count -gt 0) {
    Write-Host "❌ Missing prerequisites: $($missing -join ', ')" -ForegroundColor Red
    Write-Host "Please install them before running this script." -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ All prerequisites found" -ForegroundColor Green

# ─────────────────────────────────────────────────────────────────────
# Supabase
# ─────────────────────────────────────────────────────────────────────
if (-not $SkipSupabase) {
    Write-Host "`n📦 Setting up Supabase..." -ForegroundColor Yellow
    Push-Location "$Root/supabase"
    
    try {
        supabase start
        Write-Host "✅ Supabase local started" -ForegroundColor Green
        
        supabase db reset
        Write-Host "✅ Database reset with migrations + seeds" -ForegroundColor Green
    }
    finally {
        Pop-Location
    }
}

# ─────────────────────────────────────────────────────────────────────
# Flutter
# ─────────────────────────────────────────────────────────────────────
if (-not $SkipFlutter) {
    Write-Host "`n📦 Setting up Flutter..." -ForegroundColor Yellow
    Push-Location "$Root/flutter"
    
    try {
        flutter pub get
        Write-Host "✅ Flutter dependencies installed" -ForegroundColor Green
        
        dart run build_runner build --delete-conflicting-outputs
        Write-Host "✅ Code generation complete" -ForegroundColor Green
    }
    finally {
        Pop-Location
    }
}

# ─────────────────────────────────────────────────────────────────────
# FastAPI
# ─────────────────────────────────────────────────────────────────────
if (-not $SkipFastApi) {
    Write-Host "`n📦 Setting up FastAPI..." -ForegroundColor Yellow
    Push-Location "$Root/fastapi"
    
    try {
        uv sync
        Write-Host "✅ FastAPI dependencies installed (uv sync)" -ForegroundColor Green
    }
    finally {
        Pop-Location
    }
}

# ─────────────────────────────────────────────────────────────────────
# .env file check
# ─────────────────────────────────────────────────────────────────────
if (-not (Test-Path "$Root/.env") -and (Test-Path "$Root/.env.example")) {
    Copy-Item "$Root/.env.example" "$Root/.env"
    Write-Host "`n⚠️  Created .env from .env.example — please fill in your values" -ForegroundColor Yellow
}

Write-Host "`n═══════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "  ✅ Setup complete!" -ForegroundColor Green
Write-Host "═══════════════════════════════════════════════════`n" -ForegroundColor Green
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Edit .env with your Supabase credentials" -ForegroundColor White
Write-Host "  2. cd flutter && flutter run" -ForegroundColor White
Write-Host "  3. cd fastapi && uvicorn app.main:app --reload" -ForegroundColor White
