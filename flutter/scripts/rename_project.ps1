<#
.SYNOPSIS
    Renames the Flutter project to a new name and bundle ID.

.DESCRIPTION
    Comprehensive rename script that updates ALL occurrences of the template
    project name and bundle identifier across every platform and config file.
    Designed to be idempotent — detects current values and replaces them.

.PARAMETER Name
    The new project name in snake_case (e.g., my_awesome_app)

.PARAMETER DisplayName
    The human-readable app name (e.g., "My Awesome App"). If omitted, derived from Name.

.PARAMETER BundleId
    The new bundle identifier (e.g., com.mycompany.myawesomeapp)

.PARAMETER OrgName
    Organisation name for metadata (e.g., "Vitatech"). Optional.

.PARAMETER DryRun
    Preview changes without modifying files.

.PARAMETER Force
    Skip confirmation prompt.

.EXAMPLE
    .\rename_project.ps1 -Name "lifeflow" -DisplayName "LifeFlow" -BundleId "com.vitatech.lifeflow" -OrgName "Vitatech"
    .\rename_project.ps1 -Name "my_app" -BundleId "com.company.myapp" -DryRun
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$Name,

    [string]$DisplayName,
    
    [Parameter(Mandatory=$true)]
    [string]$BundleId,

    [string]$OrgName,

    [switch]$DryRun,

    [switch]$Force
)

$ErrorActionPreference = "Stop"

# ── Derived values ───────────────────────────────────────────────────
$NewBundlePath = $BundleId -replace '\.', '/'
$PascalCase = ($Name -split '_' | ForEach-Object { $_.Substring(0,1).ToUpper() + $_.Substring(1) }) -join ''
if (-not $DisplayName) { $DisplayName = $PascalCase }

# ── Detect current values (idempotent — works on fresh template or partially renamed) ──
# Reads the current name from pubspec.yaml
$pubspecContent = Get-Content "pubspec.yaml" -Raw -Encoding UTF8
if ($pubspecContent -match 'name:\s+(\S+)') {
    $CurrentName = $Matches[1]
} else {
    $CurrentName = "vtt_flutter_template"
}
$CurrentPascalCase = ($CurrentName -split '_' | ForEach-Object { $_.Substring(0,1).ToUpper() + $_.Substring(1) }) -join ''

# Detect current bundle ID from build.gradle.kts
$gradleContent = Get-Content "android/app/build.gradle.kts" -Raw -Encoding UTF8
if ($gradleContent -match 'applicationId\s*=\s*"([^"]+)"') {
    $CurrentBundleId = $Matches[1]
} else {
    $CurrentBundleId = "com.example.vtt_flutter_template"
}
$CurrentBundlePath = $CurrentBundleId -replace '\.', '/'

# Also search for legacy template values that may remain
$LegacyName = "vtt_flutter_template"
$LegacyBundleId = "com.example.vtt_flutter_template"
$LegacyBundlePath = "com/example/vtt_flutter_template"
$LegacyPascalCase = "VttFlutterTemplate"
$LegacyDisplayName = "Vtt Flutter Template"

Write-Host "═══════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  Flutter Project Renaming Script (v2)    " -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Current Name   : $CurrentName ($CurrentBundleId)" -ForegroundColor Yellow
Write-Host "  New Name       : $Name ($BundleId)" -ForegroundColor Green
Write-Host "  Display Name   : $DisplayName" -ForegroundColor Green
Write-Host "  PascalCase     : $PascalCase" -ForegroundColor Green
if ($OrgName) { Write-Host "  Organisation   : $OrgName" -ForegroundColor Green }
if ($DryRun) { Write-Host "  Mode           : DRY RUN (no changes)" -ForegroundColor Magenta }
Write-Host ""

