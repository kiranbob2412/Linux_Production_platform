#!/bin/bash

source "$(dirname "$0")/common.sh"

section "NETWORK INTERFACES AND LINK"

if ! command_exists ip; then
    fail "ip command not available"
    exit 1
fi

ip -br link 2>/dev/null

echo
echo "Interface Details:"

while read -r interface state mac rest; do

    [ -z "$interface" ] && continue

    echo
    echo "Interface: $interface"
    echo "State: ${state:-UNKNOWN}"
    echo "MAC: ${mac:-UNKNOWN}"

    if [ "$interface" = "lo" ]; then
        continue
    fi

    if command_exists ethtool; then

        details="$(ethtool "$interface" 2>/dev/null || true)"

        speed="$(echo "$details" |
            awk -F': ' '/^[[:space:]]*Speed:/ {print $2; exit}')"

        duplex="$(echo "$details" |
            awk -F': ' '/^[[:space:]]*Duplex:/ {print $2; exit}')"

        link="$(echo "$details" |
            awk -F': ' '/^[[:space:]]*Link detected:/ {print $2; exit}')"

        echo "Speed: ${speed:-UNKNOWN}"
        echo "Duplex: ${duplex:-UNKNOWN}"
        echo "Link: ${link:-UNKNOWN}"

        if [ "$link" = "yes" ]; then
            ok "$interface physical link detected"
        elif [ "$link" = "no" ]; then
            warn "$interface physical link not detected"
        else
            na "$interface link state unavailable"
        fi
    else
        na "ethtool not installed"
    fi

done < <(ip -br link 2>/dev/null)
