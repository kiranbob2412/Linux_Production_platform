#!/bin/bash
set -u

source "$(dirname "$0")/common.sh"

obs_section "OBSERVABILITY CORRELATION"

FAILURES=0

echo "Correlation identity:"
echo "  Timestamp: $(date --iso-8601=seconds)"
echo "  Host: $(hostname)"
echo "  Kernel: $(uname -r)"

echo
echo "Process correlation:"
if command -v ps >/dev/null 2>&1; then
    PROCESS_COUNT="$(ps -e --no-headers | wc -l)"
    echo "  Process visibility: AVAILABLE"
    echo "  Processes observed: $PROCESS_COUNT"
else
    echo "  Process visibility: NOT AVAILABLE"
    FAILURES=$((FAILURES + 1))
fi

echo
echo "Network correlation:"
if command -v ss >/dev/null 2>&1; then
    SOCKET_COUNT="$(ss -tunH 2>/dev/null | wc -l)"
    echo "  Socket visibility: AVAILABLE"
    echo "  Socket entries observed: $SOCKET_COUNT"
else
    echo "  Socket visibility: NOT AVAILABLE"
    FAILURES=$((FAILURES + 1))
fi

echo
echo "Observability backends:"

if curl -fsS --max-time 5 \
    http://127.0.0.1:9090/-/ready >/dev/null 2>&1; then
    echo "  Prometheus: READY"
else
    echo "  Prometheus: NOT READY"
    FAILURES=$((FAILURES + 1))
fi

if curl -fsS --max-time 5 \
    http://127.0.0.1:3100/ready >/dev/null 2>&1; then
    echo "  Loki: READY"
else
    echo "  Loki: NOT READY"
    FAILURES=$((FAILURES + 1))
fi

if curl -fsS --max-time 5 \
    http://127.0.0.1:3200/ready >/dev/null 2>&1; then
    echo "  Tempo: READY"
else
    echo "  Tempo: NOT READY"
    FAILURES=$((FAILURES + 1))
fi

echo
echo "Correlation dimensions:"
echo "  Timestamp"
echo "  Host"
echo "  Process"
echo "  Network endpoint"
echo "  Metrics"
echo "  Logs"
echo "  Traces"

echo
echo "Correlation workflow:"
echo "  Metric anomaly"
echo "      -> Log evidence"
echo "      -> Trace evidence"
echo "      -> Network evidence"
echo "      -> Root-cause investigation"

echo
if [[ "$FAILURES" -eq 0 ]]; then
    echo "Observability correlation: HEALTHY"
    obs_report "Observability correlation signals and backend readiness are healthy."
else
    echo "Observability correlation: DEGRADED"
    obs_report "Observability correlation has $FAILURES required check failure(s)."
fi

exit "$FAILURES"
