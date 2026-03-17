<#
.SYNOPSIS
    Verify Gates - Automated quality checks for the AI App Factory.

.DESCRIPTION
    Runs quality gates against Flutter + Supabase code:
      Gate 1: Compilation (dart analyze + format + supabase db reset)
      Gate 2: Pattern Structural (entity/model/repo/view/viewmodel conventions)
      Gate 3: Architecture (layer deps, cross-feature isolation, package whitelist)
      Gate 4: Experience (sensory + personality, unique rules only)
      Gate 5: Cross-Screen Reactivity (repo mutations must trigger UI refresh)
      Gate 6: Supabase RLS (DISABLED - re-enable when RLS is mandatory)
      Gate 7: Tests (flutter test runner)

.PARAMETER Scope
    What to check: file | task | phase | all (default: all)

.PARAMETER Gate
    Which gate(s) to run: 1-7, comma-separated, or "all" (default: all)

.PARAMETER File
    Specific file to check (when Scope=file)

.PARAMETER Json
    Output results as JSON

.PARAMETER Fix
    Auto-fix what can be fixed (dart format)

.EXAMPLE
    .\verify-gates.ps1
    .\verify-gates.ps1 -Gate 1 -Scope all
    .\verify-gates.ps1 -Gate 2,3 -Scope file -File "lib/features/habits/views/habits_view.dart"
    .\verify-gates.ps1 -Gate all -Json
#>

[CmdletBinding()]
param(
    [ValidateSet("file", "task", "phase", "all")]
    [string]$Scope = "all",

    [string]$Gate = "all",

    [string]$File = "",

    [switch]$Json,

    [switch]$Fix
)

# ===================================================================
# CONFIGURATION
# ===================================================================

$ErrorActionPreference = "Stop"
$script:RepoRoot = (Resolve-Path "$PSScriptRoot/../..").Path
$script:FlutterRoot = Join-Path $script:RepoRoot "flutter"
$script:SupabaseRoot = Join-Path $script:RepoRoot "supabase"
$script:LibRoot = Join-Path $script:FlutterRoot "lib"
$script:GatesDir = $PSScriptRoot

# Results accumulator
$script:Results = @{
    timestamp  = (Get-Date -Format "yyyy-MM-ddTHH:mm:ss")
    scope      = $Scope
    gates      = @{}
    summary    = @{ total_pass = 0; total_fail = 0; total_warn = 0; total_skip = 0 }
}

# ===================================================================
# HELPERS
# ===================================================================

function Add-GateResult {
    param(
        [int]$GateNum,
        [string]$Rule,
        [ValidateSet("PASS", "FAIL", "WARN", "SKIP")]
        [string]$Status,
        [string]$Message = "",
        [string]$FilePath = "",
        [string[]]$Details = @()
    )

    $gateKey = "gate_$GateNum"
    if (-not $script:Results.gates.ContainsKey($gateKey)) {
        $script:Results.gates[$gateKey] = @{
            name    = $script:GateNames[$GateNum]
            results = [System.Collections.ArrayList]::new()
            pass    = 0; fail = 0; warn = 0; skip = 0
        }
    }

    $entry = @{
        rule    = $Rule
        status  = $Status
        message = $Message
        file    = $FilePath
        details = $Details
    }

    [void]$script:Results.gates[$gateKey].results.Add($entry)

    switch ($Status) {
        "PASS" { $script:Results.gates[$gateKey].pass++; $script:Results.summary.total_pass++ }
        "FAIL" { $script:Results.gates[$gateKey].fail++; $script:Results.summary.total_fail++ }
        "WARN" { $script:Results.gates[$gateKey].warn++; $script:Results.summary.total_warn++ }
        "SKIP" { $script:Results.gates[$gateKey].skip++; $script:Results.summary.total_skip++ }
    }
}

$script:GateNames = @{
    1 = "Compilation"
    2 = "Pattern Structural"
    3 = "Architecture"
    4 = "Experience"
    5 = "Cross-Screen Reactivity"
    6 = "Supabase RLS (disabled)"
    7 = "Tests"
}

function Write-GateHeader {
    param([int]$Num)
    $name = $script:GateNames[$Num]
    Write-Host ""
    Write-Host "==========================================================" -ForegroundColor Cyan
    Write-Host "  GATE $Num - $name" -ForegroundColor Cyan
    Write-Host "==========================================================" -ForegroundColor Cyan
}

function Write-RuleResult {
    param([string]$Rule, [string]$Status, [string]$Message = "")
    $color = switch ($Status) {
        "PASS" { "Green" }
        "FAIL" { "Red" }
        "WARN" { "Yellow" }
        "SKIP" { "DarkGray" }
    }
    $icon = switch ($Status) {
        "PASS" { "[PASS]" }
        "FAIL" { "[FAIL]" }
        "WARN" { "[WARN]" }
        "SKIP" { "[SKIP]" }
    }
    $line = "  $icon $Rule"
    if ($Message) { $line += " - $Message" }
    Write-Host $line -ForegroundColor $color
}

function Get-FlutterFiles {
    param([string]$Pattern, [string]$Directory = "")
    $searchPath = if ($Directory) { Join-Path $script:LibRoot $Directory } else { $script:LibRoot }
    if (-not (Test-Path $searchPath)) { return @() }
    Get-ChildItem -Path $searchPath -Filter $Pattern -Recurse -File -ErrorAction SilentlyContinue
}

