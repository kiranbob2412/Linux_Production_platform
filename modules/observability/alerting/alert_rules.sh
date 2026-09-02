#!/bin/bash

source "$(dirname "$0")/../common.sh"

RULES="$PROJECT_ROOT/config/observability/prometheus/rules/platform_alerts.yml"

obs_section "PROMETHEUS ALERT RULES"

if [ ! -f "$RULES" ]; then
    echo "Alert rules: MISSING"
    exit 1
fi

echo "Alert rules: FOUND"

echo
echo "Configured alerts:"
grep -E '^[[:space:]]*- alert:' "$RULES" || true

echo
echo "Severity levels:"
grep -E '^[[:space:]]*severity:' "$RULES" | sort -u

obs_report "Prometheus alert rules validated."
