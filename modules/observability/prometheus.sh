#!/bin/bash

source "$(dirname "$0")/common.sh"

obs_section "PROMETHEUS"

if obs_command_exists prometheus; then
    echo "Prometheus: INSTALLED"
    prometheus --version 2>/dev/null | head -1
    obs_report "Prometheus detected."
else
    echo "Prometheus: NOT INSTALLED"
    echo "Integration status: READY"
    obs_report "Prometheus not installed; integration point ready."
fi

if obs_command_exists curl; then
    echo
    echo "Prometheus endpoint:"
    if curl -fsS --max-time 3 http://127.0.0.1:9090/-/healthy >/dev/null 2>&1; then
        echo "Prometheus API: HEALTHY"
    else
        echo "Prometheus API: NOT AVAILABLE"
    fi
fi
