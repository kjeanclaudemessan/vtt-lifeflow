<# 
.SYNOPSIS
    LifeFlow — Install Git hooks.
.DESCRIPTION
    Copies custom hooks from scripts/hooks/ into .git/hooks/.
#>

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
$HooksSource = "$Root/scripts/hooks"
$HooksDest = "$Root/.git/hooks"

Write-Host "`n═══════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  LifeFlow — Install Git Hooks" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════`n" -ForegroundColor Cyan

if (-not (Test-Path $HooksDest)) {
    New-Item -ItemType Directory -Path $HooksDest -Force | Out-Null
}

$hooks = Get-ChildItem -Path $HooksSource -File

foreach ($hook in $hooks) {
    $dest = Join-Path $HooksDest $hook.Name
    Copy-Item -Path $hook.FullName -Destination $dest -Force
    Write-Host "✅ Installed: $($hook.Name)" -ForegroundColor Green
}

Write-Host "`n✅ Git hooks installed ($($hooks.Count) hooks)" -ForegroundColor Green
