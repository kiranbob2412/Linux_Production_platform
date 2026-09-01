#!/bin/bash

source "$(dirname "$0")/k8s_common.sh"

k8s_section "KUBERNETES NETWORK POLICY"

if ! k8s_ready; then
    k8s_na "kubectl unavailable"
    exit 0
fi

if ! k8s_cluster_reachable; then
    k8s_na "Kubernetes cluster unavailable"
    exit 0
fi

echo "NetworkPolicies:"
kubectl get networkpolicy -A 2>/dev/null || true

echo
echo "Policy definitions:"
kubectl get networkpolicy -A -o yaml 2>/dev/null |
    sed -n '1,600p' || true

k8s_ok "NetworkPolicy analysis completed"
