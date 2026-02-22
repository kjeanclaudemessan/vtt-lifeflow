<# 
.SYNOPSIS
    LifeFlow — Reset local Supabase database.
.DESCRIPTION
    Stops Supabase, resets DB with all migrations and seeds, restarts.
#>
param(
    [switch]$Hard,
    [switch]$SeedOnly
)

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot

Write-Host "`n═══════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  LifeFlow — Database Reset" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════`n" -ForegroundColor Cyan

Push-Location "$Root/supabase"

try {
    if ($Hard) {
        Write-Host "🔄 Hard reset: stopping Supabase..." -ForegroundColor Yellow
        supabase stop --no-backup
        supabase start
        Write-Host "✅ Supabase restarted from scratch" -ForegroundColor Green
    }
    
    Write-Host "🔄 Resetting database (migrations + seeds)..." -ForegroundColor Yellow
    supabase db reset
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Database reset complete" -ForegroundColor Green
    } else {
        Write-Host "❌ Database reset failed" -ForegroundColor Red
        exit 1
    }
    
    # Show status
    Write-Host "`n📊 Supabase status:" -ForegroundColor Cyan
    supabase status
}
finally {
    Pop-Location
}

Write-Host "`n═══════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "  ✅ Database ready!" -ForegroundColor Green
Write-Host "═══════════════════════════════════════════════════`n" -ForegroundColor Green
Write-Host "  Studio:  http://localhost:54423" -ForegroundColor White
Write-Host "  API:     http://localhost:54421" -ForegroundColor White
Write-Host "  DB:      postgresql://postgres:postgres@localhost:54532/postgres" -ForegroundColor White
