\
#!/usr/bin/env bash
set -euo pipefail
TARGET="${1:-}"
if [[ -z "$TARGET" ]]; then
  echo "Usage: bash apply_ui_restore.sh /absolute/path/to/shopconnect_mvp"
  exit 1
fi
if [[ ! -d "$TARGET" ]]; then
  echo "Target not found: $TARGET"
  exit 1
fi

STAMP="$(date +%Y%m%d_%H%M%S)"
BACKUP_DIR="$TARGET/.backup_ui_restore_$STAMP"
mkdir -p "$BACKUP_DIR"

backup_if_exists () {
  local rel="$1"
  if [[ -f "$TARGET/$rel" ]]; then
    mkdir -p "$BACKUP_DIR/$(dirname "$rel")"
    cp "$TARGET/$rel" "$BACKUP_DIR/$rel"
  fi
}

for f in \
  lib/main.dart \
  lib/screens/home_screen.dart \
  lib/screens/stores_screen.dart \
  lib/screens/categories_screen.dart \
  lib/screens/profile_screen.dart \
  lib/screens/store_detail_screen.dart \
  lib/models/store_model.dart \
  lib/widgets/store_tile.dart
do
  backup_if_exists "$f"
done

mkdir -p "$TARGET/lib/screens" "$TARGET/lib/models" "$TARGET/lib/widgets"

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cp "$ROOT/lib/main.dart" "$TARGET/lib/main.dart"
cp "$ROOT/lib/screens/home_screen.dart" "$TARGET/lib/screens/home_screen.dart"
cp "$ROOT/lib/screens/stores_screen.dart" "$TARGET/lib/screens/stores_screen.dart"
cp "$ROOT/lib/screens/categories_screen.dart" "$TARGET/lib/screens/categories_screen.dart"
cp "$ROOT/lib/screens/profile_screen.dart" "$TARGET/lib/screens/profile_screen.dart"
cp "$ROOT/lib/screens/store_detail_screen.dart" "$TARGET/lib/screens/store_detail_screen.dart"
cp "$ROOT/lib/models/store_model.dart" "$TARGET/lib/models/store_model.dart"
cp "$ROOT/lib/widgets/store_tile.dart" "$TARGET/lib/widgets/store_tile.dart"

echo "Target project: $TARGET"
echo "Backup saved:   $BACKUP_DIR"
echo "Done."
echo "Next: cd \"$TARGET\" && flutter pub get && flutter run -d chrome --web-port 8081"
