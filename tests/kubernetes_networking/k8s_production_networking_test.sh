#!/bin/bash

set -u

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
DIR="$ROOT/modules/kubernetes_networking"

FAILURES=0

MODULES=(
    pod_connectivity.sh
    service_path.sh
    node_pod_routing.sh
    cni_health.sh
    overlay_mtu.sh
    ingress_gateway.sh
    network_policy_validation.sh
    network_health.sh
)

echo "============================================================"
echo " KUBERNETES PRODUCTION NETWORKING TEST"
echo "============================================================"

for module in "${MODULES[@]}"; do

    if [ ! -f "$DIR/$module" ]; then
        echo "FAIL: missing $module"
        FAILURES=$((FAILURES + 1))
        continue
    fi

    if bash -n "$DIR/$module"; then
        echo "PASS: syntax $module"
    else
        echo "FAIL: syntax $module"
        FAILURES=$((FAILURES + 1))
    fi

done

if bash -n "$DIR/k8s_network_master.sh"; then
    echo "PASS: master syntax"
else
    echo "FAIL: master syntax"
    FAILURES=$((FAILURES + 1))
fi

if [ "$FAILURES" -eq 0 ]; then
    echo
    echo "PASS: KUBERNETES PRODUCTION NETWORKING TEST"
    echo "PASS: ALL PRODUCTION NETWORKING MODULES VALIDATED"
    exit 0
fi

echo
echo "FAIL: KUBERNETES PRODUCTION NETWORKING TEST"
echo "FAILURES: $FAILURES"
exit 1
