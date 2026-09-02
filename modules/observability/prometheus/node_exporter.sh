#!/bin/bash

source "$(dirname "$0")/../common.sh"

obs_section "NODE EXPORTER"

if obs_command_exists node_exporter; then
    echo "Node Exporter binary: AVAILABLE"
    node_exporter --version 2>&1 | head -1
    obs_report "Node Exporter binary detected."
else
    echo "Node Exporter binary: NOT INSTALLED"
    echo "Integration status: READY"
fi

if obs_command_exists curl; then
    echo
    echo "Node Exporter endpoint:"
    if curl -fsS --max-time 3 \
        http://127.0.0.1:9100/metrics >/dev/null 2>&1; then
        echo "Metrics endpoint: HEALTHY"
        obs_report "Node Exporter metrics endpoint healthy."
    else
        echo "Metrics endpoint: NOT AVAILABLE"
    fi
fi
