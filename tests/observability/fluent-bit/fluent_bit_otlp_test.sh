#!/bin/bash

set -u

PROJECT_ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
CONFIG="$PROJECT_ROOT/config/observability/fluent-bit/otlp_logs.conf"

fail() {
    echo "FAIL: $1"
    exit 1
}

pass() {
    echo "PASS: $1"
}

echo "======================================"
echo "FLUENT BIT → OTEL LOGS TEST"
echo "======================================"

[ -f "$CONFIG" ] || fail "OTLP logs config missing"
pass "OTLP logs config exists"

grep -qi "Name.*tail" "$CONFIG" ||
    fail "Tail input missing"
pass "Tail input configured"

grep -q "linux.logs" "$CONFIG" ||
    fail "Linux log tag missing"
pass "Linux log tag configured"

grep -qi "Name.*opentelemetry" "$CONFIG" ||
    fail "OpenTelemetry output missing"
pass "OpenTelemetry output configured"

grep -q "Host.*127.0.0.1" "$CONFIG" ||
    fail "OTel host missing"
pass "OTel host configured"

grep -q "Port.*4318" "$CONFIG" ||
    fail "OTLP HTTP port missing"
pass "OTLP HTTP port configured"

grep -q "/v1/logs" "$CONFIG" ||
    fail "OTLP logs endpoint missing"
pass "OTLP logs endpoint configured"

echo
echo "FLUENT BIT → OTEL LOGS: PASS"
