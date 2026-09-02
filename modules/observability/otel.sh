#!/bin/bash

source "$(dirname "$0")/common.sh"

obs_section "OPENTELEMETRY"

if obs_command_exists otelcol; then
    echo "OpenTelemetry Collector: INSTALLED"
    otelcol --version 2>/dev/null | head -1
    obs_report "OpenTelemetry Collector detected."
elif obs_command_exists otelcol-contrib; then
    echo "OpenTelemetry Collector Contrib: INSTALLED"
    otelcol-contrib --version 2>/dev/null | head -1
    obs_report "OpenTelemetry Collector Contrib detected."
else
    echo "OpenTelemetry Collector: NOT INSTALLED"
    echo "Integration status: READY"
    obs_report "OpenTelemetry Collector not installed."
fi
