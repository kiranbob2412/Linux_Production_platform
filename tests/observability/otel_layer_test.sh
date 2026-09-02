#!/bin/bash

PROJECT_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

CONFIG="$PROJECT_ROOT/config/observability/otel/otelcol.yml"

MODULES=(
    "$PROJECT_ROOT/modules/observability/otel/collector.sh"
    "$PROJECT_ROOT/modules/observability/otel/pipelines.sh"
    "$PROJECT_ROOT/modules/observability/otel/tracing.sh"
    "$PROJECT_ROOT/modules/observability/otel/correlation.sh"
    "$PROJECT_ROOT/modules/observability/otel/health.sh"
    "$PROJECT_ROOT/modules/observability/otel_master.sh"
)

failed=0

echo "======================================"
echo "OPENTELEMETRY LAYER TEST"
echo "======================================"

if [ -f "$CONFIG" ]; then
    echo "PASS: otelcol.yml"
else
    echo "FAIL: otelcol.yml"
    failed=$((failed + 1))
fi

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
    echo "PASS: OPENTELEMETRY LAYER TEST"
    exit 0
else
    echo "FAIL: $failed checks failed"
    exit 1
fi
