SHOPCONNECT – Restore missing UI entry files (main.dart imports)

This drop-in adds ONLY these files if missing or overwrites them with known-good versions:
  - lib/theme/app_theme.dart
  - lib/screens/home_screen.dart
  - lib/main.dart

It does NOT touch your other screens/models/services.

Install:
  1) unzip this zip
  2) bash apply_restore_ui.sh /full/path/to/your/shopconnect_mvp

Then:
  cd <project> && flutter pub get && flutter run -d chrome --web-port 8081
