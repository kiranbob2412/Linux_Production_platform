#!/bin/bash

PROJECT_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
OBS_DIR="$PROJECT_ROOT/modules/observability"

modules=(
    common.sh
    metrics.sh
    prometheus.sh
    logs.sh
    otel.sh
    tracing.sh
    ebpf_observability.sh
    flow_logs.sh
    correlation.sh
    health.sh
    observability_master.sh
)

failed=0

echo "======================================"
echo "OBSERVABILITY FOUNDATION TEST"
echo "======================================"

for module in "${modules[@]}"; do
    file="$OBS_DIR/$module"

    if [ ! -f "$file" ]; then
        echo "FAIL: Missing $module"
        failed=$((failed + 1))
        continue
    fi

    if ! bash -n "$file"; then
        echo "FAIL: Syntax error: $module"
        failed=$((failed + 1))
        continue
    fi

    if [ ! -x "$file" ]; then
        echo "FAIL: Not executable: $module"
        failed=$((failed + 1))
        continue
    fi

    echo "PASS: $module"
done

echo

if [ "$failed" -eq 0 ]; then
    echo "PASS: OBSERVABILITY FOUNDATION TEST"
    exit 0
else
    echo "FAIL: $failed checks failed"
    exit 1
fi
