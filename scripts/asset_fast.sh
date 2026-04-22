#!/usr/bin/env bash
set -e

PROJECT_ROOT="/Users/gt/Projects/shopconnect"
cd "$PROJECT_ROOT"

echo "📂 Project root: $PROJECT_ROOT"

VERSION_FILE="$PROJECT_ROOT/VERSION"

if [ -f "$VERSION_FILE" ]; then
  CURRENT_VERSION="$(cat "$VERSION_FILE" | tr -d '[:space:]')"
else
  CURRENT_VERSION="v1.0.0"
fi

BASE="${CURRENT_VERSION#v}"
MAJOR="$(echo "$BASE" | cut -d. -f1)"
MINOR="$(echo "$BASE" | cut -d. -f2)"
PATCH="$(echo "$BASE" | cut -d. -f3)"
NEW_VERSION="v${MAJOR}.${MINOR}.${PATCH}"

TIMESTAMP="$(date +"%Y.%m.%d-%H%M")"
ZIP_NAME="shopconnect_assets_${NEW_VERSION}_${TIMESTAMP}.zip"

echo "🔢 Version (fast, no bump): $NEW_VERSION"
echo "⏱  Timestamp: $TIMESTAMP"
echo "📦 ZIP: $ZIP_NAME"

echo "🔍 Checking asset folders..."
mkdir -p assets/icon assets/logos assets/data

echo "🔧 Ensuring launcher icon exists..."
if [ ! -f "assets/icon/app_icon.png" ] && [ -f "assets/logos/sephora.png" 
]; then
  cp "assets/logos/sephora.png" "assets/icon/app_icon.png"
fi

echo "📦 Cleaning dist folder..."
rm -rf dist
mkdir -p dist/assets

echo "📁 Copying logos..."
[ -d "assets/logos" ] && cp -R "assets/logos" "dist/assets"

echo "📁 Copying splash screens..."
[ -d "assets/splash" ] && cp -R "assets/splash" "dist/assets"

echo "📁 Copying screenshots..."
if [ -d "assets/screenshots" ]; then
  mkdir -p "dist/assets/screenshots"
  [ -d "assets/screenshots/ios" ] && cp -R "assets/screenshots/ios" 
"dist/assets/screenshots"
  [ -d "assets/screenshots/android" ] && cp -R 
"assets/screenshots/android" "dist/assets/screenshots"
fi

echo "📁 Copying marketing banners..."
if [ -d "assets/marketing/banners" ]; then
  mkdir -p "dist/assets/marketing"
  cp -R "assets/marketing/banners" "dist/assets/marketing"
fi

echo "📁 Copying icons..."
[ -d "assets/icon" ] && cp -R "assets/icon" "dist/assets"

echo "🗜️ Creating ZIP..."
cd dist
zip -r "$ZIP_NAME" "assets" > /dev/null
mv "$ZIP_NAME" "$PROJECT_ROOT"
cd "$PROJECT_ROOT"

echo "✅ Done."
echo "📦 Output: $ZIP_NAME"

