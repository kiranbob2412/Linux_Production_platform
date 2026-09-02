#!/bin/bash

source "$(dirname "$0")/../common.sh"

obs_section "PROMETHEUS HEALTH"

if ! obs_command_exists curl; then
    echo "curl: NOT AVAILABLE"
    exit 1
fi

if curl -fsS --max-time 3 \
    http://127.0.0.1:9090/-/healthy >/dev/null 2>&1; then

    echo "Prometheus endpoint: HEALTHY"

    if curl -fsS --max-time 3 \
        http://127.0.0.1:9090/api/v1/status/buildinfo >/dev/null 2>&1; then
        echo "Prometheus API: HEALTHY"
    else
        echo "Prometheus API: DEGRADED"
    fi
else
    echo "Prometheus server: NOT RUNNING"
    echo "Status: N/A - server deployment is a later integration step"
fi

obs_report "Prometheus health check completed."
