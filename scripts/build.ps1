<# 
.SYNOPSIS
    LifeFlow — Build Flutter app.
.DESCRIPTION
    Builds the Flutter app for the specified platform and environment.
#>
param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("android", "ios", "web", "apk", "aab", "ipa")]
    [string]$Platform,

    [ValidateSet("development", "staging", "production")]
    [string]$Env = "development",

    [switch]$Release
)

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot

Write-Host "`n═══════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  LifeFlow — Build ($Platform / $Env)" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════`n" -ForegroundColor Cyan

Push-Location "$Root/flutter"

try {
    # Code generation
    Write-Host "⚙️  Running build_runner..." -ForegroundColor Yellow
    dart run build_runner build --delete-conflicting-outputs
    Write-Host "✅ Code generation complete" -ForegroundColor Green

    $mode = if ($Release) { "--release" } else { "--debug" }
    $dartDefines = "--dart-define=ENV=$Env"

    switch ($Platform) {
        "android" {
            Write-Host "`n📱 Building Android APK ($mode)..." -ForegroundColor Yellow
            flutter build apk $mode $dartDefines
        }
        "apk" {
            Write-Host "`n📱 Building Android APK ($mode)..." -ForegroundColor Yellow
            flutter build apk $mode $dartDefines
        }
        "aab" {
            Write-Host "`n📱 Building Android App Bundle ($mode)..." -ForegroundColor Yellow
            flutter build appbundle $mode $dartDefines
        }
        "ios" {
            Write-Host "`n🍎 Building iOS ($mode)..." -ForegroundColor Yellow
            flutter build ios $mode $dartDefines --no-codesign
        }
        "ipa" {
            Write-Host "`n🍎 Building iOS IPA ($mode)..." -ForegroundColor Yellow
            flutter build ipa $mode $dartDefines
        }
        "web" {
            Write-Host "`n🌐 Building Web ($mode)..." -ForegroundColor Yellow
            flutter build web $mode $dartDefines
        }
    }

    if ($LASTEXITCODE -eq 0) {
        Write-Host "`n✅ Build successful!" -ForegroundColor Green
    } else {
        Write-Host "`n❌ Build failed" -ForegroundColor Red
        exit 1
    }
}
finally {
    Pop-Location
}
