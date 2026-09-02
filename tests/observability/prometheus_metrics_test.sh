#!/bin/bash

PROJECT_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

MODULES=(
    "$PROJECT_ROOT/modules/observability/prometheus/node_exporter.sh"
    "$PROJECT_ROOT/modules/observability/prometheus/linux_metrics.sh"
    "$PROJECT_ROOT/modules/observability/prometheus/metrics_validation.sh"
)

failed=0

echo "======================================"
echo "PROMETHEUS LINUX METRICS TEST"
echo "======================================"

for module in "${MODULES[@]}"; do

    if [ ! -f "$module" ]; then
        echo "FAIL: missing $(basename "$module")"
        failed=$((failed + 1))
        continue
    fi

    if ! bash -n "$module"; then
        echo "FAIL: syntax $(basename "$module")"
        failed=$((failed + 1))
        continue
    fi

    if [ ! -x "$module" ]; then
        echo "FAIL: executable $(basename "$module")"
        failed=$((failed + 1))
        continue
    fi

    echo "PASS: $(basename "$module")"
done

echo

if [ "$failed" -eq 0 ]; then
    echo "PASS: PROMETHEUS LINUX METRICS TEST"
    exit 0
else
    echo "FAIL: $failed checks failed"
    exit 1
fi
