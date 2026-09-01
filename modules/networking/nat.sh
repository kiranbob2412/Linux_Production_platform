#!/bin/bash

source "$(dirname "$0")/common.sh"

section "NAT AND CONNECTION TRACKING"

found=0

if command_exists nft; then
    found=1
    echo "IPv4 NAT:"
    nft list table ip nat 2>/dev/null || true

    echo
    echo "IPv6 NAT:"
    nft list table ip6 nat 2>/dev/null || true
fi

if command_exists iptables; then
    found=1
    echo
    echo "iptables NAT:"
    iptables -t nat -L -n -v 2>/dev/null | sed -n '1,200p' || true
fi

if command_exists conntrack; then
    found=1
    echo
    echo "Connection tracking:"
    conntrack -S 2>/dev/null || true
fi

if [ "$found" -eq 1 ]; then
    ok "NAT/connection-tracking diagnostics available"
else
    na "NAT/connection-tracking tooling unavailable"
fi
