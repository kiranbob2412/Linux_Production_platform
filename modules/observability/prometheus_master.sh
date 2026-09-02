#!/bin/bash

BASE="$(cd "$(dirname "$0")" && pwd)"

echo "======================================"
echo "PROMETHEUS OBSERVABILITY"
echo "======================================"

modules=(
    prometheus/prometheus_config.sh
    prometheus/metrics_contract.sh
    prometheus/prometheus_health.sh
)

failed=0

for module in "${modules[@]}"; do
    echo
    echo ">>> Running: $module"

    if bash "$BASE/$module"; then
        echo "STATUS: PASS"
    else
        echo "STATUS: FAIL"
        failed=$((failed + 1))
    fi
done

echo
echo "======================================"

if [ "$failed" -eq 0 ]; then
    echo "PROMETHEUS LAYER: PASS"
    exit 0
else
    echo "PROMETHEUS LAYER: DEGRADED"
    exit 1
fi
