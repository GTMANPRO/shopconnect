SHOPCONNECT Step 4 (SAFE DROP‑IN) — Seed Data + Filtering + Search + Home Featured + Recently Viewed

WHAT THIS ZIP DOES (SAFE):
- Only copies files into your project's lib/ folder.
- It does NOT touch pubspec.yaml, android/, ios/, web/, etc.
- It creates a timestamped backup folder before copying.

INCLUDED FILES:
lib/main.dart
lib/data/seed_data.dart
lib/models/store_model.dart
lib/state/recently_viewed.dart
lib/widgets/store_tile.dart
lib/screens/home_screen.dart
lib/screens/categories_screen.dart
lib/screens/stores_screen.dart
lib/screens/store_detail_screen.dart

APPLY:
1) unzip this zip somewhere (e.g. ~/Downloads/shopconnect_step4)
2) run:
   bash <unzipped_folder>/apply_step4.sh ~/Projects/shopconnect_mvp

VERIFY:
- Your project path must contain pubspec.yaml
- After apply:
  flutter pub get
  flutter run -d chrome --web-port 8081
