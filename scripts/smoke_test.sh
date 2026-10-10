#!/usr/bin/env bash
set -u
CTFD_URL="${CTFD_URL:-http://127.0.0.1:8000}"
OSINT_URL="${OSINT_URL:-http://127.0.0.1:8082}"
WEB_URL="${WEB_URL:-http://127.0.0.1:8081}"
SSH_HOST="${SSH_HOST:-127.0.0.1}"
SSH_PORT="${SSH_PORT:-2222}"
pass=0; fail=0; skip=0
ok(){ echo "[PASS] $*"; pass=$((pass+1)); }
bad(){ echo "[FAIL] $*"; fail=$((fail+1)); }
skipf(){ echo "[SKIP] $*"; skip=$((skip+1)); }

if command -v docker >/dev/null 2>&1; then
  if docker compose config -q >/dev/null 2>&1; then ok "Docker Compose parses"; else bad "Docker Compose parse failed"; fi
  for net in control_net challenge_front nightfall_ingress; do
    if docker network inspect "$net" >/dev/null 2>&1; then
      internal=$(docker network inspect "$net" --format '{{.Internal}}' 2>/dev/null || echo unknown)
      echo "[INFO] network $net Internal=$internal"
    else
      skipf "Docker network $net not present"
    fi
  done
else
  skipf "Docker CLI not installed"
fi

if command -v curl >/dev/null 2>&1; then
  for pair in "CTFd|$CTFD_URL" "OSINT|$OSINT_URL" "NF03|$WEB_URL"; do
    name=${pair%%|*}; url=${pair#*|}
    if curl -fsS --max-time 5 "$url" >/dev/null 2>&1; then ok "$name responds at $url"; else skipf "$name not reachable at $url"; fi
  done
else
  skipf "curl not installed"
fi

if command -v nc >/dev/null 2>&1; then
  if nc -z -w 3 "$SSH_HOST" "$SSH_PORT" >/dev/null 2>&1; then ok "NF06 SSH gateway is reachable"; else skipf "NF06 SSH gateway not reachable"; fi
else
  skipf "nc/netcat not installed"
fi

echo "Summary: PASS=$pass FAIL=$fail SKIP=$skip"
[ "$fail" -eq 0 ]
