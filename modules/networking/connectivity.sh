#!/bin/bash

source "$(dirname "$0")/common.sh"

section "END-TO-END CONNECTIVITY"

gateway="$(default_gateway)"

if [ -n "$gateway" ]; then
    echo "Layer 3 gateway test:"
    if ping -c 2 -W "$NETWORK_TIMEOUT" "$gateway" >/dev/null 2>&1; then
        ok "Gateway reachable"
    else
        fail "Gateway unreachable"
    fi
fi

echo
echo "External IP connectivity:"
if ping -c 2 -W "$NETWORK_TIMEOUT" 1.1.1.1 >/dev/null 2>&1; then
    ok "External IP reachable"
else
    warn "External ICMP unavailable"
fi

echo
echo "DNS + HTTPS connectivity:"

if command_exists curl; then
    if curl -fsSIL --max-time "$NETWORK_TIMEOUT" https://example.com \
        >/dev/null 2>&1; then
        ok "HTTPS endpoint reachable"
    else
        warn "HTTPS endpoint unavailable"
    fi
else
    na "curl unavailable"
fi
