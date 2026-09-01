#!/bin/bash

source "$(dirname "$0")/common.sh"

section "LOAD BALANCER NETWORKING"

echo "Common load-balancer listener ports:"

ss -lntup 2>/dev/null |
    grep -E ':(80|443|8080|8443|8000|9000)\b' ||
    echo "No common load-balancer ports detected"

echo
echo "HTTP health endpoint:"

if command_exists curl; then
    curl -fsSIL \
        --max-time "$NETWORK_TIMEOUT" \
        "${NETWORK_HTTP_URL:-https://example.com}" \
        2>/dev/null |
        sed -n '1,30p' || true
else
    na "curl unavailable"
fi

ok "Load-balancer/network endpoint diagnostics completed"
