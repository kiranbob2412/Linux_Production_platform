#!/bin/bash

source "$(dirname "$0")/../common.sh"

CONFIG="$PROJECT_ROOT/config/observability/alertmanager/alertmanager.yml"

obs_section "ALERTMANAGER"

if [ ! -f "$CONFIG" ]; then
    echo "Alertmanager configuration: MISSING"
    exit 1
fi

echo "Alertmanager configuration: FOUND"

if obs_command_exists alertmanager; then
    echo "Alertmanager binary: AVAILABLE"
    alertmanager --version 2>&1 | head -1
else
    echo "Alertmanager binary: NOT INSTALLED"
    echo "Integration status: READY"
fi

if obs_command_exists curl; then
    echo
    if curl -fsS --max-time 3 \
        http://127.0.0.1:9093/-/healthy >/dev/null 2>&1; then
        echo "Alertmanager endpoint: HEALTHY"
    else
        echo "Alertmanager endpoint: NOT AVAILABLE"
    fi
fi

obs_report "Alertmanager integration checked."
