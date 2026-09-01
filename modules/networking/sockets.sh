#!/bin/bash

source "$(dirname "$0")/common.sh"

section "SOCKET AND PORT DIAGNOSTICS"

if ! command_exists ss; then
    fail "ss command unavailable"
    exit 1
fi

echo "All listening TCP/UDP sockets:"
ss -lntup 2>/dev/null || ss -lntu 2>/dev/null

echo
echo "Socket summary:"
ss -s 2>/dev/null

echo
echo "Common service ports:"
ss -lntup 2>/dev/null |
    grep -E ':(22|53|80|443|3306|5432|6379|8080|8443)\b' ||
    echo "No common service ports detected"

echo
echo "Socket states:"
ss -tan 2>/dev/null |
    awk 'NR>1 {count[$1]++} END {for (s in count) print s, count[s]}' |
    sort

ok "Socket and port diagnostics collected"
