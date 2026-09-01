#!/bin/bash

source "$(dirname "$0")/common.sh"

section "NETWORK PERFORMANCE"

interface="$(default_interface)"

if [ -n "$interface" ]; then

    echo "Interface statistics:"
    ip -s link show dev "$interface" 2>/dev/null | sed -n '1,40p'

    echo
    echo "Interface counters:"
    awk -v iface="$interface" '
        $1 ~ iface ":" {
            gsub(":", "", $1)
            printf "RX packets=%s bytes=%s errors=%s dropped=%s\n",
                   $2,$3,$4,$5
            printf "TX packets=%s bytes=%s errors=%s dropped=%s\n",
                   $10,$11,$12,$13
        }
    ' /proc/net/dev

    if command_exists ethtool; then
        echo
        echo "Driver statistics:"
        ethtool -S "$interface" 2>/dev/null |
            sed -n '1,160p' || true
    fi

else
    warn "Default interface unavailable"
fi

echo
echo "Socket statistics:"
ss -s 2>/dev/null || true

if command_exists nstat; then
    echo
    echo "Kernel network statistics:"
    nstat -az 2>/dev/null | sed -n '1,160p'
fi

ok "Network performance diagnostics collected"
