#!/bin/bash

set -u

PROJECT_ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"

CONFIG="$PROJECT_ROOT/config/observability/otel/logs_pipeline.yml"
SYSTEM_LOG_MODULE="$PROJECT_ROOT/modules/observability/logs/system_logs.sh"
STRUCTURED_MODULE="$PROJECT_ROOT/modules/observability/logs/structured_logs.sh"

fail() {
    echo "FAIL: $1"
    exit 1
}

pass() {
    echo "PASS: $1"
}

echo "======================================"
echo "OBSERVABILITY LOGS PIPELINE TEST"
echo "======================================"

[ -f "$CONFIG" ] || fail "Logs pipeline config missing"
pass "Logs pipeline config exists"

grep -q "filelog/system:" "$CONFIG" ||
    fail "filelog receiver missing"
pass "Filelog receiver present"

grep -q "/var/log/syslog" "$CONFIG" ||
    fail "syslog source missing"
pass "syslog source configured"

grep -q "/var/log/auth.log" "$CONFIG" ||
    fail "auth.log source missing"
pass "auth.log source configured"

grep -q "/var/log/kern.log" "$CONFIG" ||
    fail "kern.log source missing"
pass "kern.log source configured"

grep -q "include_file_path: true" "$CONFIG" ||
    fail "file path enrichment missing"
pass "File path enrichment configured"

grep -q "batch:" "$CONFIG" ||
    fail "batch processor missing"
pass "Batch processor configured"

grep -q "logs:" "$CONFIG" ||
    fail "logs pipeline missing"
pass "Logs pipeline present"

[ -x "$SYSTEM_LOG_MODULE" ] ||
    fail "System log module not executable"
pass "System log module executable"

[ -x "$STRUCTURED_MODULE" ] ||
    fail "Structured log module not executable"
pass "Structured log module executable"

echo
echo "OBSERVABILITY LOGS PIPELINE: PASS"
