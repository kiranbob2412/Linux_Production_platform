#!/bin/bash

source "$(dirname "$0")/common.sh"

section "NETWORK TUNNELS"

echo "Tunnel interfaces:"

ip -d link show 2>/dev/null |
    grep -Ei \
    'gre|gretap|ipip|sit|vxlan|wireguard|tun|tap' |
    sed -n '1,200p' || true

echo
echo "Tunnel addresses:"
ip addr show 2>/dev/null |
    grep -Ei 'tun|tap|gre|ipip|sit|vxlan|wg' |
    sed -n '1,120p' || true

ok "Tunnel inventory completed"
