#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-$(pwd)}"
cd "$ROOT"

if [ ! -f package.json ]; then
  npm init -y >/dev/null 2>&1 || true
fi

if npm list firebase >/dev/null 2>&1; then
  echo "firebase package already installed"
else
  npm install firebase
fi
