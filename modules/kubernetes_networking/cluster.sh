#!/bin/bash

source "$(dirname "$0")/k8s_common.sh"

k8s_section "KUBERNETES CLUSTER NETWORKING"

if ! k8s_ready; then
    k8s_na "kubectl unavailable"
    exit 0
fi

if ! k8s_cluster_reachable; then
    k8s_na "Kubernetes cluster unavailable"
    exit 0
fi

echo "Cluster:"
kubectl cluster-info

echo
echo "Nodes:"
kubectl get nodes -o wide

echo
echo "Node PodCIDRs:"
kubectl get nodes \
    -o custom-columns='NAME:.metadata.name,POD-CIDR:.spec.podCIDR,POD-CIDRS:.spec.podCIDRs,INTERNAL-IP:.status.addresses[?(@.type=="InternalIP")].address'

k8s_ok "Kubernetes cluster networking inspected"
