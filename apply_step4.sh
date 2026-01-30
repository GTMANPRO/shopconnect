#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: bash apply_step4.sh /absolute/path/to/your/flutter_project"
  exit 1
fi

SRC_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET_DIR="$1"

if [[ ! -f "$TARGET_DIR/pubspec.yaml" ]]; then
  echo "ERROR: $TARGET_DIR does not look like a Flutter project (pubspec.yaml not found)."
  echo "Tip: pass the folder that contains pubspec.yaml."
  exit 1
fi

STAMP="$(date +"%Y%m%d_%H%M%S")"
BACKUP_DIR="$TARGET_DIR/_backup_step4_$STAMP"

echo "Creating backup at: $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

# Backup only the files we will touch
mkdir -p "$BACKUP_DIR/lib"
for p in main.dart data/seed_data.dart models/store_model.dart state/recently_viewed.dart widgets/store_tile.dart screens/home_screen.dart screens/categories_screen.dart screens/stores_screen.dart screens/store_detail_screen.dart; do
  if [[ -f "$TARGET_DIR/lib/$p" ]]; then
    mkdir -p "$(dirname "$BACKUP_DIR/lib/$p")"
    cp "$TARGET_DIR/lib/$p" "$BACKUP_DIR/lib/$p"
  fi
done

echo "Copying Step 4 lib/ files into: $TARGET_DIR/lib"
mkdir -p "$TARGET_DIR/lib"
cp -R "$SRC_DIR/lib/"* "$TARGET_DIR/lib/"

echo "✅ Step 4 applied safely."
echo "Next:"
echo "  cd "$TARGET_DIR""
echo "  flutter pub get"
echo "  flutter run -d chrome --web-port 8081"
