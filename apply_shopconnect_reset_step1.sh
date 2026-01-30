#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: bash apply_shopconnect_reset_step1.sh /path/to/flutter_project"
  exit 1
fi

TARGET="$(cd "$1" && pwd)"
STAMP="$(date +"%Y%m%d_%H%M%S")"
echo "Target project: $TARGET"
echo "Backup stamp:   $STAMP"

cd "$TARGET"

# Back up existing lib/ (if it exists)
if [ -d "lib" ]; then
  cp -R "lib" "lib.backup.${STAMP}"
  echo "Backed up existing lib/ -> lib.backup.${STAMP}/"
fi

mkdir -p lib assets/logos

# Copy in the new lib/ and placeholder logos
cp -R "shopconnect_step1_full_reset_dropin/lib/." "lib/"
cp -R "shopconnect_step1_full_reset_dropin/assets/logos/." "assets/logos/"

echo "Done."
echo ""
echo "NEXT (important):"
echo "  1) Add assets to pubspec.yaml if missing:"
echo "       flutter:"
echo "         assets:"
echo "           - assets/logos/"
echo "  2) flutter pub get"
echo "  3) flutter run -d chrome --web-port 8081"
