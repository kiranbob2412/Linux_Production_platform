#!/bin/bash

source "$(dirname "$0")/common.sh"

section "FIREWALL DIAGNOSTICS"

found=0

if command_exists ufw; then
    found=1
    echo "UFW:"
    ufw status verbose 2>/dev/null || true
fi

if command_exists nft; then
    found=1
    echo
    echo "nftables:"
    nft list ruleset 2>/dev/null | sed -n '1,200p' || true
fi

if command_exists iptables; then
    found=1
    echo
    echo "iptables:"
    iptables -S 2>/dev/null | sed -n '1,160p' || true

    echo
    echo "iptables counters:"
    iptables -L -n -v 2>/dev/null | sed -n '1,160p' || true
fi

if [ "$found" -eq 1 ]; then
    ok "Firewall/filtering diagnostics available"
else
    na "No supported firewall framework detected"
fi
