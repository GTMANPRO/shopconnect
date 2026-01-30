#!/usr/bin/env bash
set -euo pipefail

TARGET="${1:-}"
if [[ -z "$TARGET" ]]; then
  echo "Usage: bash apply_money_stores.sh /path/to/flutter_project"
  exit 1
fi

if [[ ! -f "$TARGET/pubspec.yaml" ]]; then
  echo "❌ pubspec.yaml not found in: $TARGET"
  echo "Make sure you pass the Flutter project root (the folder containing pubspec.yaml)."
  exit 1
fi

SEED="$TARGET/lib/data/seed_data.dart"
if [[ ! -f "$SEED" ]]; then
  echo "❌ seed_data.dart not found at: $SEED"
  echo "Expected: lib/data/seed_data.dart"
  exit 1
fi

TS="$(date +%Y%m%d_%H%M%S)"
BACKUP_DIR="$TARGET/_backup_money_stores_${TS}"
mkdir -p "$BACKUP_DIR/lib/data"
cp "$SEED" "$BACKUP_DIR/lib/data/seed_data.dart"

python3 - <<'PY' "$SEED"
import sys, re

path = sys.argv[1]
src = open(path, "r", encoding="utf-8").read()

m = re.search(r"(static\s+final\s+List<StoreModel>\s+stores\s*=\s*<StoreModel>\s*\[\s*)(.*?)(\s*\]\s*;)", src, flags=re.S)
if not m:
    raise SystemExit("❌ Could not find 'static final List<StoreModel> stores = <StoreModel>[' block in seed_data.dart")

prefix, body, suffix = m.group(1), m.group(2), m.group(3)

def has_id(store_id: str) -> bool:
    return re.search(r"id\s*:\s*['\"]%s['\"]" % re.escape(store_id), body) is not None

stores_to_add = [
  dict(id="walmart", name="Walmart", category="Electronics",
       description="Everyday low prices across electronics, home, and more.",
       logo="assets/logos/amazon.png", url="https://www.walmart.com/", featured=True),
  dict(id="target", name="Target", category="Fashion",
       description="Style, home, and essentials with frequent promos.",
       logo="assets/logos/amazon.png", url="https://www.target.com/", featured=False),
  dict(id="ebay", name="eBay", category="Electronics",
       description="New and used goods—great for deals and unique finds.",
       logo="assets/logos/amazon.png", url="https://www.ebay.com/", featured=False),
  dict(id="etsy", name="Etsy", category="Beauty",
       description="Handmade and unique goods from independent sellers.",
       logo="assets/logos/amazon.png", url="https://www.etsy.com/", featured=False),
  dict(id="temu", name="Temu", category="Fashion",
       description="Trend-driven low-cost items—strong for viral/social traffic.",
       logo="assets/logos/amazon.png", url="https://www.temu.com/", featured=False),
  dict(id="shein", name="SHEIN", category="Fashion",
       description="Fast fashion with frequent drops—viral/social friendly.",
       logo="assets/logos/amazon.png", url="https://www.shein.com/", featured=False),
  dict(id="aliexpress", name="AliExpress", category="Electronics",
       description="Marketplace for budget gadgets and deals.",
       logo="assets/logos/amazon.png", url="https://www.aliexpress.com/", featured=False),
  dict(id="bestbuy", name="Best Buy", category="Electronics",
       description="High-ticket electronics—good for larger commission dollars.",
       logo="assets/logos/amazon.png", url="https://www.bestbuy.com/", featured=True),
  dict(id="newegg", name="Newegg", category="Electronics",
       description="PC parts, gaming, and tech—strong for high-intent shoppers.",
       logo="assets/logos/amazon.png", url="https://www.newegg.com/", featured=False),
  dict(id="apple", name="Apple", category="Electronics",
       description="Premium devices and accessories—high-ticket intent.",
       logo="assets/logos/amazon.png", url="https://www.apple.com/", featured=False),
  dict(id="booking", name="Booking.com", category="Travel",
       description="Hotels and travel deals—payouts depend on country/season.",
       logo="assets/logos/amazon.png", url="https://www.booking.com/", featured=True),
  dict(id="adidas", name="Adidas", category="Sports",
       description="Sportswear and sneakers—strong brand conversion.",
       logo="assets/logos/nike.png", url="https://www.adidas.com/", featured=False),
]

snippets = []
for s in stores_to_add:
    if has_id(s["id"]):
        continue
    snippets.append(
f"""    StoreModel(
      id: '{s["id"]}',
      name: '{s["name"]}',
      category: '{s["category"]}',
      description: '{s["description"]}',
      logoAsset: '{s["logo"]}',
      outboundUrl: '{s["url"]}',
      isFeatured: {str(s["featured"]).lower()},
    ),"""
    )

if not snippets:
    open(path, "w", encoding="utf-8").write(src)
    print("✅ No new stores added (they already exist).")
    raise SystemExit(0)

insert = "\n\n  // --- Added core affiliate stores (Money Stores Pack) ---\n" + "\n\n".join(snippets) + "\n"
new_body = body.rstrip() + insert + "\n"
new_src = src[:m.start(2)] + new_body + src[m.end(2):]
open(path, "w", encoding="utf-8").write(new_src)
print("✅ Added", len(snippets), "stores to SeedData.")
PY

echo "✅ Applied Money Stores Pack."
echo "Backup saved to: $BACKUP_DIR"
