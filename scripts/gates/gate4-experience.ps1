<#
.SYNOPSIS
    Gate 4 - Experience Check: sensory + personality (unique rules, no overlap with Gate 2)
    Gate 2 already covers: state machine (isBusy/hasError), i18n (Text hardcoded), typography
    Gate 4 focuses on: empty states for lists, animations, haptic, skeleton loading, tone
#>

function Invoke-Gate4 {
    param(
        [string]$Scope = "all",
        [System.IO.FileInfo[]]$ScopeFiles = @()
    )

    $checkAll = ($Scope -eq "all" -or $Scope -eq "phase") -and ($ScopeFiles.Count -eq 0)

    # Get view files in features + modules (not ui/views/ like startup/home)
    $viewFiles = if ($checkAll) {
        @(Get-FlutterFiles -Pattern "*_view.dart") | Where-Object {
            $_.FullName -match "\\(features|modules)\\"
        }
    }
    else {
        @($ScopeFiles | Where-Object { $_.Name -match "_view\.dart$" -and $_.FullName -match "(features|modules)" })
    }

    foreach ($f in $viewFiles) {
        $rel = Get-RelativePath $f.FullName
        $content = Get-Content $f.FullName -Raw

        # =======================================================
        # Empty State for List Views (unique to Gate 4)
        # =======================================================
        $isList = $content -match "ListView|SliverList|GridView|CustomScrollView"
        $hasEmpty = $content -match "AppEmptyState|EmptyState|\.isEmpty"

        if ($isList -and -not $hasEmpty) {
            Add-GateResult -GateNum 4 -Rule "exp-empty-state" -Status "WARN" -FilePath $rel -Message "List view without empty state"
            Write-RuleResult -Rule "exp-empty-state" -Status "WARN" -Message "$rel - list view, no empty state detected"
        }
        elseif ($isList -and $hasEmpty) {
            Add-GateResult -GateNum 4 -Rule "exp-empty-state" -Status "PASS" -FilePath $rel
            Write-RuleResult -Rule "exp-empty-state" -Status "PASS" -Message "$rel - empty state present"
        }

        # =======================================================
        # Sensory Layer (animations, haptic, skeleton loading)
        # =======================================================

        $animationPatterns = @(
            "AnimatedSwitcher", "AnimatedContainer", "AnimatedOpacity", "AnimatedPadding",
            "AnimatedAlign", "AnimatedCrossFade", "AnimatedSize", "AnimatedPositioned",
            "FadeTransition", "SlideTransition", "ScaleTransition", "RotationTransition",
            "AppStaggeredFadeIn", "AppFadeIn", "AppSlideIn", "TweenAnimationBuilder",
            "AnimationController", "Hero"
        )
        $hasAnimation = $false
        foreach ($pat in $animationPatterns) {
            if ($content -match [regex]::Escape($pat)) { $hasAnimation = $true; break }
        }

        if ($hasAnimation) {
            Add-GateResult -GateNum 4 -Rule "exp-sensory-animation" -Status "PASS" -FilePath $rel
            Write-RuleResult -Rule "exp-sensory-animation" -Status "PASS" -Message "$rel - has animations"
        }
        else {
            Add-GateResult -GateNum 4 -Rule "exp-sensory-animation" -Status "WARN" -FilePath $rel -Message "No animations detected"
            Write-RuleResult -Rule "exp-sensory-animation" -Status "WARN" -Message "$rel - no animations"
        }

        # Haptic feedback on user actions
        $hasHaptic = $content -match "HapticFeedback|haptic|vibrate"
        if ($hasHaptic) {
            Add-GateResult -GateNum 4 -Rule "exp-sensory-haptic" -Status "PASS" -FilePath $rel
            Write-RuleResult -Rule "exp-sensory-haptic" -Status "PASS" -Message "$rel"
        }
        else {
            Add-GateResult -GateNum 4 -Rule "exp-sensory-haptic" -Status "WARN" -FilePath $rel -Message "No haptic feedback"
            Write-RuleResult -Rule "exp-sensory-haptic" -Status "WARN" -Message "$rel - no haptic feedback"
        }

        # Loading: skeleton/shimmer preferred over bare spinner
        $hasSkeleton = $content -match "AppSkeleton|AppLoadingState|ShimmerLoading|Shimmer"
        $hasSpinner = $content -match "CircularProgressIndicator"
        $hasBusy = $content -match "isBusy"
        if ($hasSkeleton) {
            Add-GateResult -GateNum 4 -Rule "exp-sensory-loading" -Status "PASS" -FilePath $rel -Message "Uses skeleton/shimmer loading"
            Write-RuleResult -Rule "exp-sensory-loading" -Status "PASS" -Message "$rel - skeleton loading"
        }
        elseif ($hasSpinner) {
            Add-GateResult -GateNum 4 -Rule "exp-sensory-loading" -Status "WARN" -FilePath $rel -Message "Uses spinner - prefer skeleton"
            Write-RuleResult -Rule "exp-sensory-loading" -Status "WARN" -Message "$rel - spinner instead of skeleton"
        }
        elseif ($hasBusy) {
            Add-GateResult -GateNum 4 -Rule "exp-sensory-loading" -Status "WARN" -FilePath $rel -Message "Has isBusy but no visible loading indicator"
            Write-RuleResult -Rule "exp-sensory-loading" -Status "WARN" -Message "$rel - busy state but no loading widget"
        }

        # =======================================================
        # Personality Layer: tone check only (i18n already in Gate 2)
        # =======================================================

        # Empty state tone check - no "Aucun resultat" / "Liste vide" / "Rien" hardcoded
        $badEmptyText = [regex]::Matches($content, "(?i)(aucun\s+r[eé]sultat|liste\s+vide|rien\s+(ici|à|a)\s|no\s+results?\b|nothing\s+here)")
        if ($badEmptyText.Count -gt 0) {
            $samples = @($badEmptyText | ForEach-Object { $_.Value } | Select-Object -First 3)
            Add-GateResult -GateNum 4 -Rule "exp-personality-tone" -Status "FAIL" -FilePath $rel -Message "Empty state uses negative tone" -Details $samples
            Write-RuleResult -Rule "exp-personality-tone" -Status "FAIL" -Message "$rel - negative empty state text: $($samples -join ', ')"
        }
        else {
            Add-GateResult -GateNum 4 -Rule "exp-personality-tone" -Status "PASS" -FilePath $rel
            Write-RuleResult -Rule "exp-personality-tone" -Status "PASS" -Message "$rel"
        }
    }

    if ($viewFiles.Count -eq 0) {
        Add-GateResult -GateNum 4 -Rule "exp-check" -Status "SKIP" -Message "No view files in scope"
        Write-RuleResult -Rule "exp-check" -Status "SKIP" -Message "No view files found in features/modules"
    }
}
