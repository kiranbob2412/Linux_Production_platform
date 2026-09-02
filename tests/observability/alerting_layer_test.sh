#!/bin/bash

PROJECT_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

FILES=(
    "$PROJECT_ROOT/config/observability/prometheus/rules/platform_alerts.yml"
    "$PROJECT_ROOT/config/observability/alertmanager/alertmanager.yml"
)

MODULES=(
    "$PROJECT_ROOT/modules/observability/alerting/alert_rules.sh"
    "$PROJECT_ROOT/modules/observability/alerting/alertmanager.sh"
    "$PROJECT_ROOT/modules/observability/alerting/severity.sh"
    "$PROJECT_ROOT/modules/observability/alerting_master.sh"
)

failed=0

echo "======================================"
echo "ALERTING LAYER TEST"
echo "======================================"

for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "PASS: $(basename "$file")"
    else
        echo "FAIL: $(basename "$file")"
        failed=$((failed + 1))
    fi
done

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
    echo "PASS: ALERTING LAYER TEST"
    exit 0
else
    echo "FAIL: $failed checks failed"
    exit 1
fi
