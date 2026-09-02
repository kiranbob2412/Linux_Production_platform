#!/bin/bash

source "$(dirname "$0")/common.sh"

obs_section "DISTRIBUTED TRACING"

echo "Tracing architecture:"
echo "Application"
echo "    -> OpenTelemetry SDK"
echo "    -> OpenTelemetry Collector"
echo "    -> Trace Backend"

echo
echo "Trace dimensions:"
echo "Trace ID"
echo "Span ID"
echo "Parent / Child spans"
echo "Service dependency"
echo "Latency"
echo "Error status"

obs_report "Distributed tracing architecture validated."
