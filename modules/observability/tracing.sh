#!/bin/bash
set -u

source "$(dirname "$0")/common.sh"

obs_section "DISTRIBUTED TRACING"

echo "Tracing architecture:"
echo "Application / Trace Generator"
echo "    -> OpenTelemetry SDK / OTLP"
echo "    -> OpenTelemetry Collector"
echo "    -> Grafana Tempo"
echo "    -> Grafana Explore"

echo
echo "OpenTelemetry Collector:"
echo "OTLP gRPC: 4317"
echo "OTLP HTTP: 4318"

echo
echo "Grafana Tempo:"
echo "OTLP gRPC: 4327"
echo "OTLP HTTP: 4328"
echo "HTTP API: 3200"

echo
echo "Trace dimensions:"
echo "Trace ID"
echo "Span ID"
echo "Parent / Child spans"
echo "Service dependency"
echo "Latency"
echo "Error status"

echo
if curl -fsS --max-time 5 \
    http://127.0.0.1:3200/ready >/dev/null 2>&1; then
    echo "Tempo: HEALTHY"
    obs_report "Distributed tracing backend is healthy."
else
    echo "Tempo: NOT AVAILABLE"
    obs_report "Distributed tracing backend is not currently available."
fi
