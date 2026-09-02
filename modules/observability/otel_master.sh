#!/bin/bash

BASE="$(cd "$(dirname "$0")" && pwd)"

echo "======================================"
echo "OPENTELEMETRY OBSERVABILITY"
echo "======================================"

modules=(
    otel/collector.sh
    otel/pipelines.sh
    otel/tracing.sh
    otel/correlation.sh
    otel/health.sh
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
    echo "OPENTELEMETRY LAYER: PASS"
    exit 0
else
    echo "OPENTELEMETRY LAYER: DEGRADED"
    exit 1
fi
