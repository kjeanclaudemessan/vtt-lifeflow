<#
.SYNOPSIS
    Mobile Loop - Automated build, install, and visual testing pipeline.

.DESCRIPTION
    Orchestrates the Mobile MCP visual testing loop:
      1. Build Flutter APK (debug)
      2. Install on emulator via ADB
      3. Launch app via ADB
      4. Output instructions for Copilot MCP navigation + screenshots
    
    The actual screen navigation and screenshot capture is done by Copilot
    using Mobile MCP tools (mobile_screenshot, mobile_list_elements, etc.).
    This script handles the build/install/infrastructure side.

.PARAMETER ScreenMap
    Path to the screen map JSON (default: scripts/mobile/screen-maps/lifeflow.json)

.PARAMETER SkipBuild
    Skip the APK build step (reuse existing APK)

.PARAMETER SkipInstall
    Skip the APK install step

.PARAMETER Clean
    Clean build before building

.PARAMETER EmulatorName
    AVD name (default: Pixel_6_Pro_API_30)

.EXAMPLE
    .\mobile-loop.ps1
    .\mobile-loop.ps1 -SkipBuild
    .\mobile-loop.ps1 -ScreenMap "scripts/mobile/screen-maps/lifeflow.json"
#>

[CmdletBinding()]
param(
    [string]$ScreenMap = "",
    [switch]$SkipBuild,
    [switch]$SkipInstall,
    [switch]$Clean,
    [string]$EmulatorName = "Pixel_6_Pro_API_34",
    [string]$EnvFile = ".env.staging"
)

$ErrorActionPreference = "Stop"

# ===================================================================
# CONFIGURATION
# ===================================================================

$RepoRoot = (Resolve-Path "$PSScriptRoot/../..").Path
$FlutterRoot = Join-Path $RepoRoot "flutter"
$ApkPath = Join-Path $FlutterRoot "build/app/outputs/flutter-apk/app-debug.apk"
$ScreenshotDir = Join-Path $RepoRoot "docs/screenshots"
$AndroidHome = $env:ANDROID_HOME
if (-not $AndroidHome) { $AndroidHome = "C:\Users\LENOVO\AppData\Local\Android\Sdk" }
$Adb = Join-Path $AndroidHome "platform-tools\adb.exe"
$Emulator = Join-Path $AndroidHome "emulator\emulator.exe"

# Default screen map
if (-not $ScreenMap) {
    $ScreenMap = Join-Path $PSScriptRoot "screen-maps\lifeflow.json"
}

# ===================================================================
# HELPERS
# ===================================================================

function Write-Step {
    param([string]$Icon, [string]$Message)
    Write-Host ""
    Write-Host "  $Icon $Message" -ForegroundColor Cyan
    Write-Host "  $('-' * 50)" -ForegroundColor DarkGray
}

function Write-Ok {
    param([string]$Message)
    Write-Host "  [OK] $Message" -ForegroundColor Green
}

function Write-Err {
    param([string]$Message)
    Write-Host "  [ERR] $Message" -ForegroundColor Red
}

function Write-Info {
    param([string]$Message)
    Write-Host "  [i] $Message" -ForegroundColor DarkGray
}

# ===================================================================
# STEP 0: VALIDATE PREREQUISITES
# ===================================================================

Write-Host ""
Write-Host "==========================================================" -ForegroundColor White
Write-Host "  MOBILE LOOP - Visual Testing Pipeline" -ForegroundColor White
Write-Host "==========================================================" -ForegroundColor White
Write-Host "  $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"

Write-Step "0" "Validating prerequisites"

# Check screen map
if (-not (Test-Path $ScreenMap)) {
    Write-Err "Screen map not found: $ScreenMap"
    exit 1
}
$map = Get-Content $ScreenMap -Raw | ConvertFrom-Json
$package = $map.app.package
$appName = $map.app.name
Write-Ok "Screen map loaded: $appName ($package) - $($map.screens.Count) screens"

# Check ADB
if (-not (Test-Path $Adb)) {
    Write-Err "ADB not found at: $Adb"
    Write-Err "Set ANDROID_HOME environment variable"
    exit 1
}
Write-Ok "ADB found"

# Check Flutter
Push-Location $FlutterRoot
try {
    $flutterVersion = flutter --version 2>&1 | Select-Object -First 1
    Write-Ok "Flutter: $flutterVersion"
}
catch {
    Write-Err "Flutter not found in PATH"
    exit 1
}

# ===================================================================
# STEP 1: CHECK EMULATOR
# ===================================================================

Write-Step "1" "Checking emulator"

$devices = & $Adb devices 2>&1 | Where-Object { $_ -match "emulator-\d+\s+device" }
if ($devices) {
    Write-Ok "Emulator connected: $($devices[0].ToString().Trim())"
}
else {
    Write-Info "No emulator running. Starting $EmulatorName..."
    Start-Process -FilePath $Emulator -ArgumentList "-avd", $EmulatorName, "-no-audio", "-no-boot-anim", "-gpu", "swiftshader_indirect"
    
    # Wait for boot (max 180s)
    $timeout = 180
    $elapsed = 0
    while ($elapsed -lt $timeout) {
        Start-Sleep -Seconds 5
        $elapsed += 5
        $boot = (& $Adb shell getprop sys.boot_completed 2>$null).Trim()
        if ($boot -eq "1") { break }
        Write-Info "Waiting for boot... ($elapsed s)"
    }
    
    if ($boot -ne "1") {
        Write-Err "Emulator failed to boot within ${timeout}s"
        exit 1
    }
    Write-Ok "Emulator booted: $EmulatorName"
}

