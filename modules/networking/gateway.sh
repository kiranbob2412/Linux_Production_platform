#!/bin/bash

source "$(dirname "$0")/common.sh"

section "GATEWAY DIAGNOSTICS"

gateway="$(default_gateway)"

if [ -z "$gateway" ]; then
    fail "Default gateway not found"
    exit 1
fi

echo "Default Gateway: $gateway"

if ping -c 2 -W "$NETWORK_TIMEOUT" "$gateway" >/dev/null 2>&1; then
    ok "Gateway reachable: $gateway"
else
    fail "Gateway unreachable: $gateway"
fi
