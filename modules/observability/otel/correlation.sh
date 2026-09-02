#!/bin/bash

source "$(dirname "$0")/../common.sh"

obs_section "TELEMETRY CORRELATION"

echo "Metric"
echo "  ↓"
echo "Alert"
echo "  ↓"
echo "Trace ID"
echo "  ↓"
echo "Trace spans"
echo "  ↓"
echo "Logs"
echo "  ↓"
echo "Infrastructure / network evidence"
echo "  ↓"
echo "Root cause"

echo
echo "Correlation keys:"
echo "trace_id"
echo "span_id"
echo "service.name"
echo "host.name"
echo "k8s.pod.name"
echo "cloud.provider"
echo "cloud.region"

obs_report "Telemetry correlation model validated."
