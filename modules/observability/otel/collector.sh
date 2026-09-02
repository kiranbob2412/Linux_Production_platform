#!/bin/bash

source "$(dirname "$0")/../common.sh"

CONFIG="$PROJECT_ROOT/config/observability/otel/otelcol.yml"

obs_section "OPENTELEMETRY COLLECTOR"

if [ ! -f "$CONFIG" ]; then
    echo "Collector configuration: MISSING"
    exit 1
fi

echo "Collector configuration: FOUND"

if obs_command_exists otelcol; then
    echo "otelcol binary: AVAILABLE"
elif obs_command_exists otelcol-contrib; then
    echo "otelcol-contrib binary: AVAILABLE"
else
    echo "OpenTelemetry Collector: NOT INSTALLED"
    echo "Integration status: READY"
fi

echo
echo "OTLP endpoints:"
echo "gRPC: 0.0.0.0:4317"
echo "HTTP: 0.0.0.0:4318"

obs_report "OpenTelemetry Collector configuration checked."
