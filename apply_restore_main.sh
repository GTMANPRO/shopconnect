#!/usr/bin/env bash
set -euo pipefail

TARGET="${1:-}"
if [[ -z "$TARGET" ]]; then
  echo "Usage: bash apply_restore_main.sh /path/to/flutter_project"
  exit 1
fi
if [[ ! -d "$TARGET" ]]; then
  echo "Target project not found: $TARGET"
  exit 1
fi

STAMP="$(date +%Y%m%d_%H%M%S)"
echo "Target project: $TARGET"
echo "Backup stamp:   $STAMP"

mkdir -p "$TARGET/lib"

# Backup existing main.dart if it exists
if [[ -f "$TARGET/lib/main.dart" ]]; then
  cp "$TARGET/lib/main.dart" "$TARGET/lib/main.dart.backup.$STAMP"
  echo "Backed up existing lib/main.dart -> lib/main.dart.backup.$STAMP"
fi

cp "lib/main.dart" "$TARGET/lib/main.dart"
echo "Restored: lib/main.dart"

echo
echo "Next:"
echo "  cd "$TARGET""
echo "  flutter pub get"
echo "  flutter run -d chrome --web-port 8081"