if ($CurrentName -eq $Name -and $CurrentBundleId -eq $BundleId) {
    # Even if names match, check for legacy remnants
    $legacyFound = $false
    $filesToCheck = @(
        "android/app/src/main/AndroidManifest.xml",
        "web/index.html",
        "windows/runner/Runner.rc",
        "windows/runner/main.cpp",
        "windows/CMakeLists.txt",
        "linux/runner/my_application.cc",
        "linux/CMakeLists.txt",
        "macos/Runner.xcodeproj/xcshareddata/xcschemes/Runner.xcscheme",
        "macos/Runner/Configs/AppInfo.xcconfig",
        "macos/Runner.xcodeproj/project.pbxproj",
        "ios/Runner/Info.plist",
        "pubspec_patrol.yaml"
    )
    foreach ($f in $filesToCheck) {
        if (Test-Path $f) {
            $c = Get-Content $f -Raw -Encoding UTF8 -ErrorAction SilentlyContinue
            if ($c -match [regex]::Escape($LegacyName) -or $c -match [regex]::Escape($LegacyBundleId) -or $c -match [regex]::Escape($LegacyDisplayName)) {
                $legacyFound = $true
                break
            }
        }
    }
    if (-not $legacyFound) {
        Write-Host "Project is already named '$Name' with bundle '$BundleId'. Nothing to do." -ForegroundColor Green
        exit 0
    }
    Write-Host "  Legacy template values found — cleaning up..." -ForegroundColor Yellow
}

# Confirm
if (-not $Force -and -not $DryRun) {
    $confirm = Read-Host "Continue? (y/n)"
    if ($confirm -ne 'y') {
        Write-Host "Aborted." -ForegroundColor Red
        exit 1
    }
}

# ── Counters ─────────────────────────────────────────────────────────
$script:changedFiles = 0
$script:totalReplacements = 0

# ── Replace function ─────────────────────────────────────────────────
function Replace-InFile {
    param(
        [string]$FilePath,
        [string]$OldValue,
        [string]$NewValue
    )
    
    if (-not (Test-Path $FilePath)) { return }
    if ($OldValue -eq $NewValue) { return }
    
    $content = Get-Content $FilePath -Raw -Encoding UTF8
    if ($content -match [regex]::Escape($OldValue)) {
        $count = ([regex]::Matches($content, [regex]::Escape($OldValue))).Count
        if ($DryRun) {
            Write-Host "  [DRY] Would update: $FilePath ($count replacements)" -ForegroundColor Magenta
        } else {
            $content = $content -replace [regex]::Escape($OldValue), $NewValue
            Set-Content $FilePath $content -Encoding UTF8 -NoNewline
            Write-Host "  Updated: $FilePath ($count)" -ForegroundColor Gray
        }
        $script:changedFiles++
        $script:totalReplacements += $count
    }
}

# Helper: replace both current and legacy values in a file
function Replace-AllVariants {
    param(
        [string]$FilePath,
        [hashtable]$Replacements  # @{ "old" = "new" }
    )
    foreach ($old in $Replacements.Keys) {
        Replace-InFile $FilePath $old $Replacements[$old]
    }
}

Write-Host "Renaming project..." -ForegroundColor Cyan

# ═══════════════════════════════════════════════════════════════════════
# [1/12] pubspec.yaml
# ═══════════════════════════════════════════════════════════════════════
Write-Host "`n[1/12] pubspec.yaml" -ForegroundColor White
Replace-InFile "pubspec.yaml" "name: $CurrentName" "name: $Name"
Replace-InFile "pubspec.yaml" "name: $LegacyName" "name: $Name"
Replace-InFile "pubspec.yaml" "description: A new Flutter project." "description: $DisplayName Flutter application."

# ═══════════════════════════════════════════════════════════════════════
# [2/12] pubspec_patrol.yaml
# ═══════════════════════════════════════════════════════════════════════
Write-Host "[2/12] pubspec_patrol.yaml" -ForegroundColor White
Replace-InFile "pubspec_patrol.yaml" $LegacyBundleId $BundleId
Replace-InFile "pubspec_patrol.yaml" $CurrentBundleId $BundleId

# ═══════════════════════════════════════════════════════════════════════
# [3/12] Android
# ═══════════════════════════════════════════════════════════════════════
Write-Host "[3/12] Android (build.gradle, AndroidManifest, Kotlin, Fastlane)" -ForegroundColor White

# build.gradle.kts — namespace + applicationId
Replace-AllVariants "android/app/build.gradle.kts" @{
    "namespace = `"$CurrentBundleId`"" = "namespace = `"$BundleId`""
    "applicationId = `"$CurrentBundleId`"" = "applicationId = `"$BundleId`""
    "namespace = `"$LegacyBundleId`"" = "namespace = `"$BundleId`""
    "applicationId = `"$LegacyBundleId`"" = "applicationId = `"$BundleId`""
}

