#!/bin/bash

source "$(dirname "$0")/common.sh"

section "ICMP DIAGNOSTICS"

gateway="$(default_gateway)"

if [ -n "$gateway" ]; then
    echo "Gateway ICMP:"
    if ping -c 3 -W "$NETWORK_TIMEOUT" "$gateway" 2>/dev/null; then
        ok "Gateway responds to ICMP"
    else
        warn "Gateway does not respond to ICMP"
    fi
else
    warn "No default gateway available for ICMP test"
fi

echo
echo "External ICMP:"
if ping -c 3 -W "$NETWORK_TIMEOUT" 1.1.1.1 2>/dev/null; then
    ok "External ICMP connectivity available"
else
    warn "External ICMP connectivity unavailable"
fi
