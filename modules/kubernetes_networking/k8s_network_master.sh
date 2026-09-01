#!/bin/bash

set -u

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
DIR="$ROOT/modules/kubernetes_networking"

REPORT_DIR="$ROOT/reports/kubernetes_networking"
mkdir -p "$REPORT_DIR"

REPORT="$REPORT_DIR/k8s_network_$(date +%Y%m%d_%H%M%S).report"

exec > >(tee "$REPORT") 2>&1

source "$DIR/k8s_common.sh"

echo "============================================================"
echo " LINUX PRODUCTION PLATFORM"
echo " KUBERNETES NETWORKING ENGINEERING"
echo "============================================================"

MODULES=(
    cluster.sh
    cni.sh
    services.sh
    network_policy.sh
    dns.sh
    ebpf.sh
    kube_proxy.sh
)

for module in "${MODULES[@]}"; do
    echo
    echo "------------------------------------------------------------"
    echo "MODULE: $module"
    echo "------------------------------------------------------------"

    bash "$DIR/$module" || true
done

echo
echo "============================================================"
echo " KUBERNETES NETWORKING SUMMARY"
echo "============================================================"

echo "OK       : $K8S_OK"
echo "WARN     : $K8S_WARN"
echo "FAIL     : $K8S_FAIL"
echo "N/A      : $K8S_NA"

echo
echo "Report: $REPORT"
