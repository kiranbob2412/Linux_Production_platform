#!/bin/bash

source "$(dirname "$0")/common.sh"

section "VLAN DIAGNOSTICS"

echo "VLAN interfaces:"

ip -d link show 2>/dev/null |
    grep -B3 -A8 -i "vlan" |
    sed -n '1,160p' || true

if command_exists bridge; then
    echo
    echo "Bridge VLAN configuration:"
    bridge vlan show 2>/dev/null || true
fi

ok "VLAN diagnostics completed"
