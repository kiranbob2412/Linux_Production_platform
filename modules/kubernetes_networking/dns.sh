#!/bin/bash

source "$(dirname "$0")/k8s_common.sh"

k8s_section "KUBERNETES DNS"

if ! k8s_ready; then
    k8s_na "kubectl unavailable"
    exit 0
fi

if ! k8s_cluster_reachable; then
    k8s_na "Kubernetes cluster unavailable"
    exit 0
fi

echo "DNS services:"
kubectl get svc -A 2>/dev/null |
    grep -Ei 'kube-dns|coredns' || true

echo
echo "DNS pods:"
kubectl get pods -A -o wide 2>/dev/null |
    grep -Ei 'coredns|kube-dns' || true

echo
echo "DNS ConfigMaps:"
kubectl get configmap -A 2>/dev/null |
    grep -Ei 'coredns|kube-dns' || true

k8s_ok "Kubernetes DNS analysis completed"
