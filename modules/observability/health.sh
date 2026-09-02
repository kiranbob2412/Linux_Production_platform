#!/bin/bash

source "$(dirname "$0")/common.sh"

obs_section "OBSERVABILITY HEALTH"

health=0

if obs_command_exists journalctl; then
    echo "Logging capability: OK"
    health=$((health + 1))
else
    echo "Logging capability: DEGRADED"
fi

if obs_command_exists ss; then
    echo "Network telemetry capability: OK"
    health=$((health + 1))
else
    echo "Network telemetry capability: DEGRADED"
fi

if obs_command_exists ps; then
    echo "Process telemetry capability: OK"
    health=$((health + 1))
else
    echo "Process telemetry capability: DEGRADED"
fi

if obs_command_exists free; then
    echo "Memory telemetry capability: OK"
    health=$((health + 1))
else
    echo "Memory telemetry capability: DEGRADED"
fi

echo
echo "Healthy capabilities: $health/4"

obs_report "Observability health: $health/4"
