#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BACKEND_DIR="$ROOT/backend"
WEB_PORT="${SHOPCONNECT_WEB_PORT:-8082}"
BACKEND_PORT="${SHOPCONNECT_BACKEND_PORT:-3000}"

echo "== ShopConnect Launcher =="
echo "Project: $ROOT"
echo "Backend: http://localhost:$BACKEND_PORT"
echo "Web:     http://127.0.0.1:$WEB_PORT"
echo ""

# Helpers
kill_port () {
  local p="$1"
  kill -9 $(lsof -ti tcp:"$p" 2>/dev/null) 2>/dev/null || true
}

wait_http () {
  local url="$1"
  local max_tries="${2:-60}"
  local i=0
  while true; do
    if curl -s -o /dev/null "$url"; then
      return 0
    fi
    i=$((i+1))
    if [[ "$i" -ge "$max_tries" ]]; then
      return 1
    fi
    sleep 0.5
  done
}

# Clean ports
kill_port "$BACKEND_PORT"
kill_port "$WEB_PORT"

# Start backend
if [[ -f "$BACKEND_DIR/server.js" ]]; then
  echo "Starting backend..."
  (cd "$BACKEND_DIR" && nohup node server.js > "$ROOT/.sc_backend.log" 2>&1 &) || true
else
  echo "⚠️ backend/server.js not found. Skipping backend start."
fi

# Start Flutter (Chrome device)
echo "Starting Flutter (Chrome)..."
# Run flutter in a new Terminal window so it stays open
osascript <<OSA
tell application "Terminal"
  activate
  do script "cd \"$ROOT\" && flutter run -d chrome --web-port $WEB_PORT --web-hostname 127.0.0.1"
end tell
OSA

# Wait for web server to be reachable, then open Chrome
echo "Waiting for web to be reachable..."
if wait_http "http://127.0.0.1:$WEB_PORT/index.html" 80; then
  echo "Opening Chrome..."
  open -a "Google Chrome" "http://127.0.0.1:$WEB_PORT"
  echo "✅ Launched."
else
  echo "❌ Web did not become reachable on port $WEB_PORT."
  echo "Check the Flutter Terminal window for build errors."
  exit 1
fi
