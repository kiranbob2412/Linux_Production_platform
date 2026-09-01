#!/bin/bash

source "$(dirname "$0")/k8s_common.sh"

k8s_section "KUBERNETES POD CONNECTIVITY"

if ! k8s_ready; then
    k8s_na "kubectl unavailable"
    exit 0
fi

if ! k8s_cluster_reachable; then
    k8s_na "Kubernetes cluster unavailable"
    exit 0
fi

echo "Pods:"
kubectl get pods -A -o wide

echo
echo "Pod IP inventory:"
kubectl get pods -A \
    -o custom-columns='NAMESPACE:.metadata.namespace,NAME:.metadata.name,IP:.status.podIP,NODE:.spec.nodeName,PHASE:.status.phase'

k8s_ok "Pod connectivity inventory completed"
