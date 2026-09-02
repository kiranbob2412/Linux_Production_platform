#!/bin/bash

source "$(dirname "$0")/../common.sh"

obs_section "GRAFANA"

if obs_command_exists grafana-server; then
    echo "Grafana binary: AVAILABLE"
else
    echo "Grafana binary: NOT INSTALLED"
    echo "Integration status: READY"
fi

if obs_command_exists curl; then
    if curl -fsS --max-time 3 \
        http://127.0.0.1:3000/api/health >/dev/null 2>&1; then
        echo "Grafana API: HEALTHY"
        obs_report "Grafana API healthy."
    else
        echo "Grafana API: NOT AVAILABLE"
    fi
fi
