#!/bin/bash

source "$(dirname "$0")/common.sh"

section "NETWORK SECURITY POSTURE"

echo "Listening services:"
ss -lntup 2>/dev/null | sed -n '1,200p'

echo
echo "IP forwarding:"
sysctl net.ipv4.ip_forward 2>/dev/null || true
sysctl net.ipv6.conf.all.forwarding 2>/dev/null || true

echo
echo "Reverse path filtering:"
sysctl net.ipv4.conf.all.rp_filter 2>/dev/null || true

echo
echo "Firewall summary:"

if command_exists ufw; then
    ufw status 2>/dev/null || true
fi

if command_exists nft; then
    nft list ruleset 2>/dev/null | sed -n '1,120p' || true
fi

echo
echo "SSH exposure:"
ss -lnt 2>/dev/null | grep -E ':(22)\b' || echo "SSH port 22 not listening"

ok "Network security posture inspected"
