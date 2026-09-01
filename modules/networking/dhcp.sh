#!/bin/bash

source "$(dirname "$0")/common.sh"

section "DHCP DIAGNOSTICS"

interface="$(default_interface)"

echo "Primary interface: ${interface:-NOT FOUND}"

if command_exists nmcli; then
    echo
    echo "NetworkManager device information:"
    nmcli device show "$interface" 2>/dev/null |
        grep -E 'GENERAL.DEVICE|GENERAL.CONNECTION|IP4.DHCP|IP6.DHCP|DHCP4|DHCP6' ||
        true

    ok "NetworkManager DHCP information queried"
else
    na "nmcli not available"
fi

echo
echo "DHCP lease files:"

found=0

for file in \
    /var/lib/dhcp/dhclient*.leases \
    /var/lib/NetworkManager/*.lease \
    /var/lib/dhcpcd/*.lease; do

    if [ -f "$file" ]; then
        echo "$file"
        found=1
    fi
done

if [ "$found" -eq 0 ]; then
    echo "No standard DHCP lease file detected"
fi
