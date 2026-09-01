#!/bin/bash

source "$(dirname "$0")/k8s_common.sh"

k8s_section "KUBERNETES OVERLAY AND MTU"

echo "Interfaces:"
ip -br link 2>/dev/null

echo
echo "MTU values:"

ip -o link show 2>/dev/null |
awk -F'mtu ' 'NF>1 {
    split($2,a," ");
    print $1, "MTU=" a[1]
}'

echo
echo "Overlay indicators:"

ip -d link show 2>/dev/null |
    grep -Ei 'vxlan|geneve|ipip|gre|gretap' |
    sed -n '1,160p' ||
    echo "No common overlay interface detected"

echo
echo "CNI interface indicators:"

ip -br link 2>/dev/null |
    grep -Ei 'cni|flannel|cali|cilium|vxlan|geneve' ||
    echo "No common CNI/overlay interface detected"

k8s_ok "Overlay and MTU inspection completed"
