ShopConnect — Step 1 Reset (Links + Logos, no Firebase)

What this does
- Rebuilds your project's `lib/` folder with a clean, compiling MVP.
- Uses local placeholder logo assets (assets/logos/*.png).
- Uses direct affiliate links (opens in external browser).
- Does NOT use Firebase / Firestore (so it runs everywhere immediately).

How to apply
1) Unzip this package somewhere (Downloads is fine).
2) Run:

   bash shopconnect_step1_full_reset_dropin/apply_shopconnect_reset_step1.sh ~/Projects/shopconnect_mvp

3) Ensure your pubspec.yaml contains:

   flutter:
     assets:
       - assets/logos/

4) Then:

   cd ~/Projects/shopconnect_mvp
   flutter pub get
   flutter run -d chrome --web-port 8081
