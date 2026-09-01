#!/bin/bash

source "$(dirname "$0")/common.sh"

section "ARP AND IPv6 NEIGHBORS"

if ! command_exists ip; then
    fail "ip command not available"
    exit 1
fi

echo "Neighbor Table:"
ip neigh show 2>/dev/null

echo
echo "IPv4 Neighbor / ARP:"
ip -4 neigh show 2>/dev/null

echo
echo "IPv6 Neighbor Discovery:"
ip -6 neigh show 2>/dev/null

failed_neighbors="$(
    ip neigh show 2>/dev/null |
    awk '$NF ~ /FAILED|INCOMPLETE/ {count++} END {print count+0}'
)"

if [ "$failed_neighbors" -eq 0 ]; then
    ok "No FAILED or INCOMPLETE neighbors detected"
else
    warn "$failed_neighbors problematic neighbor entries detected"
fi
