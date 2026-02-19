<#
.SYNOPSIS
    Renames the Flutter project to a new name and bundle ID.

.DESCRIPTION
    This script renames all occurrences of the template project name
    and bundle identifier to your new project name.

.PARAMETER Name
    The new project name in snake_case (e.g., my_awesome_app)

.PARAMETER BundleId
    The new bundle identifier (e.g., com.mycompany.myawesomeapp)

.EXAMPLE
    .\rename_project.ps1 -Name "my_app" -BundleId "com.company.myapp"
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$Name,
    
    [Parameter(Mandatory=$true)]
    [string]$BundleId,

    [switch]$Force
)

$ErrorActionPreference = "Stop"

# Configuration
$OldName = "vtt_flutter_template"
$OldBundleId = "com.example.vtt_flutter_template"
$OldBundlePath = "com/example/vtt_flutter_template"

# Derived values
$NewBundlePath = $BundleId -replace '\.', '/'
$PascalCaseName = ($Name -split '_' | ForEach-Object { $_.Substring(0,1).ToUpper() + $_.Substring(1) }) -join ''
$OldPascalCase = "VttFlutterTemplate"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Flutter Project Renaming Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Old Name: $OldName" -ForegroundColor Yellow
Write-Host "New Name: $Name" -ForegroundColor Green
Write-Host "Old Bundle: $OldBundleId" -ForegroundColor Yellow
Write-Host "New Bundle: $BundleId" -ForegroundColor Green
Write-Host ""

# Confirm
if (-not $Force) {
    $confirm = Read-Host "Continue? (y/n)"
    if ($confirm -ne 'y') {
        Write-Host "Aborted." -ForegroundColor Red
        exit 1
    }
}

Write-Host ""
Write-Host "Renaming project..." -ForegroundColor Cyan

# Function to replace content in file
function Replace-InFile {
    param(
        [string]$FilePath,
        [string]$OldValue,
        [string]$NewValue
    )
    
    if (Test-Path $FilePath) {
        $content = Get-Content $FilePath -Raw -Encoding UTF8
        if ($content -match [regex]::Escape($OldValue)) {
            $content = $content -replace [regex]::Escape($OldValue), $NewValue
            Set-Content $FilePath $content -Encoding UTF8 -NoNewline
            Write-Host "  Updated: $FilePath" -ForegroundColor Gray
        }
    }
}

# 1. Update pubspec.yaml
Write-Host "`n[1/7] Updating pubspec.yaml..." -ForegroundColor White
Replace-InFile "pubspec.yaml" "name: $OldName" "name: $Name"
Replace-InFile "pubspec.yaml" "description: A new Flutter project." "description: $PascalCaseName Flutter application."

# 2. Update Android files
Write-Host "[2/7] Updating Android configuration..." -ForegroundColor White
Replace-InFile "android/app/build.gradle.kts" "namespace = `"$OldBundleId`"" "namespace = `"$BundleId`""
Replace-InFile "android/app/build.gradle.kts" "applicationId = `"$OldBundleId`"" "applicationId = `"$BundleId`""
Replace-InFile "android/app/src/main/AndroidManifest.xml" $OldBundleId $BundleId

# Rename Kotlin directory structure
$oldKotlinPath = "android/app/src/main/kotlin/$OldBundlePath"
$newKotlinPath = "android/app/src/main/kotlin/$NewBundlePath"

if (Test-Path $oldKotlinPath) {
    # Create new directory structure
    $newKotlinDir = Split-Path $newKotlinPath -Parent
    New-Item -ItemType Directory -Path $newKotlinDir -Force | Out-Null
    
    # Move MainActivity
    if (Test-Path "$oldKotlinPath/MainActivity.kt") {
        $mainActivityContent = Get-Content "$oldKotlinPath/MainActivity.kt" -Raw
        $mainActivityContent = $mainActivityContent -replace "package $OldBundleId", "package $BundleId"
        
        New-Item -ItemType Directory -Path $newKotlinPath -Force | Out-Null
        Set-Content "$newKotlinPath/MainActivity.kt" $mainActivityContent -Encoding UTF8
        
        # Remove old directory
        Remove-Item "android/app/src/main/kotlin/com/example" -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "  Moved MainActivity.kt" -ForegroundColor Gray
    }
}

# 3. Update iOS files
Write-Host "[3/7] Updating iOS configuration..." -ForegroundColor White
Replace-InFile "ios/Runner.xcodeproj/project.pbxproj" $OldBundleId $BundleId
Replace-InFile "ios/Runner.xcodeproj/project.pbxproj" $OldName $Name

# 4. Update Web files
Write-Host "[4/7] Updating Web configuration..." -ForegroundColor White
Replace-InFile "web/index.html" "<title>$OldName</title>" "<title>$PascalCaseName</title>"
Replace-InFile "web/manifest.json" "`"name`": `"$OldName`"" "`"name`": `"$PascalCaseName`""
Replace-InFile "web/manifest.json" "`"short_name`": `"$OldName`"" "`"short_name`": `"$PascalCaseName`""

# 5. Update Linux files
Write-Host "[5/7] Updating Linux configuration..." -ForegroundColor White
Replace-InFile "linux/CMakeLists.txt" "set(BINARY_NAME `"$OldName`")" "set(BINARY_NAME `"$Name`")"

# 6. Update Windows files
Write-Host "[6/7] Updating Windows configuration..." -ForegroundColor White
Replace-InFile "windows/CMakeLists.txt" "set(BINARY_NAME `"$OldName`")" "set(BINARY_NAME `"$Name`")"

# 7. Update macOS files
Write-Host "[7/7] Updating macOS configuration..." -ForegroundColor White
Replace-InFile "macos/Runner.xcodeproj/project.pbxproj" $OldBundleId $BundleId

# 8. Update Dart imports
Write-Host "`nUpdating Dart imports..." -ForegroundColor Cyan
Get-ChildItem -Path "lib", "test", "integration_test" -Recurse -Filter "*.dart" -ErrorAction SilentlyContinue | ForEach-Object {
    Replace-InFile $_.FullName "package:$OldName/" "package:$Name/"
}

# 9. Update .iml files
Write-Host "Updating IDE files..." -ForegroundColor Cyan
if ((Test-Path "$OldName.iml") -and -not (Test-Path "$Name.iml")) {
    Rename-Item "$OldName.iml" "$Name.iml" -Force
} elseif (Test-Path "$OldName.iml") {
    Remove-Item "$OldName.iml" -Force
}

# Clean and get dependencies
Write-Host "`nRunning flutter clean..." -ForegroundColor Cyan
flutter clean

Write-Host "Running flutter pub get..." -ForegroundColor Cyan
flutter pub get

Write-Host "`n========================================" -ForegroundColor Green
Write-Host "  Project renamed successfully!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Run: dart run build_runner build --delete-conflicting-outputs"
Write-Host "  2. Update app icons: flutter pub run flutter_launcher_icons"
Write-Host "  3. Configure your environments in lib/core/config/env/"
Write-Host "  4. Update README.md with your project info"
Write-Host ""
