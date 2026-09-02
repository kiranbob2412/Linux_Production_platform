#!/bin/bash

BASE="$(cd "$(dirname "$0")" && pwd)"

echo "======================================"
echo "GRAFANA OBSERVABILITY"
echo "======================================"

modules=(
    grafana/grafana.sh
    grafana/dashboard_validation.sh
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
    echo "GRAFANA LAYER: PASS"
    exit 0
else
    echo "GRAFANA LAYER: DEGRADED"
    exit 1
fi
