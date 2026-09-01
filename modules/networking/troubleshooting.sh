#!/bin/bash

source "$(dirname "$0")/common.sh"

section "NETWORK TROUBLESHOOTING CHAIN"

iface="$(default_interface)"
gateway="$(default_gateway)"

echo "1. Interface:"
if [ -n "$iface" ]; then
    ip link show "$iface" 2>/dev/null | sed -n '1,4p'
else
    warn "No default interface"
fi

echo
echo "2. Address:"
[ -n "$iface" ] && ip addr show dev "$iface" 2>/dev/null | sed -n '1,40p'

echo
echo "3. Gateway:"
if [ -n "$gateway" ]; then
    echo "$gateway"
    ping -c 2 -W "$NETWORK_TIMEOUT" "$gateway" >/dev/null 2>&1 &&
        ok "Gateway reachable" ||
        warn "Gateway unreachable"
else
    warn "Gateway missing"
fi

echo
echo "4. DNS:"
getent hosts example.com >/dev/null 2>&1 &&
    ok "DNS working" ||
    warn "DNS failed"

echo
echo "5. External IP:"
ping -c 2 -W "$NETWORK_TIMEOUT" 1.1.1.1 >/dev/null 2>&1 &&
    ok "External IP reachable" ||
    warn "External ICMP unavailable"

echo
echo "6. HTTPS:"
if command_exists curl; then
    curl -fsSI --max-time "$NETWORK_TIMEOUT" \
        https://example.com >/dev/null 2>&1 &&
        ok "HTTPS reachable" ||
        warn "HTTPS failed"
fi

echo
echo "Troubleshooting chain completed."
