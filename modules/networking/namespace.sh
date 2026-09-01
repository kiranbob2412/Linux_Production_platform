#!/bin/bash

source "$(dirname "$0")/common.sh"

section "NETWORK NAMESPACES"

if ! command_exists ip; then
    fail "ip command unavailable"
    exit 1
fi

echo "Network namespaces:"
ip netns list 2>/dev/null || true

echo
echo "Namespace links:"
ip -all netns exec "" ip link 2>/dev/null || true

ok "Network namespace diagnostics completed"
