#!/bin/bash
set -euo pipefail

CONFIG="$HOME/linux-production-platform/config/observability/grafana/provisioning/datasources/loki.yml"

echo "======================================"
echo "GRAFANA LOKI DATASOURCE TEST"
echo "======================================"

if [ ! -f "$CONFIG" ]; then
    echo "FAIL: Loki datasource configuration not found"
    exit 1
fi
echo "PASS: Loki datasource configuration"

required_patterns=(
    "name: Loki"
    "type: loki"
    "url: http://127.0.0.1:3100"
    "access: proxy"
)

for pattern in "${required_patterns[@]}"; do
    if grep -Fq "$pattern" "$CONFIG"; then
        echo "PASS: $pattern"
    else
        echo "FAIL: $pattern"
        exit 1
    fi
done

if systemctl is-active --quiet grafana-server; then
    echo "PASS: Grafana service"
else
    echo "FAIL: Grafana service"
    exit 1
fi

echo
echo "GRAFANA LOKI DATASOURCE TEST: PASS"
