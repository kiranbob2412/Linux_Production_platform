#!/bin/bash
set -euo pipefail

LOKI_BIN="/usr/local/bin/loki"
LOKI_CONFIG="/etc/loki/loki.yml"

echo "======================================"
echo "LOKI RUNTIME"
echo "======================================"

if [ ! -x "$LOKI_BIN" ]; then
    echo "Loki binary: FAIL"
    exit 1
fi
echo "Loki binary: PASS"

if [ ! -f "$LOKI_CONFIG" ]; then
    echo "Loki configuration: FAIL"
    exit 1
fi
echo "Loki configuration: PASS"

if ! systemctl is-active --quiet loki.service; then
    echo "Loki service: FAIL"
    exit 1
fi
echo "Loki service: PASS"

if ! curl -fsS --max-time 5 http://127.0.0.1:3100/ready >/dev/null 2>&1; then
    echo "Loki readiness: FAIL"
    exit 1
fi
echo "Loki readiness: PASS"

echo
echo "Loki runtime: PASS"
