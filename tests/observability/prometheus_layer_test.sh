#!/bin/bash

PROJECT_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

CONFIG="$PROJECT_ROOT/config/observability/prometheus/prometheus.yml"
RULES="$PROJECT_ROOT/config/observability/prometheus/rules/platform_rules.yml"

MODULES=(
    "$PROJECT_ROOT/modules/observability/prometheus/prometheus_config.sh"
    "$PROJECT_ROOT/modules/observability/prometheus/metrics_contract.sh"
    "$PROJECT_ROOT/modules/observability/prometheus/prometheus_health.sh"
    "$PROJECT_ROOT/modules/observability/prometheus_master.sh"
)

failed=0

echo "======================================"
echo "PROMETHEUS LAYER TEST"
echo "======================================"

if [ -f "$CONFIG" ]; then
    echo "PASS: prometheus.yml"
else
    echo "FAIL: prometheus.yml"
    failed=$((failed + 1))
fi

if [ -f "$RULES" ]; then
    echo "PASS: platform_rules.yml"
else
    echo "FAIL: platform_rules.yml"
    failed=$((failed + 1))
fi

for module in "${MODULES[@]}"; do

    if [ ! -f "$module" ]; then
        echo "FAIL: missing $module"
        failed=$((failed + 1))
        continue
    fi

    if ! bash -n "$module"; then
        echo "FAIL: syntax $module"
        failed=$((failed + 1))
        continue
    fi

    if [ ! -x "$module" ]; then
        echo "FAIL: not executable $module"
        failed=$((failed + 1))
        continue
    fi

    echo "PASS: $(basename "$module")"
done

echo

if [ "$failed" -eq 0 ]; then
    echo "PASS: PROMETHEUS LAYER TEST"
    exit 0
else
    echo "FAIL: $failed checks failed"
    exit 1
fi
