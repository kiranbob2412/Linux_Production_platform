#!/bin/bash

source "$(dirname "$0")/common.sh"

section "TCP DIAGNOSTICS"

if ! command_exists ss; then
    fail "ss command unavailable"
    exit 1
fi

echo "TCP listening sockets:"
ss -ltn 2>/dev/null

echo
echo "TCP established connections:"
ss -tn state established 2>/dev/null

echo
echo "TCP connection states:"
ss -tan 2>/dev/null |
    awk 'NR>1 {print $1}' |
    sort |
    uniq -c |
    sort -nr

echo
echo "TCP statistics:"
ss -s 2>/dev/null

if command_exists nstat; then
    echo
    echo "TCP kernel counters:"
    nstat -az Tcp 2>/dev/null | sed -n '1,100p'
fi

ok "TCP diagnostics collected"
