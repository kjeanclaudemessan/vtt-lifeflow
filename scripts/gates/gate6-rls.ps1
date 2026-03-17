<#
.SYNOPSIS
    Gate 6 - RLS & Policy Check: every table must have RLS enabled + policies
#>

function Invoke-Gate6 {
    param(
        [string]$Scope = "all",
        [System.IO.FileInfo[]]$ScopeFiles = @()
    )

    $supabaseDir = Join-Path $PSScriptRoot "..\..\supabase\migrations"
    if (-not (Test-Path $supabaseDir)) {
        Add-GateResult -GateNum 6 -Rule "rls-migrations" -Status "SKIP" -Message "supabase/migrations/ not found"
        Write-RuleResult -Rule "rls-migrations" -Status "SKIP" -Message "No supabase/migrations/ directory"
        return
    }

    $sqlFiles = @(Get-ChildItem -Path $supabaseDir -Filter "*.sql" -File | Sort-Object Name)
    if ($sqlFiles.Count -eq 0) {
        Add-GateResult -GateNum 6 -Rule "rls-migrations" -Status "SKIP" -Message "No SQL migration files"
        Write-RuleResult -Rule "rls-migrations" -Status "SKIP" -Message "No migration files found"
        return
    }

    # Merge all SQL into one blob to resolve cross-file references
    $allSql = ""
    foreach ($f in $sqlFiles) {
        $allSql += "`n-- FILE: $($f.Name)`n"
        $allSql += (Get-Content $f.FullName -Raw)
    }

    # Extract all CREATE TABLE statements (public schema)
    $tableMatches = [regex]::Matches($allSql, "CREATE\s+TABLE\s+(?:IF\s+NOT\s+EXISTS\s+)?(?:public\.)?(\w+)", [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tables = @()
    foreach ($m in $tableMatches) {
        $tableName = $m.Groups[1].Value
        # Skip internal/system tables
        if ($tableName -notin @("schema_migrations", "_prisma_migrations")) {
            $tables += $tableName
        }
    }
    $tables = $tables | Select-Object -Unique

    if ($tables.Count -eq 0) {
        Add-GateResult -GateNum 6 -Rule "rls-tables" -Status "SKIP" -Message "No tables found in migrations"
        Write-RuleResult -Rule "rls-tables" -Status "SKIP" -Message "No tables found"
        return
    }

    # Check RLS enabled for each table
    $rlsEnabledPattern = "ALTER\s+TABLE\s+(?:public\.)?{TABLE}\s+ENABLE\s+ROW\s+LEVEL\s+SECURITY"
    $policyPattern = "CREATE\s+POLICY\s+.+?\s+ON\s+(?:public\.)?{TABLE}\s+"

    $rlsEnabled = @{}
    $policies = @{}

    foreach ($table in $tables) {
        $rlsRegex = $rlsEnabledPattern -replace "\{TABLE\}", [regex]::Escape($table)
        $rlsEnabled[$table] = $allSql -match $rlsRegex

        $polRegex = $policyPattern -replace "\{TABLE\}", [regex]::Escape($table)
        $polMatches = [regex]::Matches($allSql, $polRegex, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
        $policies[$table] = $polMatches.Count
    }

    # ── Rule: rls-enabled ────────────────────────────────────
    foreach ($table in $tables) {
        if ($rlsEnabled[$table]) {
            Add-GateResult -GateNum 6 -Rule "rls-enabled" -Status "PASS" -Message "RLS enabled on '$table'"
            Write-RuleResult -Rule "rls-enabled" -Status "PASS" -Message "Table '$table' - RLS enabled"
        }
        else {
            Add-GateResult -GateNum 6 -Rule "rls-enabled" -Status "FAIL" -Message "RLS NOT enabled on '$table'"
            Write-RuleResult -Rule "rls-enabled" -Status "FAIL" -Message "Table '$table' - MISSING RLS!"
        }
    }

    # ── Rule: rls-policies ───────────────────────────────────
    foreach ($table in $tables) {
        if (-not $rlsEnabled[$table]) { continue }

        if ($policies[$table] -gt 0) {
            Add-GateResult -GateNum 6 -Rule "rls-policies" -Status "PASS" -Message "'$table' has $($policies[$table]) policies"
            Write-RuleResult -Rule "rls-policies" -Status "PASS" -Message "Table '$table' - $($policies[$table]) policies"
        }
        else {
            Add-GateResult -GateNum 6 -Rule "rls-policies" -Status "WARN" -Message "RLS enabled on '$table' but NO policies defined (locked out!)"
            Write-RuleResult -Rule "rls-policies" -Status "WARN" -Message "Table '$table' - RLS enabled, 0 policies (fully locked)"
        }
    }

    # ── Rule: rls-crud-coverage ──────────────────────────────
    $crudOps = @("SELECT", "INSERT", "UPDATE", "DELETE")
    foreach ($table in $tables) {
        if (-not $rlsEnabled[$table]) { continue }
        if ($policies[$table] -eq 0) { continue }

        $missing = @()
        foreach ($op in $crudOps) {
            $opRegex = "CREATE\s+POLICY\s+.+?\s+ON\s+(?:public\.)?$([regex]::Escape($table))\s+FOR\s+$op"
            if ($allSql -notmatch $opRegex) {
                $missing += $op
            }
        }

        if ($missing.Count -eq 0) {
            Add-GateResult -GateNum 6 -Rule "rls-crud-coverage" -Status "PASS" -Message "'$table' has full CRUD policy coverage"
            Write-RuleResult -Rule "rls-crud-coverage" -Status "PASS" -Message "Table '$table' - full CRUD coverage"
        }
        else {
            Add-GateResult -GateNum 6 -Rule "rls-crud-coverage" -Status "WARN" -Message "'$table' missing policies for: $($missing -join ', ')"
            Write-RuleResult -Rule "rls-crud-coverage" -Status "WARN" -Message "Table '$table' - missing: $($missing -join ', ')"
        }
    }
}
