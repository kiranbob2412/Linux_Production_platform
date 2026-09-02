#!/bin/bash

source "$(dirname "$0")/../common.sh"

CONFIG="$PROJECT_ROOT/config/observability/prometheus/prometheus.yml"
RULES="$PROJECT_ROOT/config/observability/prometheus/rules/platform_rules.yml"

obs_section "PROMETHEUS CONFIGURATION"

if [ -f "$CONFIG" ]; then
    echo "Prometheus configuration: FOUND"
else
    echo "Prometheus configuration: MISSING"
    exit 1
fi

if [ -f "$RULES" ]; then
    echo "Prometheus rules: FOUND"
else
    echo "Prometheus rules: MISSING"
    exit 1
fi

echo
echo "Scrape interval:"
grep -E '^[[:space:]]*scrape_interval:' "$CONFIG" || true

echo
echo "Configured jobs:"
grep -E '^[[:space:]]*- job_name:' "$CONFIG" || true

obs_report "Prometheus configuration validation completed."
