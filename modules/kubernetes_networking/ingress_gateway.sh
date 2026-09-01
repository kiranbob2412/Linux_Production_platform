#!/bin/bash

source "$(dirname "$0")/k8s_common.sh"

k8s_section "KUBERNETES INGRESS AND GATEWAY"

if ! k8s_ready; then
    k8s_na "kubectl unavailable"
    exit 0
fi

if ! k8s_cluster_reachable; then
    k8s_na "Kubernetes cluster unavailable"
    exit 0
fi

echo "Ingress resources:"
kubectl get ingress -A -o wide 2>/dev/null || true

echo
echo "Gateway API resources:"

if kubectl api-resources 2>/dev/null | grep -qi '^gateways'; then
    kubectl get gateway -A 2>/dev/null || true
    kubectl get gatewayclass -A 2>/dev/null || true
    kubectl get httproute -A 2>/dev/null || true
    kubectl get grpcroutes -A 2>/dev/null || true
else
    echo "Gateway API resources not installed"
fi

echo
echo "Ingress/Gateway controllers:"
kubectl get pods -A -o wide 2>/dev/null |
    grep -Ei 'ingress|gateway|traefik|nginx|haproxy|envoy' ||
    echo "No recognized ingress/gateway controller detected"

k8s_ok "Ingress/Gateway analysis completed"
