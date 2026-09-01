#!/bin/bash

source "$(dirname "$0")/k8s_common.sh"

k8s_section "KUBERNETES SERVICE NETWORKING"

if ! k8s_ready; then
    k8s_na "kubectl unavailable"
    exit 0
fi

if ! k8s_cluster_reachable; then
    k8s_na "Kubernetes cluster unavailable"
    exit 0
fi

echo "Services:"
kubectl get svc -A -o wide

echo
echo "EndpointSlices:"
kubectl get endpointslices -A -o wide 2>/dev/null || true

echo
echo "Ingress:"
kubectl get ingress -A 2>/dev/null || true

k8s_ok "Service networking inspected"
