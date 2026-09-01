#!/bin/bash

source "$(dirname "$0")/k8s_common.sh"

k8s_section "KUBERNETES SERVICE PATH ANALYSIS"

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
kubectl get endpointslices -A \
    -o custom-columns='NAMESPACE:.metadata.namespace,NAME:.metadata.name,SERVICE:.metadata.labels.kubernetes\.io/service-name,ENDPOINTS:.endpoints[*].addresses[*]' \
    2>/dev/null || true

echo
echo "Service → Endpoints consistency:"
kubectl get svc -A --no-headers 2>/dev/null |
while read -r namespace service rest; do
    endpoints="$(kubectl get endpointslice \
        -n "$namespace" \
        -l "kubernetes.io/service-name=$service" \
        --no-headers 2>/dev/null | wc -l)"

    if [ "$endpoints" -gt 0 ]; then
        echo "OK: $namespace/$service has EndpointSlice data"
    else
        echo "WARN: $namespace/$service has no EndpointSlice data"
    fi
done

k8s_ok "Service path analysis completed"
