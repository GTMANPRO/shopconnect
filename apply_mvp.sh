#!/usr/bin/env bash
set -euo pipefail

TARGET="${1:-}"
if [[ -z "$TARGET" ]]; then
  echo "Usage: bash apply_mvp.sh /path/to/your/flutter/project"
  exit 1
fi

if [[ ! -f "$TARGET/pubspec.yaml" ]]; then
  echo "ERROR: pubspec.yaml not found in: $TARGET"
  echo "Make sure you pass the Flutter project root (the folder containing pubspec.yaml)."
  exit 1
fi

STAMP="$(date +%Y%m%d_%H%M%S)"
echo "Target project: $TARGET"
echo "Backup stamp:   $STAMP"

if [[ -d "$TARGET/lib" ]]; then
  echo "Backing up existing lib/ -> lib.backup.$STAMP/"
  cp -R "$TARGET/lib" "$TARGET/lib.backup.$STAMP"
fi

echo "Copying MVP lib/ into project..."
rm -rf "$TARGET/lib"
cp -R "./lib" "$TARGET/lib"

echo "Done."
echo "Next:"
echo "  cd \"$TARGET\""
echo "  flutter pub get"
echo "  flutter run -d chrome --web-port 8080"
