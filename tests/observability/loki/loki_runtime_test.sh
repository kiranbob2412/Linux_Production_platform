#!/bin/bash
set -euo pipefail

LOKI_BIN="/usr/local/bin/loki"
LOKI_CONFIG="/etc/loki/loki.yml"

echo "======================================"
echo "LOKI RUNTIME TEST"
echo "======================================"

if [ -x "$LOKI_BIN" ]; then
    echo "PASS: Loki binary"
else
    echo "FAIL: Loki binary"
    exit 1
fi

if [ -f "$LOKI_CONFIG" ]; then
    echo "PASS: Loki configuration"
else
    echo "FAIL: Loki configuration"
    exit 1
fi

if systemctl is-active --quiet loki.service; then
    echo "PASS: Loki service"
else
    echo "FAIL: Loki service"
    exit 1
fi

if curl -fsS --max-time 5 http://127.0.0.1:3100/ready >/dev/null 2>&1; then
    echo "PASS: Loki readiness"
else
    echo "FAIL: Loki readiness"
    exit 1
fi

echo
echo "LOKI RUNTIME TEST: PASS"
