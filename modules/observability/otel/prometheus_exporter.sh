#!/bin/bash

source "$(dirname "$0")/../common.sh"

obs_section "OTEL PROMETHEUS EXPORTER"

if obs_command_exists curl; then
    if curl -fsS --max-time 3 \
        http://127.0.0.1:8889/metrics >/dev/null 2>&1; then
        echo "OTel Prometheus endpoint: HEALTHY"
        obs_report "OTel Prometheus exporter endpoint healthy."
    else
        echo "OTel Prometheus endpoint: NOT AVAILABLE"
        echo "Status: READY FOR COLLECTOR CONFIGURATION"
    fi
fi

echo
echo "Exporter endpoint:"
echo "http://127.0.0.1:8889/metrics"
