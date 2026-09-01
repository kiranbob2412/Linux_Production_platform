#!/bin/bash

set -u

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
DIR="$ROOT/modules/kubernetes_networking"

FAILURES=0

for file in "$DIR"/*.sh; do
    if bash -n "$file"; then
        echo "PASS: syntax $(basename "$file")"
    else
        echo "FAIL: syntax $(basename "$file")"
        FAILURES=$((FAILURES + 1))
    fi
done

REQUIRED=(
    k8s_common.sh
    cluster.sh
    cni.sh
    services.sh
    network_policy.sh
    dns.sh
    ebpf.sh
    kube_proxy.sh
    k8s_network_master.sh
)

for file in "${REQUIRED[@]}"; do
    if [ -f "$DIR/$file" ]; then
        echo "PASS: module $file"
    else
        echo "FAIL: missing $file"
        FAILURES=$((FAILURES + 1))
    fi
done

if [ "$FAILURES" -eq 0 ]; then
    echo
    echo "PASS: KUBERNETES NETWORKING FOUNDATION TEST"
    exit 0
fi

echo
echo "FAIL: KUBERNETES NETWORKING FOUNDATION TEST"
exit 1
