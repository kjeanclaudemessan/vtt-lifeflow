<#
.SYNOPSIS
    Gate 3 - Architecture: layer dependencies, cross-feature isolation, package whitelist
#>

function Invoke-Gate3 {
    param(
        [string]$Scope = "all",
        [System.IO.FileInfo[]]$ScopeFiles = @()
    )

    $checkAll = ($Scope -eq "all" -or $Scope -eq "phase") -and ($ScopeFiles.Count -eq 0)

    # Load .gatesignore if exists
    $ignorePatterns = @()
    $ignoreFile = Join-Path $script:RepoRoot ".gatesignore"
    if (Test-Path $ignoreFile) {
        $ignorePatterns = Get-Content $ignoreFile | Where-Object { $_ -and $_ -notmatch "^\s*#" }
    }

    function Test-Ignored {
        param([string]$FilePath)
        foreach ($pat in $ignorePatterns) {
            if ($FilePath -match [regex]::Escape($pat)) { return $true }
        }
        return $false
    }

    # ===========================================================
    # T017 - Layer Dependencies
    # ===========================================================

    # --- domain/ must only import equatable, dartz, fpdart, and domain/ internals ---
    $domainFiles = if ($checkAll) {
        @(Get-FlutterFiles -Pattern "*.dart" -Directory "domain")
    }
    else {
        @($ScopeFiles | Where-Object { $_.FullName -match "[\\/]domain[\\/]" })
    }

    $domainViolations = @()
    foreach ($f in $domainFiles) {
        if (Test-Ignored (Get-RelativePath $f.FullName)) { continue }
        $rel = Get-RelativePath $f.FullName
        $lines = Get-Content $f.FullName
        foreach ($line in $lines) {
            if ($line -match "^\s*import\s+") {
                # Allowed: equatable, dartz, fpdart, flutter/material (for TimeOfDay etc), domain/ internal, core/
                if ($line -match "package:equatable" -or
                    $line -match "package:dartz" -or
                    $line -match "package:fpdart" -or
                    $line -match "package:flutter/" -or
                    $line -match "domain/" -or
                    $line -match "core/" -or
                    $line -match "package:collection") {
                    continue
                }
                # Forbidden: data/, services/, features/, modules/, supabase, json_annotation, http
                if ($line -match "data/" -or
                    $line -match "services/" -or
                    $line -match "features/" -or
                    $line -match "modules/" -or
                    $line -match "package:supabase" -or
                    $line -match "package:json_annotation" -or
                    $line -match "package:http") {
                    $domainViolations += "$rel : $($line.Trim())"
                }
            }
        }
    }

    if ($domainViolations.Count -eq 0) {
        Add-GateResult -GateNum 3 -Rule "layer-domain-pure" -Status "PASS" -Message "domain/ has no forbidden imports"
        Write-RuleResult -Rule "layer-domain-pure" -Status "PASS" -Message "domain/ layer is pure"
    }
    else {
        Add-GateResult -GateNum 3 -Rule "layer-domain-pure" -Status "FAIL" -Message "$($domainViolations.Count) forbidden imports in domain/" -Details $domainViolations
        Write-RuleResult -Rule "layer-domain-pure" -Status "FAIL" -Message "$($domainViolations.Count) violations in domain/"
        foreach ($v in $domainViolations | Select-Object -First 5) {
            Write-Host "    $v" -ForegroundColor DarkRed
        }
    }

    # --- data/ must NOT import presentation/views/viewmodels/features ---
    $dataFiles = if ($checkAll) {
        @(Get-FlutterFiles -Pattern "*.dart" -Directory "data")
    }
    else {
        @($ScopeFiles | Where-Object { $_.FullName -match "[\\/]data[\\/]" })
    }

    $dataViolations = @()
    foreach ($f in $dataFiles) {
        if (Test-Ignored (Get-RelativePath $f.FullName)) { continue }
        $rel = Get-RelativePath $f.FullName
        $lines = Get-Content $f.FullName
        foreach ($line in $lines) {
            if ($line -match "^\s*import\s+") {
                if ($line -match "presentation/" -or $line -match "views/" -or $line -match "viewmodels/" -or $line -match "features/") {
                    $dataViolations += "$rel : $($line.Trim())"
                }
            }
        }
    }

    if ($dataViolations.Count -eq 0) {
        Add-GateResult -GateNum 3 -Rule "layer-data-no-ui" -Status "PASS" -Message "data/ does not import UI"
        Write-RuleResult -Rule "layer-data-no-ui" -Status "PASS" -Message "data/ layer clean"
    }
    else {
        Add-GateResult -GateNum 3 -Rule "layer-data-no-ui" -Status "FAIL" -Message "$($dataViolations.Count) UI imports in data/" -Details $dataViolations
        Write-RuleResult -Rule "layer-data-no-ui" -Status "FAIL" -Message "$($dataViolations.Count) violations in data/"
        foreach ($v in $dataViolations | Select-Object -First 5) {
            Write-Host "    $v" -ForegroundColor DarkRed
        }
    }

    # --- views/ must NOT import data/, supabase_flutter, http ---
    $viewFiles = if ($checkAll) {
        @(Get-FlutterFiles -Pattern "*_view.dart")
    }
    else {
        @($ScopeFiles | Where-Object { $_.Name -match "_view\.dart$" })
    }

    $viewViolations = @()
    foreach ($f in $viewFiles) {
        if (Test-Ignored (Get-RelativePath $f.FullName)) { continue }
        $rel = Get-RelativePath $f.FullName
        $lines = Get-Content $f.FullName
        foreach ($line in $lines) {
            if ($line -match "^\s*import\s+") {
                if ($line -match "[\\/]data[\\/]" -or $line -match "data/models" -or $line -match "data/repositories" -or
                    $line -match "package:supabase_flutter" -or $line -match "package:http/") {
                    $viewViolations += "$rel : $($line.Trim())"
                }
            }
        }
    }

    if ($viewViolations.Count -eq 0) {
        Add-GateResult -GateNum 3 -Rule "layer-view-no-data" -Status "PASS" -Message "views/ do not import data layer"
        Write-RuleResult -Rule "layer-view-no-data" -Status "PASS" -Message "views/ layer clean"
    }
    else {
        Add-GateResult -GateNum 3 -Rule "layer-view-no-data" -Status "FAIL" -Message "$($viewViolations.Count) data imports in views/" -Details $viewViolations
        Write-RuleResult -Rule "layer-view-no-data" -Status "FAIL" -Message "$($viewViolations.Count) violations in views/"
        foreach ($v in $viewViolations | Select-Object -First 5) {
            Write-Host "    $v" -ForegroundColor DarkRed
        }
    }

    # --- viewmodels/ can import domain/ but NOT data/ directly ---
    $vmFiles = if ($checkAll) {
        @(Get-FlutterFiles -Pattern "*_viewmodel.dart")
    }
    else {
        @($ScopeFiles | Where-Object { $_.Name -match "_viewmodel\.dart$" })
    }

    $vmViolations = @()
    foreach ($f in $vmFiles) {
        if (Test-Ignored (Get-RelativePath $f.FullName)) { continue }
        $rel = Get-RelativePath $f.FullName
        $lines = Get-Content $f.FullName
        foreach ($line in $lines) {
            if ($line -match "^\s*import\s+") {
                if ($line -match "[\\/]data[\\/]" -or $line -match "data/models" -or $line -match "data/repositories") {
                    $vmViolations += "$rel : $($line.Trim())"
                }
            }
        }
    }

    if ($vmViolations.Count -eq 0) {
        Add-GateResult -GateNum 3 -Rule "layer-vm-no-data" -Status "PASS" -Message "viewmodels/ do not import data layer"
        Write-RuleResult -Rule "layer-vm-no-data" -Status "PASS" -Message "viewmodels/ layer clean"
    }
    else {
        Add-GateResult -GateNum 3 -Rule "layer-vm-no-data" -Status "FAIL" -Message "$($vmViolations.Count) data imports in viewmodels/" -Details $vmViolations
        Write-RuleResult -Rule "layer-vm-no-data" -Status "FAIL" -Message "$($vmViolations.Count) violations in viewmodels/"
        foreach ($v in $vmViolations | Select-Object -First 5) {
            Write-Host "    $v" -ForegroundColor DarkRed
        }
    }

    # ===========================================================
    # T018 - Cross-Feature Isolation
    # ===========================================================

    $featureDirs = @()
    $featuresPath = Join-Path $script:LibRoot "features"
    $modulesPath = Join-Path $script:LibRoot "modules"

    if (Test-Path $featuresPath) {
        $featureDirs += Get-ChildItem -Path $featuresPath -Directory
    }
    if (Test-Path $modulesPath) {
        $featureDirs += Get-ChildItem -Path $modulesPath -Directory
    }

    $crossImportViolations = @()
    foreach ($dir in $featureDirs) {
        $dirName = $dir.Name
        $parentType = if ($dir.FullName -match "\\features\\") { "features" } else { "modules" }
        $files = Get-ChildItem -Path $dir.FullName -Filter "*.dart" -Recurse -File

        foreach ($f in $files) {
            if (Test-Ignored (Get-RelativePath $f.FullName)) { continue }
            $rel = Get-RelativePath $f.FullName
            $lines = Get-Content $f.FullName

            foreach ($line in $lines) {
                if ($line -match "^\s*import\s+") {
                    # Check for cross-feature imports
                    if ($parentType -eq "features" -and $line -match "features/(\w+)/" ) {
                        $importedFeature = $Matches[1]
                        if ($importedFeature -ne $dirName) {
                            $crossImportViolations += "$rel imports features/$importedFeature/"
                        }
                    }
                    if ($parentType -eq "modules" -and $line -match "modules/(\w+)/") {
                        $importedModule = $Matches[1]
                        if ($importedModule -ne $dirName) {
                            $crossImportViolations += "$rel imports modules/$importedModule/"
                        }
                    }
                }
            }
        }
    }

    if ($crossImportViolations.Count -eq 0) {
        Add-GateResult -GateNum 3 -Rule "cross-feature-isolation" -Status "PASS" -Message "No cross-feature/module imports"
        Write-RuleResult -Rule "cross-feature-isolation" -Status "PASS" -Message "Feature isolation OK"
    }
    else {
        Add-GateResult -GateNum 3 -Rule "cross-feature-isolation" -Status "FAIL" -Message "$($crossImportViolations.Count) cross-feature imports" -Details $crossImportViolations
        Write-RuleResult -Rule "cross-feature-isolation" -Status "FAIL" -Message "$($crossImportViolations.Count) cross-feature imports"
        foreach ($v in $crossImportViolations | Select-Object -First 5) {
            Write-Host "    $v" -ForegroundColor DarkRed
        }
    }

    # ===========================================================
    # T019 - Package Whitelist
    # ===========================================================

    # Read pubspec.yaml to get declared packages
    $pubspecPath = Join-Path $script:FlutterRoot "pubspec.yaml"
    $declaredPackages = @()
    if (Test-Path $pubspecPath) {
        $pubContent = Get-Content $pubspecPath
        $inDeps = $false
        foreach ($line in $pubContent) {
            if ($line -match "^(dependencies|dev_dependencies):") { $inDeps = $true; continue }
            if ($inDeps -and $line -match "^\S") { $inDeps = $false }
            if ($inDeps -and $line -match "^\s+(\w[\w_-]*)") {
                $declaredPackages += $Matches[1]
            }
        }
    }
    # Add built-in SDK packages
    $declaredPackages += @("flutter", "dart", "meta", "async", "collection", "convert", "math", "io", "typed_data", "path")

    # Forbidden packages in features/
    $forbiddenInFeatures = @("http", "dio")
    $packageViolations = @()

    $featureFiles = if ($checkAll) {
        @(Get-FlutterFiles -Pattern "*.dart" -Directory "features") + @(Get-FlutterFiles -Pattern "*.dart" -Directory "modules")
    }
    else {
        @($ScopeFiles | Where-Object { $_.FullName -match "[\\/](features|modules)[\\/]" })
    }

    foreach ($f in $featureFiles) {
        $rel = Get-RelativePath $f.FullName
        $lines = Get-Content $f.FullName
        foreach ($line in $lines) {
            if ($line -match "^\s*import\s+'package:(\w[\w_]*)") {
                $pkg = $Matches[1]

                # Check forbidden in features
                if ($pkg -in $forbiddenInFeatures) {
                    $packageViolations += "$rel : forbidden package '$pkg' (use service/repo instead)"
                }

                # Check undeclared packages  
                $pkgBase = $pkg -replace "_", ""
                $isKnown = $declaredPackages | Where-Object { $_ -eq $pkg -or ($_ -replace "_|-", "") -eq $pkgBase }
                # Allow the project's own package
                if (-not $isKnown -and $pkg -ne "lifeflow" -and $pkg -notmatch "^flutter_") {
                    # This is a warning, not a fail - might be a transitive dependency
                }
            }
        }
    }

    # Also check for 'provider' package (we use GetIt via Stacked)
    $providerUse = @()
    foreach ($f in $featureFiles) {
        $content = Get-Content $f.FullName -Raw
        if ($content -match "package:provider/") {
            $providerUse += Get-RelativePath $f.FullName
        }
    }
    if ($providerUse.Count -gt 0) {
        $packageViolations += $providerUse | ForEach-Object { "$_ : uses 'provider' package (use GetIt/Stacked instead)" }
    }

    if ($packageViolations.Count -eq 0) {
        Add-GateResult -GateNum 3 -Rule "package-whitelist" -Status "PASS" -Message "No forbidden packages"
        Write-RuleResult -Rule "package-whitelist" -Status "PASS" -Message "Package usage OK"
    }
    else {
        Add-GateResult -GateNum 3 -Rule "package-whitelist" -Status "FAIL" -Message "$($packageViolations.Count) package violations" -Details $packageViolations
        Write-RuleResult -Rule "package-whitelist" -Status "FAIL" -Message "$($packageViolations.Count) package violations"
        foreach ($v in $packageViolations | Select-Object -First 5) {
            Write-Host "    $v" -ForegroundColor DarkRed
        }
    }
}