# AndroidManifest.xml — label + any bundle references
Replace-InFile "android/app/src/main/AndroidManifest.xml" "android:label=`"$LegacyName`"" "android:label=`"$DisplayName`""
Replace-InFile "android/app/src/main/AndroidManifest.xml" "android:label=`"$CurrentName`"" "android:label=`"$DisplayName`""

# Debug/Profile AndroidManifests
foreach ($variant in @("debug", "profile")) {
    $manifestPath = "android/app/src/main/$variant/AndroidManifest.xml"
    Replace-InFile $manifestPath $CurrentBundleId $BundleId
    Replace-InFile $manifestPath $LegacyBundleId $BundleId
}

# Kotlin directory + MainActivity
$kotlinPaths = @(
    "android/app/src/main/kotlin/$CurrentBundlePath",
    "android/app/src/main/kotlin/$LegacyBundlePath"
)
foreach ($oldKotlinPath in $kotlinPaths) {
    if ((Test-Path $oldKotlinPath) -and $oldKotlinPath -ne "android/app/src/main/kotlin/$NewBundlePath") {
        if ($DryRun) {
            Write-Host "  [DRY] Would move Kotlin: $oldKotlinPath → android/app/src/main/kotlin/$NewBundlePath" -ForegroundColor Magenta
        } else {
            New-Item -ItemType Directory -Path "android/app/src/main/kotlin/$NewBundlePath" -Force | Out-Null
            if (Test-Path "$oldKotlinPath/MainActivity.kt") {
                $mainActivityContent = Get-Content "$oldKotlinPath/MainActivity.kt" -Raw
                $mainActivityContent = $mainActivityContent -replace "package $CurrentBundleId", "package $BundleId"
                $mainActivityContent = $mainActivityContent -replace "package $LegacyBundleId", "package $BundleId"
                Set-Content "android/app/src/main/kotlin/$NewBundlePath/MainActivity.kt" $mainActivityContent -Encoding UTF8 -NoNewline
                Write-Host "  Moved: MainActivity.kt" -ForegroundColor Gray
            }
            # Clean old directories
            $oldRoot = ($oldKotlinPath -split '/')[0..5] -join '/'  # android/app/src/main/kotlin/com
            Remove-Item $oldKotlinPath -Recurse -Force -ErrorAction SilentlyContinue
        }
        $script:changedFiles++
    }
}

# Fastlane
Replace-InFile "android/fastlane/Appfile" $CurrentBundleId $BundleId
Replace-InFile "android/fastlane/Appfile" $LegacyBundleId $BundleId

# ═══════════════════════════════════════════════════════════════════════
# [4/12] iOS
# ═══════════════════════════════════════════════════════════════════════
Write-Host "[4/12] iOS (pbxproj, Info.plist, Fastlane)" -ForegroundColor White

Replace-AllVariants "ios/Runner.xcodeproj/project.pbxproj" @{
    $CurrentBundleId = $BundleId
    $LegacyBundleId = $BundleId
    $CurrentName = $Name
    $LegacyName = $Name
}

# Info.plist — display name + bundle name
Replace-InFile "ios/Runner/Info.plist" "<string>$LegacyDisplayName</string>" "<string>$DisplayName</string>"
Replace-InFile "ios/Runner/Info.plist" "<string>$LegacyName</string>" "<string>$Name</string>"
Replace-InFile "ios/Runner/Info.plist" "<string>$CurrentName</string>" "<string>$Name</string>"

# Fastlane
Replace-InFile "ios/fastlane/Appfile" $CurrentBundleId $BundleId
Replace-InFile "ios/fastlane/Appfile" $LegacyBundleId $BundleId
Replace-InFile "ios/fastlane/Matchfile" $CurrentBundleId $BundleId
Replace-InFile "ios/fastlane/Matchfile" $LegacyBundleId $BundleId

