#!/bin/bash

BASE="$(cd "$(dirname "$0")" && pwd)"

echo "======================================"
echo "OBSERVABILITY ENGINEERING"
echo "======================================"

modules=(
    metrics.sh
    prometheus.sh
    logs.sh
    otel.sh
    tracing.sh
    ebpf_observability.sh
    flow_logs.sh
    correlation.sh
    health.sh
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
    echo "OBSERVABILITY HEALTH: PASS"
    exit 0
else
    echo "OBSERVABILITY HEALTH: DEGRADED"
    exit 1
fi
