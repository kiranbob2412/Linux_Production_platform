#!/bin/bash
set -u

source "$(dirname "$0")/common.sh"

obs_section "NETWORK FLOW OBSERVABILITY"

FAILURES=0

echo "Network interfaces:"
if command -v ip >/dev/null 2>&1; then
    ip -br link
else
    echo "  ip: NOT AVAILABLE"
    FAILURES=$((FAILURES + 1))
fi

echo
echo "Active interfaces:"
if command -v ip >/dev/null 2>&1; then
    ACTIVE_INTERFACES="$(ip -br link | awk '$2 == "UP" {print}')"

    if [[ -n "$ACTIVE_INTERFACES" ]]; then
        echo "$ACTIVE_INTERFACES"
    else
        echo "  No active non-loopback interface detected"
    fi
fi

echo
echo "Socket summary:"
if command -v ss >/dev/null 2>&1; then
    ss -s
else
    echo "  ss: NOT AVAILABLE"
    FAILURES=$((FAILURES + 1))
fi

echo
echo "Listening services:"
if command -v ss >/dev/null 2>&1; then
    ss -tuln
else
    echo "  Socket inspection unavailable"
fi

echo
echo "Packet capture capability:"
if command -v tcpdump >/dev/null 2>&1; then
    echo "  tcpdump: AVAILABLE"
    tcpdump --version 2>&1 | head -1
else
    echo "  tcpdump: NOT AVAILABLE"
    FAILURES=$((FAILURES + 1))
fi

echo
echo "Flow telemetry sources:"
echo "  Linux socket statistics"
echo "  Packet capture"
echo "  AWS VPC Flow Logs"
echo "  Kubernetes network telemetry"
echo "  eBPF network telemetry"

echo
if [[ "$FAILURES" -eq 0 ]]; then
    echo "Network flow observability: HEALTHY"
    obs_report "Network flow observability capabilities are healthy."
else
    echo "Network flow observability: DEGRADED"
    obs_report "Network flow observability has $FAILURES required capability check failure(s)."
fi

exit "$FAILURES"
