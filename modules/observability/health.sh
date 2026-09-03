#!/bin/bash
set -u

source "$(dirname "$0")/common.sh"

obs_section "OBSERVABILITY HEALTH"

FAILURES=0
HEALTHY=0
TOTAL=8

check_command() {
    local label="$1"
    local command_name="$2"

    if obs_command_exists "$command_name"; then
        echo "$label: OK"
        HEALTHY=$((HEALTHY + 1))
    else
        echo "$label: DEGRADED"
        FAILURES=$((FAILURES + 1))
    fi
}

check_endpoint() {
    local label="$1"
    local url="$2"

    if curl -fsS --max-time 5 "$url" >/dev/null 2>&1; then
        echo "$label: READY"
        HEALTHY=$((HEALTHY + 1))
    else
        echo "$label: NOT READY"
        FAILURES=$((FAILURES + 1))
    fi
}

check_command "Logging capability" journalctl
check_command "Network telemetry capability" ss
check_command "Process telemetry capability" ps
check_command "Memory telemetry capability" free

echo
echo "Observability backends:"

check_endpoint "OpenTelemetry Collector" \
    http://127.0.0.1:13133/

check_endpoint "Prometheus" \
    http://127.0.0.1:9090/-/ready

check_endpoint "Loki" \
    http://127.0.0.1:3100/ready

check_endpoint "Tempo" \
    http://127.0.0.1:3200/ready

echo
echo "Healthy capabilities: $HEALTHY/$TOTAL"

if [[ "$FAILURES" -eq 0 ]]; then
    echo "Observability health: HEALTHY"
    obs_report "Observability health: $HEALTHY/$TOTAL; all required checks passed."
else
    echo "Observability health: DEGRADED"
    obs_report "Observability health: $HEALTHY/$TOTAL; $FAILURES required check(s) failed."
fi

exit "$FAILURES"