# ===================================================================
# STEP 2: BUILD APK
# ===================================================================

if (-not $SkipBuild) {
    Write-Step "2" "Building debug APK"
    
    if ($Clean) {
        Write-Info "Cleaning build..."
        flutter clean 2>&1 | Out-Null
        flutter pub get 2>&1 | Out-Null
    }
    
    $envFilePath = Join-Path $FlutterRoot $EnvFile
    if (Test-Path $envFilePath) {
        Write-Info "Using env file: $EnvFile"
        $buildOutput = flutter build apk --debug --dart-define-from-file=$envFilePath 2>&1
    } else {
        $buildOutput = flutter build apk --debug 2>&1
    }
    if ($LASTEXITCODE -ne 0) {
        Write-Err "APK build failed!"
        $buildOutput | ForEach-Object { Write-Host "  $_" -ForegroundColor Red }
        exit 1
    }
    Write-Ok "APK built: $ApkPath"
}
else {
    Write-Step "2" "Skipping build (--SkipBuild)"
    if (-not (Test-Path $ApkPath)) {
        Write-Err "No APK found at: $ApkPath"
        Write-Err "Run without -SkipBuild first"
        exit 1
    }
    Write-Ok "Using existing APK"
}

# ===================================================================
# STEP 3: INSTALL APK
# ===================================================================

if (-not $SkipInstall) {
    Write-Step "3" "Installing APK on emulator"
    
    $installOutput = & $Adb install -r $ApkPath 2>&1
    if ($installOutput -match "Success") {
        Write-Ok "APK installed: $package"
    }
    else {
        Write-Err "Install failed: $installOutput"
        exit 1
    }
}
else {
    Write-Step "3" "Skipping install (--SkipInstall)"
}

# ===================================================================
# STEP 4: LAUNCH APP
# ===================================================================

Write-Step "4" "Launching app"

& $Adb shell am start -n "$package/.MainActivity" 2>&1 | Out-Null
Start-Sleep -Seconds 3
Write-Ok "App launched: $package"

# ===================================================================
# STEP 5: PREPARE SCREENSHOT DIRECTORY
# ===================================================================

Write-Step "5" "Preparing screenshot directory"

if (Test-Path $ScreenshotDir) {
    Remove-Item -Path $ScreenshotDir -Recurse -Force
}

foreach ($screen in $map.screens) {
    if ($screen.skipScreenshot) { continue }
    $dir = Join-Path $ScreenshotDir $screen.id
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
}
Write-Ok "Screenshot directories created at: docs/screenshots/"

# ===================================================================
# STEP 6: OUTPUT MCP NAVIGATION INSTRUCTIONS
# ===================================================================

Write-Step "6" "MCP Navigation Plan"

Write-Host ""
Write-Host "  The app is running on the emulator." -ForegroundColor Yellow
Write-Host "  Use Mobile MCP tools to navigate and capture:" -ForegroundColor Yellow
Write-Host ""

$screensToCapture = $map.screens | Where-Object { -not $_.skipScreenshot }
$idx = 1
foreach ($screen in $screensToCapture) {
    Write-Host "  [$idx] $($screen.name) ($($screen.id))" -ForegroundColor White
    if ($screen.navigateAction) {
        Write-Host "      Navigate: $($screen.navigateAction)" -ForegroundColor DarkGray
    }
    Write-Host "      -> mobile_screenshot -> docs/screenshots/$($screen.id)/screenshot.png" -ForegroundColor DarkGray
    Write-Host "      -> mobile_list_elements -> docs/screenshots/$($screen.id)/accessibility-tree.json" -ForegroundColor DarkGray
    $idx++
}

Write-Host ""
Write-Host "  Dark mode: Toggle theme in settings, then re-capture as *-dark.png" -ForegroundColor DarkGray

# ===================================================================
# SUMMARY
# ===================================================================

Write-Host ""
Write-Host "==========================================================" -ForegroundColor White
Write-Host "  MOBILE LOOP READY" -ForegroundColor White
Write-Host "==========================================================" -ForegroundColor White
Write-Host "  App: $appName ($package)" -ForegroundColor Green
Write-Host "  Screens: $($screensToCapture.Count) to capture" -ForegroundColor Green
Write-Host "  Output: docs/screenshots/" -ForegroundColor Green
Write-Host ""
Write-Host "  Next: Use Copilot with Mobile MCP tools to navigate and screenshot." -ForegroundColor Yellow
Write-Host ""

Pop-Location

# Return screen map data for programmatic use
return @{
    package   = $package
    appName   = $appName
    screens   = $screensToCapture
    outputDir = $ScreenshotDir
    status    = "ready"
}
