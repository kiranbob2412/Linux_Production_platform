#!/bin/bash

source "$(dirname "$0")/../common.sh"

OUTPUT="$OBS_REPORT_DIR/linux_metrics.txt"

obs_section "LINUX METRICS"

{
    echo "timestamp=$(obs_timestamp)"
    echo

    echo "[uptime]"
    uptime

    echo
    echo "[load_average]"
    cat /proc/loadavg

    echo
    echo "[memory]"
    free -b

    echo
    echo "[filesystem]"
    df -P

    echo
    echo "[network_interfaces]"
    ip -s link

    echo
    echo "[tcp]"
    ss -s

    echo
    echo "[processes]"
    ps -e --no-headers | wc -l
} | tee "$OUTPUT"

obs_report "Native Linux metrics snapshot written to $OUTPUT."
