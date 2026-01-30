#!/usr/bin/env bash
set -euo pipefail

TARGET="${1:-}"
if [[ -z "$TARGET" ]]; then
  echo "Usage: bash apply_pubspec_assets.sh /absolute/or/relative/path/to/shopconnect_mvp"
  exit 1
fi

if [[ ! -d "$TARGET" ]]; then
  echo "Target project directory not found: $TARGET"
  exit 1
fi

STAMP="$(date +%Y%m%d_%H%M%S)"
echo "Target project: $TARGET"
echo "Backup stamp:   $STAMP"

cd "$TARGET"

if [[ -f pubspec.yaml ]]; then
  cp "pubspec.yaml" "pubspec.yaml.backup.${STAMP}"
fi

cp -f "${BASH_SOURCE%/*}/pubspec.yaml" "pubspec.yaml"

echo "Done."
echo "Next:"
echo "  cd "$TARGET""
echo "  flutter clean"
echo "  flutter pub get"
echo "  flutter run -d chrome --web-port 8081"
