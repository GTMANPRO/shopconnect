#!/usr/bin/env bash
set -euo pipefail
ROOT="${1:-$PWD}"
cat <<EOF
Run these commands in a new terminal from:
  $ROOT

1) Start Flutter web in profile mode:
   flutter run -d chrome --profile --trace-skia --verbose

2) Reproduce the slow page and store click.

3) Save logs:
   flutter logs > tmp/flutter_profile_log.txt

4) Run audits:
   node scripts/audit_flutter_perf.js
   node scripts/audit_asset_sizes.js

Files generated:
- tmp/flutter_profile_log.txt
- tmp/flutter_perf_audit_report.json
- tmp/asset_size_audit_report.json
EOF
