ShopConnect SAFE drop-in (lib only)

What this ZIP touches:
  - lib/main.dart
  - lib/screens/*.dart

It does NOT include or replace:
  - pubspec.yaml
  - assets/
  - android/ ios/ web/ macos/ windows/ linux/
  - any other lib/ folders (models/, theme/, data/, etc.)

How to apply (recommended):
  1) Unzip this file anywhere (e.g. Downloads/shopconnect_safe_dropin)
  2) cd into your Flutter project root (folder with pubspec.yaml)
  3) Run:
       bash /path/to/unzipped/apply_safe.sh

Manual apply (if you prefer):
  - Copy lib/main.dart into your project at lib/main.dart
  - Copy all files in lib/screens/ into your project at lib/screens/

Rollback:
  - Your previous files are backed up into:
      _backup_step4_<timestamp>/
