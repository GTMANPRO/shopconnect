# ShopConnect MVP drop-in (lib/ only)

## Your project folder
From your earlier terminal output, your Flutter project root is:
`/Users/gt/Projects/shopconnect`

This drop-in ZIP contains **only**:
- `lib/` (new structured MVP code)
- `README_MVP_INSTALL.md`
- `apply_mvp.sh` (optional installer script)

## Option A: Manual (safest)
1. In your project root, back up your current `lib/`:
   ```bash
   cd /Users/gt/Projects/shopconnect
   cp -R lib lib.backup.$(date +%Y%m%d_%H%M%S)
   ```
2. Copy the ZIP's `lib/` folder into the project root (replace existing `lib/`).
3. Run:
   ```bash
   flutter pub get
   flutter run -d chrome --web-port 8080
   ```

## Option B: Run the installer script
From the directory where you unzip this package:
```bash
bash apply_mvp.sh /Users/gt/Projects/shopconnect
```

It will:
- back up `lib/` into `lib.backup.TIMESTAMP/`
- copy in the new `lib/`

## Firebase (minimal)
Add deps in `pubspec.yaml`:
- firebase_core
- cloud_firestore
- url_launcher

Then run FlutterFire:
```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

Uncomment Firebase.initializeApp in `lib/main.dart` after `firebase_options.dart` exists.
