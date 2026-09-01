#!/bin/bash

source "$(dirname "$0")/common.sh"

section "LINUX BRIDGE DIAGNOSTICS"

if ! command_exists bridge; then
    na "bridge command unavailable"
    exit 0
fi

echo "Bridge links:"
bridge link 2>/dev/null || true

echo
echo "Bridge VLAN:"
bridge vlan show 2>/dev/null || true

echo
echo "Bridge forwarding database:"
bridge fdb show 2>/dev/null | sed -n '1,160p'

ok "Linux bridge diagnostics completed"
