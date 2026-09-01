#!/bin/bash

source "$(dirname "$0")/common.sh"

section "NIC BONDING / TEAMING"

if [ -f /proc/net/bonding/bond0 ]; then
    cat /proc/net/bonding/bond0
    ok "bond0 detected"
else
    echo "No bond0 detected"
fi

echo
echo "All bonding devices:"

found=0

for file in /proc/net/bonding/*; do
    if [ -f "$file" ]; then
        found=1
        echo
        echo "===== $file ====="
        cat "$file"
    fi
done

if [ "$found" -eq 0 ]; then
    na "No Linux bonding devices detected"
else
    ok "Bonding diagnostics completed"
fi
