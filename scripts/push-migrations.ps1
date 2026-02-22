<#
.SYNOPSIS
    Push Supabase migrations to a remote database (staging or production).

.DESCRIPTION
    Uses `supabase db push --db-url` to apply local migrations to a remote
    Supabase/Postgres instance hosted on Coolify VPS.

    Prerequisites:
    - Supabase CLI installed (supabase --version)
    - PostgreSQL port exposed on Coolify for the target environment
    - Correct DB password in this script or .env file

.PARAMETER Environment
    Target environment: staging (default) or production.

.PARAMETER DryRun
    Show what would be executed without applying changes.

.EXAMPLE
    .\scripts\push-migrations.ps1
    .\scripts\push-migrations.ps1 -Environment production
    .\scripts\push-migrations.ps1 -DryRun
#>

param(
    [ValidateSet("staging", "production")]
    [string]$Environment = "staging",

    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

# ── Configuration ──────────────────────────────────────────────────────
# VPS IP address (Coolify)
$VPS_IP = "144.91.67.237"

# Database credentials per environment
# IMPORTANT: The Postgres port MUST be exposed on Coolify (see docs/DEPLOYMENT_GUIDE.md)
$Config = @{
    staging = @{
        Host     = $VPS_IP
        Port     = 5433          # Mapped externally on Coolify (internal: 5432)
        Database = "postgres"
        User     = "postgres"
        Password = "U8UzFre2hUTE6RicnEmRqe0U9g8KHIjR"
    }
    production = @{
        Host     = $VPS_IP
        Port     = 5434          # Mapped externally on Coolify (internal: 5432)
        Database = "postgres"
        User     = "postgres"
        Password = ""            # TODO: Set production password when ready
    }
}

# ── Preflight checks ──────────────────────────────────────────────────
Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  LifeFlow — Push Migrations to $($Environment.ToUpper())" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# Check Supabase CLI
if (-not (Get-Command "supabase" -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: Supabase CLI not found. Install it:" -ForegroundColor Red
    Write-Host "  scoop install supabase" -ForegroundColor Yellow
    exit 1
}

$env_config = $Config[$Environment]

if ([string]::IsNullOrEmpty($env_config.Password)) {
    Write-Host "ERROR: No database password configured for '$Environment'." -ForegroundColor Red
    Write-Host "  Edit this script and set the password in the `$Config.$Environment section." -ForegroundColor Yellow
    exit 1
}

# Build the connection string
# Note: sslmode=disable because Coolify Postgres doesn't have TLS configured by default
$DB_URL = "postgresql://$($env_config.User):$($env_config.Password)@$($env_config.Host):$($env_config.Port)/$($env_config.Database)?sslmode=disable"

# ── Show plan ──────────────────────────────────────────────────────────
Write-Host "  Target:   $($env_config.Host):$($env_config.Port)/$($env_config.Database)" -ForegroundColor White
Write-Host "  User:     $($env_config.User)" -ForegroundColor White
Write-Host ""

# Ensure we're in the project root (where supabase/ dir lives)
$ProjectRoot = Split-Path -Parent $PSScriptRoot
Push-Location $ProjectRoot

try {
    # List pending migrations
    Write-Host "Checking migration status..." -ForegroundColor Gray
    Write-Host ""

    if ($DryRun) {
        Write-Host "[DRY RUN] Would execute:" -ForegroundColor Yellow
        Write-Host "  supabase db push --db-url `"postgresql://$($env_config.User):****@$($env_config.Host):$($env_config.Port)/$($env_config.Database)?sslmode=disable`"" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "Listing local migrations:" -ForegroundColor Gray

        $migrations = Get-ChildItem -Path "supabase/migrations" -Filter "*.sql" | Sort-Object Name
        foreach ($m in $migrations) {
            Write-Host "  $($m.Name)" -ForegroundColor DarkGray
        }
        Write-Host ""
        Write-Host "$($migrations.Count) migration(s) found locally." -ForegroundColor White
    }
    else {
        # Confirmation prompt
        if ($Environment -eq "production") {
            Write-Host "⚠  WARNING: You are about to push migrations to PRODUCTION!" -ForegroundColor Red
            $confirm = Read-Host "Type 'yes' to confirm"
            if ($confirm -ne "yes") {
                Write-Host "Aborted." -ForegroundColor Yellow
                exit 0
            }
        }
        else {
            Write-Host "Pushing migrations to staging..." -ForegroundColor White
        }

        Write-Host ""

        # Execute the push
        # PGSSLMODE=disable to skip TLS (Coolify Postgres doesn't have TLS by default)
        $env:PGSSLMODE = "disable"
        supabase db push --db-url $DB_URL
        Remove-Item env:PGSSLMODE

        if ($LASTEXITCODE -eq 0) {
            Write-Host ""
            Write-Host "Migrations pushed successfully to $($Environment.ToUpper())!" -ForegroundColor Green
        }
        else {
            Write-Host ""
            Write-Host "ERROR: Migration push failed (exit code: $LASTEXITCODE)" -ForegroundColor Red
            Write-Host "Check the output above for details." -ForegroundColor Yellow
            exit $LASTEXITCODE
        }
    }
}
finally {
    Pop-Location
}

Write-Host ""
