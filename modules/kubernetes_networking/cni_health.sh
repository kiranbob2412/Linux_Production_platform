#!/bin/bash

source "$(dirname "$0")/k8s_common.sh"

k8s_section "CNI HEALTH"

if ! k8s_ready; then
    k8s_na "kubectl unavailable"
    exit 0
fi

if ! k8s_cluster_reachable; then
    k8s_na "Kubernetes cluster unavailable"
    exit 0
fi

echo "CNI-related workloads:"

kubectl get pods -A -o wide 2>/dev/null |
    grep -Ei 'cilium|calico|flannel|weave|antrea|canal|aws-node|azure-cni|kube-router' ||
    echo "No recognized CNI workload detected"

echo
echo "DaemonSets:"
kubectl get daemonsets -A 2>/dev/null |
    grep -Ei 'cilium|calico|flannel|weave|antrea|canal|aws-node|kube-router' ||
    echo "No recognized CNI DaemonSet detected"

echo
echo "Unhealthy networking pods:"

kubectl get pods -A --no-headers 2>/dev/null |
awk '$4 != "Running" && $4 != "Completed" {print}' |
sed -n '1,100p' || true

k8s_ok "CNI health inspection completed"
