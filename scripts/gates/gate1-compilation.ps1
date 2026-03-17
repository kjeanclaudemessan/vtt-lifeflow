<#
.SYNOPSIS
    Gate 1 - Compilation: dart analyze + dart format + supabase db reset
#>

function Invoke-Gate1 {
    param(
        [string]$Scope = "all",
        [switch]$Fix
    )

    # ─── dart analyze ───────────────────────────────────────────
    $rule = "dart-analyze"
    try {
        Push-Location $script:FlutterRoot
        $output = & dart analyze --no-fatal-infos 2>&1 | Out-String
        Pop-Location

        if ($LASTEXITCODE -eq 0 -and $output -notmatch "error|warning") {
            Add-GateResult -GateNum 1 -Rule $rule -Status "PASS" -Message "No issues"
            Write-RuleResult -Rule $rule -Status "PASS"
        }
        elseif ($output -match "(\d+) issue") {
            $issueLines = ($output -split "`n") | Where-Object { $_ -match "(error|warning|info)\s*[-•]" -or $_ -match "^\s{2,}\w" }
            $details = @($issueLines | Select-Object -First 20)
            Add-GateResult -GateNum 1 -Rule $rule -Status "FAIL" -Message "Issues found" -Details $details
            Write-RuleResult -Rule $rule -Status "FAIL" -Message "$($details.Count) issues (see details)"
            foreach ($d in $details | Select-Object -First 10) {
                Write-Host "    $d" -ForegroundColor DarkRed
            }
        }
        else {
            Add-GateResult -GateNum 1 -Rule $rule -Status "PASS" -Message "Clean"
            Write-RuleResult -Rule $rule -Status "PASS"
        }
    }
    catch {
        Add-GateResult -GateNum 1 -Rule $rule -Status "FAIL" -Message "dart analyze failed: $($_.Exception.Message)"
        Write-RuleResult -Rule $rule -Status "FAIL" -Message $_.Exception.Message
    }

    # ─── dart format ────────────────────────────────────────────
    $rule = "dart-format"
    try {
        Push-Location $script:FlutterRoot

        if ($Fix) {
            & dart format lib/ 2>&1 | Out-Null
            Add-GateResult -GateNum 1 -Rule $rule -Status "PASS" -Message "Auto-formatted"
            Write-RuleResult -Rule $rule -Status "PASS" -Message "Auto-formatted with -Fix"
        }
        else {
            $output = & dart format --set-exit-if-changed --output=none lib/ 2>&1 | Out-String
            if ($LASTEXITCODE -eq 0) {
                Add-GateResult -GateNum 1 -Rule $rule -Status "PASS" -Message "All files formatted"
                Write-RuleResult -Rule $rule -Status "PASS"
            }
            else {
                $unformatted = ($output -split "`n") | Where-Object { $_ -match "Changed\s" -or ($_ -match "\.dart$" -and $_ -notmatch "^Formatted") }
                $details = @($unformatted | Select-Object -First 20)
                Add-GateResult -GateNum 1 -Rule $rule -Status "FAIL" -Message "Unformatted files found" -Details $details
                Write-RuleResult -Rule $rule -Status "FAIL" -Message "$($details.Count) files need formatting"
                foreach ($d in $details | Select-Object -First 5) {
                    Write-Host "    $d" -ForegroundColor DarkRed
                }
            }
        }
        Pop-Location
    }
    catch {
        Add-GateResult -GateNum 1 -Rule $rule -Status "FAIL" -Message "dart format failed: $($_.Exception.Message)"
        Write-RuleResult -Rule $rule -Status "FAIL" -Message $_.Exception.Message
    }

    # ─── supabase db reset ──────────────────────────────────────
    $rule = "supabase-db-reset"

    # Only run if scope touches SQL or is 'all'
    $shouldRunDb = ($Scope -eq "all") -or ($Scope -eq "phase")
    if (-not $shouldRunDb) {
        Add-GateResult -GateNum 1 -Rule $rule -Status "SKIP" -Message "Skipped (scope=$Scope)"
        Write-RuleResult -Rule $rule -Status "SKIP" -Message "Scope doesn't include SQL"
        return
    }

    try {
        Push-Location $script:SupabaseRoot
        # Check if supabase is running
        $statusOutput = & supabase status 2>&1 | Out-String
        if ($statusOutput -match "not running" -or $LASTEXITCODE -ne 0) {
            Add-GateResult -GateNum 1 -Rule $rule -Status "SKIP" -Message "Supabase not running locally"
            Write-RuleResult -Rule $rule -Status "SKIP" -Message "Supabase not running - start with 'supabase start'"
            Pop-Location
            return
        }

        $output = & supabase db reset 2>&1 | Out-String
        Pop-Location

        if ($LASTEXITCODE -eq 0) {
            Add-GateResult -GateNum 1 -Rule $rule -Status "PASS" -Message "DB reset successful"
            Write-RuleResult -Rule $rule -Status "PASS"
        }
        else {
            $errorLines = ($output -split "`n") | Where-Object { $_ -match "error|ERROR|FATAL" }
            $details = @($errorLines | Select-Object -First 10)
            Add-GateResult -GateNum 1 -Rule $rule -Status "FAIL" -Message "DB reset failed" -Details $details
            Write-RuleResult -Rule $rule -Status "FAIL" -Message "Migration errors"
            foreach ($d in $details | Select-Object -First 5) {
                Write-Host "    $d" -ForegroundColor DarkRed
            }
        }
    }
    catch {
        Pop-Location -ErrorAction SilentlyContinue
        Add-GateResult -GateNum 1 -Rule $rule -Status "FAIL" -Message "supabase db reset failed: $($_.Exception.Message)"
        Write-RuleResult -Rule $rule -Status "FAIL" -Message $_.Exception.Message
    }
}
