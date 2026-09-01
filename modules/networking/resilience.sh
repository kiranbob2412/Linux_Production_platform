#!/bin/bash

source "$(dirname "$0")/common.sh"

section "NETWORK RESILIENCE READINESS"

echo "Default route:"
ip route show default 2>/dev/null

echo
echo "Multiple interfaces:"
interface_count="$(ip -o link show | awk -F': ' '$2 !~ /^lo(@|$)/ {count++} END {print count+0}')"
echo "Non-loopback interfaces: $interface_count"

if [ "$interface_count" -gt 1 ]; then
    ok "Multiple network interfaces detected"
else
    warn "Only one non-loopback interface detected"
fi

echo
echo "Multiple default routes:"
default_count="$(ip route show default 2>/dev/null | wc -l)"
echo "Default routes: $default_count"

if [ "$default_count" -gt 1 ]; then
    ok "Multiple default routes detected"
else
    echo "Single/default route configuration"
fi

echo
echo "Neighbor state:"
ip neigh show 2>/dev/null

echo
echo "NetworkManager state:"
if command_exists nmcli; then
    nmcli general status 2>/dev/null || true
fi

echo
echo "Resilience diagnostics completed."
