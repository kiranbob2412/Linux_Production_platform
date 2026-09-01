#!/bin/bash

source "$(dirname "$0")/common.sh"

section "HTTP / HTTPS APPLICATION DIAGNOSTICS"

url="${NETWORK_HTTP_URL:-https://example.com}"

echo "Target: $url"

if ! command_exists curl; then
    na "curl unavailable"
    exit 0
fi

echo
echo "Headers:"
if curl -fsSIL --max-time "$NETWORK_TIMEOUT" "$url" 2>/dev/null |
    sed -n '1,40p'; then
    ok "HTTP/HTTPS endpoint responded"
else
    fail "HTTP/HTTPS endpoint failed"
fi

echo
echo "Timing:"

curl -o /dev/null -sS \
    --max-time "$NETWORK_TIMEOUT" \
    -w 'DNS: %{time_namelookup}s\nConnect: %{time_connect}s\nTLS: %{time_appconnect}s\nTTFB: %{time_starttransfer}s\nTotal: %{time_total}s\nHTTP: %{http_code}\n' \
    "$url" 2>/dev/null || true
