#!/bin/bash

source "$(dirname "$0")/common.sh"

section "IP ADDRESSING"

if ! command_exists ip; then
    fail "ip command not available"
    exit 1
fi

echo "IPv4:"
ip -4 -br addr 2>/dev/null

echo
echo "IPv6:"
ip -6 -br addr 2>/dev/null

echo
echo "IPv4 Address Details:"
ip -4 addr show 2>/dev/null

echo
echo "IPv6 Address Details:"
ip -6 addr show 2>/dev/null

if ip -4 addr show scope global 2>/dev/null | grep -q "inet "; then
    ok "Global IPv4 address detected"
else
    warn "No global IPv4 address detected"
fi

if ip -6 addr show scope global 2>/dev/null | grep -q "inet6 "; then
    ok "Global IPv6 address detected"
else
    warn "No global IPv6 address detected"
fi

echo
echo "Address Statistics:"
ip -s addr 2>/dev/null | sed -n '1,160p'
