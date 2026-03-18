<#
.SYNOPSIS
    Gate 2 - Pattern Structural: entity/model/repo/view/viewmodel conventions
#>

function Invoke-Gate2 {
    param(
        [string]$Scope = "all",
        [System.IO.FileInfo[]]$ScopeFiles = @()
    )

    # Determine which files to check
    $checkAll = ($Scope -eq "all" -or $Scope -eq "phase") -and ($ScopeFiles.Count -eq 0)

    # ===========================================================
    # T009 - Entities
    # ===========================================================

    $entityFiles = if ($checkAll) {
        @(Get-FlutterFiles -Pattern "*_entity.dart")
    }
    else {
        @($ScopeFiles | Where-Object { $_.Name -match "_entity\.dart$" })
    }

    foreach ($f in $entityFiles) {
        $rel = Get-RelativePath $f.FullName
        $content = Get-Content $f.FullName -Raw

        # Must extend Equatable
        if ($content -match "extends\s+Equatable") {
            Add-GateResult -GateNum 2 -Rule "entity-equatable" -Status "PASS" -FilePath $rel
            Write-RuleResult -Rule "entity-equatable" -Status "PASS" -Message $rel
        }
        else {
            Add-GateResult -GateNum 2 -Rule "entity-equatable" -Status "FAIL" -FilePath $rel -Message "Missing 'extends Equatable'"
            Write-RuleResult -Rule "entity-equatable" -Status "FAIL" -Message "$rel - missing extends Equatable"
        }

        # Must have props
        if ($content -match "List<Object\??>\s+get\s+props") {
            Add-GateResult -GateNum 2 -Rule "entity-props" -Status "PASS" -FilePath $rel
            Write-RuleResult -Rule "entity-props" -Status "PASS" -Message $rel
        }
        else {
            Add-GateResult -GateNum 2 -Rule "entity-props" -Status "FAIL" -FilePath $rel -Message "Missing 'List<Object?> get props'"
            Write-RuleResult -Rule "entity-props" -Status "FAIL" -Message "$rel - missing props getter"
        }

        # Must NOT import data/, supabase, json_annotation
        $forbidden = @("import.*data/", "import.*supabase", "import.*json_annotation")
        $violations = @()
        foreach ($pat in $forbidden) {
            if ($content -match $pat) { $violations += $pat }
        }
        if ($violations.Count -eq 0) {
            Add-GateResult -GateNum 2 -Rule "entity-no-data-import" -Status "PASS" -FilePath $rel
            Write-RuleResult -Rule "entity-no-data-import" -Status "PASS" -Message $rel
        }
        else {
            Add-GateResult -GateNum 2 -Rule "entity-no-data-import" -Status "FAIL" -FilePath $rel -Message "Forbidden imports: $($violations -join ', ')"
            Write-RuleResult -Rule "entity-no-data-import" -Status "FAIL" -Message "$rel - imports data/supabase/json"
        }
    }

    if ($entityFiles.Count -eq 0) {
        Add-GateResult -GateNum 2 -Rule "entity-check" -Status "SKIP" -Message "No entity files in scope"
        Write-RuleResult -Rule "entity-check" -Status "SKIP" -Message "No entity files found"
    }

    # ===========================================================
    # T010 - Models
    # ===========================================================

    $modelFiles = if ($checkAll) {
        @(Get-FlutterFiles -Pattern "*_model.dart") | Where-Object {
            $_.FullName -match "\\data\\models\\" -or $_.FullName -match "\\data\\models/"
        }
    }
    else {
        @($ScopeFiles | Where-Object { $_.Name -match "_model\.dart$" -and $_.FullName -match "data[\\/]models" })
    }

    foreach ($f in $modelFiles) {
        $rel = Get-RelativePath $f.FullName
        $content = Get-Content $f.FullName -Raw

        # Must have @JsonSerializable
        if ($content -match "@JsonSerializable") {
            Add-GateResult -GateNum 2 -Rule "model-json-serializable" -Status "PASS" -FilePath $rel
            Write-RuleResult -Rule "model-json-serializable" -Status "PASS" -Message $rel
        }
        else {
            Add-GateResult -GateNum 2 -Rule "model-json-serializable" -Status "FAIL" -FilePath $rel -Message "Missing @JsonSerializable"
            Write-RuleResult -Rule "model-json-serializable" -Status "FAIL" -Message "$rel - missing @JsonSerializable"
        }

        # Must have toEntity, fromEntity, fromJson, toJson
        $requiredMethods = @("toEntity", "fromEntity", "fromJson", "toJson")
        $missing = @()
        foreach ($m in $requiredMethods) {
            if ($content -notmatch $m) { $missing += $m }
        }
        if ($missing.Count -eq 0) {
            Add-GateResult -GateNum 2 -Rule "model-methods" -Status "PASS" -FilePath $rel
            Write-RuleResult -Rule "model-methods" -Status "PASS" -Message $rel
        }
        else {
            Add-GateResult -GateNum 2 -Rule "model-methods" -Status "FAIL" -FilePath $rel -Message "Missing methods: $($missing -join ', ')"
            Write-RuleResult -Rule "model-methods" -Status "FAIL" -Message "$rel - missing: $($missing -join ', ')"
        }

        # Should have toInsertJson or toUpdateJson (warning)
        if ($content -match "toInsertJson|toUpdateJson") {
            Add-GateResult -GateNum 2 -Rule "model-insert-update" -Status "PASS" -FilePath $rel
            Write-RuleResult -Rule "model-insert-update" -Status "PASS" -Message $rel
        }
        else {
            Add-GateResult -GateNum 2 -Rule "model-insert-update" -Status "WARN" -FilePath $rel -Message "No toInsertJson/toUpdateJson"
            Write-RuleResult -Rule "model-insert-update" -Status "WARN" -Message "$rel - consider adding toInsertJson/toUpdateJson"
        }
    }

    if ($modelFiles.Count -eq 0) {
        Add-GateResult -GateNum 2 -Rule "model-check" -Status "SKIP" -Message "No model files in scope"
        Write-RuleResult -Rule "model-check" -Status "SKIP" -Message "No model files found"
    }

    # ===========================================================
    # T011 - Repositories
    # ===========================================================

    # Interface files
    $repoInterfaceFiles = if ($checkAll) {
        @(Get-FlutterFiles -Pattern "i_*_repository.dart")
    }
    else {
        @($ScopeFiles | Where-Object { $_.Name -match "^i_.*_repository\.dart$" })
    }

    foreach ($f in $repoInterfaceFiles) {
        $rel = Get-RelativePath $f.FullName
        $content = Get-Content $f.FullName -Raw

        # Must use Either<Failure or FutureResult
        if ($content -match "Either<Failure" -or $content -match "FutureResult") {
            Add-GateResult -GateNum 2 -Rule "repo-either" -Status "PASS" -FilePath $rel
            Write-RuleResult -Rule "repo-either" -Status "PASS" -Message $rel
        }
        else {
            Add-GateResult -GateNum 2 -Rule "repo-either" -Status "FAIL" -FilePath $rel -Message "Missing Either<Failure> or FutureResult return types"
            Write-RuleResult -Rule "repo-either" -Status "FAIL" -Message "$rel - no Either/FutureResult"
        }
    }

    # Implementation files
    $repoImplFiles = if ($checkAll) {
        @(Get-FlutterFiles -Pattern "*_repository_impl.dart")
    }
    else {
        @($ScopeFiles | Where-Object { $_.Name -match "_repository_impl\.dart$" })
    }

    foreach ($f in $repoImplFiles) {
        $rel = Get-RelativePath $f.FullName
        $content = Get-Content $f.FullName -Raw

        # Should have try/catch
        if ($content -match "try\s*\{") {
            Add-GateResult -GateNum 2 -Rule "repo-impl-try-catch" -Status "PASS" -FilePath $rel
            Write-RuleResult -Rule "repo-impl-try-catch" -Status "PASS" -Message $rel
        }
        else {
            Add-GateResult -GateNum 2 -Rule "repo-impl-try-catch" -Status "WARN" -FilePath $rel -Message "No try/catch found"
            Write-RuleResult -Rule "repo-impl-try-catch" -Status "WARN" -Message "$rel - no try/catch blocks"
        }

        # Must NOT import presentation/views/viewmodels/features
        $forbiddenImports = @("import.*presentation/", "import.*views/", "import.*viewmodels/", "import.*features/")
        $violations = @()
        foreach ($pat in $forbiddenImports) {
            if ($content -match $pat) { $violations += $pat }
        }
        if ($violations.Count -eq 0) {
            Add-GateResult -GateNum 2 -Rule "repo-impl-no-ui-import" -Status "PASS" -FilePath $rel
            Write-RuleResult -Rule "repo-impl-no-ui-import" -Status "PASS" -Message $rel
        }
        else {
            Add-GateResult -GateNum 2 -Rule "repo-impl-no-ui-import" -Status "FAIL" -FilePath $rel -Message "Imports UI layer"
            Write-RuleResult -Rule "repo-impl-no-ui-import" -Status "FAIL" -Message "$rel - imports presentation layer"
        }
    }

    # ===========================================================
    # T012 - Views
    # ===========================================================

    $viewFiles = if ($checkAll) {
        @(Get-FlutterFiles -Pattern "*_view.dart") | Where-Object {
            $_.FullName -match "\\features\\" -or $_.FullName -match "\\modules\\"
        }
    }
    else {
        @($ScopeFiles | Where-Object { $_.Name -match "_view\.dart$" })
    }

    foreach ($f in $viewFiles) {
        $rel = Get-RelativePath $f.FullName
        $content = Get-Content $f.FullName -Raw

        # No business logic in views (locator<*Repository>, .save(, .delete(, .update( direct calls)
        $logicPatterns = @("locator<.*Repository", "\.save\(", "\.delete\(.*supabase", "\.update\(.*supabase")
        $found = @()
        foreach ($pat in $logicPatterns) {
            if ($content -match $pat) { $found += $pat }
        }
        if ($found.Count -eq 0) {
            Add-GateResult -GateNum 2 -Rule "view-no-logic" -Status "PASS" -FilePath $rel
            Write-RuleResult -Rule "view-no-logic" -Status "PASS" -Message $rel
        }
        else {
            Add-GateResult -GateNum 2 -Rule "view-no-logic" -Status "FAIL" -FilePath $rel -Message "Business logic in view"
            Write-RuleResult -Rule "view-no-logic" -Status "FAIL" -Message "$rel - business logic detected"
        }

        # Must handle isBusy + hasError (state machine - Dérive #5)
        $hasBusy = $content -match "isBusy|viewModel\.isBusy|model\.isBusy"
        $hasError = $content -match "hasError|viewModel\.hasError|model\.hasError"
        if ($hasBusy -and $hasError) {
            Add-GateResult -GateNum 2 -Rule "view-state-machine" -Status "PASS" -FilePath $rel
            Write-RuleResult -Rule "view-state-machine" -Status "PASS" -Message $rel
        }
        else {
            $missing = @()
            if (-not $hasBusy) { $missing += "isBusy" }
            if (-not $hasError) { $missing += "hasError" }
            Add-GateResult -GateNum 2 -Rule "view-state-machine" -Status "FAIL" -FilePath $rel -Message "Missing: $($missing -join ', ')"
            Write-RuleResult -Rule "view-state-machine" -Status "FAIL" -Message "$rel - missing $($missing -join ', ')"
        }

        # No hardcoded colors
        $colorPatterns = @("(?<!App)Colors\.\w+", "Color\(0x", "Color\.fromRGBO", "Color\.fromARGB")
        $colorViolations = @()
        foreach ($pat in $colorPatterns) {
            $matches = [regex]::Matches($content, $pat)
            foreach ($m in $matches) {
                # Allow Colors.transparent, Colors.white, Colors.black (common exceptions)
                if ($m.Value -notmatch "Colors\.(transparent|white|black)") {
                    $colorViolations += $m.Value
                }
            }
        }
        if ($colorViolations.Count -eq 0) {
            Add-GateResult -GateNum 2 -Rule "view-no-hardcoded-colors" -Status "PASS" -FilePath $rel
            Write-RuleResult -Rule "view-no-hardcoded-colors" -Status "PASS" -Message $rel
        }
        else {
            $unique = $colorViolations | Select-Object -Unique
            Add-GateResult -GateNum 2 -Rule "view-no-hardcoded-colors" -Status "FAIL" -FilePath $rel -Message "Hardcoded colors: $($unique -join ', ')" -Details $unique
            Write-RuleResult -Rule "view-no-hardcoded-colors" -Status "FAIL" -Message "$rel - hardcoded colors: $($unique -join ', ')"
        }

        # No hardcoded strings in features/modules (must use l10n)
        # Only check files in features/ and modules/ - not ui/views/ (startup, home, showcase)
        if ($f.FullName -match "\\(features|modules)\\") {
            # Match Text(' or Text(" but not inside comments
            $hardcodedStrings = [regex]::Matches($content, "Text\(\s*['""][^'""]*['""]")
            # Filter out common false positives
            $realViolations = @($hardcodedStrings | Where-Object {
                $_.Value -notmatch "Text\(\s*['""]\s*['""]" -and  # empty string
                $_.Value -notmatch "Text\(\s*['""][\d\s\.\-\+]+['""]"  # pure numbers/symbols
            })

            if ($realViolations.Count -eq 0) {
                Add-GateResult -GateNum 2 -Rule "view-i18n" -Status "PASS" -FilePath $rel
                Write-RuleResult -Rule "view-i18n" -Status "PASS" -Message $rel
            }
            else {
                $samples = @($realViolations | ForEach-Object { $_.Value } | Select-Object -First 5)
                Add-GateResult -GateNum 2 -Rule "view-i18n" -Status "FAIL" -FilePath $rel -Message "Hardcoded strings" -Details $samples
                Write-RuleResult -Rule "view-i18n" -Status "FAIL" -Message "$rel - $($realViolations.Count) hardcoded strings"
            }
        }

        # No TextStyle(fontSize without AppTextStyles/AppTypography
        $rawFontSize = [regex]::Matches($content, "TextStyle\([^)]*fontSize")
        if ($rawFontSize.Count -eq 0) {
            Add-GateResult -GateNum 2 -Rule "view-typography" -Status "PASS" -FilePath $rel
            Write-RuleResult -Rule "view-typography" -Status "PASS" -Message $rel
        }
        else {
            Add-GateResult -GateNum 2 -Rule "view-typography" -Status "FAIL" -FilePath $rel -Message "$($rawFontSize.Count) raw TextStyle(fontSize) - use AppTextStyles"
            Write-RuleResult -Rule "view-typography" -Status "FAIL" -Message "$rel - raw TextStyle(fontSize)"
        }
    }

    # ===========================================================
    # T013 - ViewModels
    # ===========================================================

    $vmFiles = if ($checkAll) {
        @(Get-FlutterFiles -Pattern "*_viewmodel.dart")
    }
    else {
        @($ScopeFiles | Where-Object { $_.Name -match "_viewmodel\.dart$" })
    }

    foreach ($f in $vmFiles) {
        $rel = Get-RelativePath $f.FullName
        $content = Get-Content $f.FullName -Raw

        # Should use runBusyFuture or setBusy
        if ($content -match "runBusyFuture|setBusy|setBusyForObject") {
            Add-GateResult -GateNum 2 -Rule "vm-busy-management" -Status "PASS" -FilePath $rel
            Write-RuleResult -Rule "vm-busy-management" -Status "PASS" -Message $rel
        }
        else {
            Add-GateResult -GateNum 2 -Rule "vm-busy-management" -Status "WARN" -FilePath $rel -Message "No busy management"
            Write-RuleResult -Rule "vm-busy-management" -Status "WARN" -Message "$rel - no runBusyFuture/setBusy"
        }

        # Must NOT import supabase_flutter or http directly (bypass repo)
        if ($content -match "import.*supabase_flutter" -or $content -match "import.*package:http/") {
            Add-GateResult -GateNum 2 -Rule "vm-no-direct-deps" -Status "FAIL" -FilePath $rel -Message "Direct supabase/http import - must use repository"
            Write-RuleResult -Rule "vm-no-direct-deps" -Status "FAIL" -Message "$rel - imports supabase/http directly"
        }
        else {
            Add-GateResult -GateNum 2 -Rule "vm-no-direct-deps" -Status "PASS" -FilePath $rel
            Write-RuleResult -Rule "vm-no-direct-deps" -Status "PASS" -Message $rel
        }
    }

    # ===========================================================
    # T014 - Design System Whitelist
    # ===========================================================

    $dsDir = Join-Path $script:LibRoot "design_system"
    if (Test-Path $dsDir) {
        # Extract all App* widget/class names from design_system/
        $dsContent = Get-ChildItem -Path $dsDir -Filter "*.dart" -Recurse | ForEach-Object { Get-Content $_.FullName -Raw }
        $dsAllContent = $dsContent -join "`n"
        $dsClasses = [regex]::Matches($dsAllContent, "class\s+(App\w+)") | ForEach-Object { $_.Groups[1].Value } | Select-Object -Unique | Sort-Object
        
        if ($dsClasses.Count -gt 0) {
            Add-GateResult -GateNum 2 -Rule "ds-whitelist-extracted" -Status "PASS" -Message "$($dsClasses.Count) design system classes found"
            Write-RuleResult -Rule "ds-whitelist-extracted" -Status "PASS" -Message "$($dsClasses.Count) DS classes: $($dsClasses[0..4] -join ', ')..."
        }

        # Check features/ and modules/ for App* usage not in whitelist
        $featureModuleFiles = @(Get-FlutterFiles -Pattern "*.dart" -Directory "features") + @(Get-FlutterFiles -Pattern "*.dart" -Directory "modules")
        $unknownWidgets = @{}

        foreach ($f in $featureModuleFiles) {
            $content = Get-Content $f.FullName -Raw
            $usedAppClasses = [regex]::Matches($content, "\bApp[A-Z]\w+") | ForEach-Object { $_.Value } | Select-Object -Unique
            foreach ($cls in $usedAppClasses) {
                if ($cls -notin $dsClasses -and $cls -notmatch "^App(Route|Locator|StackedApp)") {
                    $rel = Get-RelativePath $f.FullName
                    if (-not $unknownWidgets.ContainsKey($cls)) { $unknownWidgets[$cls] = @() }
                    $unknownWidgets[$cls] += $rel
                }
            }
        }

        if ($unknownWidgets.Count -eq 0) {
            Add-GateResult -GateNum 2 -Rule "ds-whitelist-check" -Status "PASS" -Message "All App* classes are in design system"
            Write-RuleResult -Rule "ds-whitelist-check" -Status "PASS" -Message "All App* classes are registered"
        }
        else {
            $details = @($unknownWidgets.GetEnumerator() | ForEach-Object { "$($_.Key) in $($_.Value -join ', ')" })
            Add-GateResult -GateNum 2 -Rule "ds-whitelist-check" -Status "WARN" -Message "$($unknownWidgets.Count) unknown App* classes" -Details $details
            Write-RuleResult -Rule "ds-whitelist-check" -Status "WARN" -Message "$($unknownWidgets.Count) unknown App* classes"
            foreach ($d in $details | Select-Object -First 5) {
                Write-Host "    $d" -ForegroundColor DarkYellow
            }
        }
    }

    # ===========================================================
    # T015 - Naming Conventions
    # ===========================================================

    $namingIssues = @()

    # Entities should be in domain/entities/
    $misplacedEntities = @(Get-FlutterFiles -Pattern "*_entity.dart" | Where-Object {
        $_.FullName -notmatch "domain[\\/]entities"
    })
    foreach ($f in $misplacedEntities) {
        $namingIssues += "Entity not in domain/entities/: $(Get-RelativePath $f.FullName)"
    }

    # Models should be in data/models/
    $misplacedModels = @(Get-FlutterFiles -Pattern "*_model.dart" | Where-Object {
        $_.FullName -notmatch "data[\\/]models" -and $_.FullName -notmatch "\\ui\\"
    })
    foreach ($f in $misplacedModels) {
        $namingIssues += "Model not in data/models/: $(Get-RelativePath $f.FullName)"
    }

    # Repo interfaces should be i_*_repository.dart in domain/repositories/
    $misplacedRepoI = @(Get-FlutterFiles -Pattern "i_*_repository.dart" | Where-Object {
        $_.FullName -notmatch "domain[\\/]repositories"
    })
    foreach ($f in $misplacedRepoI) {
        $namingIssues += "Repo interface not in domain/repositories/: $(Get-RelativePath $f.FullName)"
    }

    # Repo impls should be in data/repositories/
    $misplacedRepoImpl = @(Get-FlutterFiles -Pattern "*_repository_impl.dart" | Where-Object {
        $_.FullName -notmatch "data[\\/]repositories"
    })
    foreach ($f in $misplacedRepoImpl) {
        $namingIssues += "Repo impl not in data/repositories/: $(Get-RelativePath $f.FullName)"
    }

    if ($namingIssues.Count -eq 0) {
        Add-GateResult -GateNum 2 -Rule "naming-conventions" -Status "PASS" -Message "All files correctly placed"
        Write-RuleResult -Rule "naming-conventions" -Status "PASS" -Message "Naming + placement OK"
    }
    else {
        Add-GateResult -GateNum 2 -Rule "naming-conventions" -Status "WARN" -Message "$($namingIssues.Count) placement issues" -Details $namingIssues
        Write-RuleResult -Rule "naming-conventions" -Status "WARN" -Message "$($namingIssues.Count) placement issues"
        foreach ($issue in $namingIssues | Select-Object -First 5) {
            Write-Host "    $issue" -ForegroundColor DarkYellow
        }
    }
}
