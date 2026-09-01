#!/bin/bash

source "$(dirname "$0")/k8s_common.sh"

k8s_section "NETWORK POLICY VALIDATION"

if ! k8s_ready; then
    k8s_na "kubectl unavailable"
    exit 0
fi

if ! k8s_cluster_reachable; then
    k8s_na "Kubernetes cluster unavailable"
    exit 0
fi

POLICY_COUNT="$(
    kubectl get networkpolicy -A \
        --no-headers 2>/dev/null |
        wc -l
)"

echo "NetworkPolicy count: $POLICY_COUNT"

if [ "$POLICY_COUNT" -eq 0 ]; then
    k8s_warn "No NetworkPolicy objects detected"
else
    k8s_ok "NetworkPolicy objects detected"
fi

echo
echo "Namespaces:"
kubectl get namespaces \
    -o custom-columns='NAME:.metadata.name'

echo
echo "Policies:"
kubectl get networkpolicy -A -o wide 2>/dev/null || true

echo
echo "Policy selectors:"
kubectl get networkpolicy -A \
    -o jsonpath='{range .items[*]}{.metadata.namespace}{" / "}{.metadata.name}{" : "}{.spec.podSelector.matchLabels}{"\n"}{end}' \
    2>/dev/null || true
