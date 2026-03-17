<#
.SYNOPSIS
    Gate 7 - Tests: run flutter test + optional coverage
#>

function Invoke-Gate7 {
    param(
        [string]$Scope = "all",
        [System.IO.FileInfo[]]$ScopeFiles = @()
    )

    $flutterDir = Join-Path $PSScriptRoot "..\..\flutter"
    if (-not (Test-Path $flutterDir)) {
        Add-GateResult -GateNum 7 -Rule "flutter-tests" -Status "SKIP" -Message "flutter/ directory not found"
        Write-RuleResult -Rule "flutter-tests" -Status "SKIP" -Message "No flutter/ directory"
        return
    }

    $testDir = Join-Path $flutterDir "test"
    if (-not (Test-Path $testDir)) {
        Add-GateResult -GateNum 7 -Rule "flutter-tests" -Status "SKIP" -Message "flutter/test/ directory not found"
        Write-RuleResult -Rule "flutter-tests" -Status "SKIP" -Message "No test/ directory"
        return
    }

    $testFiles = @(Get-ChildItem -Path $testDir -Filter "*_test.dart" -Recurse -File)
    if ($testFiles.Count -eq 0) {
        Add-GateResult -GateNum 7 -Rule "flutter-tests" -Status "SKIP" -Message "No test files found"
        Write-RuleResult -Rule "flutter-tests" -Status "SKIP" -Message "No *_test.dart files"
        return
    }

    # ── Rule: test-exists - check test coverage per feature/module ────────
    $libDir = Join-Path $flutterDir "lib"
    $featureDirs = @()
    $featuresPath = Join-Path $libDir "features"
    $modulesPath = Join-Path $libDir "modules"

    if (Test-Path $featuresPath) {
        $featureDirs += @(Get-ChildItem -Path $featuresPath -Directory)
    }
    if (Test-Path $modulesPath) {
        $featureDirs += @(Get-ChildItem -Path $modulesPath -Directory)
    }

    foreach ($dir in $featureDirs) {
        $featureName = $dir.Name
        # Check if any test file references this feature
        $hasTest = $false
        $testSubDir = Join-Path $testDir $featureName
        if (Test-Path $testSubDir) {
            $featureTests = @(Get-ChildItem -Path $testSubDir -Filter "*_test.dart" -Recurse -File)
            if ($featureTests.Count -gt 0) { $hasTest = $true }
        }
        # Also check for test files matching the feature name
        if (-not $hasTest) {
            $matchingTests = @($testFiles | Where-Object { $_.Name -match $featureName })
            if ($matchingTests.Count -gt 0) { $hasTest = $true }
        }

        if ($hasTest) {
            Add-GateResult -GateNum 7 -Rule "test-exists" -Status "PASS" -Message "Feature '$featureName' has tests"
            Write-RuleResult -Rule "test-exists" -Status "PASS" -Message "Feature '$featureName' - has tests"
        }
        else {
            Add-GateResult -GateNum 7 -Rule "test-exists" -Status "WARN" -Message "Feature '$featureName' has no tests"
            Write-RuleResult -Rule "test-exists" -Status "WARN" -Message "Feature '$featureName' - no tests"
        }
    }

    # ── Rule: flutter-test-run - actually run tests ──────────────────────
    Push-Location $flutterDir
    try {
        Write-Host "`n  Running flutter test..." -ForegroundColor Cyan

        # Determine scope: specific files or all
        $testArgs = @("test", "--no-pub")
        if ($Scope -eq "file" -and $ScopeFiles.Count -gt 0) {
            $testFilePaths = @($ScopeFiles | Where-Object { $_.Name -match "_test\.dart$" } | ForEach-Object { $_.FullName })
            if ($testFilePaths.Count -eq 0) {
                Add-GateResult -GateNum 7 -Rule "flutter-test-run" -Status "SKIP" -Message "No test files in scope"
                Write-RuleResult -Rule "flutter-test-run" -Status "SKIP" -Message "No test files in scope"
                return
            }
            $testArgs += $testFilePaths
        }

        $result = & flutter @testArgs 2>&1
        $exitCode = $LASTEXITCODE

        if ($exitCode -eq 0) {
            Add-GateResult -GateNum 7 -Rule "flutter-test-run" -Status "PASS" -Message "All tests passed"
            Write-RuleResult -Rule "flutter-test-run" -Status "PASS" -Message "flutter test - all passed"
        }
        else {
            $failureLines = @($result | Select-String -Pattern "FAILED|ERROR|Exception" | Select-Object -First 5)
            $details = ($failureLines | ForEach-Object { $_.Line.Trim() }) -join "; "
            Add-GateResult -GateNum 7 -Rule "flutter-test-run" -Status "FAIL" -Message "Tests failed (exit code $exitCode)" -Details $details
            Write-RuleResult -Rule "flutter-test-run" -Status "FAIL" -Message "flutter test - FAILED (exit $exitCode)"
        }
    }
    catch {
        Add-GateResult -GateNum 7 -Rule "flutter-test-run" -Status "FAIL" -Message "flutter test crashed: $_"
        Write-RuleResult -Rule "flutter-test-run" -Status "FAIL" -Message "flutter test - exception: $_"
    }
    finally {
        Pop-Location
    }
}
