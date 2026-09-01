#!/bin/bash

source "$(dirname "$0")/k8s_common.sh"

k8s_section "KUBE-PROXY NETWORKING"

if ! k8s_ready; then
    k8s_na "kubectl unavailable"
    exit 0
fi

if ! k8s_cluster_reachable; then
    k8s_na "Kubernetes cluster unavailable"
    exit 0
fi

echo "kube-proxy pods:"
kubectl get pods -A -o wide 2>/dev/null |
    grep -Ei 'kube-proxy' ||
    echo "kube-proxy pods not detected"

echo
echo "kube-proxy DaemonSet:"
kubectl get daemonset -A 2>/dev/null |
    grep -Ei 'kube-proxy' || true

k8s_ok "kube-proxy analysis completed"
