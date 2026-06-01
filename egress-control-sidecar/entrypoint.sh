#!/bin/sh
set -eu

GOST_PORT="${GOST_PORT:-12345}"
GOST_MARK="${GOST_MARK:-114514}"
APP_DIR="${APP_DIR:-/opt/egress-sidecar}"
GOST_CONFIG="${GOST_CONFIG:-$APP_DIR/gost.yaml}"
ALLOWLIST="${ALLOWLIST:-$APP_DIR/allowlist.txt}"
NFTABLES_RULESET_NAME="${NFTABLES_RULESET_NAME:-gost_egress}"

export GOST_PORT GOST_MARK GOST_CONFIG ALLOWLIST

cleanup() {
  nft delete table inet "$NFTABLES_RULESET_NAME" 2>/dev/null || true
}

mkdir -p "$(dirname "$ALLOWLIST")"
: > "$ALLOWLIST"
cleanup

echo "egress-control-sidecar ready: default egress is allow-all until policy allow or deny-all is applied"
echo "try: docker compose exec egress-control-sidecar policy allow api.gitlab.com"

trap cleanup INT TERM EXIT

/bin/gost -C "$GOST_CONFIG" &
wait "$!"
