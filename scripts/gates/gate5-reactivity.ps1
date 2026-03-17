<#
.SYNOPSIS
    Gate 5 - Cross-Screen Reactivity: repository mutations must trigger UI refresh
    Detects: _repo.createX() / updateX() / deleteX() / archiveX() / _service.toggleX()
    Ignores: local list ops (_list.add(), _map.remove(), _frequencyDays.add())
    Checks: rebuildUi, notifyListeners, notifyChanged, EventService, _loadX() reload
    setBusy is NOT a notify pattern (it's state management, not cross-screen reactivity)
#>

function Invoke-Gate5 {
    param(
        [string]$Scope = "all",
        [System.IO.FileInfo[]]$ScopeFiles = @()
    )

    $checkAll = ($Scope -eq "all" -or $Scope -eq "phase") -and ($ScopeFiles.Count -eq 0)

    $vmFiles = if ($checkAll) {
        @(Get-FlutterFiles -Pattern "*_viewmodel.dart")
    }
    else {
        @($ScopeFiles | Where-Object { $_.Name -match "_viewmodel\.dart$" })
    }

    if ($vmFiles.Count -eq 0) {
        Add-GateResult -GateNum 5 -Rule "reactivity-check" -Status "SKIP" -Message "No viewmodel files in scope"
        Write-RuleResult -Rule "reactivity-check" -Status "SKIP" -Message "No viewmodel files found"
        return
    }

    # Real repository/service mutation patterns (method calls on injected deps)
    # Must be preceded by _ (private field) to distinguish from local list ops
    $repoMutationRegex = "(?:_\w+(?:Repo(?:sitory)?|Service))\.\s*(?:create|insert|update|save|delete|remove|archive|unarchive|toggle|log|mark|clear|reorder)\w*\s*\("

    # Cross-screen notification patterns (NOT setBusy - that's state management)
    $notifyPatterns = @(
        "rebuildUi",
        "notifyListeners",
        "notifySourceChanged",
        "notifyChanged",
        "notifyChildrensChanged",
        "EventService",
        "EventBus",
        "notifyHabitChanged",
        "notifyDomainChanged"
    )
    # Also: calling a _loadX() method after mutation = full reload pattern
    $reloadPattern = "await\s+_load\w+\("

    foreach ($f in $vmFiles) {
        $rel = Get-RelativePath $f.FullName
        $content = Get-Content $f.FullName -Raw

        # Find real repository mutations
        $mutations = [regex]::Matches($content, $repoMutationRegex)

        if ($mutations.Count -eq 0) {
            Add-GateResult -GateNum 5 -Rule "reactivity-mutations" -Status "PASS" -FilePath $rel -Message "No repository mutations (read-only)"
            Write-RuleResult -Rule "reactivity-mutations" -Status "PASS" -Message "$rel - read-only"
            continue
        }

        # Has repo mutations - check for cross-screen notification
        $hasNotify = $false
        foreach ($pat in $notifyPatterns) {
            if ($content -match [regex]::Escape($pat)) { $hasNotify = $true; break }
        }
        if (-not $hasNotify -and $content -match $reloadPattern) { $hasNotify = $true }

        if ($hasNotify) {
            Add-GateResult -GateNum 5 -Rule "reactivity-mutations" -Status "PASS" -FilePath $rel -Message "$($mutations.Count) mutations with notification"
            Write-RuleResult -Rule "reactivity-mutations" -Status "PASS" -Message "$rel - $($mutations.Count) mutations + notify"
        }
        else {
            $mutSamples = @($mutations | ForEach-Object { $_.Value.Trim() } | Select-Object -Unique -First 3) -join "; "
            Add-GateResult -GateNum 5 -Rule "reactivity-mutations" -Status "WARN" -FilePath $rel -Message "Mutations without cross-screen notify: $mutSamples"
            Write-RuleResult -Rule "reactivity-mutations" -Status "WARN" -Message "$rel - no notify after mutations"
        }

        # Per-method deep check: find async methods with repo mutation but no notify
        $methodRegex = "(?s)Future\s*<[^>]*>\s+(\w+)\s*\([^)]*\)\s*async\s*\{((?:[^{}]|\{(?:[^{}]|\{[^{}]*\})*\})*)\}"
        $methodMatches = [regex]::Matches($content, $methodRegex)
        foreach ($method in $methodMatches) {
            $methodName = $method.Groups[1].Value
            $methodBody = $method.Groups[2].Value

            $hasMutInMethod = [regex]::IsMatch($methodBody, $repoMutationRegex)
            if (-not $hasMutInMethod) { continue }

            $hasNotifyInMethod = $false
            foreach ($pat in $notifyPatterns) {
                if ($methodBody -match [regex]::Escape($pat)) { $hasNotifyInMethod = $true; break }
            }
            if (-not $hasNotifyInMethod -and $methodBody -match $reloadPattern) { $hasNotifyInMethod = $true }

            if (-not $hasNotifyInMethod) {
                Add-GateResult -GateNum 5 -Rule "reactivity-method" -Status "WARN" -FilePath $rel -Message "Method '$methodName' has repo mutation but no notify/reload"
                Write-RuleResult -Rule "reactivity-method" -Status "WARN" -Message "$rel::$methodName - mutation without notify"
            }
        }
    }
}
