#!/bin/bash

OBSERVABILITY_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$OBSERVABILITY_ROOT/../.." && pwd)"

OBS_REPORT_DIR="$PROJECT_ROOT/reports/observability"
OBS_LOG_DIR="$PROJECT_ROOT/logs/observability"

mkdir -p "$OBS_REPORT_DIR" "$OBS_LOG_DIR"

obs_timestamp() {
    date '+%Y-%m-%d %H:%M:%S'
}

obs_report() {
    echo "[$(obs_timestamp)] $*" >> "$OBS_REPORT_DIR/observability_report.txt"
}

obs_command_exists() {
    command -v "$1" >/dev/null 2>&1
}

obs_section() {
    echo
    echo "======================================"
    echo "$1"
    echo "======================================"
}
