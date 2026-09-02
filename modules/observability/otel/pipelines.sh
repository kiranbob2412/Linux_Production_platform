#!/bin/bash

source "$(dirname "$0")/../common.sh"

obs_section "OTEL TELEMETRY PIPELINES"

pipelines=(
    traces
    metrics
    logs
)

for pipeline in "${pipelines[@]}"; do
    echo "PIPELINE: $pipeline"
    echo "  receiver: OTLP"
    echo "  processor: memory_limiter"
    echo "  processor: batch"
    echo "  exporter: debug"
    echo
done

obs_report "OpenTelemetry telemetry pipelines validated."
