#!/bin/bash

source "$(dirname "$0")/common.sh"

section "MTU AND PATH-MTU"

interface="$(default_interface)"

if [ -z "$interface" ]; then
    warn "Default network interface not detected"
    exit 0
fi

echo "Interface: $interface"

mtu="$(
    ip link show dev "$interface" 2>/dev/null |
    sed -n 's/.*mtu \([0-9]\+\).*/\1/p'
)"

echo "MTU: ${mtu:-UNKNOWN}"

if [ -n "$mtu" ]; then
    ok "Interface MTU detected"
else
    warn "Interface MTU unavailable"
fi

if command_exists tracepath; then
    echo
    echo "Path MTU probe:"
    tracepath -m 8 1.1.1.1 2>/dev/null | sed -n '1,40p' || true
else
    na "tracepath not installed"
fi
