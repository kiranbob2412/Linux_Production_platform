#!/bin/bash

source "$(dirname "$0")/k8s_common.sh"

k8s_section "NODE TO POD ROUTING"

echo "Local Linux routes:"

ip route 2>/dev/null |
    sed -n '1,160p'

echo
echo "Pod-related routes:"

ip route 2>/dev/null |
    grep -Ei 'cni|pod|docker|calico|cilium|flannel|veth' ||
    echo "No obvious CNI routes detected"

echo
echo "CNI interfaces:"

ip -br link 2>/dev/null |
    grep -Ei 'cni|veth|flannel|cali|cilium' ||
    echo "No obvious CNI interfaces detected"

k8s_ok "Node-to-Pod routing inventory completed"
