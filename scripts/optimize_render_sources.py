#!/usr/bin/env python3
import pathlib
import re
import shutil
import sys
import json

ROOT = pathlib.Path(sys.argv[1]).resolve() if len(sys.argv) > 1 else pathlib.Path.cwd()
TARGETS = [
    ROOT / "lib" / "home_screen.dart",
    ROOT / "lib" / "categories_screen.dart",
]
REPORT = {
    "root": str(ROOT),
    "files": [],
    "notes": [
        "This patch only performs conservative text substitutions.",
        "It targets active root-level screens discovered during audit.",
        "No duplicate screen files are deleted.",
    ],
}

def ensure_import(src: str) -> str:
    imp = "import 'dev/render_opt.dart';"
    if imp in src:
        return src
    lines = src.splitlines()
    insert_at = 0
    for i, line in enumerate(lines):
        if line.startswith("import "):
            insert_at = i + 1
    lines.insert(insert_at, imp)
    return "\n".join(lines) + ("\n" if src.endswith("\n") else "")

def count_replace(pattern, repl, src):
    new, count = re.subn(pattern, repl, src)
    return new, count

for file in TARGETS:
    entry = {"file": str(file), "exists": file.exists(), "changes": {}}
    if not file.exists():
        REPORT["files"].append(entry)
        continue

    original = file.read_text()
    backup = file.with_suffix(file.suffix + ".bak_render_opt")
    if not backup.exists():
        shutil.copyfile(file, backup)

    updated = ensure_import(original)

    updated, c1 = count_replace(r'(?<![\w.])Opacity\s*\(', 'PerfOpacity(', updated)
    updated, c2 = count_replace(r'Image\.network\s*\(', 'PerfImage.network(', updated)

    if updated != original:
        file.write_text(updated)

    entry["changes"]["opacity_to_perfopacity"] = c1
    entry["changes"]["imagenetwork_to_perfimage"] = c2
    entry["changed"] = updated != original
    REPORT["files"].append(entry)

report_path = ROOT / "tmp" / "render_optimization_patch_report.json"
report_path.parent.mkdir(parents=True, exist_ok=True)
report_path.write_text(json.dumps(REPORT, indent=2))
print("Saved render optimization patch report:", report_path)
for f in REPORT["files"]:
    print("-", f["file"], "changed" if f.get("changed") else "unchanged", f.get("changes", {}))
