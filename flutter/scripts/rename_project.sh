#!/bin/bash

# ============================================================================
# Flutter Project Renaming Script
# ============================================================================
# Usage: ./rename_project.sh <new_name> <new_bundle_id>
# Example: ./rename_project.sh my_awesome_app com.mycompany.myawesomeapp
# ============================================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Check arguments
if [ $# -ne 2 ]; then
    echo -e "${RED}Usage: $0 <new_name> <new_bundle_id>${NC}"
    echo -e "${YELLOW}Example: $0 my_awesome_app com.mycompany.myawesomeapp${NC}"
    exit 1
fi

NEW_NAME=$1
NEW_BUNDLE_ID=$2

# Old values
OLD_NAME="vtt_flutter_template"
OLD_BUNDLE_ID="com.example.vtt_flutter_template"
OLD_BUNDLE_PATH="com/example/vtt_flutter_template"

# Derived values
NEW_BUNDLE_PATH=$(echo "$NEW_BUNDLE_ID" | sed 's/\./\//g')
NEW_PASCAL_CASE=$(echo "$NEW_NAME" | sed -r 's/(^|_)([a-z])/\U\2/g')
OLD_PASCAL_CASE="VttFlutterTemplate"

echo -e "${CYAN}========================================"
echo -e "  Flutter Project Renaming Script"
echo -e "========================================${NC}"
echo ""
echo -e "${YELLOW}Old Name: ${OLD_NAME}${NC}"
echo -e "${GREEN}New Name: ${NEW_NAME}${NC}"
echo -e "${YELLOW}Old Bundle: ${OLD_BUNDLE_ID}${NC}"
echo -e "${GREEN}New Bundle: ${NEW_BUNDLE_ID}${NC}"
echo ""

read -p "Continue? (y/n) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${RED}Aborted.${NC}"
    exit 1
fi

echo ""
echo -e "${CYAN}Renaming project...${NC}"

# Function to replace in file
replace_in_file() {
    local file=$1
    local old=$2
    local new=$3
    
    if [ -f "$file" ]; then
        if grep -q "$old" "$file" 2>/dev/null; then
            if [[ "$OSTYPE" == "darwin"* ]]; then
                sed -i '' "s|$old|$new|g" "$file"
            else
                sed -i "s|$old|$new|g" "$file"
            fi
            echo -e "  Updated: $file"
        fi
    fi
}

# 1. Update pubspec.yaml
echo -e "\n${NC}[1/7] Updating pubspec.yaml...${NC}"
replace_in_file "pubspec.yaml" "name: $OLD_NAME" "name: $NEW_NAME"
replace_in_file "pubspec.yaml" "description: A new Flutter project." "description: $NEW_PASCAL_CASE Flutter application."

# 2. Update Android files
echo -e "[2/7] Updating Android configuration..."
replace_in_file "android/app/build.gradle.kts" "namespace = \"$OLD_BUNDLE_ID\"" "namespace = \"$NEW_BUNDLE_ID\""
replace_in_file "android/app/build.gradle.kts" "applicationId = \"$OLD_BUNDLE_ID\"" "applicationId = \"$NEW_BUNDLE_ID\""
replace_in_file "android/app/src/main/AndroidManifest.xml" "$OLD_BUNDLE_ID" "$NEW_BUNDLE_ID"

# Rename Kotlin directory structure
OLD_KOTLIN_PATH="android/app/src/main/kotlin/$OLD_BUNDLE_PATH"
NEW_KOTLIN_PATH="android/app/src/main/kotlin/$NEW_BUNDLE_PATH"

if [ -d "$OLD_KOTLIN_PATH" ]; then
    mkdir -p "$NEW_KOTLIN_PATH"
    
    if [ -f "$OLD_KOTLIN_PATH/MainActivity.kt" ]; then
        sed "s|package $OLD_BUNDLE_ID|package $NEW_BUNDLE_ID|g" "$OLD_KOTLIN_PATH/MainActivity.kt" > "$NEW_KOTLIN_PATH/MainActivity.kt"
        rm -rf "android/app/src/main/kotlin/com/example"
        echo "  Moved MainActivity.kt"
    fi
fi

# 3. Update iOS files
echo -e "[3/7] Updating iOS configuration..."
replace_in_file "ios/Runner.xcodeproj/project.pbxproj" "$OLD_BUNDLE_ID" "$NEW_BUNDLE_ID"
replace_in_file "ios/Runner.xcodeproj/project.pbxproj" "$OLD_NAME" "$NEW_NAME"

# 4. Update Web files
echo -e "[4/7] Updating Web configuration..."
replace_in_file "web/index.html" "<title>$OLD_NAME</title>" "<title>$NEW_PASCAL_CASE</title>"
replace_in_file "web/manifest.json" "\"name\": \"$OLD_NAME\"" "\"name\": \"$NEW_PASCAL_CASE\""
replace_in_file "web/manifest.json" "\"short_name\": \"$OLD_NAME\"" "\"short_name\": \"$NEW_PASCAL_CASE\""

# 5. Update Linux files
echo -e "[5/7] Updating Linux configuration..."
replace_in_file "linux/CMakeLists.txt" "set(BINARY_NAME \"$OLD_NAME\")" "set(BINARY_NAME \"$NEW_NAME\")"

# 6. Update Windows files
echo -e "[6/7] Updating Windows configuration..."
replace_in_file "windows/CMakeLists.txt" "set(BINARY_NAME \"$OLD_NAME\")" "set(BINARY_NAME \"$NEW_NAME\")"

# 7. Update macOS files
echo -e "[7/7] Updating macOS configuration..."
replace_in_file "macos/Runner.xcodeproj/project.pbxproj" "$OLD_BUNDLE_ID" "$NEW_BUNDLE_ID"

# 8. Update Dart imports
echo -e "\n${CYAN}Updating Dart imports...${NC}"
find lib test -name "*.dart" -type f 2>/dev/null | while read -r file; do
    replace_in_file "$file" "package:$OLD_NAME/" "package:$NEW_NAME/"
done

# 9. Rename .iml file
echo -e "Updating IDE files..."
if [ -f "$OLD_NAME.iml" ]; then
    mv "$OLD_NAME.iml" "$NEW_NAME.iml"
fi

# Clean and get dependencies
echo -e "\n${CYAN}Running flutter clean...${NC}"
flutter clean

echo -e "${CYAN}Running flutter pub get...${NC}"
flutter pub get

echo -e "\n${GREEN}========================================"
echo -e "  Project renamed successfully!"
echo -e "========================================${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. Run: dart run build_runner build --delete-conflicting-outputs"
echo "  2. Update app icons: flutter pub run flutter_launcher_icons"
echo "  3. Configure your environments in lib/core/config/env/"
echo "  4. Update README.md with your project info"
echo ""
