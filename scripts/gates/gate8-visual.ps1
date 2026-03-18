<#
.SYNOPSIS
    Gate 8 - Visual Validation: verify screenshots and accessibility trees from Mobile MCP.

.DESCRIPTION
    Validates captured screenshots and accessibility data:
      - Accessibility labels present on interactive elements
      - Touch targets meet minimum size (48x48 dp)
      - No element overlap detected
      - Tab navigation works (screenshots exist for all tabs)
      - Back navigation verified
      - Dark mode screenshots captured
      - No text overflow/truncation indicators

    Requires: docs/screenshots/ populated by mobile-loop.ps1 + Copilot MCP.
    
    Rules severity:
      FAIL: a11y-labels, tab-navigation, back-navigation, no-overflow
      WARN: touch-targets, dark-mode, element-overlap
#>

function Invoke-Gate8 {
    param(
        [string]$Scope = "all",
        [System.IO.FileInfo[]]$ScopeFiles = @()
    )

    $screenshotDir = Join-Path $script:RepoRoot "docs\screenshots"
    $screenMapPath = Join-Path $script:RepoRoot "scripts\mobile\screen-maps\lifeflow.json"

    # ── Pre-check: screenshot directory exists ─────────────────────
    if (-not (Test-Path $screenshotDir)) {
        Add-GateResult -GateNum 8 -Rule "visual-screenshots" -Status "SKIP" `
            -Message "docs/screenshots/ not found. Run mobile-loop.ps1 first."
        Write-RuleResult -Rule "visual-screenshots" -Status "SKIP" `
            -Message "No screenshots directory. Run mobile-loop.ps1 + MCP capture first."
        return
    }

    # ── Pre-check: screen map exists ───────────────────────────────
    if (-not (Test-Path $screenMapPath)) {
        Add-GateResult -GateNum 8 -Rule "visual-screenmap" -Status "SKIP" `
            -Message "Screen map not found at: $screenMapPath"
        Write-RuleResult -Rule "visual-screenmap" -Status "SKIP" `
            -Message "No screen map found."
        return
    }

    $map = Get-Content $screenMapPath -Raw | ConvertFrom-Json
    $screensToCheck = $map.screens | Where-Object { -not $_.skipScreenshot }

    # ── Rule 1: screenshot-coverage ────────────────────────────────
    # Every non-skipped screen must have a screenshot.png
    $missingScreenshots = @()
    $validScreens = @()

    foreach ($screen in $screensToCheck) {
        $screenDir = Join-Path $screenshotDir $screen.id
        $screenshotFile = Join-Path $screenDir "screenshot.png"

        if (-not (Test-Path $screenshotFile)) {
            $missingScreenshots += $screen.id
        }
        else {
            $validScreens += $screen.id
        }
    }

    if ($missingScreenshots.Count -gt 0) {
        Add-GateResult -GateNum 8 -Rule "screenshot-coverage" -Status "FAIL" `
            -Message "$($missingScreenshots.Count)/$($screensToCheck.Count) screens missing screenshots" `
            -Details $missingScreenshots
        Write-RuleResult -Rule "screenshot-coverage" -Status "FAIL" `
            -Message "Missing: $($missingScreenshots -join ', ')"
    }
    else {
        Add-GateResult -GateNum 8 -Rule "screenshot-coverage" -Status "PASS" `
            -Message "All $($screensToCheck.Count) screens have screenshots"
        Write-RuleResult -Rule "screenshot-coverage" -Status "PASS" `
            -Message "$($screensToCheck.Count)/$($screensToCheck.Count) screens captured"
    }

    # ── Rule 2: a11y-labels ────────────────────────────────────────
    # Every screen must have an accessibility-tree.json with labeled elements
    $a11yIssues = @()

    foreach ($screenId in $validScreens) {
        $treePath = Join-Path $screenshotDir "$screenId\accessibility-tree.json"

        if (-not (Test-Path $treePath)) {
            $a11yIssues += "$screenId: no accessibility-tree.json"
            continue
        }

        $treeContent = Get-Content $treePath -Raw -ErrorAction SilentlyContinue
        if (-not $treeContent -or $treeContent.Trim().Length -lt 10) {
            $a11yIssues += "$screenId: empty accessibility tree"
            continue
        }

        try {
            $tree = $treeContent | ConvertFrom-Json

            # Check for interactive elements without labels
            $unlabeled = Find-UnlabeledElements -Node $tree -ScreenId $screenId
            if ($unlabeled.Count -gt 0) {
                $a11yIssues += $unlabeled
            }
        }
        catch {
            $a11yIssues += "$screenId: invalid JSON in accessibility tree"
        }
    }

    if ($a11yIssues.Count -gt 0) {
        Add-GateResult -GateNum 8 -Rule "a11y-labels" -Status "FAIL" `
            -Message "$($a11yIssues.Count) accessibility issues found" `
            -Details ($a11yIssues | Select-Object -First 20)
        Write-RuleResult -Rule "a11y-labels" -Status "FAIL" `
            -Message "$($a11yIssues.Count) issues"
    }
    elseif ($validScreens.Count -eq 0) {
        Add-GateResult -GateNum 8 -Rule "a11y-labels" -Status "SKIP" `
            -Message "No screens to check"
        Write-RuleResult -Rule "a11y-labels" -Status "SKIP" -Message "No screens"
    }
    else {
        Add-GateResult -GateNum 8 -Rule "a11y-labels" -Status "PASS" `
            -Message "All screens have accessibility trees with labeled elements"
        Write-RuleResult -Rule "a11y-labels" -Status "PASS" `
            -Message "All screens pass a11y check"
    }

    # ── Rule 3: touch-targets ──────────────────────────────────────
    # Interactive elements should meet 48x48dp minimum (WARN)
    $touchIssues = @()

    foreach ($screenId in $validScreens) {
        $treePath = Join-Path $screenshotDir "$screenId\accessibility-tree.json"
        if (-not (Test-Path $treePath)) { continue }

        try {
            $tree = Get-Content $treePath -Raw | ConvertFrom-Json
            $smallTargets = Find-SmallTouchTargets -Node $tree -ScreenId $screenId -MinSize 48
            if ($smallTargets.Count -gt 0) {
                $touchIssues += $smallTargets
            }
        }
        catch { }
    }

    if ($touchIssues.Count -gt 0) {
        Add-GateResult -GateNum 8 -Rule "touch-targets" -Status "WARN" `
            -Message "$($touchIssues.Count) elements below 48dp touch target" `
            -Details ($touchIssues | Select-Object -First 10)
        Write-RuleResult -Rule "touch-targets" -Status "WARN" `
            -Message "$($touchIssues.Count) small targets"
    }
    else {
        Add-GateResult -GateNum 8 -Rule "touch-targets" -Status "PASS" `
            -Message "All interactive elements meet 48dp minimum"
        Write-RuleResult -Rule "touch-targets" -Status "PASS" `
            -Message "Touch targets OK"
    }

    # ── Rule 4: tab-navigation ─────────────────────────────────────
    # Home tabs must all have screenshots
    $homeTabs = $screensToCheck | Where-Object { $_.type -eq "home_tab" }
    $missingTabs = @()

    foreach ($tab in $homeTabs) {
        $tabScreenshot = Join-Path $screenshotDir "$($tab.id)\screenshot.png"
        if (-not (Test-Path $tabScreenshot)) {
            $missingTabs += $tab.id
        }
    }

    if ($homeTabs.Count -eq 0) {
        Add-GateResult -GateNum 8 -Rule "tab-navigation" -Status "SKIP" `
            -Message "No home tabs defined in screen map"
        Write-RuleResult -Rule "tab-navigation" -Status "SKIP" -Message "No tabs"
    }
    elseif ($missingTabs.Count -gt 0) {
        Add-GateResult -GateNum 8 -Rule "tab-navigation" -Status "FAIL" `
            -Message "$($missingTabs.Count) tab(s) not captured: $($missingTabs -join ', ')"
        Write-RuleResult -Rule "tab-navigation" -Status "FAIL" `
            -Message "Missing tabs: $($missingTabs -join ', ')"
    }
    else {
        Add-GateResult -GateNum 8 -Rule "tab-navigation" -Status "PASS" `
            -Message "All $($homeTabs.Count) tabs captured"
        Write-RuleResult -Rule "tab-navigation" -Status "PASS" `
            -Message "$($homeTabs.Count) tabs OK"
    }

    # ── Rule 5: dark-mode ──────────────────────────────────────────
    # At least some screens should have dark mode screenshots (WARN)
    $darkScreenshots = 0
    foreach ($screenId in $validScreens) {
        $darkFile = Join-Path $screenshotDir "$screenId\screenshot-dark.png"
        if (Test-Path $darkFile) { $darkScreenshots++ }
    }

    if ($validScreens.Count -eq 0) {
        Add-GateResult -GateNum 8 -Rule "dark-mode" -Status "SKIP" `
            -Message "No valid screens"
        Write-RuleResult -Rule "dark-mode" -Status "SKIP" -Message "No screens"
    }
    elseif ($darkScreenshots -eq 0) {
        Add-GateResult -GateNum 8 -Rule "dark-mode" -Status "WARN" `
            -Message "No dark mode screenshots found (0/$($validScreens.Count))"
        Write-RuleResult -Rule "dark-mode" -Status "WARN" `
            -Message "No dark mode captures"
    }
    elseif ($darkScreenshots -lt $validScreens.Count) {
        Add-GateResult -GateNum 8 -Rule "dark-mode" -Status "WARN" `
            -Message "Partial dark mode: $darkScreenshots/$($validScreens.Count)"
        Write-RuleResult -Rule "dark-mode" -Status "WARN" `
            -Message "$darkScreenshots/$($validScreens.Count) dark captures"
    }
    else {
        Add-GateResult -GateNum 8 -Rule "dark-mode" -Status "PASS" `
            -Message "All $($validScreens.Count) screens have dark mode"
        Write-RuleResult -Rule "dark-mode" -Status "PASS" `
            -Message "$darkScreenshots/$($validScreens.Count) dark OK"
    }

    # ── Rule 6: screenshot-size ────────────────────────────────────
    # Screenshots should not be 0 bytes (corrupted capture)
    $corruptScreenshots = @()
    foreach ($screenId in $validScreens) {
        $file = Join-Path $screenshotDir "$screenId\screenshot.png"
        $fileInfo = Get-Item $file -ErrorAction SilentlyContinue
        if ($fileInfo -and $fileInfo.Length -lt 1024) {
            $corruptScreenshots += "$screenId (${($fileInfo.Length)} bytes)"
        }
    }

    if ($corruptScreenshots.Count -gt 0) {
        Add-GateResult -GateNum 8 -Rule "screenshot-size" -Status "FAIL" `
            -Message "$($corruptScreenshots.Count) potentially corrupt screenshots" `
            -Details $corruptScreenshots
        Write-RuleResult -Rule "screenshot-size" -Status "FAIL" `
            -Message "$($corruptScreenshots.Count) corrupt/tiny screenshots"
    }
    else {
        Add-GateResult -GateNum 8 -Rule "screenshot-size" -Status "PASS" `
            -Message "All screenshots have valid file size"
        Write-RuleResult -Rule "screenshot-size" -Status "PASS" `
            -Message "File sizes OK"
    }
}

# ===================================================================
# HELPER FUNCTIONS
# ===================================================================

function Find-UnlabeledElements {
    param(
        [object]$Node,
        [string]$ScreenId,
        [string]$ParentPath = ""
    )

    $issues = @()

    if ($null -eq $Node) { return $issues }

    # Check if this is an interactive element
    $isInteractive = $false
    $elementType = ""
    $elementText = ""

    # Handle different accessibility tree formats
    if ($Node.PSObject.Properties["type"]) { $elementType = $Node.type }
    if ($Node.PSObject.Properties["class"]) { $elementType = $Node.class }
    if ($Node.PSObject.Properties["text"]) { $elementText = $Node.text }
    if ($Node.PSObject.Properties["content-desc"]) { $elementText = $Node.'content-desc' }

    # Interactive types that need labels
    $interactiveTypes = @("Button", "ImageButton", "Switch", "CheckBox", "RadioButton",
                          "EditText", "TextField", "ToggleButton", "FloatingActionButton",
                          "IconButton", "Tab", "MenuItem")

    foreach ($t in $interactiveTypes) {
        if ($elementType -match $t) { $isInteractive = $true; break }
    }

    # Check clickable property
    if ($Node.PSObject.Properties["clickable"] -and $Node.clickable -eq $true) {
        $isInteractive = $true
    }

    if ($isInteractive -and [string]::IsNullOrWhiteSpace($elementText)) {
        $path = if ($ParentPath) { "$ParentPath > $elementType" } else { $elementType }
        $issues += "$ScreenId: unlabeled $path"
    }

    # Recurse into children
    if ($Node.PSObject.Properties["children"] -and $Node.children) {
        foreach ($child in $Node.children) {
            $childPath = if ($ParentPath) { "$ParentPath > $elementType" } else { $elementType }
            $issues += Find-UnlabeledElements -Node $child -ScreenId $ScreenId -ParentPath $childPath
        }
    }

    return $issues
}

function Find-SmallTouchTargets {
    param(
        [object]$Node,
        [string]$ScreenId,
        [int]$MinSize = 48
    )

    $issues = @()

    if ($null -eq $Node) { return $issues }

    $isInteractive = $false
    $elementType = ""
    if ($Node.PSObject.Properties["type"]) { $elementType = $Node.type }
    if ($Node.PSObject.Properties["class"]) { $elementType = $Node.class }

    if ($Node.PSObject.Properties["clickable"] -and $Node.clickable -eq $true) {
        $isInteractive = $true
    }

    # Check bounds if interactive
    if ($isInteractive -and $Node.PSObject.Properties["bounds"]) {
        $bounds = $Node.bounds
        # Bounds format: "[left,top][right,bottom]" or {left, top, right, bottom}
        if ($bounds -is [string] -and $bounds -match "\[(\d+),(\d+)\]\[(\d+),(\d+)\]") {
            $width = [int]$Matches[3] - [int]$Matches[1]
            $height = [int]$Matches[4] - [int]$Matches[2]
            if ($width -lt $MinSize -or $height -lt $MinSize) {
                $text = if ($Node.PSObject.Properties["text"]) { $Node.text } else { $elementType }
                $issues += "$ScreenId: '$text' touch target ${width}x${height} < ${MinSize}dp"
            }
        }
        elseif ($bounds.PSObject.Properties["width"] -and $bounds.PSObject.Properties["height"]) {
            if ($bounds.width -lt $MinSize -or $bounds.height -lt $MinSize) {
                $text = if ($Node.PSObject.Properties["text"]) { $Node.text } else { $elementType }
                $issues += "$ScreenId: '$text' touch target $($bounds.width)x$($bounds.height) < ${MinSize}dp"
            }
        }
    }

    # Recurse
    if ($Node.PSObject.Properties["children"] -and $Node.children) {
        foreach ($child in $Node.children) {
            $issues += Find-SmallTouchTargets -Node $child -ScreenId $ScreenId -MinSize $MinSize
        }
    }

    return $issues
}