function Get-RelativePath {
    param([string]$FullPath)
    $FullPath.Replace($script:FlutterRoot + "\", "").Replace("\", "/")
}

function Test-FileContent {
    param(
        [System.IO.FileInfo]$FileObj,
        [string]$Pattern,
        [switch]$MustExist,
        [switch]$MustNotExist
    )
    $content = Get-Content $FileObj.FullName -Raw -ErrorAction SilentlyContinue
    if (-not $content) { return $false }
    $match = $content -match $Pattern
    if ($MustExist) { return $match }
    if ($MustNotExist) { return -not $match }
    return $match
}

# ===================================================================
# GATE LOADING - Source individual gate scripts
# ===================================================================

. "$script:GatesDir\gate1-compilation.ps1"
. "$script:GatesDir\gate2-patterns.ps1"
. "$script:GatesDir\gate3-architecture.ps1"
. "$script:GatesDir\gate4-experience.ps1"
. "$script:GatesDir\gate5-reactivity.ps1"
# Gate 6 (RLS) disabled - re-enable when RLS policy enforcement is mandatory
# . "$script:GatesDir\gate6-rls.ps1"
. "$script:GatesDir\gate7-tests.ps1"

# ===================================================================
# GATE EXECUTION
# ===================================================================

# Parse gate list
# Gate 6 (RLS) excluded from "all" - re-add when RLS is mandatory
$gatesToRun = if ($Gate -eq "all") { @(1,2,3,4,5,7) } else { $Gate -split "," | ForEach-Object { [int]$_.Trim() } }

# Determine file list for scope=file
$scopeFiles = @()
if ($Scope -eq "file" -and $File) {
    $fullPath = if ([System.IO.Path]::IsPathRooted($File)) { $File } else { Join-Path $script:FlutterRoot $File }
    if (Test-Path $fullPath) {
        $scopeFiles = @(Get-Item $fullPath)
    }
    else {
        Write-Host "  [ERROR] File not found: $File" -ForegroundColor Red
        exit 1
    }
}

$now = Get-Date -Format 'HH:mm:ss'
$gateList = $gatesToRun -join ', '
Write-Host ""
Write-Host "===========================================================" -ForegroundColor White
Write-Host "           VERIFY GATES - AI App Factory                    " -ForegroundColor White
Write-Host "===========================================================" -ForegroundColor White
Write-Host "  Scope: $Scope | Gates: $gateList | $now"

foreach ($g in $gatesToRun) {
    Write-GateHeader $g
    switch ($g) {
        1 { Invoke-Gate1 -Scope $Scope -Fix:$Fix }
        2 { Invoke-Gate2 -Scope $Scope -ScopeFiles $scopeFiles }
        3 { Invoke-Gate3 -Scope $Scope -ScopeFiles $scopeFiles }
        4 { Invoke-Gate4 -Scope $Scope -ScopeFiles $scopeFiles }
        5 { Invoke-Gate5 -Scope $Scope -ScopeFiles $scopeFiles }
        # 6 { Invoke-Gate6 }  # RLS disabled
        7 { Invoke-Gate7 -Scope $Scope }
    }
}

# ===================================================================
# SUMMARY
# ===================================================================

Write-Host ""
Write-Host "==========================================================" -ForegroundColor White
Write-Host "  SUMMARY" -ForegroundColor White
Write-Host "==========================================================" -ForegroundColor White

$s = $script:Results.summary
$totalChecks = $s.total_pass + $s.total_fail + $s.total_warn + $s.total_skip
Write-Host "  Total checks : $totalChecks"
Write-Host "  PASS         : $($s.total_pass)" -ForegroundColor Green
Write-Host "  FAIL         : $($s.total_fail)" -ForegroundColor Red
Write-Host "  WARN         : $($s.total_warn)" -ForegroundColor Yellow
Write-Host "  SKIP         : $($s.total_skip)" -ForegroundColor DarkGray

foreach ($g in $gatesToRun) {
    $gateKey = "gate_$g"
    if ($script:Results.gates.ContainsKey($gateKey)) {
        $gr = $script:Results.gates[$gateKey]
        $status = if ($gr.fail -gt 0) { "FAIL" } elseif ($gr.warn -gt 0) { "WARN" } else { "PASS" }
        $color = switch ($status) { "PASS" { "Green" } "FAIL" { "Red" } "WARN" { "Yellow" } }
        Write-Host "  Gate $g ($($gr.name)): $status (P:$($gr.pass) F:$($gr.fail) W:$($gr.warn) S:$($gr.skip))" -ForegroundColor $color
    }
}

Write-Host ""

if ($s.total_fail -gt 0) {
    Write-Host "  RESULT: FAIL - $($s.total_fail) failures must be fixed." -ForegroundColor Red
}
elseif ($s.total_warn -gt 0) {
    Write-Host "  RESULT: PASS WITH WARNINGS - $($s.total_warn) warnings to review." -ForegroundColor Yellow
}
else {
    Write-Host "  RESULT: ALL PASS" -ForegroundColor Green
}

# ===================================================================
# JSON OUTPUT
# ===================================================================

if ($Json) {
    $jsonPath = Join-Path $script:RepoRoot "gate-results.json"
    # Convert nested hashtables to ordered for clean JSON
    $script:Results | ConvertTo-Json -Depth 10 | Set-Content -Path $jsonPath -Encoding UTF8
    Write-Host "  JSON written to: $jsonPath" -ForegroundColor DarkGray
}

# Exit code
if ($s.total_fail -gt 0) { exit 1 } else { exit 0 }
