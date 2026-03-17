<#
.SYNOPSIS
    Post-task gate runner with retry loop.
    Runs verify-gates.ps1 after a task, parses JSON results, generates
    a targeted correction prompt if FAIL, and retries up to N times.

.PARAMETER TaskId
    Task identifier (e.g., "T005"). Used for logging only.

.PARAMETER Files
    Comma-separated list of files modified in the task (relative to flutter/).
    If omitted, runs with -Scope all.

.PARAMETER MaxRetries
    Maximum correction iterations (default: 3).

.PARAMETER Gate
    Which gate(s) to run (default: "all"). Same format as verify-gates.ps1.

.EXAMPLE
    .\run-post-task.ps1 -TaskId T005
    .\run-post-task.ps1 -TaskId T005 -Files "lib/features/habits/views/habits_view.dart" -MaxRetries 2
    .\run-post-task.ps1 -TaskId T005 -Gate "2,3,4"
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$TaskId,

    [string]$Files = "",

    [int]$MaxRetries = 3,

    [string]$Gate = "all"
)

$ErrorActionPreference = "Stop"
$scriptDir = $PSScriptRoot
$repoRoot = (Resolve-Path "$scriptDir/../..").Path
$verifyScript = Join-Path $scriptDir "verify-gates.ps1"
$jsonPath = Join-Path $repoRoot "gate-results.json"

# Build base arguments
$baseArgs = @("-Gate", $Gate, "-Json")
if ($Files) {
    $fileList = $Files -split "," | ForEach-Object { $_.Trim() }
    # Run per-file scope for each
    $baseArgs += @("-Scope", "file")
}
else {
    $baseArgs += @("-Scope", "all")
}

function Format-GateReport {
    param([PSCustomObject]$Results)

    $summary = $Results.summary
    $output = @()
    $output += ""
    $output += "--- Post-Task Gate Report: $TaskId ---"
    $output += "PASS: $($summary.total_pass) | FAIL: $($summary.total_fail) | WARN: $($summary.total_warn) | SKIP: $($summary.total_skip)"
    $output += ""

    foreach ($prop in $Results.gates.PSObject.Properties) {
        $gate = $prop.Value
        $gateStatus = if ($gate.fail -gt 0) { "FAIL" } elseif ($gate.warn -gt 0) { "WARN" } else { "PASS" }
        $output += "  $($prop.Name) ($($gate.name)): $gateStatus"

        # Show only failures and warnings
        foreach ($r in $gate.results) {
            if ($r.status -eq "FAIL" -or $r.status -eq "WARN") {
                $filePart = if ($r.file) { " [$($r.file)]" } else { "" }
                $output += "    [$($r.status)] $($r.rule)$filePart - $($r.message)"
            }
        }
    }
    $output += ""
    return $output -join "`n"
}

function Build-CorrectionPrompt {
    param([PSCustomObject]$Results)

    $failures = @()
    foreach ($prop in $Results.gates.PSObject.Properties) {
        $gate = $prop.Value
        foreach ($r in $gate.results) {
            if ($r.status -eq "FAIL") {
                $failures += "- Gate '$($gate.name)' rule '$($r.rule)' FAIL on file '$($r.file)': $($r.message)"
            }
        }
    }

    if ($failures.Count -eq 0) { return $null }

    $prompt = @()
    $prompt += "## Gate Correction Needed ($TaskId)"
    $prompt += ""
    $prompt += "The following gate checks failed after task implementation:"
    $prompt += ""
    $prompt += $failures
    $prompt += ""
    $prompt += "Please fix each failure. Do NOT change gate scripts — fix the source code."
    return $prompt -join "`n"
}

# Main loop
$attempt = 0
$passed = $false

while ($attempt -le $MaxRetries -and -not $passed) {
    $attempt++
    Write-Host ""
    Write-Host "====== $TaskId - Gate Check (attempt $attempt/$($MaxRetries + 1)) ======" -ForegroundColor Cyan

    # Run gate verification
    if ($Files) {
        # Run once per file
        foreach ($file in $fileList) {
            & $verifyScript -Gate $Gate -Scope file -File $file -Json | Out-Null
        }
    }
    else {
        & $verifyScript @baseArgs | Out-Null
    }

    # Parse JSON results
    if (-not (Test-Path $jsonPath)) {
        Write-Host "  [ERROR] gate-results.json not found" -ForegroundColor Red
        exit 1
    }

    $results = Get-Content $jsonPath -Raw | ConvertFrom-Json
    $report = Format-GateReport $results
    Write-Host $report

    if ($results.summary.total_fail -eq 0) {
        $passed = $true
        Write-Host "  ALL GATES PASSED for $TaskId" -ForegroundColor Green
    }
    else {
        if ($attempt -le $MaxRetries) {
            $correction = Build-CorrectionPrompt $results
            Write-Host ""
            Write-Host "--- Correction Prompt (copy to agent) ---" -ForegroundColor Yellow
            Write-Host $correction
            Write-Host "--- End Correction Prompt ---" -ForegroundColor Yellow
            Write-Host ""
            Write-Host "  Waiting for corrections before retry..." -ForegroundColor Yellow
            Write-Host "  Press Enter when corrections are applied, or Ctrl+C to abort."
            Read-Host
        }
        else {
            Write-Host "  MAX RETRIES REACHED ($MaxRetries) - $($results.summary.total_fail) failures remain" -ForegroundColor Red
            exit 1
        }
    }
}

# Cleanup
if (Test-Path $jsonPath) { Remove-Item $jsonPath -Force }
exit 0
