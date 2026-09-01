#!/bin/bash

source "$(dirname "$0")/common.sh"

section "NETWORK OBSERVABILITY"

echo "Timestamp:"
timestamp

echo
echo "Host:"
hostname

echo
echo "Interfaces:"
ip -br link 2>/dev/null

echo
echo "Addresses:"
ip -br addr 2>/dev/null

echo
echo "Routes:"
ip route show 2>/dev/null

echo
echo "Sockets:"
ss -s 2>/dev/null

echo
echo "Interface counters:"
cat /proc/net/dev 2>/dev/null | sed -n '1,100p'

echo
echo "Kernel network counters:"
if command_exists nstat; then
    nstat -az 2>/dev/null | sed -n '1,120p'
else
    na "nstat unavailable"
fi

ok "Network observability snapshot generated"
