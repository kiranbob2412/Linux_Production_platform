#!/bin/bash

source "$(dirname "$0")/../common.sh"

DASHBOARD="$PROJECT_ROOT/config/observability/grafana/dashboards/linux-production-platform.json"
DATASOURCE="$PROJECT_ROOT/config/observability/grafana/provisioning/datasources/prometheus.yml"
PROVIDER="$PROJECT_ROOT/config/observability/grafana/provisioning/dashboards/dashboard.yml"

obs_section "GRAFANA DASHBOARD VALIDATION"

failed=0

for file in "$DASHBOARD" "$DATASOURCE" "$PROVIDER"; do
    if [ -f "$file" ]; then
        echo "PASS: $(basename "$file")"
    else
        echo "FAIL: $(basename "$file")"
        failed=$((failed + 1))
    fi
done

if command -v python3 >/dev/null 2>&1; then
    if python3 -m json.tool "$DASHBOARD" >/dev/null 2>&1; then
        echo "PASS: dashboard JSON syntax"
    else
        echo "FAIL: dashboard JSON syntax"
        failed=$((failed + 1))
    fi
fi

obs_report "Grafana dashboard validation completed."

if [ "$failed" -eq 0 ]; then
    exit 0
else
    exit 1
fi
