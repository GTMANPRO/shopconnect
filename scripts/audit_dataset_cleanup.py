from pathlib import Path
import json
import csv

PROJECT_ROOT = Path(__file__).resolve().parents[1]
STORE_PATH = PROJECT_ROOT / 'assets' / 'data' / 'stores.json'
CSV_PATH = PROJECT_ROOT / 'data_templates' / 'outbound_url_updates.csv'

def good(v):
    return isinstance(v, str) and v.strip().startswith('http')

def main():
    stores = json.loads(STORE_PATH.read_text(encoding='utf-8'))

    missing_both = []
    missing_outbound = []
    missing_affiliate = []

    for s in stores:
        sid = str(s.get('id', '')).strip()
        name = str(s.get('name', '')).strip()
        cats = str(s.get('categories', '')).strip()
        aff = s.get('affiliateUrl')
        out = s.get('outboundUrl')

        if not good(aff) and not good(out):
            missing_both.append((sid, name, cats))
        elif not good(out):
            missing_outbound.append((sid, name, cats))
        elif not good(aff):
            missing_affiliate.append((sid, name, cats))

    print(f"stores.json path: {STORE_PATH}")
    print(f"total stores: {len(stores)}")
    print(f"missing affiliate + outbound: {len(missing_both)}")
    print(f"missing outbound only: {len(missing_outbound)}")
    print(f"missing affiliate only: {len(missing_affiliate)}")
    print()

    print("FIRST 100 missing affiliate + outbound")
    for sid, name, cats in missing_both[:100]:
        print(f"- {sid} | {name} | {cats}")

    print()
    print(f"CSV template path: {CSV_PATH}")
    if CSV_PATH.exists():
        with CSV_PATH.open('r', encoding='utf-8') as f:
            rows = list(csv.reader(f))
        print(f"csv rows: {len(rows)}")
    else:
        print("csv template not found")

if __name__ == '__main__':
    main()
