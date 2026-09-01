#!/bin/bash

source "$(dirname "$0")/common.sh"

section "PACKET CAPTURE DIAGNOSTICS"

if ! command_exists tcpdump; then
    na "tcpdump not installed"
    exit 0
fi

echo "tcpdump version:"
tcpdump --version 2>&1 | head -1

echo
echo "Capture interfaces:"
tcpdump -D 2>/dev/null | sed -n '1,80p'

echo
echo "Capture capability:"

if [ "$(id -u)" -eq 0 ]; then
    ok "Running with root privileges for packet capture"
else
    if timeout 3 tcpdump -ni any -c 1 -w /dev/null 2>/dev/null; then
        ok "Packet capture permitted"
    else
        warn "tcpdump available but packet capture may require elevated privileges"
    fi
fi