# ═══════════════════════════════════════════════════════════════════════
# [5/12] Web
# ═══════════════════════════════════════════════════════════════════════
Write-Host "[5/12] Web (index.html, manifest.json)" -ForegroundColor White
Replace-InFile "web/index.html" "<title>$LegacyName</title>" "<title>$DisplayName</title>"
Replace-InFile "web/index.html" "<title>$CurrentPascalCase</title>" "<title>$DisplayName</title>"
Replace-InFile "web/index.html" "<title>$CurrentName</title>" "<title>$DisplayName</title>"
Replace-InFile "web/index.html" "content=`"$LegacyName`"" "content=`"$DisplayName`""
Replace-InFile "web/index.html" "content=`"$CurrentName`"" "content=`"$DisplayName`""
Replace-InFile "web/manifest.json" "`"name`": `"$LegacyName`"" "`"name`": `"$DisplayName`""
Replace-InFile "web/manifest.json" "`"name`": `"$CurrentPascalCase`"" "`"name`": `"$DisplayName`""
Replace-InFile "web/manifest.json" "`"short_name`": `"$LegacyName`"" "`"short_name`": `"$DisplayName`""
Replace-InFile "web/manifest.json" "`"short_name`": `"$CurrentPascalCase`"" "`"short_name`": `"$DisplayName`""

# ═══════════════════════════════════════════════════════════════════════
# [6/12] Linux
# ═══════════════════════════════════════════════════════════════════════
Write-Host "[6/12] Linux (CMakeLists, my_application.cc)" -ForegroundColor White
Replace-InFile "linux/CMakeLists.txt" "set(BINARY_NAME `"$LegacyName`")" "set(BINARY_NAME `"$Name`")"
Replace-InFile "linux/CMakeLists.txt" "set(BINARY_NAME `"$CurrentName`")" "set(BINARY_NAME `"$Name`")"
Replace-InFile "linux/CMakeLists.txt" "set(APPLICATION_ID `"$LegacyBundleId`")" "set(APPLICATION_ID `"$BundleId`")"
Replace-InFile "linux/CMakeLists.txt" "set(APPLICATION_ID `"$CurrentBundleId`")" "set(APPLICATION_ID `"$BundleId`")"
Replace-InFile "linux/runner/my_application.cc" "`"$LegacyName`"" "`"$DisplayName`""
Replace-InFile "linux/runner/my_application.cc" "`"$CurrentName`"" "`"$DisplayName`""

# ═══════════════════════════════════════════════════════════════════════
# [7/12] Windows
# ═══════════════════════════════════════════════════════════════════════
Write-Host "[7/12] Windows (CMakeLists, Runner.rc, main.cpp)" -ForegroundColor White
Replace-InFile "windows/CMakeLists.txt" "project($LegacyName " "project($Name "
Replace-InFile "windows/CMakeLists.txt" "project($CurrentName " "project($Name "
Replace-InFile "windows/CMakeLists.txt" "set(BINARY_NAME `"$LegacyName`")" "set(BINARY_NAME `"$Name`")"
Replace-InFile "windows/CMakeLists.txt" "set(BINARY_NAME `"$CurrentName`")" "set(BINARY_NAME `"$Name`")"
Replace-InFile "windows/runner/Runner.rc" "`"$LegacyName`"" "`"$DisplayName`""
Replace-InFile "windows/runner/Runner.rc" "$LegacyName.exe" "$Name.exe"
Replace-InFile "windows/runner/main.cpp" "L`"$LegacyName`"" "L`"$DisplayName`""
Replace-InFile "windows/runner/main.cpp" "L`"$CurrentName`"" "L`"$DisplayName`""

# ═══════════════════════════════════════════════════════════════════════
# [8/12] macOS
# ═══════════════════════════════════════════════════════════════════════
Write-Host "[8/12] macOS (pbxproj, xcscheme, AppInfo.xcconfig)" -ForegroundColor White
Replace-InFile "macos/Runner.xcodeproj/project.pbxproj" "$LegacyName.app" "$Name.app"
Replace-InFile "macos/Runner.xcodeproj/project.pbxproj" $LegacyBundleId $BundleId
Replace-InFile "macos/Runner.xcodeproj/project.pbxproj" $LegacyName $Name
Replace-InFile "macos/Runner.xcodeproj/xcshareddata/xcschemes/Runner.xcscheme" "$LegacyName.app" "$Name.app"
Replace-InFile "macos/Runner/Configs/AppInfo.xcconfig" "PRODUCT_NAME = $LegacyName" "PRODUCT_NAME = $Name"
Replace-InFile "macos/Runner/Configs/AppInfo.xcconfig" "PRODUCT_NAME = $CurrentName" "PRODUCT_NAME = $Name"

