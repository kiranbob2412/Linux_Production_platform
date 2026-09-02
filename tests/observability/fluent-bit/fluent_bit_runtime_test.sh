#!/bin/bash

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
CONFIG="$PROJECT_ROOT/config/observability/fluent-bit/fluent-bit.conf"

echo "=== Fluent Bit Runtime Test ==="

test -f "$CONFIG"

grep -q 'Name              tail' "$CONFIG"
grep -q 'Tag               linux.logs' "$CONFIG"
grep -q 'Name              opentelemetry' "$CONFIG"
grep -q 'Host              127.0.0.1' "$CONFIG"
grep -q 'Port              4318' "$CONFIG"
grep -q 'Logs_uri          /v1/logs' "$CONFIG"

if command -v /opt/fluent-bit/bin/fluent-bit >/dev/null 2>&1; then
    /opt/fluent-bit/bin/fluent-bit --version
else
    echo "Fluent Bit native binary not installed."
    exit 1
fi

echo
echo "FLUENT BIT RUNTIME TEST: PASS"
