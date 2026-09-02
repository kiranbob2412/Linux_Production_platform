#!/bin/bash

source "$(dirname "$0")/../common.sh"

obs_section "OPENTELEMETRY HEALTH"

if obs_command_exists otelcol || obs_command_exists otelcol-contrib; then
    echo "Collector binary: AVAILABLE"
else
    echo "Collector binary: NOT INSTALLED"
    echo "Configuration layer: READY"
fi

if obs_command_exists curl; then
    if curl -fsS --max-time 3 \
        http://127.0.0.1:13133/ >/dev/null 2>&1; then
        echo "Collector health endpoint: HEALTHY"
    else
        echo "Collector health endpoint: NOT AVAILABLE"
    fi
fi

obs_report "OpenTelemetry health check completed."