# ═══════════════════════════════════════════════════════════════════════
# [9/12] Dart imports
# ═══════════════════════════════════════════════════════════════════════
Write-Host "[9/12] Dart imports (lib/, test/, integration_test/)" -ForegroundColor White
$dartDirs = @("lib", "test", "integration_test")
foreach ($dir in $dartDirs) {
    if (Test-Path $dir) {
        Get-ChildItem -Path $dir -Recurse -Filter "*.dart" -ErrorAction SilentlyContinue | ForEach-Object {
            Replace-InFile $_.FullName "package:$LegacyName/" "package:$Name/"
            if ($CurrentName -ne $LegacyName) {
                Replace-InFile $_.FullName "package:$CurrentName/" "package:$Name/"
            }
        }
    }
}

# ═══════════════════════════════════════════════════════════════════════
# [10/12] Environment configs
# ═══════════════════════════════════════════════════════════════════════
Write-Host "[10/12] Environment configs (appName in env configs)" -ForegroundColor White
$envDir = "lib/core/config/env"
if (Test-Path $envDir) {
    Get-ChildItem -Path $envDir -Filter "*.dart" -ErrorAction SilentlyContinue | ForEach-Object {
        Replace-InFile $_.FullName '"MyApp Staging"' "`"$DisplayName Staging`""
        Replace-InFile $_.FullName '"MyApp"' "`"$DisplayName`""
        Replace-InFile $_.FullName "'MyApp Staging'" "'$DisplayName Staging'"
        Replace-InFile $_.FullName "'MyApp'" "'$DisplayName'"
    }
}

# ═══════════════════════════════════════════════════════════════════════
# [11/16] IDE + misc files
# ═══════════════════════════════════════════════════════════════════════
Write-Host "[11/16] IDE + misc files (.iml, README)" -ForegroundColor White
if ((Test-Path "$LegacyName.iml") -and -not $DryRun) {
    Rename-Item "$LegacyName.iml" "$Name.iml" -Force -ErrorAction SilentlyContinue
}
if ((Test-Path "$CurrentName.iml") -and $CurrentName -ne $Name -and -not $DryRun) {
    Rename-Item "$CurrentName.iml" "$Name.iml" -Force -ErrorAction SilentlyContinue
}

# ═══════════════════════════════════════════════════════════════════════
# [12/16] Documentation files
# ═══════════════════════════════════════════════════════════════════════
Write-Host "[12/16] Documentation files (README, docs/)" -ForegroundColor White
$docFiles = @(
    "README.md",
    "docs/SETUP.md",
    "docs/MODULES_SPECIFICATION.md",
    "docs/ARCHITECTURE.md",
    "docs/PROGRESS.md",
    "docs/COPILOT_CONFIGURATION.md",
    "docs/UNIFIED_DATA_MODEL.md",
    "docs/CHAT_PLATFORM_FLUTTER_IMPLEMENTATION.md"
)
foreach ($f in $docFiles) {
    if (Test-Path $f) {
        Replace-InFile $f "package:$LegacyName/" "package:$Name/"
        Replace-InFile $f $LegacyName $Name
        Replace-InFile $f $LegacyBundleId $BundleId
        Replace-InFile $f $LegacyBundlePath $NewBundlePath
        if ($CurrentName -ne $LegacyName -and $CurrentName -ne $Name) {
            Replace-InFile $f "package:$CurrentName/" "package:$Name/"
            Replace-InFile $f $CurrentName $Name
        }
    }
}

# ═══════════════════════════════════════════════════════════════════════
# [13/16] .github Copilot instructions
# ═══════════════════════════════════════════════════════════════════════
Write-Host "[13/16] .github Copilot instructions" -ForegroundColor White
$ghFiles = @()
if (Test-Path ".github") {
    $ghFiles += Get-ChildItem -Path ".github" -Recurse -Include "*.md" -ErrorAction SilentlyContinue
}
foreach ($f in $ghFiles) {
    Replace-InFile $f.FullName "package:$LegacyName/" "package:$Name/"
    Replace-InFile $f.FullName $LegacyName $Name
    Replace-InFile $f.FullName $LegacyBundleId $BundleId
    if ($CurrentName -ne $LegacyName -and $CurrentName -ne $Name) {
        Replace-InFile $f.FullName "package:$CurrentName/" "package:$Name/"
    }
}

