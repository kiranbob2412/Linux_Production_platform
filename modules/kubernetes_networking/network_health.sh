#!/bin/bash

source "$(dirname "$0")/k8s_common.sh"

k8s_section "KUBERNETES NETWORK HEALTH"

if ! k8s_ready; then
    k8s_na "kubectl unavailable"
    exit 0
fi

if ! k8s_cluster_reachable; then
    k8s_na "Kubernetes cluster unavailable"
    exit 0
fi

FAIL=0

echo "Nodes:"
if kubectl get nodes --no-headers 2>/dev/null |
    awk '$2 != "Ready" {bad++} END {exit bad+0}'; then
    k8s_ok "All nodes Ready"
else
    k8s_fail "One or more nodes are not Ready"
    FAIL=1
fi

echo
echo "CoreDNS:"
if kubectl get pods -A --no-headers 2>/dev/null |
    grep -Ei 'coredns|kube-dns' |
    awk '$4 != "Running" && $4 != "Completed" {bad++} END {exit bad+0}'; then
    k8s_ok "CoreDNS appears healthy"
else
    k8s_warn "CoreDNS health requires investigation"
fi

echo
echo "Networking workloads:"
kubectl get pods -A -o wide 2>/dev/null |
    grep -Ei 'cilium|calico|flannel|antrea|aws-node|kube-proxy' |
    sed -n '1,120p' || true

echo
echo "Kubernetes network health result:"

if [ "$FAIL" -eq 0 ]; then
    echo "KUBERNETES NETWORK HEALTH: OK"
else
    echo "KUBERNETES NETWORK HEALTH: DEGRADED"
fi
