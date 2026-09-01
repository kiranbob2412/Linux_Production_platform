#!/bin/bash

source "$(dirname "$0")/common.sh"

section "ROUTING"

if ! command_exists ip; then
    fail "ip command not available"
    exit 1
fi

echo "IPv4 Routing Table:"
ip -4 route show 2>/dev/null

echo
echo "IPv6 Routing Table:"
ip -6 route show 2>/dev/null

echo
echo "Routing Rules:"
ip rule show 2>/dev/null

echo
echo "Route Selection Test:"
ip route get 1.1.1.1 2>/dev/null || true

gateway="$(default_gateway)"
interface="$(default_interface)"

if [ -n "$gateway" ]; then
    ok "Default gateway detected: $gateway"
else
    warn "Default gateway not detected"
fi

if [ -n "$interface" ]; then
    ok "Default route interface detected: $interface"
else
    warn "Default route interface not detected"
fi