# ═══════════════════════════════════════════════════════════════════════
# [14/16] Secure storage service (template keys)
# ═══════════════════════════════════════════════════════════════════════
Write-Host "[14/16] Secure storage + service keys" -ForegroundColor White
$secureStoragePath = "lib/services/storage/secure_storage_service.dart"
if (Test-Path $secureStoragePath) {
    Replace-InFile $secureStoragePath "'$LegacyName'" "'$Name'"
    Replace-InFile $secureStoragePath "'vtt_secure_storage'" "'${Name}_secure_storage'"
    if ($CurrentName -ne $LegacyName -and $CurrentName -ne $Name) {
        Replace-InFile $secureStoragePath "'$CurrentName'" "'$Name'"
        Replace-InFile $secureStoragePath "'${CurrentName}_secure_storage'" "'${Name}_secure_storage'"
    }
}

# ═══════════════════════════════════════════════════════════════════════
# [15/16] analysis_options + stacked.json
# ═══════════════════════════════════════════════════════════════════════
Write-Host "[15/16] analysis_options + stacked.json" -ForegroundColor White
Replace-InFile "stacked.json" $LegacyName $Name
if ($CurrentName -ne $LegacyName -and $CurrentName -ne $Name) {
    Replace-InFile "stacked.json" $CurrentName $Name
}

# ═══════════════════════════════════════════════════════════════════════
# [16/16] OAuth redirect URL + deep link schemes
# ═══════════════════════════════════════════════════════════════════════
Write-Host "[16/16] OAuth redirect URL + deep link schemes" -ForegroundColor White
$oauthOld = "io.supabase.vttflutter://login-callback/"
$oauthNew = "${BundleId}://login-callback/"
Get-ChildItem -Path "lib" -Recurse -Filter "*.dart" -ErrorAction SilentlyContinue | ForEach-Object {
    Replace-InFile $_.FullName $oauthOld $oauthNew
}
# Also replace current bundle-based redirect (for re-runs)
if ($CurrentBundleId -ne $BundleId) {
    $oauthCurrent = "${CurrentBundleId}://login-callback/"
    Get-ChildItem -Path "lib" -Recurse -Filter "*.dart" -ErrorAction SilentlyContinue | ForEach-Object {
        Replace-InFile $_.FullName $oauthCurrent $oauthNew
    }
}
# Deep link intent-filter in AndroidManifest
Replace-InFile "android/app/src/main/AndroidManifest.xml" "android:scheme=`"$CurrentBundleId`"" "android:scheme=`"$BundleId`""
Replace-InFile "android/app/src/main/AndroidManifest.xml" "android:scheme=`"$LegacyBundleId`"" "android:scheme=`"$BundleId`""
# iOS URL scheme
Replace-InFile "ios/Runner/Info.plist" "<string>$CurrentBundleId</string>" "<string>$BundleId</string>"
# PostHog inAppIncludes (analytics_service.dart)
Replace-InFile "lib/services/analytics/analytics_service.dart" "'package:$CurrentName'" "'package:$Name'"
Replace-InFile "lib/services/analytics/analytics_service.dart" "'package:$LegacyName'" "'package:$Name'"

# ═══════════════════════════════════════════════════════════════════════
# Post-rename: flutter clean + pub get
# ═══════════════════════════════════════════════════════════════════════
if (-not $DryRun) {
    Write-Host "`nRunning flutter clean..." -ForegroundColor Cyan
    flutter clean 2>$null

    Write-Host "Running flutter pub get..." -ForegroundColor Cyan
    flutter pub get 2>$null
}

# ═══════════════════════════════════════════════════════════════════════
# Summary
# ═══════════════════════════════════════════════════════════════════════
Write-Host ""
Write-Host "═══════════════════════════════════════════" -ForegroundColor Green
if ($DryRun) {
    Write-Host "  DRY RUN complete" -ForegroundColor Magenta
} else {
    Write-Host "  Project renamed successfully!" -ForegroundColor Green
}
Write-Host "═══════════════════════════════════════════" -ForegroundColor Green
Write-Host ""
Write-Host "  Files changed  : $($script:changedFiles)" -ForegroundColor Cyan
Write-Host "  Replacements   : $($script:totalReplacements)" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. dart run build_runner build --delete-conflicting-outputs"
Write-Host "  2. Replace app icons (provide 1024x1024 PNG, then use flutter_launcher_icons)"
Write-Host "  3. Configure OAuth providers in Supabase"
Write-Host "  4. Update README.md with your project info"
Write-Host ""
