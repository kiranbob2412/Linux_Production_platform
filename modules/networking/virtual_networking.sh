#!/bin/bash

source "$(dirname "$0")/common.sh"

section "VIRTUAL NETWORKING"

echo "Virtual/network device inventory:"

ip -d link show 2>/dev/null |
    grep -Ei \
    'veth|vxlan|dummy|tun|tap|bridge|bond|vlan|macvlan|ipvlan' |
    sed -n '1,200p' || true

echo
echo "VirtualBox/network virtualization indicators:"
ip -br link 2>/dev/null || true

ok "Virtual networking inventory completed"
