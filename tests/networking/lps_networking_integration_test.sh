#!/bin/bash

set -u

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
FAILURES=0

pass() {
    echo "PASS: $1"
}

fail() {
    echo "FAIL: $1"
    FAILURES=$((FAILURES + 1))
}

echo "============================================================"
echo " LPS NETWORKING INTEGRATION TEST"
echo "============================================================"

# Networking entry point
if [ -x "$ROOT/modules/network.sh" ]; then
    pass "networking entry point available"
else
    fail "networking entry point unavailable"
fi

# Master orchestrator
if [ -x "$ROOT/modules/networking/network_master.sh" ]; then
    pass "network master available"
else
    fail "network master unavailable"
fi

# Run networking through the same project tree
OUTPUT="/tmp/lps_networking_integration.$$"

bash "$ROOT/modules/networking/run.sh" >"$OUTPUT" 2>&1
RC=$?

if grep -q "NETWORKING ENGINEERING SUMMARY" "$OUTPUT"; then
    pass "networking summary integrated"
else
    fail "networking summary missing"
fi

if grep -q "NETWORK HEALTH:" "$OUTPUT"; then
    pass "network health integrated"
else
    fail "network health missing"
fi

if grep -q "INTERFACE" "$OUTPUT"; then
    pass "interface diagnostics integrated"
else
    fail "interface diagnostics missing"
fi

if grep -q "ROUTING" "$OUTPUT"; then
    pass "routing diagnostics integrated"
else
    fail "routing diagnostics missing"
fi

if grep -q "DNS" "$OUTPUT"; then
    pass "DNS diagnostics integrated"
else
    fail "DNS diagnostics missing"
fi

if grep -q "TCP" "$OUTPUT"; then
    pass "TCP diagnostics integrated"
else
    fail "TCP diagnostics missing"
fi

if grep -q "FIREWALL" "$OUTPUT"; then
    pass "firewall diagnostics integrated"
else
    fail "firewall diagnostics missing"
fi

if grep -q "NETWORK OBSERVABILITY" "$OUTPUT"; then
    pass "observability integrated"
else
    fail "observability missing"
fi

rm -f "$OUTPUT"

echo
echo "Networking command exit code: $RC"

echo
echo "============================================================"

if [ "$FAILURES" -eq 0 ]; then
    echo "PASS: LPS NETWORKING INTEGRATION TEST"
    echo "============================================================"
    exit 0
fi

echo "FAIL: LPS NETWORKING INTEGRATION TEST"
echo "FAILURES: $FAILURES"
echo "============================================================"

exit 1
