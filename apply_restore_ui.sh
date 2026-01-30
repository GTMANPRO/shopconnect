\
#!/usr/bin/env bash
set -euo pipefail

if [ $# -ne 1 ]; then
  echo "Usage: bash apply_restore_ui.sh /path/to/shopconnect_mvp"
  exit 1
fi

TARGET="$1"
if [ ! -d "$TARGET" ]; then
  echo "Target directory not found: $TARGET"
  exit 1
fi

STAMP="$(date +%Y%m%d_%H%M%S)"
BACKUP="$TARGET/.backup_restore_ui_$STAMP"
mkdir -p "$BACKUP"

echo "Target project: $TARGET"
echo "Backup dir:     $BACKUP"

# Backup originals if present
for f in "lib/main.dart" "lib/screens/home_screen.dart" "lib/theme/app_theme.dart"; do
  if [ -f "$TARGET/$f" ]; then
    mkdir -p "$BACKUP/$(dirname "$f")"
    cp -p "$TARGET/$f" "$BACKUP/$f"
  fi
done

# Ensure dirs
mkdir -p "$TARGET/lib/screens" "$TARGET/lib/theme"

# Copy in our files
cp -p "lib/main.dart" "$TARGET/lib/main.dart"
cp -p "lib/screens/home_screen.dart" "$TARGET/lib/screens/home_screen.dart"
cp -p "lib/theme/app_theme.dart" "$TARGET/lib/theme/app_theme.dart"

echo "Done."
echo ""
echo "Next:"
echo "  cd \"$TARGET\" && flutter pub get && flutter run -d chrome --web-port 8081"
