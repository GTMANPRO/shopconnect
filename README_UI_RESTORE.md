README — UI Restore + Material Fix (Safe Drop‑In)

Replaces/creates ONLY:
- lib/main.dart
- lib/screens/home_screen.dart
- lib/screens/stores_screen.dart
- lib/screens/categories_screen.dart
- lib/screens/profile_screen.dart
- lib/screens/store_detail_screen.dart
- lib/models/store_model.dart
- lib/widgets/store_tile.dart

Also creates folders if missing: lib/screens, lib/models, lib/widgets

Install:
  unzip this zip
  bash apply_ui_restore.sh ~/Projects/shopconnect_mvp

Then:
  cd ~/Projects/shopconnect_mvp
  flutter pub get
  flutter run -d chrome --web-port 8081

Note: pubspec.yaml must include:
  flutter:
    assets:
      - assets/logos/
