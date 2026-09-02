#!/bin/bash

BASE="$(cd "$(dirname "$0")" && pwd)"

echo "======================================"
echo "PRODUCTION ALERTING"
echo "======================================"

modules=(
    alerting/alert_rules.sh
    alerting/alertmanager.sh
    alerting/severity.sh
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
    echo "ALERTING LAYER: PASS"
    exit 0
else
    echo "ALERTING LAYER: DEGRADED"
    exit 1
fi
