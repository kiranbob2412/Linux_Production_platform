#!/bin/bash

source "$(dirname "$0")/k8s_common.sh"

k8s_section "KUBERNETES CNI ANALYSIS"

if ! k8s_ready; then
    k8s_na "kubectl unavailable"
    exit 0
fi

if ! k8s_cluster_reachable; then
    k8s_na "Kubernetes cluster unavailable"
    exit 0
fi

echo "CNI-related pods:"
kubectl get pods -A -o wide 2>/dev/null |
    grep -Ei 'cilium|calico|flannel|weave|antrea|canal|aws-node|azure-cni|kube-router' ||
    echo "No recognized CNI pods detected"

echo
echo "CNI configuration on node:"
if [ -d /etc/cni/net.d ]; then
    find /etc/cni/net.d -maxdepth 1 -type f -print 2>/dev/null
else
    echo "Node CNI directory not accessible"
fi

k8s_ok "CNI analysis completed"
